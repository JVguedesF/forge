import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import '../core/helpers/forge_helpers.dart';
import '../providers/session_providers.dart';
import '../providers/workout_providers.dart';
import '../data/models/macro_cycle.dart';
import '../data/models/enums.dart';
import '../data/repositories/macro_cycle_repository.dart';

class MacroScreen extends ConsumerStatefulWidget {
  const MacroScreen({super.key});

  @override
  ConsumerState<MacroScreen> createState() => _MacroScreenState();
}

class _MacroScreenState extends ConsumerState<MacroScreen> {
  bool _editing = false;
  MacroCycle? _draft;
  final _nameCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _startEditing(MacroCycle cycle) {
    // Deep copy para edição
    _draft = _cloneCycle(cycle);
    _nameCtrl.text = _draft!.name;
    setState(() => _editing = true);
  }

  MacroCycle _cloneCycle(MacroCycle c) {
    final clone = MacroCycle()
      ..id = c.id
      ..name = c.name
      ..description = c.description
      ..currentPhaseIndex = c.currentPhaseIndex
      ..startDate = c.startDate
      ..isActive = c.isActive
      ..phases = c.phases.map(_clonePhase).toList();
    return clone;
  }

  Phase _clonePhase(Phase p) {
    return Phase()
      ..name = p.name
      ..objective = p.objective
      ..durationWeeks = p.durationWeeks
      ..targetSessions = p.targetSessions
      ..completedSessions = p.completedSessions
      ..intensityPercent = p.intensityPercent
      ..recommendedSets = p.recommendedSets
      ..recommendedReps = p.recommendedReps
      ..deloadWeeks = List<int>.from(p.deloadWeeks)
      ..weeklySchedule = p.weeklySchedule.map(_cloneDaySchedule).toList()
      ..goals = p.goals.map(_cloneGoal).toList()
      ..startDate = p.startDate
      ..isCompleted = p.isCompleted;
  }

  DaySchedule _cloneDaySchedule(DaySchedule d) {
    return DaySchedule()
      ..weekday = d.weekday
      ..workoutIds = List<int>.from(d.workoutIds)
      ..workoutNames = List<String>.from(d.workoutNames);
  }

  PhaseGoal _cloneGoal(PhaseGoal g) {
    return PhaseGoal()
      ..type = g.type
      ..workoutType = g.workoutType
      ..description = g.description
      ..unit = g.unit
      ..target = g.target
      ..current = g.current
      ..exerciseId = g.exerciseId
      ..exerciseName = g.exerciseName;
  }

  Future<void> _saveEdits(MacroCycle original) async {
    if (_draft == null || _saving) return;
    setState(() => _saving = true);
    _draft!.name =
        _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : _draft!.name;
    await ref.read(macroCycleRepositoryProvider).save(_draft!);
    setState(() {
      _saving = false;
      _editing = false;
      _draft = null;
    });
  }

  void _cancelEdits() {
    setState(() {
      _editing = false;
      _draft = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider).valueOrNull ?? ForgeThemes.teal;
    final macroAsync = ref.watch(activeMacroCycleProvider);

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(children: [
          _AppBar(
            editing: _editing,
            saving: _saving,
            onBack: () {
              if (_editing) {
                _cancelEdits();
              } else {
                context.pop();
              }
            },
            onEdit: macroAsync.valueOrNull != null && !_editing
                ? () => _startEditing(macroAsync.value!)
                : null,
            onSave: _editing && macroAsync.valueOrNull != null
                ? () => _saveEdits(macroAsync.value!)
                : null,
            theme: theme,
          ),
          Expanded(
            child: macroAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                  child: Text('Erro: $e',
                      style: const TextStyle(color: ForgeColors.muted))),
              data: (cycle) {
                if (cycle == null) return _EmptyState(theme: theme);
                final display = _editing ? _draft! : cycle;
                return _MacroBody(
                  cycle: display,
                  editing: _editing,
                  theme: theme,
                  nameCtrl: _nameCtrl,
                  onChanged: () => setState(() {}),
                  onAddPhase: _editing
                      ? () {
                          setState(() {
                            _draft!.phases.add(Phase()
                              ..name = 'Fase ${_draft!.phases.length + 1}'
                              ..durationWeeks = 4
                              ..targetSessions = 16
                              ..intensityPercent = 70);
                          });
                        }
                      : null,
                  onDeletePhase: _editing
                      ? (i) => setState(() => _draft!.phases.removeAt(i))
                      : null,
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class _MacroBody extends ConsumerWidget {
  final MacroCycle cycle;
  final bool editing;
  final ForgeTheme theme;
  final TextEditingController nameCtrl;
  final VoidCallback onChanged;
  final VoidCallback? onAddPhase;
  final void Function(int)? onDeletePhase;

  const _MacroBody({
    required this.cycle,
    required this.editing,
    required this.theme,
    required this.nameCtrl,
    required this.onChanged,
    this.onAddPhase,
    this.onDeletePhase,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      children: [
        // Nome do ciclo
        if (editing) ...[
          const _SLabel('Nome do ciclo'),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
                color: ForgeColors.card,
                border: Border.all(color: ForgeColors.border),
                borderRadius: BorderRadius.circular(12)),
            child: TextField(
              controller: nameCtrl,
              style: const TextStyle(fontSize: 15, color: ForgeColors.text),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
            ),
          ),
        ] else ...[
          _CycleHeader(cycle: cycle, theme: theme),
          const SizedBox(height: 16),
        ],

        // Fases
        const _SLabel('Fases'),
        ...cycle.phases.asMap().entries.map((e) {
          final i = e.key;
          final phase = e.value;
          final isActive = i == cycle.currentPhaseIndex;
          return _PhaseCard(
            phase: phase,
            index: i,
            isActive: isActive,
            editing: editing,
            theme: theme,
            onChanged: onChanged,
            onDelete: onDeletePhase != null ? () => onDeletePhase!(i) : null,
          );
        }),

        if (editing && onAddPhase != null)
          GestureDetector(
            onTap: onAddPhase,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: ForgeColors.card,
                  border: Border.all(
                      style: BorderStyle.solid, color: ForgeColors.muted2),
                  borderRadius: BorderRadius.circular(14)),
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.plus, color: ForgeColors.muted, size: 16),
                    SizedBox(width: 8),
                    Text('Adicionar fase',
                        style:
                            TextStyle(fontSize: 13, color: ForgeColors.muted)),
                  ]),
            ),
          ),

        if (!editing && cycle.phases.isNotEmpty) ...[
          const SizedBox(height: 8),
          _WeeklyRoutine(
              phase: cycle.phases[cycle.currentPhaseIndex], theme: theme),
          const SizedBox(height: 16),
          _PhaseGoals(
              phase: cycle.phases[cycle.currentPhaseIndex], theme: theme),
        ],
      ],
    );
  }
}

// Card de fase com modo edição completo
class _PhaseCard extends StatefulWidget {
  final Phase phase;
  final int index;
  final bool isActive;
  final bool editing;
  final ForgeTheme theme;
  final VoidCallback onChanged;
  final VoidCallback? onDelete;

  const _PhaseCard({
    required this.phase,
    required this.index,
    required this.isActive,
    required this.editing,
    required this.theme,
    required this.onChanged,
    this.onDelete,
  });

  @override
  State<_PhaseCard> createState() => _PhaseCardState();
}

class _PhaseCardState extends State<_PhaseCard> {
  bool _expanded = false;
  late TextEditingController _nameCtrl;
  late TextEditingController _objCtrl;
  late TextEditingController _weeksCtrl;
  late TextEditingController _sessCtrl;
  late TextEditingController _intensCtrl;
  late TextEditingController _setsCtrl;
  late TextEditingController _repsCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.phase.name);
    _objCtrl = TextEditingController(text: widget.phase.objective ?? '');
    _weeksCtrl =
        TextEditingController(text: widget.phase.durationWeeks.toString());
    _sessCtrl =
        TextEditingController(text: widget.phase.targetSessions.toString());
    _intensCtrl = TextEditingController(
        text: widget.phase.intensityPercent?.toStringAsFixed(0) ?? '70');
    _setsCtrl = TextEditingController(
        text: widget.phase.recommendedSets?.toString() ?? '4');
    _repsCtrl =
        TextEditingController(text: widget.phase.recommendedReps ?? '8-10');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _objCtrl.dispose();
    _weeksCtrl.dispose();
    _sessCtrl.dispose();
    _intensCtrl.dispose();
    _setsCtrl.dispose();
    _repsCtrl.dispose();
    super.dispose();
  }

  void _applyChanges() {
    widget.phase.name = _nameCtrl.text.trim().isNotEmpty
        ? _nameCtrl.text.trim()
        : widget.phase.name;
    widget.phase.objective = _objCtrl.text.trim();
    widget.phase.durationWeeks =
        int.tryParse(_weeksCtrl.text) ?? widget.phase.durationWeeks;
    widget.phase.targetSessions =
        int.tryParse(_sessCtrl.text) ?? widget.phase.targetSessions;
    widget.phase.intensityPercent =
        double.tryParse(_intensCtrl.text) ?? widget.phase.intensityPercent;
    widget.phase.recommendedSets = int.tryParse(_setsCtrl.text);
    widget.phase.recommendedReps = _repsCtrl.text.trim();
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final barColor = widget.isActive ? widget.theme.accent : ForgeColors.muted2;
    final pct = widget.phase.targetSessions > 0
        ? (widget.phase.completedSessions / widget.phase.targetSessions)
            .clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: ForgeColors.card,
        border: Border.all(
            color: widget.isActive
                ? widget.theme.accent.withOpacity(.3)
                : ForgeColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: [
        // Header da fase
        GestureDetector(
          onTap: widget.editing
              ? () => setState(() => _expanded = !_expanded)
              : null,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                width: 4,
                height: 50,
                decoration: BoxDecoration(
                    color: barColor, borderRadius: BorderRadius.circular(4)),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      if (widget.isActive)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                              color: widget.theme.accent.withOpacity(.15),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text('ATUAL',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: widget.theme.accent,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1)),
                        ),
                      Expanded(
                        child: Text(widget.phase.name,
                            style: const TextStyle(
                                fontSize: 13,
                                color: ForgeColors.text,
                                fontWeight: FontWeight.w500)),
                      ),
                    ]),
                    const SizedBox(height: 2),
                    Text(widget.phase.objective ?? '',
                        style: const TextStyle(
                            fontSize: 11, color: ForgeColors.muted)),
                    const SizedBox(height: 6),
                    Row(children: [
                      Expanded(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 3,
                          backgroundColor: ForgeColors.border,
                          valueColor: AlwaysStoppedAnimation(barColor),
                        ),
                      )),
                      const SizedBox(width: 8),
                      Text(
                          '${widget.phase.completedSessions}/${widget.phase.targetSessions}',
                          style: TextStyle(
                              fontSize: 10,
                              color: widget.isActive
                                  ? widget.theme.accent
                                  : ForgeColors.muted)),
                    ]),
                  ])),
              if (widget.editing) ...[
                if (widget.onDelete != null)
                  GestureDetector(
                    onTap: widget.onDelete,
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(LucideIcons.trash_2,
                          color: ForgeColors.muted2, size: 16),
                    ),
                  ),
                Icon(
                    _expanded
                        ? LucideIcons.chevron_up
                        : LucideIcons.chevron_down,
                    color: ForgeColors.muted2,
                    size: 16),
              ],
            ]),
          ),
        ),

        // F8: Expanded edit fields
        if (widget.editing && _expanded)
          Container(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: ForgeColors.border))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 12),
              _EditRow(
                  label: 'Nome da fase',
                  controller: _nameCtrl,
                  onChanged: (_) => _applyChanges()),
              const SizedBox(height: 10),
              _EditRow(
                  label: 'Objetivo',
                  controller: _objCtrl,
                  onChanged: (_) => _applyChanges()),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                    child: _EditRow(
                        label: 'Semanas',
                        controller: _weeksCtrl,
                        numeric: true,
                        onChanged: (_) => _applyChanges())),
                const SizedBox(width: 10),
                Expanded(
                    child: _EditRow(
                        label: 'Sessões alvo',
                        controller: _sessCtrl,
                        numeric: true,
                        onChanged: (_) => _applyChanges())),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                    child: _EditRow(
                        label: 'Intensidade (%)',
                        controller: _intensCtrl,
                        numeric: true,
                        onChanged: (_) => _applyChanges())),
                const SizedBox(width: 10),
                Expanded(
                    child: _EditRow(
                        label: 'Séries rec.',
                        controller: _setsCtrl,
                        numeric: true,
                        onChanged: (_) => _applyChanges())),
                const SizedBox(width: 10),
                Expanded(
                    child: _EditRow(
                        label: 'Reps rec.',
                        controller: _repsCtrl,
                        onChanged: (_) => _applyChanges())),
              ]),
              const SizedBox(height: 14),

              // Deload weeks
              const Text('SEMANAS DE DELOAD',
                  style: TextStyle(
                      fontSize: 9,
                      color: ForgeColors.muted,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(widget.phase.durationWeeks, (i) {
                  final weekNum = i + 1;
                  final isDeload = widget.phase.deloadWeeks.contains(weekNum);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isDeload) {
                          widget.phase.deloadWeeks.remove(weekNum);
                        } else {
                          widget.phase.deloadWeeks.add(weekNum);
                        }
                      });
                      widget.onChanged();
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDeload
                            ? ForgeColors.corrida.withOpacity(.15)
                            : ForgeColors.surface,
                        border: Border.all(
                            color: isDeload
                                ? ForgeColors.corrida
                                : ForgeColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                          child: Text('S$weekNum',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: isDeload
                                      ? ForgeColors.corrida
                                      : ForgeColors.muted,
                                  fontWeight: isDeload
                                      ? FontWeight.w600
                                      : FontWeight.normal))),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),

              // F8: Rotina semanal editável
              _WeeklyScheduleEditor(
                  phase: widget.phase, onChanged: widget.onChanged),
              const SizedBox(height: 14),

              // F8: Metas editáveis
              _GoalsEditor(phase: widget.phase, onChanged: widget.onChanged),
            ]),
          ),
      ]),
    );
  }
}

// F8: Editor de rotina semanal
class _WeeklyScheduleEditor extends ConsumerStatefulWidget {
  final Phase phase;
  final VoidCallback onChanged;
  const _WeeklyScheduleEditor({required this.phase, required this.onChanged});

  @override
  ConsumerState<_WeeklyScheduleEditor> createState() =>
      _WeeklyScheduleEditorState();
}

class _WeeklyScheduleEditorState extends ConsumerState<_WeeklyScheduleEditor> {
  static const _dayLabels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  DaySchedule _scheduleForDay(int wd) {
    final existing =
        widget.phase.weeklySchedule.where((s) => s.weekday == wd).toList();
    if (existing.isNotEmpty) return existing.first;
    final newSched = DaySchedule()
      ..weekday = wd
      ..workoutIds = []
      ..workoutNames = [];
    widget.phase.weeklySchedule.add(newSched);
    return newSched;
  }

  Future<void> _addWorkoutToDay(BuildContext context, int wd) async {
    final workoutsAsync = ref.read(workoutsProvider);
    final workouts = workoutsAsync.valueOrNull ?? [];
    if (workouts.isEmpty) return;

    final result = await showModalBottomSheet<({int id, String name})>(
      context: context,
      backgroundColor: ForgeColors.surface,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _WorkoutPickerSheet(workouts: workouts),
    );

    if (result != null) {
      setState(() {
        final sched = _scheduleForDay(wd);
        if (!sched.workoutIds.contains(result.id)) {
          sched.workoutIds.add(result.id);
          sched.workoutNames.add(result.name);
        }
      });
      widget.onChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('ROTINA SEMANAL',
          style: TextStyle(
              fontSize: 9,
              color: ForgeColors.muted,
              letterSpacing: 2,
              fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
            color: ForgeColors.surface,
            border: Border.all(color: ForgeColors.border),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: List.generate(7, (i) {
            final wd = i + 1;
            final sched = _scheduleForDay(wd);
            final isLast = i == 6;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : const Border(
                          bottom: BorderSide(color: ForgeColors.border))),
              child: Row(children: [
                SizedBox(
                    width: 30,
                    child: Text(_dayLabels[i],
                        style: const TextStyle(
                            fontSize: 12,
                            color: ForgeColors.text,
                            fontWeight: FontWeight.w600))),
                const SizedBox(width: 8),
                Expanded(
                    child: sched.workoutNames.isEmpty
                        ? const Text('Descanso',
                            style: TextStyle(
                                fontSize: 11, color: ForgeColors.muted2))
                        : Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: sched.workoutNames
                                .asMap()
                                .entries
                                .map((e) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          sched.workoutNames.removeAt(e.key);
                                          if (e.key < sched.workoutIds.length) {
                                            sched.workoutIds.removeAt(e.key);
                                          }
                                        });
                                        widget.onChanged();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF00e5c8)
                                              .withOpacity(.1),
                                          border: Border.all(
                                              color: const Color(0xFF00e5c8)
                                                  .withOpacity(.3)),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(e.value,
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Color(0xFF00e5c8),
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              const SizedBox(width: 4),
                                              const Icon(LucideIcons.x,
                                                  size: 10,
                                                  color: Color(0xFF00e5c8)),
                                            ]),
                                      ),
                                    ))
                                .toList())),
                GestureDetector(
                  onTap: () => _addWorkoutToDay(context, wd),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(LucideIcons.plus,
                        color: ForgeColors.muted2, size: 16),
                  ),
                ),
              ]),
            );
          }),
        ),
      ),
    ]);
  }
}

class _WorkoutPickerSheet extends StatelessWidget {
  final List<dynamic> workouts;
  const _WorkoutPickerSheet({required this.workouts});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .6,
      maxChildSize: .9,
      minChildSize: .4,
      expand: false,
      builder: (_, ctrl) => Column(children: [
        const SizedBox(height: 8),
        Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: ForgeColors.border,
                borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Escolher treino',
                  style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 22,
                      color: ForgeColors.text))),
        ),
        const SizedBox(height: 10),
        Expanded(
            child: ListView.builder(
          controller: ctrl,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: workouts.length,
          itemBuilder: (_, i) {
            final w = workouts[i];
            final color = ForgeHelpers.workoutTypeColor(w.type);
            return GestureDetector(
              onTap: () => Navigator.of(context, rootNavigator: true)
                  .pop((id: w.id as int, name: w.name as String)),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                    color: ForgeColors.card,
                    border: Border.all(color: ForgeColors.border),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(w.name as String,
                          style: const TextStyle(
                              fontSize: 14,
                              color: ForgeColors.text,
                              fontWeight: FontWeight.w500))),
                  Text(ForgeHelpers.workoutTypeLabel(w.type as WorkoutType),
                      style: TextStyle(fontSize: 11, color: color)),
                ]),
              ),
            );
          },
        )),
      ]),
    );
  }
}

// F8: Editor de metas
class _GoalsEditor extends StatefulWidget {
  final Phase phase;
  final VoidCallback onChanged;
  const _GoalsEditor({required this.phase, required this.onChanged});

  @override
  State<_GoalsEditor> createState() => _GoalsEditorState();
}

class _GoalsEditorState extends State<_GoalsEditor> {
  void _addGoal() {
    setState(() {
      widget.phase.goals.add(PhaseGoal()
        ..type = GoalType.sessions
        ..description = 'Nova meta'
        ..unit = 'sessões'
        ..target = 10
        ..current = 0);
    });
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Text('METAS',
            style: TextStyle(
                fontSize: 9,
                color: ForgeColors.muted,
                letterSpacing: 2,
                fontWeight: FontWeight.w600)),
        const Spacer(),
        GestureDetector(
          onTap: _addGoal,
          child:
              const Icon(LucideIcons.plus, color: ForgeColors.muted2, size: 16),
        ),
      ]),
      const SizedBox(height: 8),
      if (widget.phase.goals.isEmpty)
        const Text('Nenhuma meta adicionada.',
            style: TextStyle(fontSize: 12, color: ForgeColors.muted2))
      else
        ...widget.phase.goals.asMap().entries.map((e) {
          final goal = e.value;
          final descCtrl = TextEditingController(text: goal.description);
          final targetCtrl =
              TextEditingController(text: goal.target.toStringAsFixed(0));
          final unitCtrl = TextEditingController(text: goal.unit);
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: ForgeColors.surface,
                border: Border.all(color: ForgeColors.border),
                borderRadius: BorderRadius.circular(10)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: TextField(
                  controller: descCtrl,
                  onChanged: (v) {
                    goal.description = v;
                    widget.onChanged();
                  },
                  style: const TextStyle(
                      fontSize: 13,
                      color: ForgeColors.text,
                      fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Descrição da meta',
                      hintStyle: TextStyle(color: ForgeColors.muted)),
                )),
                GestureDetector(
                  onTap: () {
                    setState(() => widget.phase.goals.removeAt(e.key));
                    widget.onChanged();
                  },
                  child: const Icon(LucideIcons.trash_2,
                      color: ForgeColors.muted2, size: 14),
                ),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                    child: _MiniEditField(
                        label: 'Meta',
                        controller: targetCtrl,
                        onChanged: (v) {
                          goal.target = double.tryParse(v) ?? goal.target;
                          widget.onChanged();
                        })),
                const SizedBox(width: 8),
                Expanded(
                    child: _MiniEditField(
                        label: 'Unidade',
                        controller: unitCtrl,
                        onChanged: (v) {
                          goal.unit = v;
                          widget.onChanged();
                        })),
              ]),
            ]),
          );
        }),
    ]);
  }
}

class _MiniEditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final void Function(String) onChanged;
  const _MiniEditField(
      {required this.label, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 9,
                  color: ForgeColors.muted,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                color: ForgeColors.card,
                border: Border.all(color: ForgeColors.border),
                borderRadius: BorderRadius.circular(8)),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 12, color: ForgeColors.text),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero),
            ),
          ),
        ],
      );
}

// ── Componentes de visualização (modo leitura)
class _CycleHeader extends StatelessWidget {
  final MacroCycle cycle;
  final ForgeTheme theme;
  const _CycleHeader({required this.cycle, required this.theme});

  @override
  Widget build(BuildContext context) {
    final phase =
        cycle.phases.isNotEmpty ? cycle.phases[cycle.currentPhaseIndex] : null;
    final pct = phase != null && phase.targetSessions > 0
        ? (phase.completedSessions / phase.targetSessions).clamp(0.0, 1.0)
        : 0.0;
    final weeksElapsed = cycle.startDate != null
        ? DateTime.now().difference(cycle.startDate!).inDays ~/ 7
        : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('CICLO ATIVO',
                    style: TextStyle(
                        fontSize: 9,
                        color: theme.accent,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(cycle.name,
                    style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 28,
                        color: ForgeColors.text,
                        height: 1)),
                if (cycle.description != null)
                  Text(cycle.description!,
                      style: const TextStyle(
                          fontSize: 11, color: ForgeColors.muted)),
              ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('Semana $weeksElapsed',
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 22,
                    color: theme.accent,
                    letterSpacing: 0)),
            const Text('desde o início',
                style: TextStyle(fontSize: 9, color: ForgeColors.muted)),
          ]),
        ]),
        if (phase != null) ...[
          const SizedBox(height: 14),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(phase.name,
                style: const TextStyle(
                    fontSize: 13,
                    color: ForgeColors.text,
                    fontWeight: FontWeight.w500)),
            Text('${phase.completedSessions}/${phase.targetSessions} sessões',
                style: TextStyle(
                    fontSize: 12,
                    color: theme.accent,
                    fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 5,
              backgroundColor: ForgeColors.border,
              valueColor: AlwaysStoppedAnimation(theme.accent),
            ),
          ),
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
                '${phase.targetSessions - phase.completedSessions} sessões restantes',
                style: const TextStyle(fontSize: 10, color: ForgeColors.muted)),
            Text('${(pct * 100).round()}%',
                style: TextStyle(
                    fontSize: 10,
                    color: theme.accent,
                    fontWeight: FontWeight.w600)),
          ]),
        ],
      ]),
    );
  }
}

class _WeeklyRoutine extends StatelessWidget {
  final Phase phase;
  final ForgeTheme theme;
  const _WeeklyRoutine({required this.phase, required this.theme});
  static const _dayLabels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  @override
  Widget build(BuildContext context) {
    final todayWd = DateTime.now().weekday;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SLabel('Rotina semanal'),
      Container(
        decoration: BoxDecoration(
            color: ForgeColors.card,
            border: Border.all(color: ForgeColors.border),
            borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: List.generate(7, (i) {
            final wd = i + 1;
            final sched =
                phase.weeklySchedule.where((s) => s.weekday == wd).toList();
            final names =
                sched.isNotEmpty ? sched.first.workoutNames : <String>[];
            final isToday = wd == todayWd;
            final isLast = i == 6;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: isToday
                    ? theme.accent.withOpacity(.06)
                    : Colors.transparent,
                border: isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(color: ForgeColors.border)),
              ),
              child: Row(children: [
                SizedBox(
                    width: 32,
                    child: Text(_dayLabels[i],
                        style: TextStyle(
                            fontSize: 12,
                            color: isToday ? theme.accent : ForgeColors.muted,
                            fontWeight: isToday
                                ? FontWeight.w700
                                : FontWeight.normal))),
                const SizedBox(width: 10),
                if (names.isEmpty)
                  const Text('Descanso',
                      style: TextStyle(fontSize: 12, color: ForgeColors.muted2))
                else
                  Expanded(
                      child: Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: names.map((n) {
                            WorkoutType type = WorkoutType.musculacao;
                            final nl = n.toLowerCase();
                            if (nl.contains('mob'))
                              type = WorkoutType.mobilidade;
                            else if (nl.contains('corrida'))
                              type = WorkoutType.corrida;
                            else if (nl.contains('drill'))
                              type = WorkoutType.drills;
                            else if (nl.contains('bola'))
                              type = WorkoutType.bola;
                            final color = ForgeHelpers.workoutTypeColor(type);
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 3),
                              decoration: BoxDecoration(
                                  color: color.withOpacity(.12),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(n,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: color,
                                      fontWeight: FontWeight.w500)),
                            );
                          }).toList())),
              ]),
            );
          }),
        ),
      ),
    ]);
  }
}

class _PhaseGoals extends StatelessWidget {
  final Phase phase;
  final ForgeTheme theme;
  const _PhaseGoals({required this.phase, required this.theme});

  @override
  Widget build(BuildContext context) {
    if (phase.goals.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SLabel('Metas da fase'),
      ...phase.goals.map((goal) {
        final pct = goal.target > 0
            ? (goal.current / goal.target).clamp(0.0, 1.0)
            : 0.0;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: ForgeColors.card,
              border: Border.all(color: ForgeColors.border),
              borderRadius: BorderRadius.circular(12)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                  child: Text(goal.description,
                      style: const TextStyle(
                          fontSize: 13,
                          color: ForgeColors.text,
                          fontWeight: FontWeight.w500))),
              Text(
                  '${goal.current.toStringAsFixed(0)}/${goal.target.toStringAsFixed(0)} ${goal.unit}',
                  style: TextStyle(
                      fontSize: 12,
                      color: theme.accent,
                      fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 4,
                  backgroundColor: ForgeColors.border,
                  valueColor: AlwaysStoppedAnimation(theme.accent)),
            ),
            const SizedBox(height: 5),
            Text('${(pct * 100).round()}% concluído',
                style: const TextStyle(fontSize: 10, color: ForgeColors.muted)),
          ]),
        );
      }),
    ]);
  }
}

class _EmptyState extends StatelessWidget {
  final ForgeTheme theme;
  const _EmptyState({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(LucideIcons.calendar, color: ForgeColors.muted2, size: 48),
      const SizedBox(height: 16),
      const Text('Nenhum ciclo ativo',
          style: TextStyle(
              fontFamily: 'BebasNeue', fontSize: 28, color: ForgeColors.text)),
      const SizedBox(height: 8),
      const Text('Crie um ciclo para organizar\nseus treinos por fase',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: ForgeColors.muted)),
    ]));
  }
}

// ── AppBar
class _AppBar extends StatelessWidget {
  final bool editing;
  final bool saving;
  final VoidCallback onBack;
  final VoidCallback? onEdit;
  final VoidCallback? onSave;
  final ForgeTheme theme;
  const _AppBar(
      {required this.editing,
      required this.saving,
      required this.onBack,
      this.onEdit,
      this.onSave,
      required this.theme});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: Row(children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  border: Border.all(color: ForgeColors.border),
                  shape: BoxShape.circle),
              child: Icon(editing ? LucideIcons.x : LucideIcons.arrow_left,
                  color: ForgeColors.muted, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
              child: Text('Macro Ciclo',
                  style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 22,
                      color: ForgeColors.text))),
          if (editing && onSave != null)
            GestureDetector(
              onTap: saving ? null : onSave,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                    color: saving ? ForgeColors.muted2 : theme.accent,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(saving ? 'SALVANDO...' : 'SALVAR',
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 14,
                        color: theme.id == 'neon'
                            ? Colors.black
                            : ForgeColors.bg)),
              ),
            )
          else if (!editing && onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                    color: ForgeColors.card,
                    border: Border.all(color: ForgeColors.border),
                    borderRadius: BorderRadius.circular(10)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(LucideIcons.pencil, color: ForgeColors.muted, size: 14),
                  SizedBox(width: 6),
                  Text('Editar',
                      style: TextStyle(
                          fontSize: 13,
                          color: ForgeColors.muted,
                          fontWeight: FontWeight.w500)),
                ]),
              ),
            ),
        ]),
      );
}

// ── Helpers
class _EditRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool numeric;
  final void Function(String) onChanged;
  const _EditRow(
      {required this.label,
      required this.controller,
      this.numeric = false,
      required this.onChanged});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 9,
                  color: ForgeColors.muted,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: ForgeColors.surface,
                border: Border.all(color: ForgeColors.border),
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: numeric ? TextInputType.number : TextInputType.text,
              style: const TextStyle(fontSize: 13, color: ForgeColors.text),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero),
            ),
          ),
        ],
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
