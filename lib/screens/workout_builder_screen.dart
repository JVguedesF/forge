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
  int durationSeconds;
  ExerciseType type;

  _LiveExercise({
    this.exerciseId,
    required this.name,
    this.reps = '10',
    this.suggestedWeight,
    this.durationSeconds = 30,
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

// F3: paleta de cores disponíveis
const _availableColors = [
  Color(0xFF3b82f6), // musculação azul
  Color(0xFF0ea5e9), // corrida sky
  Color(0xFF06b6d4), // drills ciano
  Color(0xFF22c55e), // bola verde
  Color(0xFF8b5cf6), // mobilidade roxo
  Color(0xFFef4444), // vermelho
  Color(0xFFf59e0b), // âmbar
  Color(0xFFec4899), // rosa
  Color(0xFF00e5c8), // teal accent
  Color(0xFFff6b35), // laranja
  Color(0xFFe8ff47), // neon
  Color(0xFFd4d4d4), // carbon
];

// F3: ícones disponíveis
const _availableIcons = <String, IconData>{
  'dumbbell': LucideIcons.dumbbell,
  'activity': LucideIcons.activity,
  'zap': LucideIcons.zap,
  'target': LucideIcons.target,
  'leaf': LucideIcons.leaf,
  'flame': LucideIcons.flame,
  'heart': LucideIcons.heart,
  'star': LucideIcons.star,
  'trophy': LucideIcons.trophy,
  'timer': LucideIcons.timer,
  'bicycle': LucideIcons.bike,
  'footprints': LucideIcons.footprints,
  'swords': LucideIcons.swords,
  'sparkles': LucideIcons.sparkles,
  'sun': LucideIcons.sun,
};

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

  // F3: cor e ícone selecionados
  Color _selectedColor = const Color(0xFF3b82f6);
  String _selectedIcon = 'dumbbell';

  @override
  void initState() {
    super.initState();
    _selectedColor = ForgeHelpers.workoutTypeColor(WorkoutType.musculacao);
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
      // F4: carrega tags corretamente
      _selectedTags
        ..clear()
        ..addAll(workout.tags);
      // F3: carrega cor e ícone
      _selectedColor = Color(workout.colorValue);
      _selectedIcon = workout.iconName;
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
                    durationSeconds: e.durationSeconds,
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

  // F2: tipo de exercício padrão por categoria do treino
  ExerciseType get _defaultExerciseType => switch (_type) {
        WorkoutType.musculacao => ExerciseType.weightReps,
        WorkoutType.mobilidade => ExerciseType.timed,
        WorkoutType.drills => ExerciseType.timed,
        WorkoutType.corrida => ExerciseType.distancePace,
        WorkoutType.bola => ExerciseType.repsOnly,
        _ => ExerciseType.weightReps,
      };

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

    final workout = Workout()
      ..name = name
      ..type = _type
      // F3: usa cor e ícone selecionados
      ..colorValue = _selectedColor.value
      ..iconName = _selectedIcon
      // F4: tags corretas
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
              ..durationSeconds = ex.durationSeconds
              ..hasSides = false;
          }).toList();
        return block;
      }).toList();

    if (_editingId != null) workout.id = _editingId;
    await ref.read(workoutRepositoryProvider).save(workout);
    if (mounted) context.pop();
  }

  void _addExerciseBlock() async {
    final ex = await _showExercisePicker();
    if (ex == null) return;
    setState(() => _blocks.add(_LiveBlock(exercises: [
          _LiveExercise(
              exerciseId: ex.id,
              name: ex.name,
              reps: ex.defaultReps,
              suggestedWeight: ex.defaultWeight,
              durationSeconds: ex.defaultDurationSeconds,
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
                reps: ex.defaultReps,
                suggestedWeight: ex.defaultWeight,
                durationSeconds: ex.defaultDurationSeconds,
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
              reps: ex.defaultReps,
              suggestedWeight: ex.defaultWeight,
              durationSeconds: ex.defaultDurationSeconds,
              type: ex.type),
        ));
  }

  // F1: picker com opção de criar exercício inline
  Future<Exercise?> _showExercisePicker() async {
    final exercises = await ref.read(exerciseRepositoryProvider).getAll();
    if (!mounted) return null;
    return showModalBottomSheet<Exercise>(
      context: context,
      backgroundColor: ForgeColors.card,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _ExercisePicker(
        exercises: exercises,
        defaultType: _defaultExerciseType,
        onCreateNew: (exercise) async {
          await ref.read(exerciseRepositoryProvider).save(exercise);
          return exercise;
        },
      ),
    );
  }

  void _editBlock(int idx) async {
    final block = _blocks[idx];
    final result = await showModalBottomSheet<_LiveBlock>(
      context: context,
      backgroundColor: ForgeColors.card,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _BlockEditor(block: block, workoutType: _type),
    );
    if (result != null) setState(() => _blocks[idx] = result);
  }

  // F3: picker de cor
  Future<void> _showColorPicker() async {
    final result = await showModalBottomSheet<Color>(
      context: context,
      backgroundColor: ForgeColors.surface,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _ColorPickerSheet(current: _selectedColor),
    );
    if (result != null) setState(() => _selectedColor = result);
  }

  // F3: picker de ícone
  Future<void> _showIconPicker() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: ForgeColors.surface,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _IconPickerSheet(current: _selectedIcon),
    );
    if (result != null) setState(() => _selectedIcon = result);
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
                      style: const TextStyle(
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
                            _selectedColor = ForgeHelpers.workoutTypeColor(t);
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

                    // F3: Cor e Ícone
                    Row(children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const _SLabel('Cor'),
                            GestureDetector(
                              onTap: _showColorPicker,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 11),
                                decoration: BoxDecoration(
                                    color: ForgeColors.card,
                                    border:
                                        Border.all(color: ForgeColors.border),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(children: [
                                  Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                          color: _selectedColor,
                                          shape: BoxShape.circle)),
                                  const SizedBox(width: 10),
                                  const Text('Alterar',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: ForgeColors.muted)),
                                  const Spacer(),
                                  const Icon(LucideIcons.chevron_right,
                                      size: 14, color: ForgeColors.muted2),
                                ]),
                              ),
                            ),
                          ])),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const _SLabel('Ícone'),
                            GestureDetector(
                              onTap: _showIconPicker,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 11),
                                decoration: BoxDecoration(
                                    color: ForgeColors.card,
                                    border:
                                        Border.all(color: ForgeColors.border),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(children: [
                                  Icon(
                                      _availableIcons[_selectedIcon] ??
                                          LucideIcons.dumbbell,
                                      color: _selectedColor,
                                      size: 22),
                                  const SizedBox(width: 10),
                                  const Text('Alterar',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: ForgeColors.muted)),
                                  const Spacer(),
                                  const Icon(LucideIcons.chevron_right,
                                      size: 14, color: ForgeColors.muted2),
                                ]),
                              ),
                            ),
                          ])),
                    ]),
                    const SizedBox(height: 20),

                    // Tags — F4 garantido
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

// ── F3: Color picker sheet
class _ColorPickerSheet extends StatelessWidget {
  final Color current;
  const _ColorPickerSheet({required this.current});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
                color: ForgeColors.border,
                borderRadius: BorderRadius.circular(2))),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Escolher cor',
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 22,
                  color: ForgeColors.text)),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: _availableColors.map((c) {
            final selected = c.value == current.value;
            return GestureDetector(
              onTap: () => Navigator.of(context, rootNavigator: true).pop(c),
              child: Container(
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: selected
                      ? Border.all(color: Colors.white, width: 2.5)
                      : null,
                ),
                child: selected
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }
}

// ── F3: Icon picker sheet
class _IconPickerSheet extends StatelessWidget {
  final String current;
  const _IconPickerSheet({required this.current});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
                color: ForgeColors.border,
                borderRadius: BorderRadius.circular(2))),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Escolher ícone',
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 22,
                  color: ForgeColors.text)),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: _availableIcons.entries.map((e) {
            final selected = e.key == current;
            return GestureDetector(
              onTap: () =>
                  Navigator.of(context, rootNavigator: true).pop(e.key),
              child: Container(
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF00e5c8).withOpacity(.15)
                      : ForgeColors.card,
                  border: Border.all(
                      color: selected
                          ? const Color(0xFF00e5c8)
                          : ForgeColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(e.value,
                    color:
                        selected ? const Color(0xFF00e5c8) : ForgeColors.muted,
                    size: 22),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ]),
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
              const SizedBox(width: 6),
              Text('${block.sets}× · ${block.restSeconds}s',
                  style:
                      const TextStyle(fontSize: 11, color: ForgeColors.muted)),
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

// ── Editor de bloco — F2: campos dinâmicos por tipo
class _BlockEditor extends StatefulWidget {
  final _LiveBlock block;
  final WorkoutType workoutType;
  const _BlockEditor({required this.block, required this.workoutType});

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
              Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                      color: ForgeColors.border,
                      borderRadius: BorderRadius.circular(2))),
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
                    child: _StepField(
                  label: 'SÉRIES',
                  value: _sets,
                  onDecrement: () => setState(() {
                    if (_sets > 1) _sets--;
                  }),
                  onIncrement: () => setState(() => _sets++),
                )),
                const SizedBox(width: 24),
                Expanded(
                    child: _StepField(
                  label: 'DESCANSO (s)',
                  value: _rest,
                  suffix: 's',
                  onDecrement: () => setState(() {
                    if (_rest >= 15) _rest -= 15;
                  }),
                  onIncrement: () => setState(() => _rest += 15),
                )),
              ]),
              const SizedBox(height: 16),
              // F2: campos por tipo de exercício
              ..._exercises.asMap().entries.map((e) {
                final ex = e.value;
                return _ExerciseFieldRow(
                  exercise: ex,
                  workoutType: widget.workoutType,
                  onChanged: () => setState(() {}),
                );
              }),
              const SizedBox(height: 8),
            ]),
      ),
    );
  }
}

// F2: linha de campo de exercício dinâmica por tipo
class _ExerciseFieldRow extends StatefulWidget {
  final _LiveExercise exercise;
  final WorkoutType workoutType;
  final VoidCallback onChanged;
  const _ExerciseFieldRow(
      {required this.exercise,
      required this.workoutType,
      required this.onChanged});

  @override
  State<_ExerciseFieldRow> createState() => _ExerciseFieldRowState();
}

class _ExerciseFieldRowState extends State<_ExerciseFieldRow> {
  late TextEditingController _repsCtrl;
  late TextEditingController _kgCtrl;
  late TextEditingController _durCtrl;

  @override
  void initState() {
    super.initState();
    _repsCtrl = TextEditingController(text: widget.exercise.reps);
    _kgCtrl = TextEditingController(
        text: widget.exercise.suggestedWeight?.toStringAsFixed(0) ?? '');
    _durCtrl =
        TextEditingController(text: widget.exercise.durationSeconds.toString());
  }

  @override
  void dispose() {
    _repsCtrl.dispose();
    _kgCtrl.dispose();
    _durCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;
    final isTimed = ex.type == ExerciseType.timed ||
        widget.workoutType == WorkoutType.mobilidade ||
        widget.workoutType == WorkoutType.drills;
    final isRepsOnly = ex.type == ExerciseType.repsOnly ||
        widget.workoutType == WorkoutType.bola;
    final isWeightReps =
        !isTimed && !isRepsOnly && widget.workoutType == WorkoutType.musculacao;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          color: ForgeColors.surface,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(ex.name,
            style: const TextStyle(
                fontSize: 13,
                color: ForgeColors.text,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(children: [
          if (isTimed) ...[
            Expanded(
                child: _MiniField(
              label: 'Duração (seg)',
              controller: _durCtrl,
              onChanged: (v) {
                ex.durationSeconds = int.tryParse(v) ?? 30;
                widget.onChanged();
              },
            )),
          ] else if (isWeightReps) ...[
            Expanded(
                child: _MiniField(
              label: 'Reps',
              controller: _repsCtrl,
              onChanged: (v) {
                ex.reps = v;
                widget.onChanged();
              },
            )),
            const SizedBox(width: 8),
            Expanded(
                child: _MiniField(
              label: 'Carga (kg)',
              controller: _kgCtrl,
              onChanged: (v) {
                ex.suggestedWeight = double.tryParse(v);
                widget.onChanged();
              },
            )),
          ] else ...[
            // repsOnly / bola
            Expanded(
                child: _MiniField(
              label: 'Reps',
              controller: _repsCtrl,
              onChanged: (v) {
                ex.reps = v;
                widget.onChanged();
              },
            )),
          ],
        ]),
      ]),
    );
  }
}

class _MiniField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final void Function(String) onChanged;
  const _MiniField(
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
              style: const TextStyle(fontSize: 13, color: ForgeColors.text),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero),
              keyboardType: TextInputType.text,
            ),
          ),
        ],
      );
}

class _StepField extends StatelessWidget {
  final String label;
  final int value;
  final String suffix;
  final VoidCallback onDecrement, onIncrement;
  const _StepField(
      {required this.label,
      required this.value,
      this.suffix = '',
      required this.onDecrement,
      required this.onIncrement});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 9, color: ForgeColors.muted, letterSpacing: 2)),
          const SizedBox(height: 6),
          Row(children: [
            _StepBtn(icon: LucideIcons.minus, onTap: onDecrement),
            const SizedBox(width: 12),
            Text('$value$suffix',
                style: const TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 28,
                    color: ForgeColors.text,
                    letterSpacing: 0)),
            const SizedBox(width: 12),
            _StepBtn(icon: LucideIcons.plus, onTap: onIncrement),
          ]),
        ],
      );
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

// ── F1: Picker de exercícios com criação inline
class _ExercisePicker extends StatefulWidget {
  final List<Exercise> exercises;
  final ExerciseType defaultType;
  final Future<Exercise?> Function(Exercise) onCreateNew;
  const _ExercisePicker(
      {required this.exercises,
      required this.defaultType,
      required this.onCreateNew});

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
                onTap: () => Navigator.of(context, rootNavigator: true).pop(),
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
        // F1: botão criar exercício inline
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: () => _createInline(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFF00e5c8).withOpacity(.1),
                border:
                    Border.all(color: const Color(0xFF00e5c8).withOpacity(.35)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.plus, color: Color(0xFF00e5c8), size: 14),
                    SizedBox(width: 6),
                    Text('Criar novo exercício',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF00e5c8),
                            fontWeight: FontWeight.w600)),
                  ]),
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
              onTap: () => Navigator.of(context, rootNavigator: true).pop(ex),
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

  // F1: form inline para criar exercício
  Future<void> _createInline(BuildContext context) async {
    final nameCtrl = TextEditingController();
    final kgCtrl = TextEditingController();
    final repsCtrl = TextEditingController(text: '10');
    final durCtrl = TextEditingController(text: '30');
    final tagsCtrl = TextEditingController();
    ExerciseType selectedType = widget.defaultType;

    final result = await showDialog<Exercise>(
      context: context,
      useRootNavigator: true,
      builder: (_) => StatefulBuilder(builder: (ctx, setS) {
        return AlertDialog(
          backgroundColor: ForgeColors.card,
          title: const Text('Novo exercício',
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 22,
                  color: ForgeColors.text)),
          content: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AField(controller: nameCtrl, label: 'Nome'),
                  const SizedBox(height: 10),
                  const Text('Tipo',
                      style: TextStyle(
                          fontSize: 9,
                          color: ForgeColors.muted,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: ExerciseType.values.map((t) {
                      final labels = {
                        ExerciseType.weightReps: 'Peso+Reps',
                        ExerciseType.timed: 'Tempo',
                        ExerciseType.repsOnly: 'Reps',
                        ExerciseType.distancePace: 'Distância',
                      };
                      return GestureDetector(
                        onTap: () => setS(() => selectedType = t),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: selectedType == t
                                ? const Color(0xFF00e5c8).withOpacity(.15)
                                : ForgeColors.surface,
                            border: Border.all(
                                color: selectedType == t
                                    ? const Color(0xFF00e5c8)
                                    : ForgeColors.border),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(labels[t]!,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: selectedType == t
                                      ? const Color(0xFF00e5c8)
                                      : ForgeColors.muted)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  if (selectedType == ExerciseType.weightReps) ...[
                    _AField(controller: kgCtrl, label: 'Carga padrão (kg)'),
                    const SizedBox(height: 10),
                    _AField(controller: repsCtrl, label: 'Reps padrão'),
                  ] else if (selectedType == ExerciseType.timed) ...[
                    _AField(controller: durCtrl, label: 'Duração padrão (seg)'),
                  ] else ...[
                    _AField(controller: repsCtrl, label: 'Reps padrão'),
                  ],
                  const SizedBox(height: 10),
                  _AField(
                      controller: tagsCtrl,
                      label: 'Tags (separadas por vírgula)'),
                ]),
          ),
          actions: [
            TextButton(
                onPressed: () =>
                    Navigator.of(ctx, rootNavigator: true).pop(null),
                child: const Text('Cancelar',
                    style: TextStyle(color: ForgeColors.muted))),
            TextButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  if (name.isEmpty) return;
                  final ex = Exercise()
                    ..name = name
                    ..type = selectedType
                    ..defaultWeight = double.tryParse(kgCtrl.text)
                    ..defaultReps =
                        repsCtrl.text.isNotEmpty ? repsCtrl.text : '10'
                    ..defaultDurationSeconds = int.tryParse(durCtrl.text) ?? 30
                    ..tags = tagsCtrl.text
                        .split(',')
                        .map((t) => t.trim())
                        .where((t) => t.isNotEmpty)
                        .toList()
                    ..defaultSets = 3
                    ..defaultRestSeconds = 90;
                  Navigator.of(ctx, rootNavigator: true).pop(ex);
                },
                child: const Text('Criar',
                    style: TextStyle(color: Color(0xFF00e5c8)))),
          ],
        );
      }),
    );

    if (result != null) {
      final saved = await widget.onCreateNew(result);
      if (saved != null && context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(result);
      }
    }
  }
}

class _AField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const _AField({required this.controller, required this.label});

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
          TextField(
            controller: controller,
            style: const TextStyle(fontSize: 13, color: ForgeColors.text),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ForgeColors.border)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00e5c8))),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4),
            ),
          ),
        ],
      );
}

// ── Shared
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
