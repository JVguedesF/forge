import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';

class WorkoutBuilderScreen extends ConsumerStatefulWidget {
  const WorkoutBuilderScreen({super.key});
  @override
  ConsumerState<WorkoutBuilderScreen> createState() =>
      _WorkoutBuilderScreenState();
}

class _WorkoutBuilderScreenState extends ConsumerState<WorkoutBuilderScreen> {
  String _selectedType = 'musculacao';
  final Set<String> _selectedTags = {'Composto', 'Isolado'};

  final _types = [
    (
      'musculacao',
      'Musculação',
      ForgeColors.musculacao,
      ForgeColors.musculacaoLight,
      LucideIcons.dumbbell
    ),
    (
      'corrida',
      'Corrida',
      ForgeColors.corrida,
      ForgeColors.corridaLight,
      LucideIcons.activity
    ),
    (
      'drills',
      'Drills',
      ForgeColors.drills,
      ForgeColors.drillsLight,
      LucideIcons.zap
    ),
    (
      'bola',
      'Bola',
      ForgeColors.bola,
      ForgeColors.bolaLight,
      LucideIcons.target
    ),
    (
      'mobilidade',
      'Mobilidade',
      ForgeColors.mobilidade,
      ForgeColors.mobilidadeLight,
      LucideIcons.leaf
    ),
    (
      'custom',
      'Custom',
      ForgeColors.muted,
      ForgeColors.muted,
      LucideIcons.sparkles
    ),
  ];

  final _allTags = [
    'Composto',
    'Isolado',
    'Core',
    'Potência',
    'Unilateral',
    'Explosão'
  ];

  final _blocks = [
    _BlockData(
        isCircuit: false,
        name: 'Supino Reto',
        sub: '4×8-10 reps · 90s desc. · 80 kg'),
    _BlockData(
        isCircuit: false,
        name: 'Supino Inclinado',
        sub: '3×10-12 reps · 75s desc.'),
    _BlockData(
        isCircuit: true,
        name: 'Super-set 1',
        sub: '3 voltas · 120s',
        exercises: ['Crucifixo × 12 reps', 'Voador × 15 reps']),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final selType = _types.firstWhere((t) => t.$1 == _selectedType);

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(theme: theme, onClose: () => context.pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SLabel('Nome'),
                    const _Field('Upper A'),
                    const _SLabel('Tipo'),
                    _TypeGrid(
                        types: _types,
                        selected: _selectedType,
                        onSelect: (t) => setState(() => _selectedType = t)),
                    const SizedBox(height: 20),
                    Row(children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const _SLabel('Cor'),
                            _PickerRow(
                                child: Row(children: [
                              Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                      color: selType.$3,
                                      shape: BoxShape.circle)),
                              const SizedBox(width: 10),
                              const Text('Alterar',
                                  style: TextStyle(
                                      fontSize: 13, color: ForgeColors.muted)),
                              const Spacer(),
                              Icon(LucideIcons.chevron_right,
                                  color: ForgeColors.muted2, size: 14),
                            ])),
                          ])),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const _SLabel('Ícone'),
                            _PickerRow(
                                child: Row(children: [
                              Icon(selType.$5, color: selType.$3, size: 22),
                              const SizedBox(width: 10),
                              const Text('Alterar',
                                  style: TextStyle(
                                      fontSize: 13, color: ForgeColors.muted)),
                              const Spacer(),
                              Icon(LucideIcons.chevron_right,
                                  color: ForgeColors.muted2, size: 14),
                            ])),
                          ])),
                    ]),
                    const SizedBox(height: 20),
                    const _SLabel('Tags'),
                    _TagsRow(
                        all: _allTags,
                        selected: _selectedTags,
                        accent: theme.accent,
                        onToggle: (t) => setState(() =>
                            _selectedTags.contains(t)
                                ? _selectedTags.remove(t)
                                : _selectedTags.add(t))),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _SLabel('Exercícios'),
                          Text('~55 min',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: theme.accent,
                                  fontWeight: FontWeight.w600)),
                        ]),
                    ..._blocks.map((b) => b.isCircuit
                        ? _CircuitBlock(block: b, accent: theme.accent)
                        : _ExerciseBlock(block: b)),
                    const SizedBox(height: 4),
                    _AddButtons(accent: theme.accent),
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

class _BlockData {
  final bool isCircuit;
  final String name, sub;
  final List<String> exercises;
  const _BlockData(
      {required this.isCircuit,
      required this.name,
      required this.sub,
      this.exercises = const []});
}

class _AppBar extends StatelessWidget {
  final ForgeTheme theme;
  final VoidCallback onClose;
  const _AppBar({required this.theme, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Row(
        children: [
          _XBtn(onTap: onClose, icon: LucideIcons.x),
          const SizedBox(width: 12),
          const Expanded(
              child: Text('Novo Treino',
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

class _TypeGrid extends StatelessWidget {
  final List<(String, String, Color, Color, IconData)> types;
  final String selected;
  final void Function(String) onSelect;
  const _TypeGrid(
      {required this.types, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 2.4,
      children: types.map((t) {
        final active = t.$1 == selected;
        return GestureDetector(
          onTap: () => onSelect(t.$1),
          child: Container(
            decoration: BoxDecoration(
              color: active ? t.$3.withOpacity(.14) : ForgeColors.card,
              border: Border.all(color: active ? t.$3 : ForgeColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(t.$5, color: active ? t.$4 : ForgeColors.muted, size: 13),
              const SizedBox(width: 4),
              Text(t.$2,
                  style: TextStyle(
                      fontSize: 11,
                      color: active ? t.$4 : ForgeColors.muted,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
        );
      }).toList(),
    );
  }
}

class _TagsRow extends StatelessWidget {
  final List<String> all;
  final Set<String> selected;
  final Color accent;
  final void Function(String) onToggle;
  const _TagsRow(
      {required this.all,
      required this.selected,
      required this.accent,
      required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: all.map((t) {
        final active = selected.contains(t);
        return GestureDetector(
          onTap: () => onToggle(t),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: active ? accent.withOpacity(.12) : ForgeColors.card,
              border: Border.all(color: active ? accent : ForgeColors.border),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(t,
                style: TextStyle(
                    fontSize: 11,
                    color: active ? accent : ForgeColors.muted,
                    fontWeight: FontWeight.w500)),
          ),
        );
      }).toList(),
    );
  }
}

class _ExerciseBlock extends StatelessWidget {
  final _BlockData block;
  const _ExerciseBlock({required this.block});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          const Text('⋮⋮',
              style: TextStyle(color: ForgeColors.muted2, fontSize: 13)),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(block.name,
                    style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 18,
                        color: ForgeColors.text)),
                Text(block.sub,
                    style: const TextStyle(
                        fontSize: 11, color: ForgeColors.muted)),
              ])),
          Icon(LucideIcons.sliders_horizontal,
              color: ForgeColors.muted2, size: 15),
        ],
      ),
    );
  }
}

class _CircuitBlock extends StatelessWidget {
  final _BlockData block;
  final Color accent;
  const _CircuitBlock({required this.block, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: ForgeColors.card,
        border: Border.all(color: accent.withOpacity(.22)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const Text('⋮⋮',
                    style: TextStyle(color: ForgeColors.muted2, fontSize: 13)),
                const SizedBox(width: 8),
                Container(
                    width: 6,
                    height: 6,
                    decoration:
                        BoxDecoration(color: accent, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(block.name,
                        style: TextStyle(
                            fontSize: 12,
                            color: accent,
                            fontWeight: FontWeight.w600))),
                Text(block.sub,
                    style: const TextStyle(
                        fontSize: 10, color: ForgeColors.muted)),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: ForgeColors.border))),
            child: Column(
              children: [
                ...block.exercises.asMap().entries.map((e) => Container(
                      padding: const EdgeInsets.fromLTRB(36, 9, 16, 9),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: e.key < block.exercises.length - 1
                                ? const BorderSide(color: ForgeColors.border)
                                : BorderSide.none),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(e.value,
                                  style: const TextStyle(
                                      fontSize: 12, color: ForgeColors.text))),
                          Icon(LucideIcons.sliders_horizontal,
                              color: ForgeColors.muted2, size: 13),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: ForgeColors.surface,
                      border: Border.all(color: accent.withOpacity(.18)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.plus, color: accent, size: 13),
                          const SizedBox(width: 5),
                          Text('Adicionar exercício',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: accent,
                                  fontWeight: FontWeight.w500)),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButtons extends StatelessWidget {
  final Color accent;
  const _AddButtons({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
              color: ForgeColors.card,
              border:
                  Border.all(color: ForgeColors.musculacao.withOpacity(.35)),
              borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(LucideIcons.dumbbell, color: ForgeColors.musculacao, size: 15),
            const SizedBox(width: 6),
            const Text('Exercício',
                style: TextStyle(
                    fontSize: 12,
                    color: ForgeColors.musculacao,
                    fontWeight: FontWeight.w600)),
          ]),
        )),
        const SizedBox(width: 8),
        Expanded(
            child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
              color: ForgeColors.card,
              border: Border.all(color: accent.withOpacity(.35)),
              borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(LucideIcons.repeat, color: accent, size: 15),
            const SizedBox(width: 6),
            Text('Super-set',
                style: TextStyle(
                    fontSize: 12, color: accent, fontWeight: FontWeight.w600)),
          ]),
        )),
      ],
    );
  }
}

class _PickerRow extends StatelessWidget {
  final Widget child;
  const _PickerRow({required this.child});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
            color: ForgeColors.card,
            border: Border.all(color: ForgeColors.border),
            borderRadius: BorderRadius.circular(12)),
        child: child,
      );
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
