import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import '../core/helpers/forge_helpers.dart';
import '../providers/workout_providers.dart';
import '../data/models/workout.dart';
import '../data/models/exercise.dart';
import '../data/models/enums.dart';

// ── Modelos internos ao vivo
class _LiveExercise {
  int? exerciseId;
  String name;
  String reps;
  double? suggestedWeight;
  ExerciseType type;

  _LiveExercise({
    this.exerciseId,
    required this.name,
    this.reps = '10',
    this.suggestedWeight,
    this.type = ExerciseType.weightReps,
  });
}

class _LiveBlock {
  bool isCircuit;
  String circuitName;
  int sets;
  int restSeconds;
  List<_LiveExercise> exercises;

  _LiveBlock({
    this.isCircuit = false,
    this.circuitName = 'Super-set',
    this.sets = 3,
    this.restSeconds = 90,
    required this.exercises,
  });
}

class WorkoutBuilderScreen extends ConsumerStatefulWidget {
  final int? editWorkoutId;
  const WorkoutBuilderScreen({super.key, this.editWorkoutId});
  @override
  ConsumerState<WorkoutBuilderScreen> createState() =>
      _WorkoutBuilderScreenState();
}

class _WorkoutBuilderScreenState extends ConsumerState<WorkoutBuilderScreen> {
  final _nameCtrl = TextEditingController();
  WorkoutType _type = WorkoutType.musculacao;
  final Set<String> _selectedTags = {};
  final List<_LiveBlock> _blocks = [];
  bool _saving = false;
  bool _loaded = false;
  int? _editingId;

  @override
  void initState() {
    super.initState();
    if (widget.editWorkoutId != null) {
      _editingId = widget.editWorkoutId;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExisting());
    }
  }

  Future<void> _loadExisting() async {
    final workout =
        await ref.read(workoutRepositoryProvider).getById(_editingId!);
    if (workout == null || !mounted) return;
    setState(() {
      _nameCtrl.text = workout.name;
      _type = workout.type;
      _selectedTags.addAll(workout.tags);
      _blocks.clear();
      for (final b in workout.blocks) {
        _blocks.add(_LiveBlock(
          isCircuit: b.isCircuit,
          circuitName: b.circuitName ?? 'Super-set',
          sets: b.sets,
          restSeconds: b.restAfterSeconds,
          exercises: b.exercises
              .map((e) => _LiveExercise(
                    exerciseId: e.exerciseId,
                    name: e.exerciseName,
                    reps: e.reps,
                    suggestedWeight: e.suggestedWeight,
                    type: e.type,
                  ))
              .toList(),
        ));
      }
      _loaded = true;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  List<String> get _availableTags => ForgeHelpers.tagsByType(_type);

  Future<void> _save() async {
    if (_saving) return;
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Digite o nome do treino'),
            backgroundColor: ForgeColors.card),
      );
      return;
    }
    if (_blocks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Adicione pelo menos um exercício'),
            backgroundColor: ForgeColors.card),
      );
      return;
    }

    setState(() => _saving = true);

    final color = ForgeHelpers.workoutTypeColor(_type);
    final workout = Workout()
      ..name = name
      ..type = _type
      ..colorValue = color.value
      ..iconName = _iconNameForType(_type)
      ..tags = _selectedTags.toList()
      ..estimatedMinutes = _blocks.fold<int>(
          0,
          (sum, b) =>
              sum +
              b.sets * (b.exercises.length * 1) +
              (b.restSeconds * b.sets ~/ 60))
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..blocks = _blocks.asMap().entries.map((e) {
        final b = e.value;
        final block = WorkoutBlock()
          ..orderIndex = e.key
          ..isCircuit = b.isCircuit
          ..circuitName = b.isCircuit ? b.circuitName : null
          ..sets = b.sets
          ..restAfterSeconds = b.restSeconds
          ..exercises = b.exercises.map((ex) {
            return WorkoutExercise()
              ..exerciseId = ex.exerciseId
              ..exerciseName = ex.name
              ..type = ex.type
              ..reps = ex.reps
              ..suggestedWeight = ex.suggestedWeight
              ..hasSides = false;
          }).toList();
        return block;
      }).toList();

    // Preserva o ID ao editar treino existente
    if (_editingId != null) workout.id = _editingId;
    await ref.read(workoutRepositoryProvider).save(workout);
    if (mounted) context.pop();
  }

  String _iconNameForType(WorkoutType t) => switch (t) {
        WorkoutType.musculacao => 'dumbbell',
        WorkoutType.corrida => 'activity',
        WorkoutType.drills => 'zap',
        WorkoutType.bola => 'target',
        WorkoutType.mobilidade => 'leaf',
        WorkoutType.custom => 'sparkles',
      };

  void _addExerciseBlock() async {
    final ex = await _showExercisePicker();
    if (ex == null) return;
    setState(() => _blocks.add(_LiveBlock(exercises: [
          _LiveExercise(
              exerciseId: ex.id,
              name: ex.name,
              reps: ex.defaultReps ?? '10',
              suggestedWeight: ex.defaultWeight,
              type: ex.type),
        ])));
  }

  void _addSuperSet() async {
    final ex = await _showExercisePicker();
    if (ex == null) return;
    setState(() => _blocks.add(_LiveBlock(
          isCircuit: true,
          circuitName: 'Super-set',
          exercises: [
            _LiveExercise(
                exerciseId: ex.id,
                name: ex.name,
                reps: ex.defaultReps ?? '10',
                suggestedWeight: ex.defaultWeight,
                type: ex.type),
          ],
        )));
  }

  void _addExerciseToBlock(int blockIdx) async {
    final ex = await _showExercisePicker();
    if (ex == null) return;
    setState(() => _blocks[blockIdx].exercises.add(
          _LiveExercise(
              exerciseId: ex.id,
              name: ex.name,
              reps: ex.defaultReps ?? '10',
              suggestedWeight: ex.defaultWeight,
              type: ex.type),
        ));
  }

  Future<Exercise?> _showExercisePicker() async {
    final exercises = await ref.read(exerciseRepositoryProvider).getAll();
    if (!mounted) return null;
    return showModalBottomSheet<Exercise>(
      context: context,
      backgroundColor: ForgeColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _ExercisePicker(exercises: exercises),
    );
  }

  void _editBlock(int idx) async {
    final block = _blocks[idx];
    final result = await showModalBottomSheet<_LiveBlock>(
      context: context,
      backgroundColor: ForgeColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _BlockEditor(block: block),
    );
    if (result != null) setState(() => _blocks[idx] = result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider).valueOrNull ?? ForgeThemes.teal;

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(children: [
          // AppBar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Row(children: [
              _XBtn(onTap: () => context.pop(), icon: LucideIcons.x),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(
                      widget.editWorkoutId != null
                          ? 'Editar Treino'
                          : 'Novo Treino',
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 22,
                          color: ForgeColors.text))),
              GestureDetector(
                onTap: _saving ? null : _save,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                      color: _saving ? ForgeColors.muted2 : theme.accent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(_saving ? 'SALVANDO...' : 'SALVAR',
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 16,
                          color: theme.id == 'neon'
                              ? Colors.black
                              : ForgeColors.bg)),
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
                    // Nome
                    const _SLabel('Nome'),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                          color: ForgeColors.card,
                          border: Border.all(color: ForgeColors.border),
                          borderRadius: BorderRadius.circular(12)),
                      child: TextField(
                        controller: _nameCtrl,
                        style: const TextStyle(
                            fontSize: 15, color: ForgeColors.text),
                        decoration: const InputDecoration(
                          hintText: 'Ex: Upper A, Corrida Longa...',
                          hintStyle: TextStyle(color: ForgeColors.muted),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                      ),
                    ),

                    // Tipo
                    const _SLabel('Tipo'),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.4,
                      children: WorkoutType.values.map((t) {
                        final active = t == _type;
                        final color = ForgeHelpers.workoutTypeColor(t);
                        final colorLight =
                            ForgeHelpers.workoutTypeColorLight(t);
                        final icon = ForgeHelpers.workoutTypeIcon(t);
                        final label = ForgeHelpers.workoutTypeLabel(t);
                        return GestureDetector(
                          onTap: () => setState(() {
                            _type = t;
                            _selectedTags.clear();
                          }),
                          child: Container(
                            decoration: BoxDecoration(
                              color: active
                                  ? color.withOpacity(.14)
                                  : ForgeColors.card,
                              border: Border.all(
                                  color: active ? color : ForgeColors.border),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(icon,
                                      color: active
                                          ? colorLight
                                          : ForgeColors.muted,
                                      size: 13),
                                  const SizedBox(width: 4),
                                  Text(label,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: active
                                              ? colorLight
                                              : ForgeColors.muted,
                                          fontWeight: FontWeight.w600)),
                                ]),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Tags
                    const _SLabel('Tags'),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _availableTags.map((t) {
                        final active = _selectedTags.contains(t);
                        return GestureDetector(
                          onTap: () => setState(() => active
                              ? _selectedTags.remove(t)
                              : _selectedTags.add(t)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: active
                                  ? theme.accent.withOpacity(.12)
                                  : ForgeColors.card,
                              border: Border.all(
                                  color: active
                                      ? theme.accent
                                      : ForgeColors.border),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(t,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: active
                                        ? theme.accent
                                        : ForgeColors.muted,
                                    fontWeight: FontWeight.w500)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Blocos
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _SLabel('Exercícios'),
                          Text('${_blocks.length} blocos',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: theme.accent,
                                  fontWeight: FontWeight.w600)),
                        ]),

                    if (_blocks.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                            color: ForgeColors.card,
                            border: Border.all(color: ForgeColors.border),
                            borderRadius: BorderRadius.circular(14)),
                        child: const Column(children: [
                          Icon(LucideIcons.dumbbell,
                              color: ForgeColors.muted2, size: 32),
                          SizedBox(height: 8),
                          Text('Nenhum exercício ainda',
                              style: TextStyle(
                                  color: ForgeColors.muted, fontSize: 13)),
                          Text('Toque em + Exercício abaixo',
                              style: TextStyle(
                                  color: ForgeColors.muted2, fontSize: 11)),
                        ]),
                      ),

                    ..._blocks.asMap().entries.map((e) {
                      final i = e.key;
                      final b = e.value;
                      return _BlockCard(
                        block: b,
                        accent: theme.accent,
                        onEdit: () => _editBlock(i),
                        onDelete: () => setState(() => _blocks.removeAt(i)),
                        onAddExercise:
                            b.isCircuit ? () => _addExerciseToBlock(i) : null,
                      );
                    }),

                    const SizedBox(height: 4),

                    // Botões adicionar
                    Row(children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: _addExerciseBlock,
                        child: Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: ForgeColors.card,
                            border: Border.all(
                                color: ForgeColors.musculacao.withOpacity(.35)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.plus,
                                    color: ForgeColors.musculacao, size: 14),
                                SizedBox(width: 6),
                                Text('Exercício',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ForgeColors.musculacao,
                                        fontWeight: FontWeight.w600)),
                              ]),
                        ),
                      )),
                      const SizedBox(width: 8),
                      Expanded(
                          child: GestureDetector(
                        onTap: _addSuperSet,
                        child: Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: ForgeColors.card,
                            border: Border.all(
                                color: theme.accent.withOpacity(.35)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.repeat,
                                    color: theme.accent, size: 14),
                                const SizedBox(width: 6),
                                Text('Super-set',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: theme.accent,
                                        fontWeight: FontWeight.w600)),
                              ]),
                        ),
                      )),
                    ]),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Card de bloco
class _BlockCard extends StatelessWidget {
  final _LiveBlock block;
  final Color accent;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onAddExercise;
  const _BlockCard(
      {required this.block,
      required this.accent,
      required this.onEdit,
      required this.onDelete,
      this.onAddExercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: ForgeColors.card,
        border: Border.all(
            color:
                block.isCircuit ? accent.withOpacity(.22) : ForgeColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(children: [
            const Text('⋮⋮',
                style: TextStyle(color: ForgeColors.muted2, fontSize: 13)),
            const SizedBox(width: 8),
            if (block.isCircuit) ...[
              Container(
                  width: 6,
                  height: 6,
                  decoration:
                      BoxDecoration(color: accent, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(block.circuitName,
                  style: TextStyle(
                      fontSize: 12,
                      color: accent,
                      fontWeight: FontWeight.w600)),
            ] else
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(block.exercises.first.name,
                        style: const TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 18,
                            color: ForgeColors.text)),
                    Text(
                        '${block.sets}×${block.exercises.first.reps} · ${block.restSeconds}s',
                        style: const TextStyle(
                            fontSize: 11, color: ForgeColors.muted)),
                  ])),
            const Spacer(),
            GestureDetector(
                onTap: onEdit,
                child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(LucideIcons.sliders_horizontal,
                        color: ForgeColors.muted2, size: 15))),
            GestureDetector(
                onTap: onDelete,
                child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(LucideIcons.trash_2,
                        color: ForgeColors.muted2, size: 15))),
          ]),
        ),
        if (block.isCircuit) ...[
          Container(
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: ForgeColors.border))),
            child: Column(children: [
              ...block.exercises.asMap().entries.map((e) => Container(
                    padding: const EdgeInsets.fromLTRB(36, 9, 16, 9),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: e.key < block.exercises.length - 1
                                ? const BorderSide(color: ForgeColors.border)
                                : BorderSide.none)),
                    child: Row(children: [
                      Expanded(
                          child: Text('${e.value.name} × ${e.value.reps}',
                              style: const TextStyle(
                                  fontSize: 12, color: ForgeColors.text))),
                    ]),
                  )),
              if (onAddExercise != null)
                GestureDetector(
                  onTap: onAddExercise,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                        color: ForgeColors.surface,
                        border: Border.all(color: accent.withOpacity(.18)),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.plus, color: accent, size: 13),
                          const SizedBox(width: 5),
                          Text('Adicionar exercício',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: accent,
                                  fontWeight: FontWeight.w500)),
                        ]),
                  ),
                ),
            ]),
          ),
        ],
      ]),
    );
  }
}

// ── Editor de bloco (bottom sheet)
class _BlockEditor extends StatefulWidget {
  final _LiveBlock block;
  const _BlockEditor({required this.block});

  @override
  State<_BlockEditor> createState() => _BlockEditorState();
}

class _BlockEditorState extends State<_BlockEditor> {
  late int _sets;
  late int _rest;
  late List<_LiveExercise> _exercises;

  @override
  void initState() {
    super.initState();
    _sets = widget.block.sets;
    _rest = widget.block.restSeconds;
    _exercises = List.from(widget.block.exercises);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Text('Editar Bloco',
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 22,
                        color: ForgeColors.text)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(
                      context,
                      _LiveBlock(
                        isCircuit: widget.block.isCircuit,
                        circuitName: widget.block.circuitName,
                        sets: _sets,
                        restSeconds: _rest,
                        exercises: _exercises,
                      )),
                  child:
                      const Icon(LucideIcons.check, color: Color(0xFF22c55e)),
                ),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const Text('SÉRIES',
                          style: TextStyle(
                              fontSize: 9,
                              color: ForgeColors.muted,
                              letterSpacing: 2)),
                      const SizedBox(height: 6),
                      Row(children: [
                        _StepBtn(
                            icon: LucideIcons.minus,
                            onTap: () => setState(() {
                                  if (_sets > 1) _sets--;
                                })),
                        const SizedBox(width: 12),
                        Text('$_sets',
                            style: const TextStyle(
                                fontFamily: 'BebasNeue',
                                fontSize: 28,
                                color: ForgeColors.text,
                                letterSpacing: 0)),
                        const SizedBox(width: 12),
                        _StepBtn(
                            icon: LucideIcons.plus,
                            onTap: () => setState(() => _sets++)),
                      ]),
                    ])),
                const SizedBox(width: 24),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const Text('DESCANSO (s)',
                          style: TextStyle(
                              fontSize: 9,
                              color: ForgeColors.muted,
                              letterSpacing: 2)),
                      const SizedBox(height: 6),
                      Row(children: [
                        _StepBtn(
                            icon: LucideIcons.minus,
                            onTap: () => setState(() {
                                  if (_rest >= 15) _rest -= 15;
                                })),
                        const SizedBox(width: 12),
                        Text('${_rest}s',
                            style: const TextStyle(
                                fontFamily: 'BebasNeue',
                                fontSize: 28,
                                color: ForgeColors.text,
                                letterSpacing: 0)),
                        const SizedBox(width: 12),
                        _StepBtn(
                            icon: LucideIcons.plus,
                            onTap: () => setState(() => _rest += 15)),
                      ]),
                    ])),
              ]),
              const SizedBox(height: 16),
              ..._exercises.asMap().entries.map((e) {
                final ex = e.value;
                final ctrl = TextEditingController(text: ex.reps);
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                      color: ForgeColors.surface,
                      border: Border.all(color: ForgeColors.border),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Expanded(
                        child: Text(ex.name,
                            style: const TextStyle(
                                fontSize: 13, color: ForgeColors.text))),
                    const Text('Reps: ',
                        style:
                            TextStyle(fontSize: 11, color: ForgeColors.muted)),
                    SizedBox(
                        width: 50,
                        child: TextField(
                          controller: ctrl,
                          onChanged: (v) => _exercises[e.key].reps = v,
                          style: const TextStyle(
                              fontSize: 13, color: ForgeColors.text),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero),
                          keyboardType: TextInputType.text,
                        )),
                  ]),
                );
              }),
              const SizedBox(height: 8),
            ]),
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              border: Border.all(color: ForgeColors.border),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: ForgeColors.muted, size: 14),
        ),
      );
}

// ── Picker de exercícios
class _ExercisePicker extends StatefulWidget {
  final List<Exercise> exercises;
  const _ExercisePicker({required this.exercises});

  @override
  State<_ExercisePicker> createState() => _ExercisePickerState();
}

class _ExercisePickerState extends State<_ExercisePicker> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.exercises
        .where((e) => e.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return DraggableScrollableSheet(
      initialChildSize: .75,
      maxChildSize: .95,
      minChildSize: .5,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            const Expanded(
                child: Text('Escolher exercício',
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 22,
                        color: ForgeColors.text))),
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(LucideIcons.x,
                    color: ForgeColors.muted, size: 18)),
          ]),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
                color: ForgeColors.surface,
                border: Border.all(color: ForgeColors.border),
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(fontSize: 13, color: ForgeColors.text),
              decoration: const InputDecoration(
                hintText: 'Buscar exercício...',
                hintStyle: TextStyle(color: ForgeColors.muted),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                prefixIcon: Icon(LucideIcons.search,
                    color: ForgeColors.muted, size: 16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
            child: ListView.builder(
          controller: ctrl,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filtered.length,
          itemBuilder: (_, i) {
            final ex = filtered[i];
            WorkoutType type = WorkoutType.musculacao;
            if (ex.tags.any((t) => ['Bola', 'Domínio', 'Drible'].contains(t)))
              type = WorkoutType.bola;
            else if (ex.tags.any((t) =>
                ['Mobilidade', 'Quadril', 'Cervical', 'Lombar'].contains(t)))
              type = WorkoutType.mobilidade;
            final color = ForgeHelpers.workoutTypeColor(type);

            return GestureDetector(
              onTap: () => Navigator.pop(context, ex),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                    color: ForgeColors.surface,
                    border: Border.all(color: ForgeColors.border),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(ex.name,
                            style: const TextStyle(
                                fontSize: 14,
                                color: ForgeColors.text,
                                fontWeight: FontWeight.w500)),
                        Text(ex.tags.join(' · '),
                            style: const TextStyle(
                                fontSize: 11, color: ForgeColors.muted)),
                      ])),
                  if (ex.defaultWeight != null)
                    Text('${ex.defaultWeight!.toStringAsFixed(0)}kg',
                        style: TextStyle(
                            fontSize: 12,
                            color: color,
                            fontWeight: FontWeight.w600)),
                ]),
              ),
            );
          },
        )),
      ]),
    );
  }
}

// ── Widgets compartilhados
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
  const _XBtn({required this.onTap, required this.icon});
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
