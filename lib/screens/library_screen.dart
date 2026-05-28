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

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});
  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final Set<String> _collapsed = {};

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider).valueOrNull ?? ForgeThemes.teal;
    final workoutsAsync = ref.watch(workoutsProvider);

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(children: [
          _LibHeader(theme: theme),
          _TabBarWidget(controller: _tab, accent: theme.accent),
          Expanded(
            child: TabBarView(controller: _tab, children: [
              workoutsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                    child: Text('Erro: $e',
                        style: const TextStyle(color: ForgeColors.muted))),
                data: (workouts) => _WorkoutsTab(
                  workouts: workouts,
                  collapsed: _collapsed,
                  onToggle: (cat) => setState(() => _collapsed.contains(cat)
                      ? _collapsed.remove(cat)
                      : _collapsed.add(cat)),
                ),
              ),
              const _ExercisesTab(),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _LibHeader extends StatelessWidget {
  final ForgeTheme theme;
  const _LibHeader({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ForgeColors.bg,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(children: [
        const Expanded(
            child: Text('Biblioteca',
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 38,
                    color: ForgeColors.text))),
        GestureDetector(
          onTap: () => context.push('/builder'),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: theme.accent, borderRadius: BorderRadius.circular(10)),
            child: Icon(LucideIcons.plus, color: theme.bg, size: 18),
          ),
        ),
      ]),
    );
  }
}

class _TabBarWidget extends StatelessWidget {
  final TabController controller;
  final Color accent;
  const _TabBarWidget({required this.controller, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: ForgeColors.border))),
      child: TabBar(
        controller: controller,
        indicatorColor: accent,
        indicatorWeight: 2,
        labelColor: accent,
        unselectedLabelColor: ForgeColors.muted,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        tabs: const [Tab(text: 'Treinos'), Tab(text: 'Exercícios')],
      ),
    );
  }
}

class _WorkoutsTab extends StatelessWidget {
  final List<Workout> workouts;
  final Set<String> collapsed;
  final void Function(String) onToggle;
  const _WorkoutsTab(
      {required this.workouts,
      required this.collapsed,
      required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final cats = WorkoutType.values.where((t) => t != WorkoutType.custom);
    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: cats.map((type) {
        final ww = workouts.where((w) => w.type == type).toList();
        if (ww.isEmpty) return const SizedBox.shrink();
        final key = type.name;
        final isCollapsed = collapsed.contains(key);
        final color = ForgeHelpers.workoutTypeColor(type);
        final icon = ForgeHelpers.workoutTypeIcon(type);
        final label = ForgeHelpers.workoutTypeLabel(type);

        return Column(children: [
          _CatHeader(
              label: label,
              color: color,
              icon: icon,
              count: ww.length,
              collapsed: isCollapsed,
              onTap: () => onToggle(key)),
          if (!isCollapsed)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              child: Column(
                  children: ww.map((w) => _WorkoutCard(workout: w)).toList()),
            ),
        ]);
      }).toList(),
    );
  }
}

class _CatHeader extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final int count;
  final bool collapsed;
  final VoidCallback onTap;
  const _CatHeader(
      {required this.label,
      required this.color,
      required this.icon,
      required this.count,
      required this.collapsed,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: ForgeColors.border))),
        child: Row(children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                color: color.withOpacity(.1),
                borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Text(label,
              style: const TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 20,
                  color: ForgeColors.text)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
                color: color.withOpacity(.1),
                borderRadius: BorderRadius.circular(20)),
            child: Text('$count treinos',
                style: TextStyle(
                    fontSize: 10, color: color, fontWeight: FontWeight.w600)),
          ),
          const Spacer(),
          Icon(collapsed ? LucideIcons.chevron_right : LucideIcons.chevron_down,
              color: ForgeColors.muted2, size: 16),
        ]),
      ),
    );
  }
}

class _WorkoutCard extends ConsumerWidget {
  final Workout workout;
  const _WorkoutCard({required this.workout});

  static String _modeForType(WorkoutType type) => switch (type) {
        WorkoutType.corrida => 'corrida',
        WorkoutType.mobilidade => 'timed',
        WorkoutType.drills => 'timed',
        WorkoutType.bola => 'timed',
        _ => 'musculacao',
      };

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ForgeColors.card,
        title: const Text('Deletar treino',
            style: TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 22,
                color: ForgeColors.text)),
        content: Text(
            'Deletar "${workout.name}"? Esta ação não pode ser desfeita.',
            style: const TextStyle(fontSize: 13, color: ForgeColors.muted)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar',
                  style: TextStyle(color: ForgeColors.muted))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Deletar',
                  style: TextStyle(color: Color(0xFFef4444)))),
        ],
      ),
    );
    if (confirm == true && workout.id != null) {
      await ref.read(workoutRepositoryProvider).delete(workout.id!);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ForgeHelpers.workoutTypeColor(workout.type);
    final colorLight = ForgeHelpers.workoutTypeColorLight(workout.type);
    final icon = ForgeHelpers.workoutTypeIcon(workout.type);
    final mode = _modeForType(workout.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ForgeColors.card,
        border: Border.all(color: color.withOpacity(.16)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
              color: color.withOpacity(.1),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(workout.name,
              style: const TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 20,
                  color: ForgeColors.text)),
          Text(
            '${workout.estimatedMinutes > 0 ? "${workout.estimatedMinutes} min" : "—"} · ${workout.blocks.length} blocos',
            style: const TextStyle(fontSize: 11, color: ForgeColors.muted),
          ),
          const SizedBox(height: 4),
          Wrap(spacing: 4, children: workout.tags.map((t) => _Tag(t)).toList()),
        ])),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Row(children: [
            // Botão editar — abre WorkoutBuilder com ID
            _SmallIconBtn(
                icon: LucideIcons.pencil,
                onTap: () => context.push('/builder?id=${workout.id}')),
            const SizedBox(width: 2),
            // Botão deletar
            _SmallIconBtn(
                icon: LucideIcons.trash_2,
                onTap: () => _confirmDelete(context, ref)),
          ]),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () => context.push(
              '/session?mode=$mode&id=${workout.id}&name=${Uri.encodeComponent(workout.name)}',
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                  color: color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Text('INICIAR',
                  style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 13,
                      color: colorLight)),
            ),
          ),
        ]),
      ]),
    );
  }
}

// ── Aba Exercícios com editar/deletar
class _ExercisesTab extends ConsumerWidget {
  const _ExercisesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesProvider);

    return exercisesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
          child: Text('Erro: $e',
              style: const TextStyle(color: ForgeColors.muted))),
      data: (exercises) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: exercises.map((e) => _ExerciseRow(exercise: e)).toList(),
      ),
    );
  }
}

class _ExerciseRow extends ConsumerWidget {
  final Exercise exercise;
  const _ExerciseRow({required this.exercise});

  WorkoutType _typeForExercise(Exercise e) {
    if (e.tags.any((t) => ['Bola', 'Domínio', 'Drible'].contains(t)))
      return WorkoutType.bola;
    if (e.tags.any(
        (t) => ['Mobilidade', 'Quadril', 'Cervical', 'Lombar'].contains(t)))
      return WorkoutType.mobilidade;
    return WorkoutType.musculacao;
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref) async {
    final nameCtrl = TextEditingController(text: exercise.name);
    final tagsCtrl = TextEditingController(text: exercise.tags.join(', '));

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ForgeColors.card,
        title: const Text('Editar exercício',
            style: TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 22,
                color: ForgeColors.text)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          _DialogField(controller: nameCtrl, label: 'Nome'),
          const SizedBox(height: 12),
          _DialogField(
              controller: tagsCtrl, label: 'Tags (separadas por vírgula)'),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar',
                  style: TextStyle(color: ForgeColors.muted))),
          TextButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                exercise.name = name;
                exercise.tags = tagsCtrl.text
                    .split(',')
                    .map((t) => t.trim())
                    .where((t) => t.isNotEmpty)
                    .toList();
                await ref.read(exerciseRepositoryProvider).save(exercise);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Salvar',
                  style: TextStyle(color: Color(0xFF00e5c8)))),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ForgeColors.card,
        title: const Text('Deletar exercício',
            style: TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 22,
                color: ForgeColors.text)),
        content: Text(
            'Deletar "${exercise.name}"? Esta ação não pode ser desfeita.',
            style: const TextStyle(fontSize: 13, color: ForgeColors.muted)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar',
                  style: TextStyle(color: ForgeColors.muted))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Deletar',
                  style: TextStyle(color: Color(0xFFef4444)))),
        ],
      ),
    );
    if (confirm == true && exercise.id != null) {
      await ref.read(exerciseRepositoryProvider).delete(exercise.id!);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = _typeForExercise(exercise);
    final color = ForgeHelpers.workoutTypeColor(type);
    final icon = ForgeHelpers.workoutTypeIcon(type);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
              color: color.withOpacity(.1),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 17),
        ),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(exercise.name,
              style: const TextStyle(
                  fontSize: 14,
                  color: ForgeColors.text,
                  fontWeight: FontWeight.w500)),
          Text('${exercise.type.name} · ${exercise.tags.join(", ")}',
              style: const TextStyle(fontSize: 11, color: ForgeColors.muted)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(
            exercise.defaultWeight != null
                ? '${exercise.defaultWeight!.toStringAsFixed(0)} kg'
                : '—',
            style: TextStyle(
                fontSize: 13, color: color, fontWeight: FontWeight.w600),
          ),
          const Text('padrão',
              style: TextStyle(fontSize: 9, color: ForgeColors.muted)),
        ]),
        const SizedBox(width: 8),
        Column(children: [
          _SmallIconBtn(
              icon: LucideIcons.pencil,
              onTap: () => _showEditDialog(context, ref)),
          const SizedBox(height: 2),
          _SmallIconBtn(
              icon: LucideIcons.trash_2,
              onTap: () => _confirmDelete(context, ref)),
        ]),
      ]),
    );
  }
}

class _DialogField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const _DialogField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: ForgeColors.muted)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            style: const TextStyle(fontSize: 14, color: ForgeColors.text),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ForgeColors.border)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00e5c8))),
            ),
          ),
        ],
      );
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(.06),
            borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: const TextStyle(
                fontSize: 9,
                color: ForgeColors.muted,
                fontWeight: FontWeight.w500)),
      );
}

class _SmallIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SmallIconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(icon, color: ForgeColors.muted2, size: 15)),
      );
}
