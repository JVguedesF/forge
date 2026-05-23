import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});
  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  int? _selectedDay;
  String _filter = 'Todos';

  final _trainedDays = const {
    1: ['musculacao'],
    2: ['mobilidade'],
    4: ['corrida'],
    5: ['drills', 'mobilidade'],
    7: ['musculacao'],
    9: ['bola'],
    10: ['mobilidade'],
    12: ['musculacao', 'corrida'],
    14: ['drills'],
    15: ['mobilidade'],
    16: ['musculacao'],
    18: ['corrida'],
    19: ['drills', 'bola'],
    20: ['musculacao', 'mobilidade'],
    21: ['musculacao'],
  };

  final _catColors = const {
    'musculacao': ForgeColors.musculacao,
    'corrida': ForgeColors.corrida,
    'drills': ForgeColors.drills,
    'bola': ForgeColors.bola,
    'mobilidade': ForgeColors.mobilidade,
  };

  final _catIcons = {
    'musculacao': LucideIcons.dumbbell,
    'corrida': LucideIcons.activity,
    'drills': LucideIcons.zap,
    'bola': LucideIcons.target,
    'mobilidade': LucideIcons.leaf,
  };

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Histórico',
                  style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 38,
                      color: ForgeColors.text)),
              const SizedBox(height: 14),
              _MonthStats(theme: theme),
              const SizedBox(height: 16),
              _SLabel('Maio 2025'),
              _Calendar(
                  trainedDays: _trainedDays,
                  catColors: _catColors,
                  selectedDay: _selectedDay,
                  accent: theme.accent,
                  onDayTap: (d) => setState(
                      () => _selectedDay = _selectedDay == d ? null : d)),
              const SizedBox(height: 16),
              _FilterRow(
                  selected: _filter,
                  accent: theme.accent,
                  onSelect: (f) => setState(() => _filter = f)),
              const SizedBox(height: 14),
              _HistoryList(catColors: _catColors, catIcons: _catIcons),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthStats extends StatelessWidget {
  final ForgeTheme theme;
  const _MonthStats({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Card(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const _SLabel('Este mês'),
                const SizedBox(height: 3),
                const Text('18 sessões',
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 26,
                        color: ForgeColors.text,
                        letterSpacing: 0)),
                const Text('14h 32min',
                    style: TextStyle(fontSize: 11, color: ForgeColors.muted)),
              ])),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Card(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const _SLabel('Streak'),
                const SizedBox(height: 3),
                Row(children: [
                  const Icon(LucideIcons.flame,
                      color: Color(0xFF00e5c8), size: 20),
                  const SizedBox(width: 6),
                  Text('7 dias',
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 26,
                          color: theme.accent,
                          letterSpacing: 0)),
                ]),
                const Text('Recorde: 14 dias',
                    style: TextStyle(fontSize: 11, color: ForgeColors.muted)),
              ])),
        ),
      ],
    );
  }
}

class _Calendar extends StatelessWidget {
  final Map<int, List<String>> trainedDays;
  final Map<String, Color> catColors;
  final int? selectedDay;
  final Color accent;
  final void Function(int) onDayTap;
  const _Calendar(
      {required this.trainedDays,
      required this.catColors,
      required this.selectedDay,
      required this.accent,
      required this.onDayTap});

  @override
  Widget build(BuildContext context) {
    const dayLabels = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
    final firstWeekday = DateTime(2025, 5, 1).weekday % 7;

    return _Card(
      child: Column(
        children: [
          Row(
              children: dayLabels
                  .map((d) => Expanded(
                      child: Center(
                          child: Text(d,
                              style: const TextStyle(
                                  fontSize: 9,
                                  color: ForgeColors.muted2,
                                  fontWeight: FontWeight.w600)))))
                  .toList()),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                childAspectRatio: 1),
            itemCount: firstWeekday + 31,
            itemBuilder: (_, i) {
              if (i < firstWeekday) return const SizedBox.shrink();
              final day = i - firstWeekday + 1;
              final isToday = day == 21;
              final isSelected = selectedDay == day;
              final cats = trainedDays[day] ?? [];
              return GestureDetector(
                onTap: () => onDayTap(day),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accent.withOpacity(.2)
                        : isToday
                            ? accent.withOpacity(.12)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(7),
                    border: (isToday || isSelected)
                        ? Border.all(color: accent.withOpacity(.3))
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$day',
                          style: TextStyle(
                              fontSize: 10,
                              color: isToday || isSelected
                                  ? accent
                                  : cats.isNotEmpty
                                      ? ForgeColors.text
                                      : const Color(0xFF444444),
                              fontWeight: isToday
                                  ? FontWeight.w600
                                  : FontWeight.normal)),
                      if (cats.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Wrap(
                            spacing: 1,
                            children: cats
                                .map((c) => Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                        color: catColors[c],
                                        shape: BoxShape.circle)))
                                .toList()),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final String selected;
  final Color accent;
  final void Function(String) onSelect;
  const _FilterRow(
      {required this.selected, required this.accent, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final filters = ['Todos', 'Musculação', 'Corrida', 'Mobilidade'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final active = f == selected;
          return GestureDetector(
            onTap: () => onSelect(f),
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
              decoration: BoxDecoration(
                color: ForgeColors.card,
                border: Border.all(color: active ? accent : ForgeColors.border),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(f,
                  style: TextStyle(
                      fontSize: 11,
                      color: active ? accent : ForgeColors.muted,
                      fontWeight:
                          active ? FontWeight.w600 : FontWeight.normal)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final Map<String, Color> catColors;
  final Map<String, IconData> catIcons;
  const _HistoryList({required this.catColors, required this.catIcons});

  @override
  Widget build(BuildContext context) {
    final sessions = [
      ('Hoje', 'musculacao', 'Upper A', '52 min · 09:15', '6.240 kg', '💪'),
      ('Ontem', 'drills', 'Drills Iniciante', '41 min · 18:30', '', '💪'),
      (
        'Ontem',
        'mobilidade',
        'Mobilidade Rotina A',
        '29 min · 07:00',
        '',
        '🔥'
      ),
      ('19 mai', 'musculacao', 'Lower A', '58 min · 17:00', '7.200 kg', '😊'),
      ('19 mai', 'bola', 'Bola Intermediário', '50 min · 08:30', '', '😊'),
      ('18 mai', 'corrida', 'Corrida Longa', '42 min · 07:00', '8.2 km', '🔥'),
    ];

    String? lastDate;
    final widgets = <Widget>[];
    for (final s in sessions) {
      if (s.$1 != lastDate) {
        if (lastDate != null) widgets.add(const SizedBox(height: 4));
        widgets.add(Padding(
            padding: const EdgeInsets.only(bottom: 8), child: _SLabel(s.$1)));
        lastDate = s.$1;
      }
      final color = catColors[s.$2] ?? ForgeColors.muted;
      final icon = catIcons[s.$2] ?? LucideIcons.activity;
      widgets.add(Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
            color: ForgeColors.card,
            border: Border.all(color: ForgeColors.border),
            borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 18)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(s.$3,
                    style: const TextStyle(
                        fontSize: 13,
                        color: ForgeColors.text,
                        fontWeight: FontWeight.w500)),
                Text(s.$4,
                    style: const TextStyle(
                        fontSize: 11, color: ForgeColors.muted)),
              ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            if (s.$5.isNotEmpty)
              Text(s.$5,
                  style: TextStyle(
                      fontSize: 12, color: color, fontWeight: FontWeight.w600)),
            Text(s.$6, style: const TextStyle(fontSize: 16)),
          ]),
        ]),
      ));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }
}

class _SLabel extends StatelessWidget {
  final String text;
  const _SLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
      style: const TextStyle(
          fontSize: 9,
          color: ForgeColors.muted,
          letterSpacing: 2,
          fontWeight: FontWeight.w600));
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
