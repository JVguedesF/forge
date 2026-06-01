import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import '../providers/session_providers.dart';
import '../providers/workout_providers.dart';
import '../data/models/enums.dart';
import '../core/helpers/forge_helpers.dart';

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith('/library')) return 1;
    if (loc.startsWith('/stats')) return 2;
    if (loc.startsWith('/history')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider).valueOrNull ?? ForgeThemes.teal;
    final idx = _currentIndex(context);
    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: child,
      bottomNavigationBar: _ForgeNav(currentIndex: idx, theme: theme),
    );
  }
}

class _ForgeNav extends ConsumerWidget {
  final int currentIndex;
  final ForgeTheme theme;
  const _ForgeNav({required this.currentIndex, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: const Color(0xF70a0a0a),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, thickness: 1, color: ForgeColors.border),
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 14),
            child: Row(
              children: [
                _NavItem(
                    icon: LucideIcons.house,
                    label: 'Início',
                    index: 0,
                    current: currentIndex,
                    route: '/home',
                    accent: theme.accent),
                _NavItem(
                    icon: LucideIcons.layout_grid,
                    label: 'Treinos',
                    index: 1,
                    current: currentIndex,
                    route: '/library',
                    accent: theme.accent),
                // F9: FAB funcional
                _FabItem(theme: theme),
                _NavItem(
                    icon: LucideIcons.chart_column,
                    label: 'Stats',
                    index: 2,
                    current: currentIndex,
                    route: '/stats',
                    accent: theme.accent),
                _NavItem(
                    icon: LucideIcons.calendar,
                    label: 'Histórico',
                    index: 3,
                    current: currentIndex,
                    route: '/history',
                    accent: theme.accent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final String route;
  final Color accent;
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.index,
      required this.current,
      required this.route,
      required this.accent});

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    final color = active ? accent : ForgeColors.muted2;
    return Expanded(
      child: GestureDetector(
        onTap: () => context.go(route),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 21),
            const SizedBox(height: 3),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                  fontSize: 9,
                  color: color,
                  letterSpacing: .3,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// F9: FAB com bottom sheet de treinos
class _FabItem extends ConsumerWidget {
  final ForgeTheme theme;
  const _FabItem({required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _openFabMenu(context, ref),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Transform.translate(
            offset: const Offset(0, -22),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.accent,
                shape: BoxShape.circle,
                border: Border.all(color: theme.bg, width: 3),
              ),
              child: Icon(
                LucideIcons.play,
                color: theme.id == 'neon' ? Colors.black : Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openFabMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111111),
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _FabMenuSheet(theme: theme),
    );
  }
}

class _FabMenuSheet extends ConsumerWidget {
  final ForgeTheme theme;
  const _FabMenuSheet({required this.theme});

  static String _modeForType(WorkoutType type) => switch (type) {
        WorkoutType.corrida => 'corrida',
        WorkoutType.musculacao => 'musculacao',
        _ => 'timed',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final macroAsync = ref.watch(activeMacroCycleProvider);
    final workoutsAsync = ref.watch(workoutsProvider);

    return DraggableScrollableSheet(
      initialChildSize: .65,
      maxChildSize: .92,
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
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            controller: ctrl,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            children: [
              // Treinos de hoje do ciclo ativo
              macroAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (cycle) {
                  if (cycle == null || cycle.phases.isEmpty)
                    return const SizedBox.shrink();
                  final phase = cycle.phases[cycle.currentPhaseIndex];
                  final wd = DateTime.now().weekday;
                  final schedList = phase.weeklySchedule
                      .where((s) => s.weekday == wd)
                      .toList();
                  if (schedList.isEmpty) return const SizedBox.shrink();
                  final sched = schedList.first;
                  if (sched.workoutNames.isEmpty)
                    return const SizedBox.shrink();

                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SheetLabel('Treinos de hoje'),
                        ...sched.workoutNames.asMap().entries.map((e) {
                          final wName = e.value;
                          final wId = e.key < sched.workoutIds.length
                              ? sched.workoutIds[e.key]
                              : null;
                          final type = _typeForName(wName);
                          return _FabWorkoutTile(
                            name: wName,
                            workoutId: wId,
                            workoutType: type,
                            highlight: true,
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              final mode = _modeForType(type);
                              final idPart = wId != null ? '&id=$wId' : '';
                              context.push(
                                  '/session?mode=$mode&type=${type.name}$idPart&name=${Uri.encodeComponent(wName)}');
                            },
                          );
                        }),
                        const SizedBox(height: 16),
                      ]);
                },
              ),
              // Todos os treinos da biblioteca
              workoutsAsync.when(
                loading: () => const Center(
                    child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator())),
                error: (_, __) => const SizedBox.shrink(),
                data: (workouts) {
                  final cats =
                      WorkoutType.values.where((t) => t != WorkoutType.custom);
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: cats.expand((type) {
                        final ww =
                            workouts.where((w) => w.type == type).toList();
                        if (ww.isEmpty) return <Widget>[];
                        return [
                          _SheetLabel(ForgeHelpers.workoutTypeLabel(type)),
                          ...ww.map((w) => _FabWorkoutTile(
                                name: w.name,
                                workoutId: w.id,
                                workoutType: w.type,
                                highlight: false,
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  final mode = _modeForType(w.type);
                                  final idPart =
                                      w.id != null ? '&id=${w.id}' : '';
                                  context.push(
                                      '/session?mode=$mode&type=${w.type.name}$idPart&name=${Uri.encodeComponent(w.name)}');
                                },
                              )),
                          const SizedBox(height: 12),
                        ];
                      }).toList());
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }

  WorkoutType _typeForName(String name) {
    final nl = name.toLowerCase();
    if (nl.contains('upper') || nl.contains('lower'))
      return WorkoutType.musculacao;
    if (nl.contains('mob')) return WorkoutType.mobilidade;
    if (nl.contains('corrida')) return WorkoutType.corrida;
    if (nl.contains('drill')) return WorkoutType.drills;
    if (nl.contains('bola')) return WorkoutType.bola;
    return WorkoutType.musculacao;
  }
}

class _FabWorkoutTile extends StatelessWidget {
  final String name;
  final int? workoutId;
  final WorkoutType workoutType;
  final bool highlight;
  final VoidCallback onTap;
  const _FabWorkoutTile(
      {required this.name,
      this.workoutId,
      required this.workoutType,
      required this.highlight,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = ForgeHelpers.workoutTypeColor(workoutType);
    final colorLight = ForgeHelpers.workoutTypeColorLight(workoutType);
    final icon = ForgeHelpers.workoutTypeIcon(workoutType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(
              color: highlight ? color.withOpacity(.3) : ForgeColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: color.withOpacity(.14),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: colorLight, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(name,
                    style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 18,
                        color: ForgeColors.text,
                        height: 1)),
                Text(ForgeHelpers.workoutTypeLabel(workoutType),
                    style: const TextStyle(
                        fontSize: 11, color: ForgeColors.muted)),
              ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                color: color.withOpacity(.14),
                borderRadius: BorderRadius.circular(8)),
            child: Text('INICIAR',
                style: TextStyle(
                    fontFamily: 'BebasNeue', fontSize: 13, color: colorLight)),
          ),
        ]),
      ),
    );
  }
}

class _SheetLabel extends StatelessWidget {
  final String text;
  const _SheetLabel(this.text);
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
