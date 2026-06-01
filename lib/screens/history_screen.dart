import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import '../core/helpers/forge_helpers.dart';
import '../providers/session_providers.dart';
import '../data/models/training_session.dart';
import '../data/models/enums.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});
  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  WorkoutType? _filter;
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider).valueOrNull ?? ForgeThemes.teal;
    final sessionsAsync = ref.watch(sessionsProvider);

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: sessionsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
              child: Text('Erro: $e',
                  style: const TextStyle(color: ForgeColors.muted))),
          data: (sessions) {
            final filtered = _filter == null
                ? sessions
                : sessions.where((s) => s.workoutType == _filter).toList();

            final monthSessions = sessions
                .where((s) =>
                    s.startTime.year == _month.year &&
                    s.startTime.month == _month.month)
                .toList();

            final dayMap = <int, Set<WorkoutType>>{};
            for (final s in monthSessions) {
              dayMap.putIfAbsent(s.startTime.day, () => {}).add(s.workoutType);
            }

            final grouped = <DateTime, List<TrainingSession>>{};
            for (final s in filtered) {
              final d = DateTime(
                  s.startTime.year, s.startTime.month, s.startTime.day);
              grouped.putIfAbsent(d, () => []).add(s);
            }
            final sortedDays = grouped.keys.toList()
              ..sort((a, b) => b.compareTo(a));

            return Column(children: [
              _Header(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  children: [
                    _MonthStats(sessions: monthSessions, theme: theme),
                    const SizedBox(height: 16),
                    _MonthCalendar(
                        month: _month,
                        dayMap: dayMap,
                        onPrev: () => setState(() =>
                            _month = DateTime(_month.year, _month.month - 1)),
                        onNext: () => setState(() =>
                            _month = DateTime(_month.year, _month.month + 1))),
                    const SizedBox(height: 16),
                    _FilterRow(
                        current: _filter,
                        onSelect: (t) =>
                            setState(() => _filter = _filter == t ? null : t)),
                    const SizedBox(height: 14),
                    if (sortedDays.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(
                            child: Text('Nenhuma sessão registrada',
                                style: TextStyle(
                                    color: ForgeColors.muted, fontSize: 14))),
                      )
                    else
                      ...sortedDays.map((day) =>
                          _DayGroup(day: day, sessions: grouped[day]!)),
                  ],
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Histórico',
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 38,
                  color: ForgeColors.text)),
        ),
      );
}

class _MonthStats extends StatelessWidget {
  final List<TrainingSession> sessions;
  final ForgeTheme theme;
  const _MonthStats({required this.sessions, required this.theme});

  @override
  Widget build(BuildContext context) {
    final totalMin =
        sessions.fold<int>(0, (s, e) => s + e.durationSeconds) ~/ 60;
    final pr = sessions.fold<int>(0, (s, e) => s + e.prCount);

    return Row(children: [
      _StatBox(
          value: sessions.length.toString(),
          label: 'sessões',
          color: theme.accent),
      const SizedBox(width: 8),
      _StatBox(value: '${totalMin}min', label: 'tempo total'),
      const SizedBox(width: 8),
      _StatBox(value: pr.toString(), label: 'PRs'),
    ]);
  }
}

class _StatBox extends StatelessWidget {
  final String value, label;
  final Color? color;
  const _StatBox({required this.value, required this.label, this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: ForgeColors.card,
              border: Border.all(color: ForgeColors.border),
              borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Text(value,
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 22,
                    color: color ?? ForgeColors.text,
                    letterSpacing: 0)),
            Text(label,
                style: const TextStyle(fontSize: 9, color: ForgeColors.muted)),
          ]),
        ),
      );
}

class _MonthCalendar extends StatelessWidget {
  final DateTime month;
  final Map<int, Set<WorkoutType>> dayMap;
  final VoidCallback onPrev, onNext;
  const _MonthCalendar(
      {required this.month,
      required this.dayMap,
      required this.onPrev,
      required this.onNext});

  static const _months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];
  static const _days = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startWd = (firstDay.weekday - 1) % 7;
    final today = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(14)),
      child: Column(children: [
        Row(children: [
          GestureDetector(
              onTap: onPrev,
              child: const Icon(LucideIcons.chevron_left,
                  color: ForgeColors.muted, size: 18)),
          Expanded(
              child: Center(
                  child: Text('${_months[month.month - 1]} ${month.year}',
                      style: const TextStyle(
                          fontSize: 13,
                          color: ForgeColors.text,
                          fontWeight: FontWeight.w600)))),
          GestureDetector(
              onTap: onNext,
              child: const Icon(LucideIcons.chevron_right,
                  color: ForgeColors.muted, size: 18)),
        ]),
        const SizedBox(height: 10),
        Row(
            children: _days
                .map((d) => Expanded(
                    child: Center(
                        child: Text(d,
                            style: const TextStyle(
                                fontSize: 10,
                                color: ForgeColors.muted,
                                fontWeight: FontWeight.w600)))))
                .toList()),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 4),
          itemCount: startWd + daysInMonth,
          itemBuilder: (_, i) {
            if (i < startWd) return const SizedBox.shrink();
            final day = i - startWd + 1;
            final types = dayMap[day];
            final isToday = today.year == month.year &&
                today.month == month.month &&
                today.day == day;

            return Container(
              decoration: isToday
                  ? BoxDecoration(
                      color: const Color(0xFF00e5c8).withOpacity(.12),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                          color: const Color(0xFF00e5c8).withOpacity(.3)))
                  : null,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$day',
                        style: TextStyle(
                          fontSize: 11,
                          color: isToday
                              ? const Color(0xFF00e5c8)
                              : (types != null
                                  ? ForgeColors.text
                                  : ForgeColors.muted2),
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                        )),
                    if (types != null) ...[
                      const SizedBox(height: 2),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: types
                              .take(3)
                              .map((t) => Container(
                                    width: 4,
                                    height: 4,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    decoration: BoxDecoration(
                                        color: ForgeHelpers.workoutTypeColor(t),
                                        shape: BoxShape.circle),
                                  ))
                              .toList()),
                    ] else
                      const SizedBox(height: 6),
                  ]),
            );
          },
        ),
      ]),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final WorkoutType? current;
  final void Function(WorkoutType) onSelect;
  const _FilterRow({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            WorkoutType.values.where((t) => t != WorkoutType.custom).map((t) {
          final active = current == t;
          final color = ForgeHelpers.workoutTypeColor(t);
          return GestureDetector(
            onTap: () => onSelect(t),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: active ? color.withOpacity(.15) : ForgeColors.card,
                border: Border.all(color: active ? color : ForgeColors.border),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(ForgeHelpers.workoutTypeLabel(t),
                  style: TextStyle(
                      fontSize: 12,
                      color: active ? color : ForgeColors.muted,
                      fontWeight: FontWeight.w500)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DayGroup extends StatelessWidget {
  final DateTime day;
  final List<TrainingSession> sessions;
  const _DayGroup({required this.day, required this.sessions});

  static const _weekdays = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo'
  ];
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
    final label =
        '${_weekdays[day.weekday - 1]}, ${day.day} ${_months[day.month - 1]}';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(label.toUpperCase(),
            style: const TextStyle(
                fontSize: 9,
                color: ForgeColors.muted,
                letterSpacing: 2,
                fontWeight: FontWeight.w600)),
      ),
      ...sessions.map((s) => _SessionCard(session: s)),
    ]);
  }
}

// F10: Sessão expansível
class _SessionCard extends StatefulWidget {
  final TrainingSession session;
  const _SessionCard({required this.session});

  @override
  State<_SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<_SessionCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _animCtrl;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _animation = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _animCtrl.forward();
      } else {
        _animCtrl.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.session;
    final color = ForgeHelpers.workoutTypeColor(s.workoutType);
    final colorLight = ForgeHelpers.workoutTypeColorLight(s.workoutType);
    final icon = ForgeHelpers.workoutTypeIcon(s.workoutType);
    final dur = ForgeHelpers.formatDuration(s.durationSeconds);
    final timeStr =
        '${s.startTime.hour.toString().padLeft(2, '0')}:${s.startTime.minute.toString().padLeft(2, '0')}';

    final effortEmojis = ['😵', '😓', '😊', '💪', '🔥'];
    final effortEmoji =
        s.perceivedEffort != null && s.perceivedEffort! < effortEmojis.length
            ? effortEmojis[s.perceivedEffort!]
            : null;

    return GestureDetector(
      onTap: _toggle,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border(
              left: BorderSide(color: color, width: 3),
              top: BorderSide(color: ForgeColors.border),
              right: BorderSide(color: ForgeColors.border),
              bottom: BorderSide(color: ForgeColors.border)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          // Header row
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: color.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(s.workoutName,
                        style: const TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 20,
                            color: ForgeColors.text)),
                    Text(
                        '${ForgeHelpers.workoutTypeLabel(s.workoutType)} · $dur · $timeStr',
                        style: const TextStyle(
                            fontSize: 11, color: ForgeColors.muted)),
                  ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                if (s.totalVolume > 0)
                  Text('${(s.totalVolume / 1000).toStringAsFixed(1)}t',
                      style: TextStyle(
                          fontSize: 13,
                          color: color,
                          fontWeight: FontWeight.w600))
                else if (s.totalDistanceKm > 0)
                  Text('${s.totalDistanceKm.toStringAsFixed(1)} km',
                      style: TextStyle(
                          fontSize: 13,
                          color: color,
                          fontWeight: FontWeight.w600)),
                if (effortEmoji != null)
                  Text(effortEmoji, style: const TextStyle(fontSize: 16)),
                if (s.prCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: colorLight.withOpacity(.12),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text('${s.prCount} PR',
                        style: TextStyle(
                            fontSize: 10,
                            color: colorLight,
                            fontWeight: FontWeight.w600)),
                  ),
              ]),
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(LucideIcons.chevron_down,
                    color: ForgeColors.muted2, size: 16),
              ),
            ]),
          ),

          // F10: Expanded content
          SizeTransition(
            sizeFactor: _animation,
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: ForgeColors.border))),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercícios e séries
                    if (s.exercises.isNotEmpty) ...[
                      const _ExpandLabel('Exercícios'),
                      ...s.exercises.map(
                          (ex) => _ExerciseDetail(exercise: ex, color: color)),
                    ],

                    // Pace por km (corrida)
                    if (s.kmPaces.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const _ExpandLabel('Pace por km'),
                      ...s.kmPaces.asMap().entries.map((e) {
                        final sPerKm = e.value;
                        final m = sPerKm ~/ 60;
                        final sec = (sPerKm % 60).round();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(children: [
                            Text('Km ${e.key + 1}',
                                style: const TextStyle(
                                    fontSize: 12, color: ForgeColors.muted)),
                            const Spacer(),
                            Text('$m:${sec.toString().padLeft(2, '0')} /km',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: color,
                                    fontWeight: FontWeight.w600)),
                          ]),
                        );
                      }),
                    ],

                    // Notas
                    if (s.notes != null && s.notes!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const _ExpandLabel('Notas'),
                      Text(s.notes!,
                          style: const TextStyle(
                              fontSize: 12, color: ForgeColors.muted)),
                    ],
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class _ExerciseDetail extends StatelessWidget {
  final SessionExercise exercise;
  final Color color;
  const _ExerciseDetail({required this.exercise, required this.color});

  @override
  Widget build(BuildContext context) {
    final completedSets = exercise.sets.where((s) => s.completed).toList();
    if (completedSets.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: ForgeColors.surface,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(exercise.exerciseName,
            style: const TextStyle(
                fontSize: 13,
                color: ForgeColors.text,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: completedSets.asMap().entries.map((e) {
            final set = e.value;
            final isPR = set.isPR;
            String label = 'S${e.key + 1}';
            if (set.weight != null && set.reps != null) {
              label += ' ${set.weight!.toStringAsFixed(0)}kg×${set.reps}';
            } else if (set.reps != null) {
              label += ' ×${set.reps}';
            } else if (set.durationSeconds != null) {
              label += ' ${set.durationSeconds}s';
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isPR ? color.withOpacity(.15) : ForgeColors.card,
                border: Border.all(color: isPR ? color : ForgeColors.border),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (isPR) ...[
                  Icon(LucideIcons.trophy, color: color, size: 10),
                  const SizedBox(width: 3),
                ],
                Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        color: isPR ? color : ForgeColors.muted,
                        fontWeight:
                            isPR ? FontWeight.w600 : FontWeight.normal)),
              ]),
            );
          }).toList(),
        ),
      ]),
    );
  }
}

class _ExpandLabel extends StatelessWidget {
  final String text;
  const _ExpandLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text.toUpperCase(),
            style: const TextStyle(
                fontSize: 9,
                color: ForgeColors.muted,
                letterSpacing: 2,
                fontWeight: FontWeight.w600)),
      );
}
