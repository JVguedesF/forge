import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});
  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Progresso',
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 38,
                          color: ForgeColors.text)),
                  const SizedBox(height: 12),
                  _MacroCycleCard(theme: theme),
                  const SizedBox(height: 16),
                  _SLabel('Recordes pessoais'),
                ],
              ),
            ),
            _PRTabBar(controller: _tab, accent: theme.accent),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _MuscTab(theme: theme),
                  _CorridaTab(theme: theme),
                  _BolaTab(theme: theme),
                  _DrillsTab(theme: theme),
                  _MobTab(theme: theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab bar de PRs
class _PRTabBar extends StatelessWidget {
  final TabController controller;
  final Color accent;
  const _PRTabBar({required this.controller, required this.accent});

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
        tabAlignment: TabAlignment.start,
        tabs: const [
          Tab(text: 'Musculação'),
          Tab(text: 'Corrida'),
          Tab(text: 'Bola'),
          Tab(text: 'Drills'),
          Tab(text: 'Mobilidade'),
        ],
      ),
    );
  }
}

// ── Musculação: lista com sparkline inline
class _MuscTab extends StatelessWidget {
  final ForgeTheme theme;
  const _MuscTab({required this.theme});

  static const _prs = [
    (
      'Supino Reto',
      '100 kg',
      '80kg',
      '+25%',
      .75,
      [60.0, 65.0, 72.0, 80.0, 82.0, 100.0]
    ),
    (
      'Agachamento',
      '120 kg',
      '100kg',
      '+20%',
      .80,
      [80.0, 90.0, 100.0, 105.0, 115.0, 120.0]
    ),
    (
      'Deadlift',
      '140 kg',
      '120kg',
      '+17%',
      .87,
      [100.0, 110.0, 120.0, 125.0, 135.0, 140.0]
    ),
    ('OHP', '70 kg', '60kg', '+17%', .70, [40.0, 45.0, 55.0, 60.0, 65.0, 70.0]),
    (
      'Remada Curvada',
      '90 kg',
      '80kg',
      '+13%',
      .75,
      [60.0, 65.0, 70.0, 75.0, 82.0, 90.0]
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        ..._prs.map((p) => _MuscPRCard(
            name: p.$1,
            value: p.$2,
            prev: p.$3,
            gain: p.$4,
            pct: p.$5,
            sparkline: p.$6,
            color: ForgeColors.musculacao,
            accent: theme.accent)),
        const SizedBox(height: 8),
        _SLabel('Comparativo entre fases'),
        _PhaseCompareCard(theme: theme),
        _SLabel('Atividade semanal'),
        _WeeklyChart(),
      ],
    );
  }
}

class _MuscPRCard extends StatelessWidget {
  final String name, value, prev, gain;
  final double pct;
  final List<double> sparkline;
  final Color color, accent;
  const _MuscPRCard(
      {required this.name,
      required this.value,
      required this.prev,
      required this.gain,
      required this.pct,
      required this.sparkline,
      required this.color,
      required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ForgeColors.card,
        border: Border.all(color: color.withOpacity(.2)),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: color.withOpacity(.06), blurRadius: 12)],
      ),
      child: Row(
        children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 9,
                      color: ForgeColors.muted,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 28,
                      color: ForgeColors.text,
                      letterSpacing: 0,
                      height: 1)),
              const SizedBox(height: 6),
              _ProgressBar(value: pct, color: color),
              const SizedBox(height: 4),
              Row(children: [
                Text(prev,
                    style: const TextStyle(
                        fontSize: 10, color: ForgeColors.muted)),
                const Spacer(),
                Text(gain,
                    style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF22c55e),
                        fontWeight: FontWeight.w600)),
              ]),
            ]),
          ),
          const SizedBox(width: 14),
          _Sparkline(values: sparkline, color: color),
        ],
      ),
    );
  }
}

class _Sparkline extends StatelessWidget {
  final List<double> values;
  final Color color;
  const _Sparkline({required this.values, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 40,
      child:
          CustomPaint(painter: _SparklinePainter(values: values, color: color)),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  const _SparklinePainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = max - min == 0 ? 1.0 : max - min;

    final points = values.asMap().entries.map((e) {
      final x = e.key / (values.length - 1) * size.width;
      final y = size.height - ((e.value - min) / range) * size.height;
      return Offset(x, y);
    }).toList();

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) path.lineTo(p.dx, p.dy);

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
        fillPath,
        Paint()
          ..color = color.withOpacity(.12)
          ..style = PaintingStyle.fill);
    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..strokeWidth = 1.8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round);

    canvas.drawCircle(points.last, 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Corrida: card único + gráfico de pace
class _CorridaTab extends StatelessWidget {
  final ForgeTheme theme;
  const _CorridaTab({required this.theme});

  @override
  Widget build(BuildContext context) {
    const color = ForgeColors.corrida;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        _Card(
            child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text('DISTÂNCIA MÁXIMA',
                    style: TextStyle(
                        fontSize: 9,
                        color: ForgeColors.muted,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1)),
                const SizedBox(height: 2),
                const Text('10.2 km',
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 36,
                        color: ForgeColors.text,
                        letterSpacing: 0,
                        height: 1)),
                const Text('Pace médio: 5:09/km',
                    style: TextStyle(fontSize: 11, color: ForgeColors.muted)),
              ])),
          Container(
              width: 1,
              height: 56,
              color: ForgeColors.border,
              margin: const EdgeInsets.symmetric(horizontal: 16)),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text('PACE MAIS RÁPIDO',
                    style: TextStyle(
                        fontSize: 9,
                        color: ForgeColors.muted,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1)),
                const SizedBox(height: 2),
                Text('4:52',
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 36,
                        color: color,
                        letterSpacing: 0,
                        height: 1)),
                const Text('/km em 5km',
                    style: TextStyle(fontSize: 11, color: ForgeColors.muted)),
              ])),
        ])),
        _Card(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('EVOLUÇÃO DE PACE — últimas 6 semanas',
              style: TextStyle(
                  fontSize: 9,
                  color: ForgeColors.muted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1)),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: CustomPaint(
              size: const Size(double.infinity, 80),
              painter: _LinePainter(
                values: [5.8, 5.6, 5.4, 5.3, 5.2, 5.09],
                color: color,
                invertY: true,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('S1',
                    style: TextStyle(fontSize: 9, color: ForgeColors.muted2)),
                Text('S2',
                    style: TextStyle(fontSize: 9, color: ForgeColors.muted2)),
                Text('S3',
                    style: TextStyle(fontSize: 9, color: ForgeColors.muted2)),
                Text('S4',
                    style: TextStyle(fontSize: 9, color: ForgeColors.muted2)),
                Text('S5',
                    style: TextStyle(fontSize: 9, color: ForgeColors.muted2)),
                Text('Esta',
                    style: TextStyle(
                        fontSize: 9,
                        color: ForgeColors.corrida,
                        fontWeight: FontWeight.w600)),
              ]),
        ])),
        _Card(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('KM ACUMULADOS NO CICLO',
              style: TextStyle(
                  fontSize: 9,
                  color: ForgeColors.muted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(children: [
            Text('68.4 km',
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 32,
                    color: color,
                    letterSpacing: 0)),
            const Spacer(),
            const Text('Meta: 120 km',
                style: TextStyle(fontSize: 11, color: ForgeColors.muted)),
          ]),
          const SizedBox(height: 8),
          _ProgressBar(value: .57, color: color),
        ])),
      ],
    );
  }
}

// ── Bola: grid 1×3 com números grandes
class _BolaTab extends StatelessWidget {
  final ForgeTheme theme;
  const _BolaTab({required this.theme});

  @override
  Widget build(BuildContext context) {
    const color = ForgeColors.bola;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        const Text('EMBAIXADINHAS — recordes',
            style: TextStyle(
                fontSize: 9,
                color: ForgeColors.muted,
                fontWeight: FontWeight.w600,
                letterSpacing: 1)),
        const SizedBox(height: 8),
        Row(children: [
          _BolaStatCard(
              label: 'Pé bom',
              value: '87',
              sub: 'Meta: 150',
              color: color,
              pct: .58),
          const SizedBox(width: 8),
          _BolaStatCard(
              label: 'Pé fraco',
              value: '41',
              sub: 'Meta: 100',
              color: color,
              pct: .41),
          const SizedBox(width: 8),
          _BolaStatCard(
              label: 'Alternando',
              value: '124',
              sub: 'Meta: 200',
              color: color,
              pct: .62),
        ]),
        const SizedBox(height: 16),
        _Card(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('PASSES EM 45S — recorde',
              style: TextStyle(
                  fontSize: 9,
                  color: ForgeColors.muted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(children: [
            Text('38',
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 48,
                    color: color,
                    letterSpacing: 0,
                    height: 1)),
            const SizedBox(width: 12),
            const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('passes',
                      style: TextStyle(fontSize: 12, color: ForgeColors.muted)),
                  Text('Meta: 50',
                      style:
                          TextStyle(fontSize: 11, color: ForgeColors.muted2)),
                ]),
          ]),
          const SizedBox(height: 8),
          _ProgressBar(value: .76, color: color),
        ])),
        _Card(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('SESSÕES NO CICLO',
              style: TextStyle(
                  fontSize: 9,
                  color: ForgeColors.muted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(children: [
            Text('12',
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 36,
                    color: color,
                    letterSpacing: 0)),
            const SizedBox(width: 8),
            const Text('sessões concluídas\nMeta: 2× por semana',
                style: TextStyle(fontSize: 11, color: ForgeColors.muted)),
          ]),
        ])),
      ],
    );
  }
}

class _BolaStatCard extends StatelessWidget {
  final String label, value, sub;
  final Color color;
  final double pct;
  const _BolaStatCard(
      {required this.label,
      required this.value,
      required this.sub,
      required this.color,
      required this.pct});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: color.withOpacity(.2)),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: color.withOpacity(.06), blurRadius: 12)],
        ),
        child: Column(children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 9,
                  color: ForgeColors.muted,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 36,
                  color: color,
                  letterSpacing: 0,
                  height: 1)),
          const SizedBox(height: 6),
          _ProgressBar(value: pct, color: color),
          const SizedBox(height: 4),
          Text(sub,
              style: const TextStyle(fontSize: 9, color: ForgeColors.muted2),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

// ── Drills: tabela compacta com comparativo
class _DrillsTab extends StatelessWidget {
  final ForgeTheme theme;
  const _DrillsTab({required this.theme});

  static const _records = [
    ('Ladder Speed', '12.4s', '13.1s', -5.3),
    ('Cone 5-10-5', '4.8s', '5.2s', -7.7),
    ('Box Jump', '8.2s', '8.9s', -7.9),
    ('Sprint 30m', '4.1s', '4.4s', -6.8),
    ('Agilidade 4×10m', '6.3s', '6.8s', -7.4),
  ];

  @override
  Widget build(BuildContext context) {
    const color = ForgeColors.drills;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        _Card(
            child: Column(children: [
          Row(children: const [
            Expanded(
                flex: 3,
                child: Text('CIRCUITO',
                    style: TextStyle(
                        fontSize: 9,
                        color: ForgeColors.muted,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1))),
            Expanded(
                flex: 2,
                child: Text('PR',
                    style: TextStyle(
                        fontSize: 9,
                        color: ForgeColors.muted,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1),
                    textAlign: TextAlign.center)),
            Expanded(
                flex: 2,
                child: Text('ANTERIOR',
                    style: TextStyle(
                        fontSize: 9,
                        color: ForgeColors.muted,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1),
                    textAlign: TextAlign.center)),
            Expanded(
                flex: 2,
                child: Text('DELTA',
                    style: TextStyle(
                        fontSize: 9,
                        color: ForgeColors.muted,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1),
                    textAlign: TextAlign.right)),
          ]),
          const SizedBox(height: 8),
          const Divider(color: ForgeColors.border, height: 1),
          ..._records.map((r) => Column(children: [
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                      flex: 3,
                      child: Text(r.$1,
                          style: const TextStyle(
                              fontSize: 12,
                              color: ForgeColors.text,
                              fontWeight: FontWeight.w500))),
                  Expanded(
                      flex: 2,
                      child: Text(r.$2,
                          style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 16,
                              color: color,
                              letterSpacing: 0),
                          textAlign: TextAlign.center)),
                  Expanded(
                      flex: 2,
                      child: Text(r.$3,
                          style: const TextStyle(
                              fontSize: 12, color: ForgeColors.muted),
                          textAlign: TextAlign.center)),
                  Expanded(
                      flex: 2,
                      child: Text('${r.$4.toStringAsFixed(1)}%',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF22c55e),
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.right)),
                ]),
                const SizedBox(height: 6),
                _ProgressBar(
                    value: (r.$4.abs() / 10).clamp(0, 1), color: color),
              ])),
        ])),
        _Card(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('SESSÕES NO CICLO',
              style: TextStyle(
                  fontSize: 9,
                  color: ForgeColors.muted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(children: [
            Text('18',
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 36,
                    color: color,
                    letterSpacing: 0)),
            const SizedBox(width: 8),
            const Text('sessões · Meta: 24',
                style: TextStyle(fontSize: 11, color: ForgeColors.muted)),
          ]),
          const SizedBox(height: 8),
          _ProgressBar(value: .75, color: color),
        ])),
      ],
    );
  }
}

// ── Mobilidade: frequência + streak
class _MobTab extends StatelessWidget {
  final ForgeTheme theme;
  const _MobTab({required this.theme});

  @override
  Widget build(BuildContext context) {
    const color = ForgeColors.mobilidade;
    const weeks = [
      ('S1', 3, 4),
      ('S2', 4, 4),
      ('S3', 2, 4),
      ('S4', 4, 4),
      ('S5', 3, 4),
      ('Esta', 3, 4),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        Row(children: [
          Expanded(
              child: _Card(
                  child: Column(children: [
            const Icon(Icons.self_improvement, color: color, size: 24),
            const SizedBox(height: 6),
            const Text('19',
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 40,
                    color: ForgeColors.text,
                    letterSpacing: 0,
                    height: 1)),
            const Text('sessões no ciclo',
                style: TextStyle(fontSize: 10, color: ForgeColors.muted)),
          ]))),
          const SizedBox(width: 8),
          Expanded(
              child: _Card(
                  child: Column(children: [
            const Icon(Icons.local_fire_department, color: color, size: 24),
            const SizedBox(height: 6),
            Text('5',
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 40,
                    color: color,
                    letterSpacing: 0,
                    height: 1)),
            const Text('streak atual',
                style: TextStyle(fontSize: 10, color: ForgeColors.muted)),
          ]))),
          const SizedBox(width: 8),
          Expanded(
              child: _Card(
                  child: Column(children: [
            const Icon(Icons.emoji_events, color: color, size: 24),
            const SizedBox(height: 6),
            const Text('8',
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 40,
                    color: ForgeColors.text,
                    letterSpacing: 0,
                    height: 1)),
            const Text('recorde streak',
                style: TextStyle(fontSize: 10, color: ForgeColors.muted)),
          ]))),
        ]),
        _Card(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('SESSÕES POR SEMANA',
              style: TextStyle(
                  fontSize: 9,
                  color: ForgeColors.muted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1)),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: weeks.map((w) {
                final isCurrent = w.$1 == 'Esta';
                final pct = w.$2 / w.$3;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${w.$2}/${w.$3}',
                              style: TextStyle(
                                  fontSize: 8,
                                  color:
                                      isCurrent ? color : ForgeColors.muted2)),
                          const SizedBox(height: 3),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: SizedBox(
                              height: 50,
                              child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(color: ForgeColors.border),
                                    FractionallySizedBox(
                                        heightFactor: pct,
                                        child: Container(
                                            color: color.withOpacity(
                                                isCurrent ? 1 : .5))),
                                  ]),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(w.$1,
                              style: TextStyle(
                                  fontSize: 9,
                                  color: isCurrent ? color : ForgeColors.muted2,
                                  fontWeight: isCurrent
                                      ? FontWeight.w600
                                      : FontWeight.normal)),
                        ]),
                  ),
                );
              }).toList(),
            ),
          ),
        ])),
        _Card(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('ROTINAS',
              style: TextStyle(
                  fontSize: 9,
                  color: ForgeColors.muted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1)),
          const SizedBox(height: 10),
          ...[
            ('Rotina A', 10, 'Membros Inf. · Lombar'),
            ('Rotina B', 9, 'Cervical · Tronco')
          ].map(
            (r) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(r.$1,
                            style: const TextStyle(
                                fontSize: 13,
                                color: ForgeColors.text,
                                fontWeight: FontWeight.w500)),
                        Text(r.$3,
                            style: const TextStyle(
                                fontSize: 10, color: ForgeColors.muted)),
                      ])),
                  Text('${r.$2}×',
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 22,
                          color: color,
                          letterSpacing: 0)),
                ])),
          ),
        ])),
      ],
    );
  }
}

// ── Gráfico de linha genérico
class _LinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  final bool invertY;
  const _LinePainter(
      {required this.values, required this.color, this.invertY = false});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = max - min == 0 ? 1.0 : max - min;

    List<Offset> points = values.asMap().entries.map((e) {
      final x = e.key / (values.length - 1) * size.width;
      final norm = (e.value - min) / range;
      final y = invertY ? norm * size.height : (1 - norm) * size.height;
      return Offset(x, y);
    }).toList();

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) path.lineTo(p.dx, p.dy);

    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
        fill,
        Paint()
          ..color = color.withOpacity(.12)
          ..style = PaintingStyle.fill);
    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round);
    canvas.drawCircle(points.last, 3.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Macro + Semanal (mantidos na tab Musculação)
class _MacroCycleCard extends StatelessWidget {
  final ForgeTheme theme;
  const _MacroCycleCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/macro'),
      child: _Card(
          child: Column(children: [
        Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _SLabel('Ciclo Base · Fase 1'),
            const Text('Semana 3 de 8',
                style: TextStyle(
                    fontSize: 14,
                    color: ForgeColors.text,
                    fontWeight: FontWeight.w500)),
          ]),
          const Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('14/24',
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 24,
                    color: theme.accent,
                    letterSpacing: 0)),
            const Text('sessões',
                style: TextStyle(fontSize: 10, color: ForgeColors.muted)),
          ]),
        ]),
        const SizedBox(height: 8),
        _ProgressBar(value: .36, color: theme.accent),
        const SizedBox(height: 12),
        ...[
          ('2× Bola/semana', .75),
          ('8km pace 5:30', .40),
          ('Supino 100kg', .87)
        ].map(
          (g) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(g.$1,
                          style: const TextStyle(
                              fontSize: 11, color: ForgeColors.muted)),
                      Text('${(g.$2 * 100).round()}%',
                          style: TextStyle(
                              fontSize: 11,
                              color: theme.accent,
                              fontWeight: FontWeight.w600)),
                    ]),
                const SizedBox(height: 3),
                _ProgressBar(
                    value: g.$2,
                    color: g.$2 >= 1 ? const Color(0xFF22c55e) : theme.accent,
                    height: 2),
              ])),
        ),
      ])),
    );
  }
}

class _PhaseCompareCard extends StatelessWidget {
  final ForgeTheme theme;
  const _PhaseCompareCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return _Card(
        child: Column(children: [
      const Text('Volume semanal médio (kg)',
          style: TextStyle(fontSize: 12, color: ForgeColors.muted)),
      const SizedBox(height: 12),
      SizedBox(
          height: 70,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          color: ForgeColors.muted3,
                          borderRadius: BorderRadius.circular(6)))),
              const SizedBox(height: 4),
              const Text('Fase 1',
                  style: TextStyle(fontSize: 10, color: ForgeColors.muted)),
              const Text('18.400 kg',
                  style: TextStyle(fontSize: 9, color: ForgeColors.muted2)),
            ])),
            const SizedBox(width: 12),
            Expanded(
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              SizedBox(
                  height: 30,
                  child: Container(
                      decoration: BoxDecoration(
                          color: ForgeColors.muted3.withOpacity(.3),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: ForgeColors.muted3)))),
              const SizedBox(height: 4),
              const Text('Fase 2',
                  style: TextStyle(fontSize: 10, color: ForgeColors.muted2)),
              const Text('Pendente',
                  style: TextStyle(fontSize: 9, color: ForgeColors.muted2)),
            ])),
          ])),
      const SizedBox(height: 8),
      const Divider(color: ForgeColors.border, height: 1),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(
            child: Column(children: [
          const Text('4.2',
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 18,
                  color: ForgeColors.text,
                  letterSpacing: 0)),
          const Text('sessões/sem.',
              style: TextStyle(fontSize: 9, color: ForgeColors.muted))
        ])),
        Container(width: 1, height: 32, color: ForgeColors.border),
        Expanded(
            child: Column(children: [
          const Text('3',
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 18,
                  color: ForgeColors.text,
                  letterSpacing: 0)),
          const Text('PRs atingidos',
              style: TextStyle(fontSize: 9, color: ForgeColors.muted))
        ])),
        Container(width: 1, height: 32, color: ForgeColors.border),
        Expanded(
            child: Column(children: [
          Text('87%',
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 18,
                  color: theme.accent,
                  letterSpacing: 0)),
          const Text('aderência',
              style: TextStyle(fontSize: 9, color: ForgeColors.muted))
        ])),
      ]),
    ]));
  }
}

class _WeeklyChart extends StatelessWidget {
  final _weeks = const [
    [18.0, 12.0, 10.0, 4.0, 8.0],
    [24.0, 18.0, 14.0, 0.0, 6.0],
    [14.0, 10.0, 18.0, 8.0, 10.0],
    [28.0, 22.0, 14.0, 6.0, 12.0],
    [22.0, 22.0, 10.0, 12.0, 8.0],
    [32.0, 18.0, 14.0, 8.0, 10.0],
  ];

  static const _colors = [
    ForgeColors.musculacao,
    ForgeColors.drills,
    ForgeColors.mobilidade,
    ForgeColors.corrida,
    ForgeColors.bola,
  ];

  static const _labels = ['Musc.', 'Drills', 'Mob.', 'Corrida', 'Bola'];

  @override
  Widget build(BuildContext context) {
    return _Card(
        child: Column(children: [
      LayoutBuilder(builder: (_, constraints) {
        final maxTotal = _weeks
            .map((w) => w.reduce((a, b) => a + b))
            .reduce((a, b) => a > b ? a : b);
        return SizedBox(
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _weeks.asMap().entries.map((e) {
              final isCurrent = e.key == _weeks.length - 1;
              final w = e.value;
              final total = w.reduce((a, b) => a + b);
              final barH = (total / maxTotal) * 70;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: barH,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: w.asMap().entries.map((s) {
                              final segH = (s.value / total) * barH;
                              return Container(
                                height: segH,
                                decoration: BoxDecoration(
                                  color: _colors[s.key]
                                      .withOpacity(isCurrent ? 1 : .55),
                                  borderRadius: s.key == 0
                                      ? const BorderRadius.vertical(
                                          top: Radius.circular(3))
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(isCurrent ? 'Esta' : 'S${e.key + 1}',
                            style: TextStyle(
                                fontSize: 9,
                                color: isCurrent
                                    ? const Color(0xFF00e5c8)
                                    : ForgeColors.muted2,
                                fontWeight: isCurrent
                                    ? FontWeight.w600
                                    : FontWeight.normal)),
                      ]),
                ),
              );
            }).toList(),
          ),
        );
      }),
      const SizedBox(height: 10),
      const Divider(color: ForgeColors.border, height: 1),
      const SizedBox(height: 8),
      Wrap(
        spacing: 10,
        runSpacing: 4,
        children: _colors
            .asMap()
            .entries
            .map((e) => Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                          color: e.value,
                          borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 4),
                  Text(_labels[e.key],
                      style: const TextStyle(
                          fontSize: 9, color: ForgeColors.muted)),
                ]))
            .toList(),
      ),
    ]));
  }
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

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: ForgeColors.card,
            border: Border.all(color: ForgeColors.border),
            borderRadius: BorderRadius.circular(14)),
        child: child,
      );
}

class _ProgressBar extends StatelessWidget {
  final double value, height;
  final Color color;
  const _ProgressBar(
      {required this.value, required this.color, this.height = 4});
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: height,
            backgroundColor: ForgeColors.border,
            valueColor: AlwaysStoppedAnimation(color)),
      );
}
