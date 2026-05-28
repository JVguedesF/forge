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
  const SessionScreen({
    super.key,
    this.mode = SessionMode.musculacao,
    this.workoutId,
    this.workoutName = '',
  });

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final type = switch (widget.mode) {
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
          workoutName: widget.workoutName,
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

// ── Modelo interno de série ao vivo
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

// ── Modelo interno de exercício ao vivo
class _ExEntry {
  final int? exerciseId;
  final String name;
  final List<String> tags;
  final String reps;
  final double? suggestedWeight;
  final int restSeconds;
  final ExerciseType type;
  final List<_LiveSet> sets;

  _ExEntry({
    this.exerciseId,
    required this.name,
    required this.tags,
    required this.reps,
    this.suggestedWeight,
    required this.restSeconds,
    required this.type,
    required this.sets,
  });
}

// ════════════════════════════════════
// MUSCULAÇÃO
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

  List<_ExEntry> _exercises = [];
  int _exIdx = 0;

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
      // fallback estático se não tiver treino
      setState(() {
        _exercises = [
          _ExEntry(
            name: widget.workoutName.isNotEmpty
                ? widget.workoutName
                : 'Treino Livre',
            tags: [],
            reps: '10',
            restSeconds: 90,
            type: ExerciseType.weightReps,
            sets: List.generate(3, (_) => _LiveSet(prevBest: '—')),
          )
        ];
        _exercises.first.sets.first.active = true;
        _loading = false;
      });
      return;
    }

    final entries = <_ExEntry>[];
    for (final block in workout.blocks) {
      for (final ex in block.exercises) {
        final kgStr = ex.suggestedWeight?.toStringAsFixed(0) ?? '';
        final prev = kgStr.isNotEmpty
            ? '${kgStr}kg×${ex.reps}'
            : ex.reps.isNotEmpty
                ? ex.reps
                : '—';
        final liveSets = List.generate(
            block.sets,
            (_) => _LiveSet(
                  prevBest: prev,
                  kg: kgStr,
                ));
        if (liveSets.isNotEmpty) liveSets.first.active = true;

        entries.add(_ExEntry(
          exerciseId: ex.exerciseId,
          name: ex.exerciseName,
          tags: [],
          reps: ex.reps.isNotEmpty ? ex.reps : '—',
          suggestedWeight: ex.suggestedWeight,
          restSeconds: block.restAfterSeconds > 0 ? block.restAfterSeconds : 90,
          type: ex.type,
          sets: liveSets,
        ));
      }
    }

    setState(() {
      _exercises = entries;
      _loading = false;
    });
  }

  _ExEntry? get _currentEx => _exercises.isEmpty ? null : _exercises[_exIdx];

  int get _currentSetIdx => _currentEx?.sets.indexWhere((s) => s.active) ?? -1;

  void _completeSet() {
    final ex = _currentEx;
    if (ex == null) return;
    final setIdx = _currentSetIdx;
    if (setIdx < 0) return;

    final set = ex.sets[setIdx];
    final kg = double.tryParse(set.kg);
    final reps = int.tryParse(set.reps);

    ref.read(activeSessionProvider.notifier).addCompletedSet(
          exerciseName: ex.name,
          exerciseId: ex.exerciseId ?? 0,
          weight: kg,
          reps: reps,
          durationSeconds: null,
        );

    setState(() {
      set.done = true;
      set.active = false;

      _rest = ex.restSeconds;
      _restTotal = ex.restSeconds;
      _restTimer?.cancel();
      _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          if (_rest > 0) _rest--;
        });
      });

      if (setIdx + 1 < ex.sets.length) {
        ex.sets[setIdx + 1].active = true;
      } else {
        // último set deste exercício
        if (_exIdx + 1 < _exercises.length) {
          _exIdx++;
          if (_exercises[_exIdx].sets.isNotEmpty) {
            _exercises[_exIdx].sets.first.active = true;
          }
        } else {
          // fim do treino
          _elapsedTimer?.cancel();
          widget.onEnd(_elapsed);
        }
      }
    });
  }

  void _prevEx() {
    if (_exIdx > 0) setState(() => _exIdx--);
  }

  void _nextEx() {
    if (_exIdx + 1 < _exercises.length) setState(() => _exIdx++);
  }

  String _fmt(int s) =>
      '${(s ~/ 3600).toString().padLeft(2, '0')}:${((s % 3600) ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
  String _fmtRest(int s) => '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final accent = widget.theme.accent;

    if (_loading) {
      return Scaffold(
        backgroundColor: ForgeColors.bg,
        body: Center(child: CircularProgressIndicator(color: accent)),
      );
    }

    if (_exercises.isEmpty) {
      return Scaffold(
        backgroundColor: ForgeColors.bg,
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

    final ex = _currentEx!;
    final setIdx = _currentSetIdx;
    final doneSets = ex.sets.where((s) => s.done).length;
    final restPct =
        _restTotal > 0 ? (1 - _rest / _restTotal).clamp(0.0, 1.0) : 1.0;
    final totalEx = _exercises.length;
    final progressPct = totalEx > 0
        ? (_exIdx + (doneSets / ex.sets.length.clamp(1, 999))) / totalEx
        : 0.0;

    // Controllers para o set ativo
    final activeSet = setIdx >= 0 ? ex.sets[setIdx] : null;

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(children: [
          // AppBar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(children: [
              _XBtn(onTap: () => context.pop()),
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
                child: Text('${_exIdx + 1} / $totalEx',
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
                valueColor: AlwaysStoppedAnimation(ForgeColors.musculacaoLight),
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
                    if (ex.tags.isNotEmpty)
                      Wrap(
                          spacing: 4,
                          children: ex.tags
                              .map((t) => _TagChip(t,
                                  color: ForgeColors.musculacaoLight))
                              .toList()),
                    const SizedBox(height: 6),
                    Text(ex.name,
                        style: const TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 46,
                            color: ForgeColors.text,
                            height: .92)),
                    const SizedBox(height: 4),
                    Text(
                        '${ex.sets.length} séries · ${ex.reps} reps · ${ex.restSeconds}s descanso',
                        style: const TextStyle(
                            fontSize: 12, color: ForgeColors.muted)),
                    const SizedBox(height: 14),

                    // Tabela de séries
                    _LiveSetTable(
                        sets: ex.sets,
                        accent: accent,
                        onKgChanged: (i, v) =>
                            setState(() => ex.sets[i].kg = v),
                        onRepsChanged: (i, v) =>
                            setState(() => ex.sets[i].reps = v)),
                    const SizedBox(height: 10),

                    // Timer de descanso
                    if (_rest > 0 || _restTotal > 0)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: ForgeColors.card,
                            border: Border.all(color: ForgeColors.border),
                            borderRadius: BorderRadius.circular(14)),
                        child: Row(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                valueColor: AlwaysStoppedAnimation(accent)),
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
                                  border: Border.all(color: ForgeColors.border),
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Text('Pular',
                                  style: TextStyle(
                                      fontSize: 11, color: ForgeColors.muted)),
                            ),
                          ),
                        ]),
                      ),
                    const SizedBox(height: 12),

                    // Botão principal
                    GestureDetector(
                      onTap: activeSet != null ? _completeSet : null,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: activeSet != null
                              ? ForgeColors.musculacao
                              : ForgeColors.muted2,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          setIdx >= 0
                              ? 'CONCLUIR SÉRIE ${setIdx + 1} →'
                              : 'EXERCÍCIO CONCLUÍDO ✓',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      GestureDetector(
                        onTap: _exIdx > 0 ? _prevEx : null,
                        child: Text('← Anterior',
                            style: TextStyle(
                                fontSize: 12,
                                color: _exIdx > 0
                                    ? ForgeColors.muted
                                    : ForgeColors.muted3)),
                      ),
                      const SizedBox(width: 28),
                      GestureDetector(
                        onTap: _exIdx + 1 < _exercises.length ? _nextEx : null,
                        child: Text('Pular →',
                            style: TextStyle(
                                fontSize: 12,
                                color: _exIdx + 1 < _exercises.length
                                    ? ForgeColors.muted
                                    : ForgeColors.muted3)),
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

// Tabela de séries ao vivo com campos editáveis
class _LiveSetTable extends StatelessWidget {
  final List<_LiveSet> sets;
  final Color accent;
  final void Function(int, String) onKgChanged;
  final void Function(int, String) onRepsChanged;
  const _LiveSetTable(
      {required this.sets,
      required this.accent,
      required this.onKgChanged,
      required this.onRepsChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.hardEdge,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: ForgeColors.surface,
          child: const Row(children: [
            SizedBox(
                width: 28,
                child: Text('#',
                    style: TextStyle(
                        fontSize: 9,
                        color: ForgeColors.muted,
                        fontWeight: FontWeight.w600))),
            Expanded(
                child: Text('ANTERIOR',
                    style: TextStyle(
                        fontSize: 9,
                        color: ForgeColors.muted,
                        fontWeight: FontWeight.w600))),
            SizedBox(
                width: 70,
                child: Text('KG',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 9,
                        color: ForgeColors.muted,
                        fontWeight: FontWeight.w600))),
            SizedBox(
                width: 70,
                child: Text('REPS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 9,
                        color: ForgeColors.muted,
                        fontWeight: FontWeight.w600))),
            SizedBox(width: 30),
          ]),
        ),
        ...sets.asMap().entries.map((e) => _LiveSetRow(
              index: e.key,
              set: e.value,
              accent: accent,
              onKgChanged: (v) => onKgChanged(e.key, v),
              onRepsChanged: (v) => onRepsChanged(e.key, v),
            )),
      ]),
    );
  }
}

class _LiveSetRow extends StatefulWidget {
  final int index;
  final _LiveSet set;
  final Color accent;
  final void Function(String) onKgChanged;
  final void Function(String) onRepsChanged;
  const _LiveSetRow(
      {required this.index,
      required this.set,
      required this.accent,
      required this.onKgChanged,
      required this.onRepsChanged});

  @override
  State<_LiveSetRow> createState() => _LiveSetRowState();
}

class _LiveSetRowState extends State<_LiveSetRow> {
  late TextEditingController _kgCtrl;
  late TextEditingController _repsCtrl;

  @override
  void initState() {
    super.initState();
    _kgCtrl = TextEditingController(text: widget.set.kg);
    _repsCtrl = TextEditingController(text: widget.set.reps);
  }

  @override
  void didUpdateWidget(_LiveSetRow old) {
    super.didUpdateWidget(old);
    if (old.set.active != widget.set.active && !widget.set.active) {
      _kgCtrl.text = widget.set.kg;
      _repsCtrl.text = widget.set.reps;
    }
  }

  @override
  void dispose() {
    _kgCtrl.dispose();
    _repsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.set.active;
    final isDone = widget.set.done;
    final isPending = !isActive && !isDone;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: isActive ? widget.accent.withOpacity(.12) : Colors.transparent,
        border: Border(
          top: BorderSide(
              color: isActive
                  ? widget.accent.withOpacity(.3)
                  : ForgeColors.border),
          left: isActive
              ? BorderSide(color: widget.accent, width: 3)
              : BorderSide.none,
        ),
      ),
      child: Opacity(
        opacity: isPending ? .3 : 1,
        child: Row(children: [
          SizedBox(
              width: 28,
              child: Text('${widget.index + 1}',
                  style: TextStyle(
                      fontSize: 13,
                      color: isActive ? widget.accent : ForgeColors.muted,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal))),
          Expanded(
              child: Text(widget.set.prevBest,
                  style: const TextStyle(
                      fontSize: 11, color: ForgeColors.muted2))),
          SizedBox(
              width: 70,
              child: _EditCell(
                  controller: _kgCtrl,
                  active: isActive,
                  done: isDone,
                  accent: widget.accent,
                  onChanged: widget.onKgChanged)),
          SizedBox(
              width: 70,
              child: _EditCell(
                  controller: _repsCtrl,
                  active: isActive,
                  done: isDone,
                  accent: widget.accent,
                  onChanged: widget.onRepsChanged,
                  placeholder: '—')),
          SizedBox(
              width: 30,
              child: isDone
                  ? Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                          color: Color(0xFF22c55e), shape: BoxShape.circle),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 13))
                  : isActive
                      ? Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: widget.accent, width: 2)),
                          child: Center(
                              child: Text('○',
                                  style: TextStyle(
                                      fontSize: 11, color: widget.accent))))
                      : Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: ForgeColors.muted3, width: 2)))),
        ]),
      ),
    );
  }
}

class _EditCell extends StatelessWidget {
  final TextEditingController controller;
  final bool active, done;
  final Color accent;
  final void Function(String) onChanged;
  final String placeholder;
  const _EditCell(
      {required this.controller,
      required this.active,
      required this.done,
      required this.accent,
      required this.onChanged,
      this.placeholder = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        color: active
            ? accent.withOpacity(.12)
            : ForgeColors.border.withOpacity(.5),
        border: active ? Border.all(color: accent) : null,
        borderRadius: BorderRadius.circular(7),
      ),
      child: done
          ? Center(
              child: Text(
                  controller.text.isNotEmpty ? controller.text : placeholder,
                  style: TextStyle(
                      fontSize: 12,
                      color: accent,
                      fontWeight: FontWeight.w500)))
          : TextField(
              controller: controller,
              enabled: active,
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: active ? accent : ForgeColors.text,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
                hintText: placeholder,
                hintStyle:
                    const TextStyle(fontSize: 12, color: ForgeColors.muted2),
              ),
            ),
    );
  }
}

// ════════════════════════════════════
// TIMED
// ════════════════════════════════════
class _TimedSession extends ConsumerStatefulWidget {
  final ForgeTheme theme;
  final String workoutName;
  final void Function(int elapsed) onEnd;
  const _TimedSession(
      {required this.theme, required this.onEnd, this.workoutName = ''});

  @override
  ConsumerState<_TimedSession> createState() => _TimedSessionState();
}

class _TimedSessionState extends ConsumerState<_TimedSession> {
  int _elapsed = 0;
  int _countdown = 45;
  final int _totalCountdown = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setState(() {
              _elapsed++;
              if (_countdown > 0) _countdown--;
            }));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(int s) =>
      '${(s ~/ 3600).toString().padLeft(2, '0')}:${((s % 3600) ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    const color = ForgeColors.mobilidade;
    const colorLight = ForgeColors.mobilidadeLight;
    final pct = _countdown / _totalCountdown;

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(children: [
              _XBtn(onTap: () => context.pop()),
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
                    style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 20,
                        color: colorLight,
                        letterSpacing: 0)),
              ])),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: ForgeColors.card,
                    border: Border.all(color: ForgeColors.border),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('1 / 1',
                    style: TextStyle(fontSize: 11, color: ForgeColors.muted)),
              ),
            ]),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                  value: .25,
                  minHeight: 4,
                  backgroundColor: ForgeColors.border,
                  valueColor: const AlwaysStoppedAnimation(color)),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                      color: color.withOpacity(.1),
                      border: Border.all(color: color.withOpacity(.28)),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Row(children: [
                    Text('🦵 Membros Inferiores',
                        style: TextStyle(
                            fontSize: 11,
                            color: colorLight,
                            fontWeight: FontWeight.w600)),
                    Spacer(),
                    Text('⚠ Escoliose',
                        style: TextStyle(fontSize: 10, color: color)),
                  ]),
                ),
                const SizedBox(height: 14),
                Wrap(spacing: 4, children: const [
                  _TagChip('Membros Inf.', color: colorLight),
                  _TagChip('Alongamento')
                ]),
                const SizedBox(height: 8),
                const Text('Figura 4\nDeitado',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 38,
                        color: ForgeColors.text,
                        height: .95)),
                const SizedBox(height: 4),
                const Text('Cruze tornozelo sobre joelho, puxe coxa',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: ForgeColors.muted)),
                const SizedBox(height: 10),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(radius: 5, backgroundColor: colorLight),
                      SizedBox(width: 10),
                      Text('LADO ESQUERDO',
                          style: TextStyle(
                              fontSize: 12,
                              color: colorLight,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .5)),
                      SizedBox(width: 10),
                      CircleAvatar(
                          radius: 5, backgroundColor: ForgeColors.border),
                    ]),
                const SizedBox(height: 22),
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(alignment: Alignment.center, children: [
                    CustomPaint(
                        size: const Size(140, 140),
                        painter: _CircleTimerPainter(pct: pct, color: color)),
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
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                      color: ForgeColors.card,
                      border: Border.all(color: ForgeColors.border),
                      borderRadius: BorderRadius.circular(12)),
                  child: RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                        text: 'A seguir: ',
                        style:
                            TextStyle(fontSize: 10, color: ForgeColors.muted)),
                    TextSpan(
                        text: 'Figura 4 — Lado Direito',
                        style: TextStyle(
                            fontSize: 12,
                            color: ForgeColors.text,
                            fontWeight: FontWeight.w500)),
                  ])),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => widget.onEnd(_elapsed),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(14)),
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

  @override
  Widget build(BuildContext context) {
    const color = ForgeColors.corrida;
    const colorLight = ForgeColors.corridaLight;

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(children: [
              _XBtn(onTap: () => context.pop()),
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
                    style: TextStyle(fontSize: 13, color: ForgeColors.muted)),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                      color: ForgeColors.card,
                      border: Border.all(color: color.withOpacity(.3)),
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
                          style:
                              TextStyle(fontSize: 9, color: ForgeColors.muted)),
                    ]),
                    Container(
                        width: 1,
                        height: 36,
                        color: ForgeColors.border,
                        margin: const EdgeInsets.symmetric(horizontal: 24)),
                    const Column(children: [
                      Text('5:30',
                          style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 22,
                              color: colorLight,
                              letterSpacing: 0)),
                      Text('pace alvo/km',
                          style:
                              TextStyle(fontSize: 9, color: ForgeColors.muted)),
                    ]),
                  ]),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      color: ForgeColors.card,
                      border: Border.all(color: ForgeColors.border),
                      borderRadius: BorderRadius.circular(14)),
                  clipBehavior: Clip.hardEdge,
                  child: Column(children: [
                    _StepRow(
                        done: true,
                        label: 'Aquecimento',
                        dist: '1 km',
                        color: color),
                    _StepRow(
                        current: true,
                        label: 'Corrida Principal',
                        dist: '6 km',
                        color: color),
                    _StepRow(
                        done: false,
                        label: 'Volta à Calma',
                        dist: '1 km',
                        color: color,
                        last: true),
                  ]),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => widget.onEnd(_elapsed),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(14)),
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

class _StepRow extends StatelessWidget {
  final bool done, current, last;
  final String label, dist;
  final Color color;
  const _StepRow(
      {this.done = false,
      this.current = false,
      this.last = false,
      required this.label,
      required this.dist,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: current ? color.withOpacity(.05) : Colors.transparent,
        border: Border(
            left:
                current ? BorderSide(color: color, width: 3) : BorderSide.none,
            bottom: last
                ? BorderSide.none
                : const BorderSide(color: ForgeColors.border)),
      ),
      child: Row(children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color: done
                  ? const Color(0xFF22c55e)
                  : current
                      ? color
                      : ForgeColors.border,
              shape: BoxShape.circle),
          child: done
              ? const Icon(Icons.check, color: Colors.white, size: 12)
              : current
                  ? const Icon(Icons.play_arrow, color: Colors.white, size: 10)
                  : null,
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: done
                        ? ForgeColors.muted
                        : current
                            ? ForgeColors.text
                            : ForgeColors.muted2,
                    fontWeight:
                        current ? FontWeight.w600 : FontWeight.normal))),
        Text(dist,
            style: TextStyle(
                fontSize: 12,
                color: done
                    ? ForgeColors.muted2
                    : current
                        ? ForgeColors.corridaLight
                        : ForgeColors.muted2)),
      ]),
    );
  }
}

// ════════════════════════════════════
// FORMULÁRIO PÓS-CORRIDA
// ════════════════════════════════════
class RunFormScreen extends ConsumerStatefulWidget {
  const RunFormScreen({super.key});

  @override
  ConsumerState<RunFormScreen> createState() => _RunFormScreenState();
}

class _RunFormScreenState extends ConsumerState<RunFormScreen> {
  final _kmCtrl = TextEditingController(text: '');
  final _timeCtrl = TextEditingController(text: '');

  double get _km => double.tryParse(_kmCtrl.text) ?? 0;
  int get _totalSeconds {
    final parts = _timeCtrl.text.split(':');
    if (parts.length == 2)
      return (int.tryParse(parts[0]) ?? 0) * 60 + (int.tryParse(parts[1]) ?? 0);
    return 0;
  }

  String get _pace {
    if (_km <= 0 || _totalSeconds <= 0) return '—';
    final sPerKm = _totalSeconds / _km;
    final m = sPerKm ~/ 60;
    final s = (sPerKm % 60).round();
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _save() {
    ref
        .read(activeSessionProvider.notifier)
        .setRunData(km: _km, totalSeconds: _totalSeconds, paces: []);
    context.pushReplacement('/session/summary');
  }

  @override
  void dispose() {
    _kmCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const color = ForgeColors.corrida;
    const colorLight = ForgeColors.corridaLight;

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Row(children: [
              _XBtn(onTap: () => context.pop(), icon: LucideIcons.arrow_left),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(10)),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const _SLabel('Km totais'),
                            _InputBox(
                                controller: _kmCtrl,
                                color: color,
                                colorLight: colorLight,
                                onChanged: (_) => setState(() {}),
                                hint: '0.0'),
                          ])),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Pace médio calculado',
                                style: TextStyle(
                                    fontSize: 13, color: ForgeColors.muted)),
                            Text('$_pace /km',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: colorLight,
                                    fontWeight: FontWeight.w600)),
                          ]),
                    ),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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

class _SessionSummaryScreenState extends ConsumerState<SessionSummaryScreen> {
  int? _effort;
  final _notesCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // Guard síncrono — evita double-save se usuário tocar duas vezes rápido
    if (_saving) return;
    _saving = true;
    if (mounted) setState(() {});

    final notifier = ref.read(activeSessionProvider.notifier);
    notifier.setEffort(_effort ?? 3);
    notifier.setNotes(_notesCtrl.text);

    final session = ref.read(activeSessionProvider);
    if (session != null) {
      final ts = session.toTrainingSession();

      // Detecta PRs (apenas musculação tem peso)
      int prCount = 0;
      if (session.workoutType == WorkoutType.musculacao) {
        for (final ex in session.exercises) {
          if (ex.exerciseId == null || ex.exerciseId == 0) continue;
          final completedSets = ex.sets
              .where((s) => s.completed && s.weight != null && s.weight! > 0)
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

      // Incrementa completedSessions no macro (uma única vez)
      await ref.read(macroCycleRepositoryProvider).incrementCompletedSessions();
    }

    notifier.clear();
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider).valueOrNull ?? ForgeThemes.teal;
    final session = ref.watch(activeSessionProvider);

    final workoutName = session?.workoutName ?? '—';
    final durationMin = session != null ? session.durationSeconds ~/ 60 : 0;
    final volume = session?.totalVolume ?? 0.0;
    final sets = session?.exercises.fold<int>(
            0, (s, e) => s + e.sets.where((set) => set.completed).length) ??
        0;

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
                child: Column(children: [
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: theme.accent.withOpacity(.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.accent, width: 2)),
                child: Icon(Icons.check, color: theme.accent, size: 28),
              ),
              const SizedBox(height: 12),
              const Text('Treino Concluído!',
                  style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 32,
                      color: ForgeColors.text)),
              Text('$workoutName · ${durationMin}min',
                  style:
                      const TextStyle(fontSize: 13, color: ForgeColors.muted)),
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
              _StatMini(value: '$sets', label: 'Séries', accent: theme.accent),
            ]),
            const SizedBox(height: 18),
            const _SLabel('Como foi o treino?'),
            Row(
                children: ['😵', '😓', '😊', '💪', '🔥']
                    .asMap()
                    .entries
                    .map((e) => Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _effort = e.key),
                            child: Container(
                              margin: EdgeInsets.only(right: e.key < 4 ? 8 : 0),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _effort == e.key
                                    ? theme.accent.withOpacity(.12)
                                    : ForgeColors.card,
                                border: Border.all(
                                    color: _effort == e.key
                                        ? theme.accent
                                        : ForgeColors.border),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(e.value,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20)),
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
                style: const TextStyle(fontSize: 13, color: ForgeColors.text),
                decoration: const InputDecoration(
                    hintText: 'Anotações opcionais...',
                    hintStyle: TextStyle(color: ForgeColors.muted),
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
                    color: _saving ? ForgeColors.muted2 : theme.accent,
                    borderRadius: BorderRadius.circular(14)),
                child: Text(_saving ? 'SALVANDO...' : 'SALVAR SESSÃO',
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
class _TagChip extends StatelessWidget {
  final String label;
  final Color? color;
  const _TagChip(this.label, {this.color});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(right: 4, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
            color: (color ?? ForgeColors.muted).withOpacity(.1),
            borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: TextStyle(
                fontSize: 9,
                color: color ?? ForgeColors.muted,
                fontWeight: FontWeight.w500)),
      );
}

class _StatMini extends StatelessWidget {
  final String value, label;
  final Color accent;
  const _StatMini(
      {required this.value, required this.label, required this.accent});

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
                style: const TextStyle(fontSize: 10, color: ForgeColors.muted)),
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
