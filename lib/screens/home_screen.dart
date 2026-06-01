import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import '../core/helpers/forge_helpers.dart';
import '../providers/session_providers.dart';
import '../providers/user_settings_provider.dart';
import '../data/models/enums.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider).valueOrNull ?? ForgeThemes.teal;
    final settingsAsync = ref.watch(userSettingsProvider);
    final macroAsync = ref.watch(activeMacroCycleProvider);
    final streak = ref.watch(streakProvider);
    final sessionsAsync = ref.watch(sessionsProvider);

    final name = settingsAsync.valueOrNull?.name ?? 'Atleta';

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ForgeHelpers.greetingByHour().toUpperCase(),
                            style: const TextStyle(
                                fontSize: 9,
                                color: ForgeColors.muted,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(name,
                            style: const TextStyle(
                                fontFamily: 'BebasNeue',
                                fontSize: 52,
                                height: .9,
                                color: ForgeColors.text)),
                        const SizedBox(height: 3),
                        Text(ForgeHelpers.todayLabel(),
                            style: const TextStyle(
                                fontSize: 11, color: ForgeColors.muted)),
                      ]),
                  const Spacer(),
                  const SizedBox(height: 8),
                  _IconBtn(
                      icon: LucideIcons.settings,
                      onTap: () => context.push('/settings')),
                ],
              ),
              const SizedBox(height: 16),
              macroAsync.when(
                loading: () => const SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const SizedBox.shrink(),
                data: (cycle) {
                  if (cycle == null) return _EmptyMacroCard(theme: theme);
                  final phase = cycle.phases.isNotEmpty
                      ? cycle.phases[cycle.currentPhaseIndex]
                      : null;
                  final pct = phase != null && phase.targetSessions > 0
                      ? (phase.completedSessions / phase.targetSessions)
                          .clamp(0.0, 1.0)
                      : 0.0;
                  return _MacroCard(
                    theme: theme,
                    cycleName: cycle.name,
                    phaseName: phase?.name ?? '—',
                    completed: phase?.completedSessions ?? 0,
                    target: phase?.targetSessions ?? 0,
                    pct: pct,
                    onTap: () => context.push('/macro'),
                  );
                },
              ),
              const SizedBox(height: 16),
              macroAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (cycle) {
                  if (cycle == null || cycle.phases.isEmpty)
                    return const SizedBox.shrink();
                  final phase = cycle.phases[cycle.currentPhaseIndex];
                  final weekday = DateTime.now().weekday;
                  final schedList = phase.weeklySchedule
                      .where((d) => d.weekday == weekday)
                      .toList();
                  if (schedList.isEmpty) return const SizedBox.shrink();
                  final sched = schedList.first;
                  final names = sched.workoutNames;
                  final ids = sched.workoutIds;
                  if (names.isEmpty) return const SizedBox.shrink();

                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel('Treinos de hoje'),
                        ...names.asMap().entries.map((e) {
                          final id = e.key < ids.length ? ids[e.key] : null;
                          return _WorkoutTodayCard(
                              name: e.value, workoutId: id);
                        }),
                      ]);
                },
              ),
              const SizedBox(height: 16),
              Row(children: [
                _StatCard(
                  icon: LucideIcons.flame,
                  iconColor: theme.accent,
                  value: streak.toString(),
                  label: 'streak',
                ),
                const SizedBox(width: 8),
                _StatCard(
                  icon: LucideIcons.layers,
                  value: () {
                    final sessions = sessionsAsync.valueOrNull ?? [];
                    final now = DateTime.now();
                    final weekStart =
                        now.subtract(Duration(days: now.weekday - 1));
                    return sessions
                        .where((s) => s.startTime.isAfter(weekStart))
                        .length
                        .toString();
                  }(),
                  label: 'semana',
                ),
                const SizedBox(width: 8),
                _StatCard(
                  icon: LucideIcons.clock,
                  value: () {
                    final sessions = sessionsAsync.valueOrNull ?? [];
                    final totalSec = sessions.fold<int>(
                        0, (sum, s) => sum + s.durationSeconds);
                    return (totalSec ~/ 3600).toString();
                  }(),
                  label: 'horas',
                ),
              ]),
              const SizedBox(height: 16),
              macroAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (cycle) {
                  if (cycle == null || cycle.phases.isEmpty)
                    return const SizedBox.shrink();
                  final phase = cycle.phases[cycle.currentPhaseIndex];
                  final now = DateTime.now();
                  final nextDays =
                      List.generate(3, (i) => now.add(Duration(days: i + 1)));
                  final days = nextDays.map((d) {
                    final wd = d.weekday;
                    final sched = phase.weeklySchedule
                        .where((s) => s.weekday == wd)
                        .toList();
                    final names = sched.isNotEmpty
                        ? sched.first.workoutNames
                        : <String>[];
                    const dayLabels = [
                      'Seg',
                      'Ter',
                      'Qua',
                      'Qui',
                      'Sex',
                      'Sáb',
                      'Dom'
                    ];
                    return (dayLabels[wd - 1], names);
                  }).toList();

                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel('Próximos dias'),
                        _NextDaysCard(days: days),
                      ]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  final ForgeTheme theme;
  final String cycleName, phaseName;
  final int completed, target;
  final double pct;
  final VoidCallback onTap;
  const _MacroCard(
      {required this.theme,
      required this.cycleName,
      required this.phaseName,
      required this.completed,
      required this.target,
      required this.pct,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _Card(
          child: Column(children: [
        Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(cycleName.toUpperCase(),
                style: const TextStyle(
                    fontSize: 9,
                    color: ForgeColors.muted,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(phaseName,
                style: const TextStyle(
                    fontSize: 14,
                    color: ForgeColors.text,
                    fontWeight: FontWeight.w500)),
          ]),
          const Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text('Sessões',
                style: TextStyle(fontSize: 9, color: ForgeColors.muted)),
            Text('$completed/$target',
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 24,
                    color: theme.accent,
                    letterSpacing: 0)),
          ]),
        ]),
        const SizedBox(height: 10),
        _ProgressBar(value: pct, color: theme.accent),
        const SizedBox(height: 7),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${target - completed} sessões restantes',
              style: const TextStyle(fontSize: 10, color: ForgeColors.muted)),
          Text('${(pct * 100).round()}%',
              style: TextStyle(
                  fontSize: 10,
                  color: theme.accent,
                  fontWeight: FontWeight.w600)),
        ]),
      ])),
    );
  }
}

class _EmptyMacroCard extends StatelessWidget {
  final ForgeTheme theme;
  const _EmptyMacroCard({required this.theme});
  @override
  Widget build(BuildContext context) {
    return _Card(
        child: Row(children: [
      const Expanded(
          child: Text('Nenhum ciclo ativo',
              style: TextStyle(fontSize: 14, color: ForgeColors.muted))),
      GestureDetector(
        onTap: () => context.push('/macro'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
              color: theme.accent, borderRadius: BorderRadius.circular(8)),
          child: Text('CRIAR',
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 13,
                  color: theme.id == 'neon' ? Colors.black : ForgeColors.bg)),
        ),
      ),
    ]));
  }
}

class _WorkoutTodayCard extends StatelessWidget {
  final String name;
  final int? workoutId;
  const _WorkoutTodayCard({required this.name, this.workoutId});

  static String _modeForType(WorkoutType type) => switch (type) {
        WorkoutType.corrida => 'corrida',
        WorkoutType.musculacao => 'musculacao',
        _ => 'timed',
      };

  static WorkoutType _typeForName(String name) {
    final nl = name.toLowerCase();
    if (nl.contains('upper') || nl.contains('lower'))
      return WorkoutType.musculacao;
    if (nl.contains('mob')) return WorkoutType.mobilidade;
    if (nl.contains('corrida')) return WorkoutType.corrida;
    if (nl.contains('drill')) return WorkoutType.drills;
    if (nl.contains('bola')) return WorkoutType.bola;
    return WorkoutType.custom;
  }

  @override
  Widget build(BuildContext context) {
    final type = _typeForName(name);
    final color = ForgeHelpers.workoutTypeColor(type);
    final colorLight = ForgeHelpers.workoutTypeColorLight(type);
    final icon = ForgeHelpers.workoutTypeIcon(type);
    final label = ForgeHelpers.workoutTypeLabel(type);
    final mode = _modeForType(type);

    final idPart = workoutId != null ? '&id=$workoutId' : '';
    final url =
        '/session?mode=$mode&type=${type.name}$idPart&name=${Uri.encodeComponent(name)}';

    return GestureDetector(
      onTap: () => context.push(url),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: color.withOpacity(.22)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: color.withOpacity(.14),
                borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: colorLight, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(label.toUpperCase(),
                    style: TextStyle(
                        fontSize: 9,
                        color: colorLight,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1)),
                Text(name,
                    style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 22,
                        color: ForgeColors.text,
                        height: 1.1)),
              ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
                color: color.withOpacity(.14),
                borderRadius: BorderRadius.circular(9)),
            child: Text('INICIAR',
                style: TextStyle(
                    fontFamily: 'BebasNeue', fontSize: 14, color: colorLight)),
          ),
        ]),
      ),
    );
  }
}

class _NextDaysCard extends StatelessWidget {
  final List<(String, List<String>)> days;
  const _NextDaysCard({required this.days});

  static const _typeColors = {
    'upper': ForgeColors.musculacao,
    'lower': ForgeColors.musculacao,
    'mob': ForgeColors.mobilidade,
    'corrida': ForgeColors.corrida,
    'drill': ForgeColors.drills,
    'bola': ForgeColors.bola,
  };

  Color _colorForName(String name) {
    final n = name.toLowerCase();
    for (final e in _typeColors.entries) if (n.contains(e.key)) return e.value;
    return ForgeColors.muted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: days.asMap().entries.map((e) {
          final last = e.key == days.length - 1;
          final day = e.value.$1;
          final names = e.value.$2;
          return Expanded(
              child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border(
                    right: last
                        ? BorderSide.none
                        : const BorderSide(color: ForgeColors.border))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(day.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 9,
                      color: ForgeColors.muted,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              if (names.isEmpty)
                const Text('Descanso',
                    style: TextStyle(fontSize: 10, color: ForgeColors.muted2))
              else ...[
                Row(
                    children: names
                        .map((n) => Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                  color: _colorForName(n),
                                  shape: BoxShape.circle),
                            ))
                        .toList()),
                const SizedBox(height: 5),
                ...names.asMap().entries.map((n) => Text(
                      n.value,
                      style: TextStyle(
                          fontSize: 10,
                          color: n.key == 0
                              ? ForgeColors.text
                              : ForgeColors.muted),
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ]),
          ));
        }).toList(),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String value, label;
  const _StatCard(
      {required this.icon,
      required this.value,
      required this.label,
      this.iconColor});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          decoration: BoxDecoration(
              color: ForgeColors.card,
              border: Border.all(color: ForgeColors.border),
              borderRadius: BorderRadius.circular(14)),
          child: Column(children: [
            Icon(icon, color: iconColor ?? ForgeColors.muted, size: 16),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 32,
                    color: ForgeColors.text,
                    letterSpacing: 0,
                    height: 1)),
            Text(label,
                style: const TextStyle(fontSize: 9, color: ForgeColors.muted)),
          ]),
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
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

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: ForgeColors.card,
            border: Border.all(color: ForgeColors.border),
            borderRadius: BorderRadius.circular(14)),
        child: child,
      );
}

class _ProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  const _ProgressBar({required this.value, required this.color});
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
            value: value,
            minHeight: 4,
            backgroundColor: ForgeColors.border,
            valueColor: AlwaysStoppedAnimation(color)),
      );
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: ForgeColors.card,
              border: Border.all(color: ForgeColors.border),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: ForgeColors.muted, size: 16),
        ),
      );
}
