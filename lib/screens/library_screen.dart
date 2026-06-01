import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import '../core/helpers/forge_helpers.dart';
import '../providers/workout_providers.dart';
import '../providers/session_providers.dart';
import '../data/models/workout.dart';
import '../data/models/exercise.dart';
import '../data/models/training_session.dart';
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
        WorkoutType.musculacao => 'musculacao',
        _ => 'timed',
      };

  // B1 FIX: usa rootNavigator: true para evitar tela preta
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
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
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(false),
              child: const Text('Cancelar',
                  style: TextStyle(color: ForgeColors.muted))),
          TextButton(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(true),
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
    final idPart = workout.id != null ? '&id=${workout.id}' : '';
    final url =
        '/session?mode=$mode&type=${workout.type.name}$idPart&name=${Uri.encodeComponent(workout.name)}';

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
            _SmallIconBtn(
                icon: LucideIcons.pencil,
                onTap: () => context.push('/builder?id=${workout.id}')),
            const SizedBox(width: 2),
            _SmallIconBtn(
                icon: LucideIcons.trash_2,
                onTap: () => _confirmDelete(context, ref)),
          ]),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () => context.push(url),
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

// ── Aba Exercícios — B5 FIX: histórico do exercício ao tocar
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

  // B5 FIX: abre bottom sheet de histórico do exercício
  void _showHistory(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.read(sessionsProvider);
    final sessions = sessionsAsync.valueOrNull ?? [];

    // Filtra sessões que contêm este exercício
    final exerciseSessions = <(DateTime, double, String)>[];
    for (final s in sessions) {
      for (final ex in s.exercises) {
        if (ex.exerciseId == exercise.id || ex.exerciseName == exercise.name) {
          final completedSets = ex.sets
              .where((set) => set.completed && set.weight != null)
              .toList();
          if (completedSets.isNotEmpty) {
            final maxW = completedSets
                .map((s) => s.weight!)
                .reduce((a, b) => a > b ? a : b);
            final setsStr = completedSets
                .map(
                    (s) => '${s.weight?.toStringAsFixed(0)}kg×${s.reps ?? "?"}')
                .join(', ');
            exerciseSessions.add((s.startTime, maxW, setsStr));
          }
          break;
        }
      }
    }

    final type = _typeForExercise(exercise);
    final color = ForgeHelpers.workoutTypeColor(type);

    showModalBottomSheet(
      context: context,
      backgroundColor: ForgeColors.surface,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: .75,
        maxChildSize: .95,
        minChildSize: .5,
        expand: false,
        builder: (_, ctrl) => _ExerciseHistorySheet(
          exercise: exercise,
          color: color,
          sessions: exerciseSessions,
          controller: ctrl,
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref) async {
    final nameCtrl = TextEditingController(text: exercise.name);
    final tagsCtrl = TextEditingController(text: exercise.tags.join(', '));

    await showDialog(
      context: context,
      useRootNavigator: true,
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
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
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
                if (context.mounted)
                  Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('Salvar',
                  style: TextStyle(color: Color(0xFF00e5c8)))),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    // B1 FIX: rootNavigator: true
    final confirm = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
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
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(false),
              child: const Text('Cancelar',
                  style: TextStyle(color: ForgeColors.muted))),
          TextButton(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(true),
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

    return GestureDetector(
      onTap: () => _showHistory(context, ref),
      child: Container(
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(exercise.name,
                    style: const TextStyle(
                        fontSize: 14,
                        color: ForgeColors.text,
                        fontWeight: FontWeight.w500)),
                Text('${exercise.type.name} · ${exercise.tags.join(", ")}',
                    style: const TextStyle(
                        fontSize: 11, color: ForgeColors.muted)),
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
      ),
    );
  }
}

// B5: Bottom sheet de histórico do exercício
class _ExerciseHistorySheet extends StatelessWidget {
  final Exercise exercise;
  final Color color;
  final List<(DateTime, double, String)> sessions;
  final ScrollController controller;
  const _ExerciseHistorySheet(
      {required this.exercise,
      required this.color,
      required this.sessions,
      required this.controller});

  static const _months = [
    'jan',
    'fev',
    'mar',
    'abr',
    'mai',
    'jun',
    'jul',
    'ago',
    'set',
    'out',
    'nov',
    'dez'
  ];

  @override
  Widget build(BuildContext context) {
    final pr = sessions.isNotEmpty
        ? sessions.map((s) => s.$2).reduce((a, b) => a > b ? a : b)
        : null;

    return Column(children: [
      const SizedBox(height: 8),
      Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
              color: ForgeColors.border,
              borderRadius: BorderRadius.circular(2))),
      const SizedBox(height: 16),
      Expanded(
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          children: [
            // Header
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(exercise.name,
                        style: const TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 26,
                            color: ForgeColors.text,
                            height: 1)),
                    const SizedBox(height: 2),
                    Text(
                        '${exercise.type.name} · ${exercise.tags.take(3).join(", ")}',
                        style: const TextStyle(
                            fontSize: 12, color: ForgeColors.muted)),
                  ])),
              if (pr != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: color.withOpacity(.15),
                      border: Border.all(color: color.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(children: [
                    Text('${pr.toStringAsFixed(0)} kg',
                        style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 20,
                            color: color,
                            letterSpacing: 0)),
                    const Text('PR atual',
                        style:
                            TextStyle(fontSize: 9, color: ForgeColors.muted)),
                  ]),
                ),
            ]),
            const SizedBox(height: 16),

            // Gráfico SVG de evolução de carga
            if (sessions.length >= 2) ...[
              const Text('EVOLUÇÃO DE CARGA',
                  style: TextStyle(
                      fontSize: 9,
                      color: ForgeColors.muted,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: ForgeColors.card,
                    border: Border.all(color: ForgeColors.border),
                    borderRadius: BorderRadius.circular(12)),
                child: _WeightChart(sessions: sessions, color: color),
              ),
              const SizedBox(height: 16),
            ],

            // Últimas sessões
            const Text('ÚLTIMAS SESSÕES',
                style: TextStyle(
                    fontSize: 9,
                    color: ForgeColors.muted,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            if (sessions.isEmpty)
              const Text('Nenhuma sessão registrada ainda.',
                  style: TextStyle(fontSize: 13, color: ForgeColors.muted))
            else
              Container(
                decoration: BoxDecoration(
                    color: ForgeColors.card,
                    border: Border.all(color: ForgeColors.border),
                    borderRadius: BorderRadius.circular(12)),
                clipBehavior: Clip.hardEdge,
                child: Column(children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    color: ForgeColors.surface,
                    child: const Row(children: [
                      Expanded(
                          child: Text('Data',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: ForgeColors.muted,
                                  fontWeight: FontWeight.w600))),
                      SizedBox(
                          width: 70,
                          child: Text('Carga',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 9,
                                  color: ForgeColors.muted,
                                  fontWeight: FontWeight.w600))),
                      SizedBox(
                          width: 90,
                          child: Text('Séries',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 9,
                                  color: ForgeColors.muted,
                                  fontWeight: FontWeight.w600))),
                    ]),
                  ),
                  ...sessions.take(5).map((s) {
                    final d = s.$1;
                    final label = '${d.day} ${_months[d.month - 1]}';
                    final isFirst = sessions.first == s;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 9),
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(color: ForgeColors.border))),
                      child: Row(children: [
                        Expanded(
                            child: Text(label,
                                style: const TextStyle(
                                    fontSize: 12, color: ForgeColors.text))),
                        SizedBox(
                            width: 70,
                            child: Text('${s.$2.toStringAsFixed(0)} kg',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: isFirst ? color : ForgeColors.muted,
                                    fontWeight: isFirst
                                        ? FontWeight.w600
                                        : FontWeight.normal))),
                        SizedBox(
                            width: 90,
                            child: Text(s.$3,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 10, color: ForgeColors.muted))),
                      ]),
                    );
                  }),
                ]),
              ),
          ],
        ),
      ),
    ]);
  }
}

class _WeightChart extends StatelessWidget {
  final List<(DateTime, double, String)> sessions;
  final Color color;
  const _WeightChart({required this.sessions, required this.color});

  @override
  Widget build(BuildContext context) {
    final reversed = sessions.reversed.toList();
    final maxW = reversed.map((s) => s.$2).reduce((a, b) => a > b ? a : b);
    final minW = reversed.map((s) => s.$2).reduce((a, b) => a < b ? a : b);
    final range = (maxW - minW).clamp(1.0, double.infinity);

    return SizedBox(
      height: 80,
      child: CustomPaint(
        size: const Size(double.infinity, 80),
        painter: _LineChartPainter(
            sessions: reversed,
            maxW: maxW,
            minW: minW,
            range: range,
            color: color),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<(DateTime, double, String)> sessions;
  final double maxW, minW, range;
  final Color color;
  const _LineChartPainter(
      {required this.sessions,
      required this.maxW,
      required this.minW,
      required this.range,
      required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (sessions.length < 2) return;
    final n = sessions.length;
    final pts = sessions.asMap().entries.map((e) {
      final x = e.key / (n - 1) * size.width;
      final y =
          size.height - (e.value.$2 - minW) / range * (size.height - 16) - 4;
      return Offset(x, y);
    }).toList();

    // Fill
    final fillPath = Path()..moveTo(pts.first.dx, size.height);
    for (final p in pts) fillPath.lineTo(p.dx, p.dy);
    fillPath.lineTo(pts.last.dx, size.height);
    fillPath.close();
    canvas.drawPath(
        fillPath,
        Paint()
          ..shader = LinearGradient(
                  colors: [color.withOpacity(.25), color.withOpacity(0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)
              .createShader(Rect.fromLTWH(0, 0, size.width, size.height)));

    // Line
    final linePath = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final p in pts.skip(1)) linePath.lineTo(p.dx, p.dy);
    canvas.drawPath(
        linePath,
        Paint()
          ..color = color
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round);

    // Dots
    for (final p in pts) {
      canvas.drawCircle(
          p,
          4,
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter old) => false;
}

// ── Shared widgets
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
