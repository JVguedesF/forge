import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import '../providers/active_session_provider.dart';
import '../providers/session_providers.dart';
import '../providers/workout_providers.dart';
import '../data/models/enums.dart';
import '../data/models/workout.dart';

enum SessionMode { musculacao, timed, corrida }

class SessionScreen extends ConsumerStatefulWidget {
  final SessionMode mode;
  final int? workoutId;
  final String workoutName;
  final WorkoutType? workoutType;
  const SessionScreen({
    super.key,
    this.mode = SessionMode.musculacao,
    this.workoutId,
    this.workoutName = '',
    this.workoutType,
  });

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final type = widget.workoutType ??
          switch (widget.mode) {
            SessionMode.musculacao => WorkoutType.musculacao,
            SessionMode.timed => WorkoutType.mobilidade,
            SessionMode.corrida => WorkoutType.corrida,
          };
      ref.read(activeSessionProvider.notifier).start(
            workoutId: widget.workoutId,
            workoutName:
                widget.workoutName.isNotEmpty ? widget.workoutName : type.name,
            workoutType: type,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider).valueOrNull ?? ForgeThemes.teal;

    // B3/B4 FIX: resolve workoutType from param or mode
    final resolvedType = widget.workoutType ??
        switch (widget.mode) {
          SessionMode.musculacao => WorkoutType.musculacao,
          SessionMode.timed => WorkoutType.mobilidade,
          SessionMode.corrida => WorkoutType.corrida,
        };

    return switch (widget.mode) {
      SessionMode.musculacao => _MuscSession(
          theme: theme,
          workoutId: widget.workoutId,
          workoutName: widget.workoutName,
          onEnd: (elapsed) {
            ref.read(activeSessionProvider.notifier).setDuration(elapsed);
            context.pushReplacement('/session/summary');
          }),
      SessionMode.timed => _TimedSession(
          theme: theme,
          workoutId: widget.workoutId,
          workoutName: widget.workoutName,
          workoutType: resolvedType, // B3/B4 FIX
          onEnd: (elapsed) {
            ref.read(activeSessionProvider.notifier).setDuration(elapsed);
            context.pushReplacement('/session/summary');
          }),
      SessionMode.corrida => _CorridaSession(
          theme: theme,
          workoutName: widget.workoutName,
          onEnd: (elapsed) {
            ref.read(activeSessionProvider.notifier).setDuration(elapsed);
            context.push('/session/form');
          }),
    };
  }
}

// ─────────────────────────────────────
// COMMON: abandon dialog (U2)
// ─────────────────────────────────────
Future<bool> _confirmAbandon(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFF161616),
      title: const Text('Abandonar treino?',
          style: TextStyle(
              fontFamily: 'BebasNeue', fontSize: 22, color: Color(0xFFf0f0f0))),
      content: const Text(
          'O progresso desta sessão será perdido.',
          style: TextStyle(fontSize: 13, color: Color(0xFF666666))),
      actions: [
        TextButton(
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(false),
            child: const Text('Continuar',
                style: TextStyle(color: Color(0xFF666666)))),
        TextButton(
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(true),
            child: const Text('Abandonar',
                style: TextStyle(color: Color(0xFFef4444)))),
      ],
    ),
  );
  return result ?? false;
}

// ─────────────────────────────────────
// Modelo interno de série ao vivo
// ─────────────────────────────────────
class _LiveSet {
  String kg;
  String reps;
  bool done;
  bool active;
  final String prevBest;
  _LiveSet(
      {required this.prevBest,
      this.kg = '',
      this.reps = '',
      this.done = false,
      this.active = false});
}

// Unidade de execução — um exercício numa volta específica
class _ExUnit {
  final int? exerciseId;
  final String name;
  final String reps;
  final double? suggestedWeight;
  final int restSeconds;
  final ExerciseType type;
  final _LiveSet liveSet;

  _ExUnit({
    this.exerciseId,
    required this.name,
    required this.reps,
    this.suggestedWeight,
    required this.restSeconds,
    required this.type,
    required this.liveSet,
  });
}

// ════════════════════════════════════
// MUSCULAÇÃO — B2 FIX: superset interleaved
// ════════════════════════════════════
class _MuscSession extends ConsumerStatefulWidget {
  final ForgeTheme theme;
  final int? workoutId;
  final String workoutName;
  final void Function(int elapsed) onEnd;
  const _MuscSession(
      {required this.theme,
      required this.onEnd,
      this.workoutId,
      this.workoutName = ''});

  @override
  ConsumerState<_MuscSession> createState() => _MuscSessionState();
}

class _MuscSessionState extends ConsumerState<_MuscSession> {
  int _elapsed = 0;
  int _rest = 0;
  int _restTotal = 90;
  Timer? _elapsedTimer;
  Timer? _restTimer;
  bool _loading = true;

  // B2 FIX: lista plana de unidades de execução (exercício × volta)
  // Para superset: ex1v1, ex2v1, [descanso], ex1v2, ex2v2, [descanso] ...
  // Para exercício avulso: ex1v1, ex1v2, ex1v3 ...
  List<_ExUnit> _units = [];
  int _unitIdx = 0;

  @override
  void initState() {
    super.initState();
    _elapsedTimer = Timer.periodic(
        const Duration(seconds: 1), (_) => setState(() => _elapsed++));
    _loadWorkout();
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadWorkout() async {
    Workout? workout;
    if (widget.workoutId != null) {
      workout =
          await ref.read(workoutRepositoryProvider).getById(widget.workoutId!);
    }

    if (workout == null || workout.blocks.isEmpty) {
      setState(() {
        _units = [
          _ExUnit(
            name: widget.workoutName.isNotEmpty
                ? widget.workoutName
                : 'Treino Livre',
            reps: '10',
            restSeconds: 90,
            type: ExerciseType.weightReps,
            liveSet: _LiveSet(prevBest: '—'),
          )
        ];
        _units.first.liveSet.active = true;
        _loading = false;
      });
      return;
    }

    final units = <_ExUnit>[];

    for (final block in workout.blocks) {
      if (!block.isCircuit) {
        // Exercício avulso: todas as séries em sequência
        for (final ex in block.exercises) {
          final kgStr = ex.suggestedWeight?.toStringAsFixed(0) ?? '';
          final prev = kgStr.isNotEmpty ? '${kgStr}kg×${ex.reps}' : ex.reps;
          for (int s = 0; s < block.sets; s++) {
            units.add(_ExUnit(
              exerciseId: ex.exerciseId,
              name: ex.exerciseName,
              reps: ex.reps.isNotEmpty ? ex.reps : '10',
              suggestedWeight: ex.suggestedWeight,
              restSeconds: block.restAfterSeconds > 0
                  ? block.restAfterSeconds
                  : 90,
              type: ex.type,
              liveSet: _LiveSet(prevBest: prev, kg: kgStr),
            ));
          }
        }
      } else {
        // B2 FIX: Superset intercalado — por volta, todos os exercícios
        for (int volta = 0; volta < block.sets; volta++) {
          for (int exI = 0; exI < block.exercises.length; exI++) {
            final ex = block.exercises[exI];
            final kgStr = ex.suggestedWeight?.toStringAsFixed(0) ?? '';
            final prev =
                kgStr.isNotEmpty ? '${kgStr}kg×${ex.reps}' : ex.reps;
            // Só aplica descanso no ÚLTIMO exercício de cada volta
            final isLastExInVolta = exI == block.exercises.length - 1;
            units.add(_ExUnit(
              exerciseId: ex.exerciseId,
              name: ex.exerciseName,
              reps: ex.reps.isNotEmpty ? ex.reps : '10',
              suggestedWeight: ex.suggestedWeight,
              restSeconds: isLastExInVolta
                  ? (block.restAfterSeconds > 0 ? block.restAfterSeconds : 120)
                  : 0, // sem descanso entre exercícios do superset
              type: ex.type,
              liveSet: _LiveSet(prevBest: prev, kg: kgStr),
            ));
          }
        }
      }
    }

    if (units.isNotEmpty) units.first.liveSet.active = true;

    setState(() {
      _units = units;
      _loading = false;
    });
  }

  _ExUnit? get _currentUnit =>
      _units.isEmpty ? null : _units[_unitIdx];

  void _completeUnit() {
    final unit = _currentUnit;
    if (unit == null) return;

    final kg = double.tryParse(unit.liveSet.kg);
    final reps = int.tryParse(unit.liveSet.reps);

    ref.read(activeSessionProvider.notifier).addCompletedSet(
          exerciseName: unit.name,
          exerciseId: unit.exerciseId ?? 0,
          weight: kg,
          reps: reps,
          durationSeconds: null,
        );

    setState(() {
      unit.liveSet.done = true;
      unit.liveSet.active = false;

      if (unit.restSeconds > 0) {
        _rest = unit.restSeconds;
        _restTotal = unit.restSeconds;
        _restTimer?.cancel();
        _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {
            if (_rest > 0) _rest--;
          });
        });
      }

      if (_unitIdx + 1 < _units.length) {
        _unitIdx++;
        _units[_unitIdx].liveSet.active = true;
      } else {
        _elapsedTimer?.cancel();
        widget.onEnd(_elapsed);
      }
    });
  }

  void _prevUnit() {
    if (_unitIdx > 0) setState(() => _unitIdx--);
  }

  void _nextUnit() {
    if (_unitIdx + 1 < _units.length) setState(() => _unitIdx++);
  }

  String _fmt(int s) =>
      '${(s ~/ 3600).toString().padLeft(2, '0')}:${((s % 3600) ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
  String _fmtRest(int s) =>
      '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';

  // U2: abandon confirmation
  Future<void> _tryClose(BuildContext ctx) async {
    final abandon = await _confirmAbandon(ctx);
    if (abandon && ctx.mounted) {
      _elapsedTimer?.cancel();
      _restTimer?.cancel();
      ref.read(activeSessionProvider.notifier).clear();
      ctx.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.theme.accent;

    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0a0a0a),
        body: Center(child: CircularProgressIndicator(color: accent)),
      );
    }

    if (_units.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0a0a0a),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Treino sem exercícios',
              style: TextStyle(color: ForgeColors.muted, fontSize: 16)),
          const SizedBox(height: 16),
          GestureDetector(
              onTap: () => context.pop(),
              child: const Text('Voltar',
                  style: TextStyle(color: ForgeColors.corridaLight))),
        ])),
      );
    }

    final unit = _currentUnit!;
    final totalUnits = _units.length;
    final progressPct =
        totalUnits > 0 ? (_unitIdx + 1) / totalUnits : 0.0;
    final restPct =
        _restTotal > 0 ? (1 - _rest / _restTotal).clamp(0.0, 1.0) : 1.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(children: [
              _XBtn(onTap: () => _tryClose(context)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(children: [
                Text(widget.workoutName.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 10,
                        color: ForgeColors.muted,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1)),
                Text(_fmt(_elapsed),
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 20,
                        color: accent,
                        letterSpacing: 0)),
              ])),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: ForgeColors.card,
                    border: Border.all(color: ForgeColors.border),
                    borderRadius: BorderRadius.circular(20)),
                child: Text('${_unitIdx + 1} / $totalUnits',
                    style: const TextStyle(
                        fontSize: 11, color: ForgeColors.muted)),
              ),
            ]),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progressPct.clamp(0.0, 1.0),
                minHeight: 4,
                backgroundColor: ForgeColors.border,
                valueColor: AlwaysStoppedAnimation(
                    ForgeColors.musculacaoLight),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(unit.name,
                        style: const TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 46,
                            color: ForgeColors.text,
                            height: .92)),
                    const SizedBox(height: 4),
                    Text(
                        '${unit.reps} reps · ${unit.restSeconds > 0 ? "${unit.restSeconds}s descanso" : "sem descanso"}',
                        style: const TextStyle(
                            fontSize: 12, color: ForgeColors.muted)),
                    const SizedBox(height: 14),

                    // Set input
                    Container(
                      decoration: BoxDecoration(
                          color: ForgeColors.card,
                          border: Border.all(color: ForgeColors.border),
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.all(14),
                      child: Row(children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                              const Text('ANTERIOR',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: ForgeColors.muted,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(unit.liveSet.prevBest,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: ForgeColors.muted2)),
                            ])),
                        _NumInput(
                            label: 'KG',
                            value: unit.liveSet.kg,
                            accent: accent,
                            onChanged: (v) =>
                                setState(() => unit.liveSet.kg = v)),
                        const SizedBox(width: 8),
                        _NumInput(
                            label: 'REPS',
                            value: unit.liveSet.reps,
                            accent: accent,
                            onChanged: (v) =>
                                setState(() => unit.liveSet.reps = v)),
                      ]),
                    ),
                    const SizedBox(height: 10),

                    // Timer descanso
                    if (_rest > 0)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: ForgeColors.card,
                            border: Border.all(color: ForgeColors.border),
                            borderRadius: BorderRadius.circular(14)),
                        child: Row(children: [
                          Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(_fmtRest(_rest),
                                    style: TextStyle(
                                        fontFamily: 'BebasNeue',
                                        fontSize: 28,
                                        color: accent,
                                        letterSpacing: 0)),
                                Text('Descanso · ${_restTotal}s',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: ForgeColors.muted)),
                              ]),
                          const SizedBox(width: 12),
                          Expanded(
                              child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                                value: restPct,
                                minHeight: 4,
                                backgroundColor: ForgeColors.border,
                                valueColor:
                                    AlwaysStoppedAnimation(accent)),
                          )),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => setState(() {
                              _rest = 0;
                              _restTimer?.cancel();
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ForgeColors.border),
                                  borderRadius:
                                      BorderRadius.circular(8)),
                              child: const Text('Pular',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: ForgeColors.muted)),
                            ),
                          ),
                        ]),
                      ),
                    const SizedBox(height: 12),

                    // Botão principal
                    GestureDetector(
                      onTap: _completeUnit,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ForgeColors.musculacao,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'CONCLUIR SÉRIE ${_unitIdx + 1} →',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _unitIdx > 0 ? _prevUnit : null,
                            child: Text('← Anterior',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _unitIdx > 0
                                        ? ForgeColors.muted
                                        : const Color(0xFF333333))),
                          ),
                          const SizedBox(width: 28),
                          GestureDetector(
                            onTap: _unitIdx + 1 < _units.length
                                ? _nextUnit
                                : null,
                            child: Text('Pular →',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _unitIdx + 1 < _units.length
                                        ? ForgeColors.muted
                                        : const Color(0xFF333333))),
                          ),
                        ]),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class _NumInput extends StatefulWidget {
  final String label;
  final String value;
  final Color accent;
  final void Function(String) onChanged;
  const _NumInput(
      {required this.label,
      required this.value,
      required this.accent,
      required this.onChanged});

  @override
  State<_NumInput> createState() => _NumInputState();
}

class _NumInputState extends State<_NumInput> {
  late TextEditingController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(widget.label,
            style: const TextStyle(
                fontSize: 9,
                color: ForgeColors.muted,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: widget.accent.withOpacity(.12),
            border: Border.all(color: widget.accent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _ctrl,
            onChanged: widget.onChanged,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'BebasNeue',
                color: widget.accent,
                letterSpacing: 0),
            decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero),
          ),
        ),
      ]),
    );
  }
}

// ════════════════════════════════════
// TIMED — B3/B4 FIX: diferenciação por WorkoutType, F5
// ════════════════════════════════════
class _TimedSession extends ConsumerStatefulWidget {
  final ForgeTheme theme;
  final int? workoutId;
  final String workoutName;
  final WorkoutType workoutType; // B3/B4
  final void Function(int elapsed) onEnd;
  const _TimedSession(
      {required this.theme,
      required this.onEnd,
      this.workoutId,
      this.workoutName = '',
      required this.workoutType});

  @override
  ConsumerState<_TimedSession> createState() => _TimedSessionState();
}

// Modelo de item de exercício timed ao vivo
class _TimedItem {
  final String name;
  final String blockLabel;
  final bool hasSides;
  final int durationSeconds;
  final bool showScoliosisAlert;
  bool leftDone;
  bool done;
  _TimedItem({
    required this.name,
    required this.blockLabel,
    this.hasSides = false,
    required this.durationSeconds,
    this.showScoliosisAlert = false,
    this.leftDone = false,
    this.done = false,
  });
}

class _TimedSessionState extends ConsumerState<_TimedSession> {
  int _elapsed = 0;
  int _countdown = 30;
  int _countdownTotal = 30;
  Timer? _timer;
  bool _loading = true;
  bool _onLeftSide = true;

  List<_TimedItem> _items = [];
  int _itemIdx = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed++;
        if (_countdown > 0) _countdown--;
        if (_countdown == 0 && _items.isNotEmpty) {
          _autoAdvance();
        }
      });
    });
    _loadWorkout();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadWorkout() async {
    Workout? workout;
    if (widget.workoutId != null) {
      workout =
          await ref.read(workoutRepositoryProvider).getById(widget.workoutId!);
    }

    if (workout == null || workout.blocks.isEmpty) {
      // fallback
      setState(() {
        _items = [
          _TimedItem(
              name: widget.workoutName.isNotEmpty
                  ? widget.workoutName
                  : 'Exercício',
              blockLabel: '',
              durationSeconds: 30)
        ];
        _countdown = 30;
        _countdownTotal = 30;
        _loading = false;
      });
      return;
    }

    final items = <_TimedItem>[];
    final isMob = workout.type == WorkoutType.mobilidade;

    for (final block in workout.blocks) {
      final blockLabel = block.circuitName ?? '';
      // B3/B4: escoliose apenas em mobilidade com blocos cervical/lombar
      final scoliosis = isMob &&
          (blockLabel.toLowerCase().contains('lombar') ||
              blockLabel.toLowerCase().contains('cervical'));

      for (final ex in block.exercises) {
        items.add(_TimedItem(
          name: ex.exerciseName,
          blockLabel: blockLabel,
          hasSides: ex.hasSides,
          durationSeconds:
              ex.durationSeconds > 0 ? ex.durationSeconds : 30,
          showScoliosisAlert: scoliosis,
        ));
      }
    }

    if (items.isNotEmpty) {
      setState(() {
        _items = items;
        _countdown = items.first.durationSeconds;
        _countdownTotal = items.first.durationSeconds;
        _loading = false;
      });
    }
  }

  void _autoAdvance() {
    final item = _currentItem;
    if (item == null) return;
    if (item.hasSides && !item.leftDone && _onLeftSide) {
      setState(() {
        _onLeftSide = false;
        item.leftDone = true;
        _countdown = item.durationSeconds;
        _countdownTotal = item.durationSeconds;
      });
    } else {
      _completeItem();
    }
  }

  void _completeItem() {
    final item = _currentItem;
    if (item == null) return;
    setState(() {
      item.done = true;
      if (_itemIdx + 1 < _items.length) {
        _itemIdx++;
        _onLeftSide = true;
        _countdown = _items[_itemIdx].durationSeconds;
        _countdownTotal = _items[_itemIdx].durationSeconds;
      } else {
        _timer?.cancel();
        widget.onEnd(_elapsed);
      }
    });
  }

  _TimedItem? get _currentItem =>
      _items.isEmpty ? null : _items[_itemIdx];

  // U2
  Future<void> _tryClose(BuildContext ctx) async {
    final abandon = await _confirmAbandon(ctx);
    if (abandon && ctx.mounted) {
      _timer?.cancel();
      ref.read(activeSessionProvider.notifier).clear();
      ctx.pop();
    }
  }

  String _fmt(int s) =>
      '${(s ~/ 3600).toString().padLeft(2, '0')}:${((s % 3600) ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0a0a0a),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final item = _currentItem;
    if (item == null) return const SizedBox.shrink();

    // B3/B4: cor baseada no tipo real
    final Color color;
    final Color colorLight;
    switch (widget.workoutType) {
      case WorkoutType.drills:
        color = ForgeColors.drills;
        colorLight = ForgeColors.drillsLight;
      case WorkoutType.bola:
        color = ForgeColors.bola;
        colorLight = ForgeColors.bolaLight;
      case WorkoutType.mobilidade:
      default:
        color = ForgeColors.mobilidade;
        colorLight = ForgeColors.mobilidadeLight;
    }

    final pct = _countdownTotal > 0
        ? _countdown / _countdownTotal
        : 0.0;
    final nextItem = _itemIdx + 1 < _items.length
        ? _items[_itemIdx + 1]
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(children: [
              _XBtn(onTap: () => _tryClose(context)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(children: [
                Text(widget.workoutName.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 10,
                        color: ForgeColors.muted,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1)),
                Text(_fmt(_elapsed),
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 20,
                        color: colorLight,
                        letterSpacing: 0)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: ForgeColors.card,
                    border: Border.all(color: ForgeColors.border),
                    borderRadius: BorderRadius.circular(20)),
                child: Text('${_itemIdx + 1} / ${_items.length}',
                    style: const TextStyle(
                        fontSize: 11, color: ForgeColors.muted)),
              ),
            ]),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                  value: _items.isNotEmpty
                      ? (_itemIdx + 1) / _items.length
                      : 0,
                  minHeight: 4,
                  backgroundColor: ForgeColors.border,
                  valueColor: AlwaysStoppedAnimation(color)),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                // Bloco label
                if (item.blockLabel.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                        color: color.withOpacity(.1),
                        border: Border.all(
                            color: color.withOpacity(.28)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      Text(item.blockLabel,
                          style: TextStyle(
                              fontSize: 11,
                              color: colorLight,
                              fontWeight: FontWeight.w600)),
                      // B3/B4 FIX: banner escoliose apenas mobilidade
                      if (item.showScoliosisAlert) ...[
                        const Spacer(),
                        const Text('⚠ Escoliose',
                            style: TextStyle(
                                fontSize: 10,
                                color: ForgeColors.mobilidade)),
                      ],
                    ]),
                  ),
                const SizedBox(height: 14),
                Text(item.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 38,
                        color: ForgeColors.text,
                        height: .95)),
                const SizedBox(height: 10),
                // Indicador de lado — apenas se hasSides
                if (item.hasSides) ...[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            radius: 5,
                            backgroundColor: _onLeftSide
                                ? colorLight
                                : ForgeColors.border),
                        const SizedBox(width: 10),
                        Text(
                            _onLeftSide
                                ? 'LADO ESQUERDO'
                                : 'LADO DIREITO',
                            style: TextStyle(
                                fontSize: 12,
                                color: colorLight,
                                fontWeight: FontWeight.w600,
                                letterSpacing: .5)),
                        const SizedBox(width: 10),
                        CircleAvatar(
                            radius: 5,
                            backgroundColor: !_onLeftSide
                                ? colorLight
                                : ForgeColors.border),
                      ]),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 12),
                // Timer circular
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(alignment: Alignment.center, children: [
                    CustomPaint(
                        size: const Size(140, 140),
                        painter: _CircleTimerPainter(
                            pct: pct, color: color)),
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('$_countdown',
                          style: const TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 50,
                              color: ForgeColors.text,
                              letterSpacing: 0,
                              height: 1)),
                      const Text('seg',
                          style: TextStyle(
                              fontSize: 10, color: ForgeColors.muted)),
                    ]),
                  ]),
                ),
                const SizedBox(height: 20),
                // Próximo
                if (nextItem != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                        color: ForgeColors.card,
                        border:
                            Border.all(color: ForgeColors.border),
                        borderRadius: BorderRadius.circular(12)),
                    child: RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: 'A seguir: ',
                          style: TextStyle(
                              fontSize: 10,
                              color: ForgeColors.muted)),
                      TextSpan(
                          text: nextItem.hasSides
                              ? '${nextItem.name} — Lado ${item.hasSides && item.leftDone && !item.done ? "Direito" : "Esquerdo"}'
                              : nextItem.name,
                          style: const TextStyle(
                              fontSize: 12,
                              color: ForgeColors.text,
                              fontWeight: FontWeight.w500)),
                    ])),
                  ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    _timer?.cancel();
                    _autoAdvance();
                    _timer = Timer.periodic(
                        const Duration(seconds: 1), (_) {
                      setState(() {
                        _elapsed++;
                        if (_countdown > 0) _countdown--;
                        if (_countdown == 0 &&
                            _items.isNotEmpty) {
                          _autoAdvance();
                        }
                      });
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(14)),
                    child: const Text('CONCLUÍDO ✓',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 20,
                            color: Colors.white)),
                  ),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class _CircleTimerPainter extends CustomPainter {
  final double pct;
  final Color color;
  const _CircleTimerPainter({required this.pct, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const r = 62.0;
    const strokeW = 7.0;
    canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..color = ForgeColors.border
          ..strokeWidth = strokeW
          ..style = PaintingStyle.stroke);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -3.14159265 / 2,
      2 * 3.14159265 * pct,
      false,
      Paint()
        ..color = color
        ..strokeWidth = strokeW
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_CircleTimerPainter old) => old.pct != pct;
}

// ════════════════════════════════════
// CORRIDA
// ════════════════════════════════════
class _CorridaSession extends ConsumerStatefulWidget {
  final ForgeTheme theme;
  final String workoutName;
  final void Function(int elapsed) onEnd;
  const _CorridaSession(
      {required this.theme, required this.onEnd, this.workoutName = ''});

  @override
  ConsumerState<_CorridaSession> createState() => _CorridaSessionState();
}

class _CorridaSessionState extends ConsumerState<_CorridaSession> {
  int _elapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (_) => setState(() => _elapsed++));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  Future<void> _tryClose(BuildContext ctx) async {
    final abandon = await _confirmAbandon(ctx);
    if (abandon && ctx.mounted) {
      _timer?.cancel();
      ref.read(activeSessionProvider.notifier).clear();
      ctx.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    const color = ForgeColors.corrida;
    const colorLight = ForgeColors.corridaLight;

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(children: [
              _XBtn(onTap: () => _tryClose(context)),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(widget.workoutName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 20,
                          color: ForgeColors.text))),
              const SizedBox(width: 46),
            ]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                Text(_fmt(_elapsed),
                    style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 64,
                        color: ForgeColors.text,
                        letterSpacing: 0,
                        height: 1)),
                const Text('tempo decorrido',
                    style: TextStyle(
                        fontSize: 13, color: ForgeColors.muted)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                      color: ForgeColors.card,
                      border: Border.all(
                          color: color.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Column(children: [
                      Text('8 km',
                          style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 22,
                              color: colorLight,
                              letterSpacing: 0)),
                      Text('meta',
                          style: TextStyle(
                              fontSize: 9,
                              color: ForgeColors.muted)),
                    ]),
                    Container(
                        width: 1,
                        height: 36,
                        color: ForgeColors.border,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 24)),
                    const Column(children: [
                      Text('5:30',
                          style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 22,
                              color: colorLight,
                              letterSpacing: 0)),
                      Text('pace alvo/km',
                          style: TextStyle(
                              fontSize: 9,
                              color: ForgeColors.muted)),
                    ]),
                  ]),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => widget.onEnd(_elapsed),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(14)),
                    child: const Text('FINALIZAR SESSÃO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 20,
                            color: Colors.white)),
                  ),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════
// FORMULÁRIO PÓS-CORRIDA — B6/F6 FIX: pace por km
// ════════════════════════════════════
class RunFormScreen extends ConsumerStatefulWidget {
  const RunFormScreen({super.key});

  @override
  ConsumerState<RunFormScreen> createState() => _RunFormScreenState();
}

class _RunFormScreenState extends ConsumerState<RunFormScreen> {
  final _kmCtrl = TextEditingController(text: '');
  final _timeCtrl = TextEditingController(text: '');
  // B6/F6: pace por km
  List<TextEditingController> _paceCtrs = [];
  int _kmCount = 0;

  double get _km => double.tryParse(_kmCtrl.text) ?? 0;

  int get _totalSeconds {
    final parts = _timeCtrl.text.split(':');
    if (parts.length == 2)
      return (int.tryParse(parts[0]) ?? 0) * 60 +
          (int.tryParse(parts[1]) ?? 0);
    return 0;
  }

  String get _pace {
    if (_km <= 0 || _totalSeconds <= 0) return '—';
    final sPerKm = _totalSeconds / _km;
    final m = sPerKm ~/ 60;
    final s = (sPerKm % 60).round();
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _onKmChanged(String v) {
    final n = double.tryParse(v)?.ceil() ?? 0;
    if (n != _kmCount) {
      setState(() {
        _kmCount = n;
        // Cria/remove controllers conforme o número de km
        while (_paceCtrs.length < n) {
          _paceCtrs.add(TextEditingController());
        }
        while (_paceCtrs.length > n) {
          _paceCtrs.removeLast().dispose();
        }
      });
    }
  }

  void _save() {
    // B6: converte pace strings para segundos por km
    final paces = _paceCtrs.map((c) {
      final parts = c.text.split(':');
      if (parts.length == 2) {
        return ((int.tryParse(parts[0]) ?? 0) * 60 +
                (int.tryParse(parts[1]) ?? 0))
            .toDouble();
      }
      return 0.0;
    }).toList();

    ref.read(activeSessionProvider.notifier).setRunData(
          km: _km,
          totalSeconds: _totalSeconds,
          paces: paces,
        );
    context.pushReplacement('/session/summary');
  }

  @override
  void dispose() {
    _kmCtrl.dispose();
    _timeCtrl.dispose();
    for (final c in _paceCtrs) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const color = ForgeColors.corrida;
    const colorLight = ForgeColors.corridaLight;

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Row(children: [
              _XBtn(
                  onTap: () => context.pop(),
                  icon: LucideIcons.arrow_left),
              const SizedBox(width: 12),
              const Expanded(
                  child: Text('Registrar Corrida',
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 22,
                          color: ForgeColors.text))),
              GestureDetector(
                onTap: _save,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text('SALVAR',
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 15,
                          color: Colors.white)),
                ),
              ),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                            const _SLabel('Km totais'),
                            _InputBox(
                                controller: _kmCtrl,
                                color: color,
                                colorLight: colorLight,
                                onChanged: _onKmChanged,
                                hint: '0.0'),
                          ])),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                            const _SLabel('Tempo (mm:ss)'),
                            _InputBox(
                                controller: _timeCtrl,
                                color: color,
                                colorLight: colorLight,
                                onChanged: (_) => setState(() {}),
                                hint: '00:00'),
                          ])),
                    ]),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 11),
                      decoration: BoxDecoration(
                          color: ForgeColors.card,
                          border: Border.all(color: ForgeColors.border),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Pace médio calculado',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: ForgeColors.muted)),
                            Text('$_pace /km',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: colorLight,
                                    fontWeight: FontWeight.w600)),
                          ]),
                    ),
                    // B6/F6: tabela de pace por km
                    if (_kmCount > 0) ...[
                      const SizedBox(height: 16),
                      const _SLabel('Pace por km'),
                      Container(
                        decoration: BoxDecoration(
                            color: ForgeColors.card,
                            border:
                                Border.all(color: ForgeColors.border),
                            borderRadius: BorderRadius.circular(14)),
                        clipBehavior: Clip.hardEdge,
                        child: Column(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            color: ForgeColors.surface,
                            child: const Row(children: [
                              Expanded(
                                  child: Text('Km',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: ForgeColors.muted,
                                          fontWeight: FontWeight.w600))),
                              SizedBox(
                                  width: 120,
                                  child: Text('Pace (mm:ss)',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: ForgeColors.muted,
                                          fontWeight: FontWeight.w600))),
                            ]),
                          ),
                          ...List.generate(_kmCount, (i) {
                            final isLast = i == _kmCount - 1;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 9),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: ForgeColors.border))),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Km ${i + 1}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: ForgeColors.muted)),
                                    SizedBox(
                                      width: 120,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                            color: color.withOpacity(.1),
                                            border: Border.all(
                                                color: color.withOpacity(.3)),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: TextField(
                                          controller: _paceCtrs[i],
                                          keyboardType:
                                              TextInputType.number,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: 'BebasNeue',
                                              fontSize: 16,
                                              color: colorLight,
                                              letterSpacing: 0),
                                          decoration:
                                              const InputDecoration(
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            hintText: '0:00',
                                            hintStyle: TextStyle(
                                                fontFamily: 'BebasNeue',
                                                fontSize: 16,
                                                color: Color(0xFF444444),
                                                letterSpacing: 0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            );
                          }),
                        ]),
                      ),
                    ],
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final Color color, colorLight;
  final void Function(String) onChanged;
  final String hint;
  const _InputBox(
      {required this.controller,
      required this.color,
      required this.colorLight,
      required this.onChanged,
      this.hint = ''});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
            color: ForgeColors.card,
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(12)),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontFamily: 'BebasNeue',
              fontSize: 24,
              color: colorLight,
              letterSpacing: 0),
          decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: hint,
              hintStyle: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 24,
                  color: colorLight.withOpacity(.3),
                  letterSpacing: 0)),
        ),
      );
}

// ════════════════════════════════════
// RESUMO
// ════════════════════════════════════
class SessionSummaryScreen extends ConsumerStatefulWidget {
  const SessionSummaryScreen({super.key});

  @override
  ConsumerState<SessionSummaryScreen> createState() =>
      _SessionSummaryScreenState();
}

class _SessionSummaryScreenState
    extends ConsumerState<SessionSummaryScreen> {
  int? _effort;
  final _notesCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    _saving = true;
    if (mounted) setState(() {});

    final notifier = ref.read(activeSessionProvider.notifier);
    notifier.setEffort(_effort ?? 3);
    notifier.setNotes(_notesCtrl.text);

    final session = ref.read(activeSessionProvider);
    if (session != null) {
      final ts = session.toTrainingSession();

      int prCount = 0;
      if (session.workoutType == WorkoutType.musculacao) {
        for (final ex in session.exercises) {
          if (ex.exerciseId == null || ex.exerciseId == 0) continue;
          final completedSets = ex.sets
              .where((s) =>
                  s.completed && s.weight != null && s.weight! > 0)
              .toList();
          if (completedSets.isEmpty) continue;
          final maxWeight = completedSets
              .map((s) => s.weight!)
              .reduce((a, b) => a > b ? a : b);
          final isPR = await ref.read(prRepositoryProvider).checkAndSavePR(
                ex.exerciseId!,
                ex.exerciseName,
                session.workoutType,
                maxWeight,
                'kg',
                0,
              );
          if (isPR) prCount++;
        }
      }

      ts.prCount = prCount;
      await ref.read(sessionRepositoryProvider).save(ts);
      await ref
          .read(macroCycleRepositoryProvider)
          .incrementCompletedSessions();
    }

    notifier.clear();
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        ref.watch(themeProvider).valueOrNull ?? ForgeThemes.teal;
    final session = ref.watch(activeSessionProvider);

    final workoutName = session?.workoutName ?? '—';
    final durationMin =
        session != null ? session.durationSeconds ~/ 60 : 0;
    final volume = session?.totalVolume ?? 0.0;
    final sets = session?.exercises.fold<int>(
            0,
            (s, e) =>
                s + e.sets.where((set) => set.completed).length) ??
        0;

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Column(children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: theme.accent.withOpacity(.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: theme.accent, width: 2)),
                    child: Icon(Icons.check, color: theme.accent, size: 28),
                  ),
                  const SizedBox(height: 12),
                  const Text('Treino Concluído!',
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 32,
                          color: ForgeColors.text)),
                  Text('$workoutName · ${durationMin}min',
                      style: const TextStyle(
                          fontSize: 13, color: ForgeColors.muted)),
                ])),
                const SizedBox(height: 24),
                Row(children: [
                  _StatMini(
                      value: '${durationMin}min',
                      label: 'Tempo',
                      accent: theme.accent),
                  const SizedBox(width: 8),
                  _StatMini(
                      value: volume > 0
                          ? '${(volume / 1000).toStringAsFixed(1)}t'
                          : '—',
                      label: 'Volume',
                      accent: theme.accent),
                  const SizedBox(width: 8),
                  _StatMini(
                      value: '$sets',
                      label: 'Séries',
                      accent: theme.accent),
                ]),
                const SizedBox(height: 18),
                const _SLabel('Como foi o treino?'),
                Row(
                    children: ['😵', '😓', '😊', '💪', '🔥']
                        .asMap()
                        .entries
                        .map((e) => Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _effort = e.key),
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: e.key < 4 ? 8 : 0),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _effort == e.key
                                        ? theme.accent.withOpacity(.12)
                                        : ForgeColors.card,
                                    border: Border.all(
                                        color: _effort == e.key
                                            ? theme.accent
                                            : ForgeColors.border),
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: Text(e.value,
                                      textAlign: TextAlign.center,
                                      style:
                                          const TextStyle(fontSize: 20)),
                                ),
                              ),
                            ))
                        .toList()),
                const SizedBox(height: 20),
                const _SLabel('Notas'),
                Container(
                  decoration: BoxDecoration(
                      color: ForgeColors.card,
                      border: Border.all(color: ForgeColors.border),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    controller: _notesCtrl,
                    maxLines: 3,
                    style: const TextStyle(
                        fontSize: 13, color: ForgeColors.text),
                    decoration: const InputDecoration(
                        hintText: 'Anotações opcionais...',
                        hintStyle:
                            TextStyle(color: ForgeColors.muted),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(14)),
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _saving ? null : _save,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: _saving
                            ? ForgeColors.muted2
                            : theme.accent,
                        borderRadius: BorderRadius.circular(14)),
                    child: Text(
                        _saving ? 'SALVANDO...' : 'SALVAR SESSÃO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 20,
                            color: theme.id == 'neon'
                                ? Colors.black
                                : ForgeColors.bg)),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

// ── Shared widgets
class _StatMini extends StatelessWidget {
  final String value, label;
  final Color accent;
  const _StatMini(
      {required this.value,
      required this.label,
      required this.accent});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
              color: ForgeColors.card,
              border: Border.all(color: ForgeColors.border),
              borderRadius: BorderRadius.circular(14)),
          child: Column(children: [
            Text(value,
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 20,
                    color: accent,
                    letterSpacing: 0)),
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: ForgeColors.muted)),
          ]),
        ),
      );
}

class _SLabel extends StatelessWidget {
  final String text;
  const _SLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text.toUpperCase(),
            style: const TextStyle(
                fontSize: 9,
                color: ForgeColors.muted,
                letterSpacing: 2,
                fontWeight: FontWeight.w600)),
      );
}

class _XBtn extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  const _XBtn({required this.onTap, this.icon = LucideIcons.x});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
              border: Border.all(color: ForgeColors.border),
              shape: BoxShape.circle),
          child: Icon(icon, color: ForgeColors.muted, size: 16),
        ),
      );
}