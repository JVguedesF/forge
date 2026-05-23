import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(theme: theme),
              const SizedBox(height: 16),
              _MacroCard(theme: theme),
              const SizedBox(height: 16),
              _SectionLabel('Treinos de hoje'),
              _WorkoutTodayCard(
                type: 'Musculação',
                name: 'Upper A',
                subtitle: '~55 min · 6 exercícios',
                color: ForgeColors.musculacao,
                colorLight: ForgeColors.musculacaoLight,
                icon: LucideIcons.dumbbell,
                onTap: () => context.push('/session?mode=musculacao'),
              ),
              const SizedBox(height: 10),
              _WorkoutTodayCard(
                type: 'Mobilidade',
                name: 'Rotina A',
                subtitle: '~30 min · Escoliose',
                color: ForgeColors.mobilidade,
                colorLight: ForgeColors.mobilidadeLight,
                icon: LucideIcons.leaf,
                onTap: () => context.push('/session?mode=timed'),
              ),
              const SizedBox(height: 16),
              _StatsRow(),
              const SizedBox(height: 16),
              _SectionLabel('Próximos dias'),
              _NextDaysCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  final ForgeTheme theme;
  const _Header({required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Label('Boa tarde'),
            const SizedBox(height: 2),
            const Text('Atleta',
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 52,
                    height: .9,
                    color: ForgeColors.text)),
            const SizedBox(height: 3),
            Text(_todayLabel(),
                style: const TextStyle(fontSize: 11, color: ForgeColors.muted)),
          ],
        ),
        const Spacer(),
        const SizedBox(height: 8),
        _IconBtn(
            icon: LucideIcons.settings, onTap: () => context.push('/settings')),
      ],
    );
  }

  String _todayLabel() {
    final now = DateTime.now();
    const dias = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo'
    ];
    const meses = [
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
    return '${dias[now.weekday - 1]} · ${now.day} de ${meses[now.month - 1]}';
  }
}

class _MacroCard extends StatelessWidget {
  final ForgeTheme theme;
  const _MacroCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/macro'),
      child: _Card(
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Label('Ciclo Base · Fase 1'),
                    const SizedBox(height: 2),
                    const Text('Semana 3 de 8',
                        style: TextStyle(
                            fontSize: 14,
                            color: ForgeColors.text,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Sessões',
                        style:
                            TextStyle(fontSize: 9, color: ForgeColors.muted)),
                    Text('14/24',
                        style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 24,
                            color: theme.accent,
                            letterSpacing: 0)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            _ProgressBar(value: .36, color: theme.accent),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('24 sessões para Fase 2',
                    style: TextStyle(fontSize: 10, color: ForgeColors.muted)),
                Text('36%',
                    style: TextStyle(
                        fontSize: 10,
                        color: theme.accent,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutTodayCard extends StatelessWidget {
  final String type, name, subtitle;
  final Color color, colorLight;
  final IconData icon;
  final VoidCallback onTap;
  const _WorkoutTodayCard(
      {required this.type,
      required this.name,
      required this.subtitle,
      required this.color,
      required this.colorLight,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: color.withOpacity(.22)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
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
                  Text(type.toUpperCase(),
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
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11, color: ForgeColors.muted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                  color: color.withOpacity(.14),
                  borderRadius: BorderRadius.circular(9)),
              child: Text('INICIAR',
                  style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 14,
                      color: colorLight)),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
            icon: LucideIcons.flame,
            iconColor: const Color(0xFF00e5c8),
            value: '7',
            label: 'streak'),
        const SizedBox(width: 8),
        _StatCard(icon: LucideIcons.layers, value: '4', label: 'semana'),
        const SizedBox(width: 8),
        _StatCard(icon: LucideIcons.clock, value: '38', label: 'horas'),
      ],
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
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        decoration: BoxDecoration(
            color: ForgeColors.card,
            border: Border.all(color: ForgeColors.border),
            borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
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
          ],
        ),
      ),
    );
  }
}

class _NextDaysCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final days = [
      _DayData('Qui', [ForgeColors.musculacao, ForgeColors.mobilidade],
          ['Lower A', 'Mob B']),
      _DayData('Sex', [ForgeColors.drills, ForgeColors.corrida],
          ['Drills', 'Corrida']),
      _DayData('Sáb', [const Color(0xFFf59e0b)], ['Upper B']),
    ];
    return Container(
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: days.asMap().entries.map((e) {
          final last = e.key == days.length - 1;
          return Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border(
                      right: last
                          ? BorderSide.none
                          : const BorderSide(color: ForgeColors.border))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Label(e.value.day),
                  const SizedBox(height: 6),
                  Row(
                      children: e.value.colors
                          .map((c) => Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                  color: c, shape: BoxShape.circle)))
                          .toList()),
                  const SizedBox(height: 5),
                  ...e.value.names.asMap().entries.map((n) => Text(n.value,
                      style: TextStyle(
                          fontSize: 10,
                          color: n.key == 0
                              ? ForgeColors.text
                              : ForgeColors.muted))),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DayData {
  final String day;
  final List<Color> colors;
  final List<String> names;
  const _DayData(this.day, this.colors, this.names);
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _Label(text),
      );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
            fontSize: 9,
            color: ForgeColors.muted,
            letterSpacing: 2,
            fontWeight: FontWeight.w600),
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
