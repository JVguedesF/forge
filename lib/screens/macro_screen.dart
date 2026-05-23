import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';

class MacroScreen extends ConsumerStatefulWidget {
  const MacroScreen({super.key});
  @override
  ConsumerState<MacroScreen> createState() => _MacroScreenState();
}

class _MacroScreenState extends ConsumerState<MacroScreen> {
  final Set<int> _deload = {3, 7};

  final _schedule = [
    (
      'Seg',
      [('Upper A', ForgeColors.musculacao), ('Mob A', ForgeColors.mobilidade)]
    ),
    ('Ter', [('Lower A', ForgeColors.corrida)]),
    ('Qua', [('Drills', ForgeColors.drills), ('Corrida', ForgeColors.corrida)]),
    (
      'Qui',
      [('Upper B', Color(0xFFf59e0b)), ('Mob B', ForgeColors.mobilidade)]
    ),
    ('Sex', [('Bola', ForgeColors.bola), ('Lower B', ForgeColors.corrida)]),
    ('Sáb', [('Corrida Longa', ForgeColors.corrida)]),
    ('Dom', [('Descanso', ForgeColors.muted2)]),
  ];

  final _adherence = [
    ('Semana 3', 5, 6, 83),
    ('Semana 2', 6, 6, 100),
    ('Semana 1', 5, 6, 83),
  ];

  final _muscles = [
    ('Peito', 3, 4, ForgeColors.musculacao),
    ('Costas', 3, 4, ForgeColors.musculacao),
    ('Pernas', 2, 4, ForgeColors.corrida),
    ('Ombros', 2, 4, ForgeColors.drills),
    ('Bíceps', 2, 4, ForgeColors.mobilidade),
    ('Tríceps', 3, 4, ForgeColors.mobilidade),
    ('Core', 4, 4, ForgeColors.bola),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(theme: theme, onBack: () => context.pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SLabel('Nome do ciclo'),
                    _Field('Ciclo Base 2025'),
                    const SizedBox(height: 4),
                    const _SLabel('Fases'),
                    _PhaseCard(
                        name: 'Fase 1 — Base',
                        sub: '8 semanas · 24 sessões · 65–75% 1RM',
                        color: const Color(0xFF22c55e),
                        active: true),
                    const SizedBox(height: 8),
                    _PhaseCard(
                        name: 'Fase 2 — Intensidade',
                        sub: '6 semanas · 20 sessões · 75–85% 1RM',
                        color: const Color(0xFFf59e0b),
                        active: false),
                    const SizedBox(height: 8),
                    _AddPhaseBtn(),
                    const SizedBox(height: 4),
                    const _SLabel('Rotina semanal — Fase 1'),
                    ..._schedule.map(
                        (d) => _DayRow(day: d.$1, items: d.$2, theme: theme)),
                    const SizedBox(height: 8),
                    const _SLabel('Semanas de Deload'),
                    _DeloadGrid(
                        total: 8,
                        deload: _deload,
                        onToggle: (i) => setState(() => _deload.contains(i)
                            ? _deload.remove(i)
                            : _deload.add(i))),
                    const SizedBox(height: 16),
                    const _SLabel('Aderência — semanas recentes'),
                    ..._adherence.map((a) => _AdherenceRow(
                        week: a.$1, done: a.$2, total: a.$3, pct: a.$4)),
                    const SizedBox(height: 8),
                    const _SLabel('Balanço muscular semanal'),
                    _MuscleBalance(muscles: _muscles),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final ForgeTheme theme;
  final VoidCallback onBack;
  const _AppBar({required this.theme, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Row(
        children: [
          _XBtn(onTap: onBack, icon: LucideIcons.arrow_left),
          const SizedBox(width: 12),
          const Expanded(
              child: Text('Macrociclo',
                  style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 22,
                      color: ForgeColors.text))),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                  color: theme.accent, borderRadius: BorderRadius.circular(10)),
              child: Text('SALVAR',
                  style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 16,
                      color:
                          theme.id == 'neon' ? Colors.black : ForgeColors.bg)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhaseCard extends StatelessWidget {
  final String name, sub;
  final Color color;
  final bool active;
  const _PhaseCard(
      {required this.name,
      required this.sub,
      required this.color,
      required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ForgeColors.card,
        border: Border.all(
            color: active ? color.withOpacity(.3) : ForgeColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
              width: 4,
              height: 44,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(name,
                      style: const TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 18,
                          color: ForgeColors.text)),
                  if (active) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: color.withOpacity(.15),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text('ATIVA',
                          style: TextStyle(
                              fontSize: 9,
                              color: color,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ]),
                Text(sub,
                    style: const TextStyle(
                        fontSize: 11, color: ForgeColors.muted)),
              ],
            ),
          ),
          Icon(LucideIcons.chevron_right, color: ForgeColors.muted2, size: 16),
        ],
      ),
    );
  }
}

class _AddPhaseBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ForgeColors.card,
        border: Border.all(color: ForgeColors.border, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(LucideIcons.plus, color: ForgeColors.muted, size: 16),
        const SizedBox(width: 8),
        const Text('Adicionar fase',
            style: TextStyle(fontSize: 13, color: ForgeColors.muted)),
      ]),
    );
  }
}

class _DayRow extends StatelessWidget {
  final String day;
  final List<(String, Color)> items;
  final ForgeTheme theme;
  const _DayRow({required this.day, required this.items, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          SizedBox(
              width: 32,
              child: Text(day,
                  style: const TextStyle(
                      fontSize: 13,
                      color: ForgeColors.text,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center)),
          const SizedBox(width: 10),
          Expanded(
            child: Wrap(
              spacing: 5,
              runSpacing: 4,
              children: items
                  .map((w) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                            color: w.$2.withOpacity(.1),
                            border: Border.all(color: w.$2.withOpacity(.35)),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(w.$1,
                            style: TextStyle(
                                fontSize: 11,
                                color: w.$2,
                                fontWeight: FontWeight.w500)),
                      ))
                  .toList(),
            ),
          ),
          Icon(LucideIcons.plus, color: ForgeColors.muted2, size: 13),
        ],
      ),
    );
  }
}

class _DeloadGrid extends StatelessWidget {
  final int total;
  final Set<int> deload;
  final void Function(int) onToggle;
  const _DeloadGrid(
      {required this.total, required this.deload, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Marque as semanas com volume reduzido',
              style: TextStyle(fontSize: 12, color: ForgeColors.muted)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: total,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            children: List.generate(total, (i) {
              final isDeload = deload.contains(i);
              return GestureDetector(
                onTap: () => onToggle(i),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDeload
                        ? ForgeColors.corrida.withOpacity(.15)
                        : ForgeColors.card,
                    border: Border.all(
                        color: isDeload
                            ? ForgeColors.corrida
                            : ForgeColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text('S${i + 1}',
                        style: TextStyle(
                            fontSize: 12,
                            color: isDeload
                                ? ForgeColors.corrida
                                : ForgeColors.muted,
                            fontWeight: isDeload
                                ? FontWeight.w600
                                : FontWeight.normal)),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
              '${deload.map((i) => "S${i + 1}").join(" e ")} marcadas como deload',
              style: const TextStyle(fontSize: 10, color: ForgeColors.muted)),
        ],
      ),
    );
  }
}

class _AdherenceRow extends StatelessWidget {
  final String week;
  final int done, total, pct;
  const _AdherenceRow(
      {required this.week,
      required this.done,
      required this.total,
      required this.pct});

  @override
  Widget build(BuildContext context) {
    final color = pct == 100
        ? const Color(0xFF22c55e)
        : pct >= 80
            ? const Color(0xFF00e5c8)
            : const Color(0xFFf59e0b);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(
              child: Text(week,
                  style:
                      const TextStyle(fontSize: 12, color: ForgeColors.text))),
          Text('$done/$total treinos',
              style: const TextStyle(fontSize: 12, color: ForgeColors.muted)),
          const SizedBox(width: 8),
          Text('$pct%',
              style: TextStyle(
                  fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MuscleBalance extends StatelessWidget {
  final List<(String, int, int, Color)> muscles;
  const _MuscleBalance({required this.muscles});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Treinos por semana (rotina atual)',
              style: TextStyle(fontSize: 12, color: ForgeColors.muted)),
          const SizedBox(height: 12),
          ...muscles.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    SizedBox(
                        width: 52,
                        child: Text(m.$1,
                            style: const TextStyle(
                                fontSize: 11, color: ForgeColors.muted))),
                    Expanded(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: m.$2 / m.$3,
                        minHeight: 6,
                        backgroundColor: ForgeColors.border,
                        valueColor: AlwaysStoppedAnimation(m.$4),
                      ),
                    )),
                    const SizedBox(width: 8),
                    SizedBox(
                        width: 20,
                        child: Text('${m.$2}×',
                            style: TextStyle(
                                fontSize: 11,
                                color: m.$4,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.right)),
                  ],
                ),
              )),
          const SizedBox(height: 4),
          const Text('⚠ Pernas com menor frequência — considere equilibrar',
              style: TextStyle(fontSize: 10, color: Color(0xFFf59e0b))),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String value;
  const _Field(this.value);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: ForgeColors.card,
            border: Border.all(color: ForgeColors.border),
            borderRadius: BorderRadius.circular(12)),
        child: Text(value,
            style: const TextStyle(fontSize: 15, color: ForgeColors.text)),
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
