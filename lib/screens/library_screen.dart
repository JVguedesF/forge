import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import 'package:go_router/go_router.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});
  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final Set<String> _collapsed = {};

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
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
          children: [
            _LibHeader(theme: theme),
            _TabBar(controller: _tab, accent: theme.accent),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _WorkoutsTab(
                      collapsed: _collapsed,
                      onToggle: (cat) => setState(() => _collapsed.contains(cat)
                          ? _collapsed.remove(cat)
                          : _collapsed.add(cat))),
                  const _ExercisesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LibHeader extends StatelessWidget {
  final ForgeTheme theme;
  const _LibHeader({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ForgeColors.bg,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        children: [
          const Expanded(
            child: Text('Biblioteca',
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 38,
                    color: ForgeColors.text)),
          ),
          GestureDetector(
            onTap: () => context.push('/builder'),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: theme.accent, borderRadius: BorderRadius.circular(10)),
              child: Icon(LucideIcons.plus, color: theme.bg, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final TabController controller;
  final Color accent;
  const _TabBar({required this.controller, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: ForgeColors.border))),
      child: TabBar(
        controller: controller,
        indicatorColor: accent,
        indicatorWeight: 2,
        labelColor: accent,
        unselectedLabelColor: ForgeColors.muted,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        tabs: const [Tab(text: 'Treinos'), Tab(text: 'Exercícios')],
      ),
    );
  }
}

// ── Dados estáticos (substituir por Isar futuramente)
class _WorkoutData {
  final String name, type;
  final int blocks, min;
  final List<String> tags;
  const _WorkoutData(this.name, this.type, this.blocks, this.min, this.tags);
}

class _CatMeta {
  final String label;
  final Color color, colorLight;
  final IconData icon;
  const _CatMeta(this.label, this.color, this.colorLight, this.icon);
}

final _cats = {
  'musculacao': _CatMeta('Academia', ForgeColors.musculacao,
      ForgeColors.musculacaoLight, LucideIcons.dumbbell),
  'corrida': _CatMeta('Corrida', ForgeColors.corrida, ForgeColors.corridaLight,
      LucideIcons.activity),
  'drills': _CatMeta(
      'Drills', ForgeColors.drills, ForgeColors.drillsLight, LucideIcons.zap),
  'bola': _CatMeta(
      'Bola', ForgeColors.bola, ForgeColors.bolaLight, LucideIcons.target),
  'mobilidade': _CatMeta('Mobilidade', ForgeColors.mobilidade,
      ForgeColors.mobilidadeLight, LucideIcons.leaf),
};

final _workouts = [
  _WorkoutData('Upper A', 'musculacao', 6, 55, ['Composto', 'Isolado']),
  _WorkoutData('Lower A', 'musculacao', 5, 60, ['Composto', 'Core']),
  _WorkoutData('Upper B', 'musculacao', 6, 55, ['Composto', 'Potência']),
  _WorkoutData('Lower B', 'musculacao', 5, 60, ['Core', 'Unilateral']),
  _WorkoutData('Corrida Longa', 'corrida', 3, 0, ['Longa']),
  _WorkoutData('Corrida Regeneração', 'corrida', 2, 0, ['Regeneração']),
  _WorkoutData(
      'Drills Iniciante', 'drills', 4, 45, ['Agilidade', 'Velocidade']),
  _WorkoutData('Bola Intermediário', 'bola', 5, 50, ['Domínio', 'Drible']),
  _WorkoutData(
      'Mobilidade A', 'mobilidade', 4, 30, ['Alongamento', 'Fortalecimento']),
  _WorkoutData('Mobilidade B', 'mobilidade', 4, 30, ['Cervical', 'Lombar']),
];

class _WorkoutsTab extends StatelessWidget {
  final Set<String> collapsed;
  final void Function(String) onToggle;
  const _WorkoutsTab({required this.collapsed, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: _cats.entries.map((e) {
        final cat = e.key;
        final meta = e.value;
        final ww = _workouts.where((w) => w.type == cat).toList();
        if (ww.isEmpty) return const SizedBox.shrink();
        final isCollapsed = collapsed.contains(cat);
        return Column(
          children: [
            _CatHeader(
                meta: meta,
                count: ww.length,
                collapsed: isCollapsed,
                onTap: () => onToggle(cat)),
            if (!isCollapsed)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: Column(
                    children:
                        ww.map((w) => _WorkoutCard(w: w, meta: meta)).toList()),
              ),
          ],
        );
      }).toList(),
    );
  }
}

class _CatHeader extends StatelessWidget {
  final _CatMeta meta;
  final int count;
  final bool collapsed;
  final VoidCallback onTap;
  const _CatHeader(
      {required this.meta,
      required this.count,
      required this.collapsed,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: ForgeColors.border))),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: meta.color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(9)),
              child: Icon(meta.icon, color: meta.color, size: 16),
            ),
            const SizedBox(width: 10),
            Text(meta.label,
                style: const TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 20,
                    color: ForgeColors.text)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: meta.color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(20)),
              child: Text('$count treinos',
                  style: TextStyle(
                      fontSize: 10,
                      color: meta.color,
                      fontWeight: FontWeight.w600)),
            ),
            const Spacer(),
            Icon(
                collapsed
                    ? LucideIcons.chevron_right
                    : LucideIcons.chevron_down,
                color: ForgeColors.muted2,
                size: 16),
          ],
        ),
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final _WorkoutData w;
  final _CatMeta meta;
  const _WorkoutCard({required this.w, required this.meta});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ForgeColors.card,
        border: Border.all(color: meta.color.withOpacity(.16)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: meta.color.withOpacity(.1),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(meta.icon, color: meta.color, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(w.name,
                    style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 20,
                        color: ForgeColors.text)),
                Text('${w.min > 0 ? "${w.min} min" : "—"} · ${w.blocks} blocos',
                    style: const TextStyle(
                        fontSize: 11, color: ForgeColors.muted)),
                const SizedBox(height: 4),
                Wrap(spacing: 4, children: w.tags.map((t) => _Tag(t)).toList()),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  _SmallIconBtn(icon: LucideIcons.pencil, onTap: () {}),
                  const SizedBox(width: 2),
                  _SmallIconBtn(icon: LucideIcons.copy, onTap: () {}),
                ],
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                      color: meta.color.withOpacity(.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('INICIAR',
                      style: TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 13,
                          color: meta.color)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExercisesTab extends StatelessWidget {
  const _ExercisesTab();

  @override
  Widget build(BuildContext context) {
    final exercises = [
      ('Supino Reto', 'Composto', ['Peito', 'Tri'], '100 kg', 'musculacao'),
      ('Agachamento', 'Composto', ['Pernas'], '120 kg', 'musculacao'),
      ('Deadlift', 'Composto', ['Posterior', 'Costas'], '140 kg', 'musculacao'),
      ('OHP', 'Composto', ['Ombros'], '70 kg', 'musculacao'),
      ('Remada Curvada', 'Composto', ['Costas'], '90 kg', 'musculacao'),
      ('Crucifixo', 'Isolado', ['Peito'], '22 kg', 'musculacao'),
      ('Prancha', 'Core', ['Core'], '2:30', 'musculacao'),
      ('Embaixadinha', 'Habilidade', ['Domínio'], '87×', 'bola'),
      ('Figura 4 Deitado', 'Timed', ['Quadril'], '—', 'mobilidade'),
      ('Pigeon Pose', 'Timed', ['Quadril'], '—', 'mobilidade'),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: exercises.map((e) {
        final meta = _cats[e.$5]!;
        return GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: ForgeColors.card,
              border: Border.all(color: ForgeColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                      color: meta.color.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(meta.icon, color: meta.color, size: 17),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.$1,
                          style: const TextStyle(
                              fontSize: 14,
                              color: ForgeColors.text,
                              fontWeight: FontWeight.w500)),
                      Text('${e.$2} · ${e.$3.join(", ")}',
                          style: const TextStyle(
                              fontSize: 11, color: ForgeColors.muted)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(e.$4,
                        style: TextStyle(
                            fontSize: 13,
                            color: meta.color,
                            fontWeight: FontWeight.w600)),
                    const Text('PR',
                        style:
                            TextStyle(fontSize: 9, color: ForgeColors.muted)),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(.06),
            borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: const TextStyle(
                fontSize: 9,
                color: ForgeColors.muted,
                fontWeight: FontWeight.w500)),
      );
}

class _SmallIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SmallIconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(icon, color: ForgeColors.muted2, size: 15)),
      );
}
