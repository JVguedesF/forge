import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import '../core/helpers/forge_helpers.dart';
import '../providers/session_providers.dart';
import '../data/models/macro_cycle.dart';
import '../data/models/enums.dart';

class MacroScreen extends ConsumerWidget {
  const MacroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider).valueOrNull ?? ForgeThemes.teal;
    final macroAsync = ref.watch(activeMacroCycleProvider);

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(children: [
          _AppBar(onBack: () => context.pop()),
          Expanded(
            child: macroAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                  child: Text('Erro: $e',
                      style: const TextStyle(color: ForgeColors.muted))),
              data: (cycle) {
                if (cycle == null) return _EmptyState(theme: theme);
                return _MacroContent(cycle: cycle, theme: theme);
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class _MacroContent extends StatelessWidget {
  final MacroCycle cycle;
  final ForgeTheme theme;
  const _MacroContent({required this.cycle, required this.theme});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      children: [
        _CycleHeader(cycle: cycle, theme: theme),
        const SizedBox(height: 16),
        _PhasesSection(cycle: cycle, theme: theme),
        const SizedBox(height: 16),
        if (cycle.phases.isNotEmpty) ...[
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
        borderRadius: BorderRadius.circular(16),
      ),
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
        const SizedBox(height: 14),
        if (phase != null) ...[
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

class _PhasesSection extends StatelessWidget {
  final MacroCycle cycle;
  final ForgeTheme theme;
  const _PhasesSection({required this.cycle, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SLabel('Fases do ciclo'),
      ...cycle.phases.asMap().entries.map((e) {
        final i = e.key;
        final phase = e.value;
        final isActive = i == cycle.currentPhaseIndex;
        final isPast = i < cycle.currentPhaseIndex;
        final pct = phase.targetSessions > 0
            ? (phase.completedSessions / phase.targetSessions).clamp(0.0, 1.0)
            : 0.0;

        final barColor = isPast
            ? ForgeColors.muted2
            : isActive
                ? theme.accent
                : ForgeColors.muted2;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: ForgeColors.card,
            border: Border.all(
                color: isActive
                    ? theme.accent.withOpacity(.3)
                    : ForgeColors.border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(children: [
            Container(
              width: 4,
              height: 80,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        if (isActive)
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                                color: theme.accent.withOpacity(.15),
                                borderRadius: BorderRadius.circular(20)),
                            child: Text('ATUAL',
                                style: TextStyle(
                                    fontSize: 8,
                                    color: theme.accent,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1)),
                          ),
                        Text(phase.name,
                            style: const TextStyle(
                                fontSize: 13,
                                color: ForgeColors.text,
                                fontWeight: FontWeight.w500)),
                      ]),
                      const SizedBox(height: 2),
                      Text(phase.objective ?? '',
                          style: const TextStyle(
                              fontSize: 11, color: ForgeColors.muted)),
                      const SizedBox(height: 8),
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
                            '${phase.completedSessions}/${phase.targetSessions}',
                            style: TextStyle(
                                fontSize: 10,
                                color: isActive
                                    ? theme.accent
                                    : ForgeColors.muted)),
                      ]),
                      const SizedBox(height: 4),
                      Text(
                          '${phase.durationWeeks} semanas · ${phase.intensityPercent}% intensidade · ${phase.recommendedSets}×${phase.recommendedReps}',
                          style: const TextStyle(
                              fontSize: 10, color: ForgeColors.muted2)),
                    ]),
              ),
            ),
          ]),
        );
      }),
    ]);
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
          borderRadius: BorderRadius.circular(14),
        ),
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
                  child: Text(
                    _dayLabels[i],
                    style: TextStyle(
                      fontSize: 12,
                      color: isToday ? theme.accent : ForgeColors.muted,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.normal,
                    ),
                  ),
                ),
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
            borderRadius: BorderRadius.circular(12),
          ),
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
                valueColor: AlwaysStoppedAnimation(theme.accent),
              ),
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
      const SizedBox(height: 24),
      GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
              color: theme.accent, borderRadius: BorderRadius.circular(12)),
          child: Text('CRIAR CICLO',
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 16,
                  color: theme.id == 'neon' ? Colors.black : ForgeColors.bg)),
        ),
      ),
    ]));
  }
}

class _AppBar extends StatelessWidget {
  final VoidCallback onBack;
  const _AppBar({required this.onBack});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: Row(children: [
          _XBtn(onTap: onBack),
          const SizedBox(width: 12),
          const Text('Macro Ciclo',
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 22,
                  color: ForgeColors.text)),
        ]),
      );
}

class _XBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _XBtn({required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
              border: Border.all(color: ForgeColors.border),
              shape: BoxShape.circle),
          child: const Icon(LucideIcons.arrow_left,
              color: ForgeColors.muted, size: 16),
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
