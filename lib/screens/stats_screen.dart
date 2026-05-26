import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import '../core/helpers/forge_helpers.dart';
import '../providers/session_providers.dart';
import '../data/models/enums.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});
  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  static const _types = [
    WorkoutType.musculacao,
    WorkoutType.corrida,
    WorkoutType.bola,
    WorkoutType.drills,
    WorkoutType.mobilidade,
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _types.length, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider).valueOrNull ?? ForgeThemes.teal;
    final sessionsAsync = ref.watch(sessionsProvider);

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(children: [
          _Header(),
          _Tabs(controller: _tab, types: _types, accent: theme.accent),
          Expanded(
            child: sessionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                  child: Text('Erro: $e',
                      style: const TextStyle(color: ForgeColors.muted))),
              data: (sessions) => TabBarView(
                controller: _tab,
                children: _types.map((type) {
                  final typeSessions =
                      sessions.where((s) => s.workoutType == type).toList();
                  return _StatsTab(
                      type: type, sessions: typeSessions, theme: theme);
                }).toList(),
              ),
            ),
          ),
        ]),
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
          child: Text('Stats',
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 38,
                  color: ForgeColors.text)),
        ),
      );
}

class _Tabs extends StatelessWidget {
  final TabController controller;
  final List<WorkoutType> types;
  final Color accent;
  const _Tabs(
      {required this.controller, required this.types, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: ForgeColors.border))),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        indicatorColor: accent,
        indicatorWeight: 2,
        labelColor: accent,
        unselectedLabelColor: ForgeColors.muted,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        tabs: types
            .map((t) => Tab(text: ForgeHelpers.workoutTypeLabel(t)))
            .toList(),
      ),
    );
  }
}

class _StatsTab extends StatelessWidget {
  final WorkoutType type;
  final List<dynamic> sessions;
  final ForgeTheme theme;
  const _StatsTab(
      {required this.type, required this.sessions, required this.theme});

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Nenhuma sessão ainda',
            style: TextStyle(fontSize: 16, color: ForgeColors.muted)),
        const SizedBox(height: 8),
        Text('Comece um treino de ${ForgeHelpers.workoutTypeLabel(type)}',
            style: const TextStyle(fontSize: 12, color: ForgeColors.muted2)),
      ]));
    }

    final color = ForgeHelpers.workoutTypeColor(type);
    final totalSec =
        sessions.fold<int>(0, (s, e) => s + (e.durationSeconds as int));
    final totalSessions = sessions.length;
    final avgMin = totalSec ~/ 60 ~/ totalSessions;
    final totalVolume =
        sessions.fold<double>(0, (s, e) => s + (e.totalVolume ?? 0.0));

    // Últimas 7 semanas
    final now = DateTime.now();
    final weeks = List.generate(7, (i) {
      final weekStart =
          now.subtract(Duration(days: now.weekday - 1 + (6 - i) * 7));
      final weekEnd = weekStart.add(const Duration(days: 6));
      final count = sessions.where((s) {
        final d = s.startTime as DateTime;
        return d.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            d.isBefore(weekEnd.add(const Duration(days: 1)));
      }).length;
      return count;
    });
    final maxWeek = weeks.reduce((a, b) => a > b ? a : b).toDouble();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // Summary cards
        Row(children: [
          _SCard(
              value: totalSessions.toString(), label: 'Sessões', color: color),
          const SizedBox(width: 8),
          _SCard(value: '${avgMin}min', label: 'Média duração'),
          const SizedBox(width: 8),
          if (type == WorkoutType.musculacao)
            _SCard(
                value: '${(totalVolume / 1000).toStringAsFixed(1)}t',
                label: 'Volume total')
          else
            _SCard(
                value: ForgeHelpers.formatDuration(totalSec),
                label: 'Tempo total'),
        ]),
        const SizedBox(height: 16),

        // Weekly bar chart
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: ForgeColors.card,
              border: Border.all(color: ForgeColors.border),
              borderRadius: BorderRadius.circular(14)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('SESSÕES POR SEMANA',
                style: TextStyle(
                    fontSize: 9,
                    color: ForgeColors.muted,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: weeks.asMap().entries.map((e) {
                  final pct = maxWeek > 0 ? e.value / maxWeek : 0.0;
                  final isLast = e.key == weeks.length - 1;
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (e.value > 0)
                            Text('${e.value}',
                                style: TextStyle(
                                    fontSize: 9,
                                    color: isLast ? color : ForgeColors.muted)),
                          const SizedBox(height: 3),
                          Container(
                            height: (pct * 60).clamp(2.0, 60.0),
                            decoration: BoxDecoration(
                              color: isLast ? color : color.withOpacity(.3),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ]),
                  ));
                }).toList(),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 16),

        // Session list
        const Text('SESSÕES RECENTES',
            style: TextStyle(
                fontSize: 9,
                color: ForgeColors.muted,
                letterSpacing: 2,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        ...sessions.take(10).map((s) => _SessionRow(session: s, color: color)),
      ],
    );
  }
}

class _SessionRow extends StatelessWidget {
  final dynamic session;
  final Color color;
  const _SessionRow({required this.session, required this.color});

  @override
  Widget build(BuildContext context) {
    final dur = ForgeHelpers.formatDuration(session.durationSeconds as int);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(session.workoutName as String,
              style: const TextStyle(
                  fontSize: 14,
                  color: ForgeColors.text,
                  fontWeight: FontWeight.w500)),
          Text(_dateLabel(session.startTime as DateTime),
              style: const TextStyle(fontSize: 11, color: ForgeColors.muted)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(dur,
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 18,
                  color: color,
                  letterSpacing: 0)),
          if (session.prCount > 0)
            Text('${session.prCount} PR',
                style: TextStyle(
                    fontSize: 10, color: color, fontWeight: FontWeight.w600)),
        ]),
      ]),
    );
  }

  String _dateLabel(DateTime d) {
    const ms = [
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
    return '${d.day} ${ms[d.month - 1]} ${d.year}';
  }
}

class _SCard extends StatelessWidget {
  final String value, label;
  final Color? color;
  const _SCard({required this.value, required this.label, this.color});

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
                    fontSize: 20,
                    color: color ?? ForgeColors.text,
                    letterSpacing: 0)),
            Text(label,
                style: const TextStyle(fontSize: 9, color: ForgeColors.muted)),
          ]),
        ),
      );
}
