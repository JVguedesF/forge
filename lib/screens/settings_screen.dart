import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(onBack: () => context.pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Avatar(theme: theme),
                    const SizedBox(height: 26),
                    const _SLabel('Tema do app'),
                    _ThemeGrid(current: theme, ref: ref),
                    const SizedBox(height: 20),
                    const _SLabel('Perfil físico'),
                    _PrefRow(
                        label: 'Peso',
                        value: '78 kg',
                        icon: LucideIcons.pencil),
                    const SizedBox(height: 8),
                    _PrefRow(
                        label: 'Altura',
                        value: '178 cm',
                        icon: LucideIcons.pencil),
                    const SizedBox(height: 10),
                    const _SLabel('Preferências'),
                    _PrefRow(
                        label: 'Descanso padrão',
                        value: '90s',
                        icon: LucideIcons.chevron_right),
                    const SizedBox(height: 8),
                    _PrefRow(
                        label: 'Som do timer',
                        value: 'Ativo',
                        icon: LucideIcons.chevron_right),
                    const SizedBox(height: 8),
                    _PrefRow(
                        label: 'Unidades',
                        value: 'Métrico',
                        icon: LucideIcons.chevron_right),
                    const SizedBox(height: 10),
                    const _SLabel('Ciclo ativo'),
                    _ActiveCycleRow(
                        theme: theme, onTap: () => context.push('/macro')),
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
  final VoidCallback onBack;
  const _AppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Row(
        children: [
          _XBtn(onTap: onBack, icon: LucideIcons.arrow_left),
          const SizedBox(width: 12),
          const Text('Configurações',
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 22,
                  color: ForgeColors.text)),
        ],
      ),
    );
  }
}

class _Avatar extends ConsumerWidget {
  final ForgeTheme theme;
  const _Avatar({required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: theme.accent.withOpacity(.12),
              shape: BoxShape.circle,
              border:
                  Border.all(color: theme.accent.withOpacity(.35), width: 2),
            ),
            child: Center(
              child: Text('A',
                  style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 30,
                      color: theme.accent,
                      letterSpacing: 0)),
            ),
          ),
          const SizedBox(height: 10),
          const Text('Atleta',
              style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 28,
                  color: ForgeColors.text)),
          const Text('Toque para editar',
              style: TextStyle(fontSize: 12, color: ForgeColors.muted)),
        ],
      ),
    );
  }
}

class _ThemeGrid extends StatelessWidget {
  final ForgeTheme current;
  final WidgetRef ref;
  const _ThemeGrid({required this.current, required this.ref});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      children: ForgeThemes.all.map((t) {
        final active = t.id == current.id;
        return GestureDetector(
          onTap: () => ref.read(themeProvider.notifier).setTheme(t.id),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: t.accent,
                  shape: BoxShape.circle,
                  border: active
                      ? Border.all(color: ForgeColors.text, width: 2.5)
                      : null,
                ),
                child: active
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
              const SizedBox(height: 6),
              Text(t.name,
                  style: TextStyle(
                      fontSize: 10,
                      color: active ? ForgeColors.text : ForgeColors.muted)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _PrefRow extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _PrefRow(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(fontSize: 14, color: ForgeColors.text)),
          const Spacer(),
          Text(value,
              style: const TextStyle(fontSize: 14, color: ForgeColors.muted)),
          const SizedBox(width: 8),
          Icon(icon, color: ForgeColors.muted2, size: 14),
        ],
      ),
    );
  }
}

class _ActiveCycleRow extends StatelessWidget {
  final ForgeTheme theme;
  final VoidCallback onTap;
  const _ActiveCycleRow({required this.theme, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Ciclo Base 2025',
                  style: TextStyle(fontSize: 14, color: ForgeColors.text)),
              Text('Fase 1 · Semana 3 de 8',
                  style: TextStyle(fontSize: 11, color: ForgeColors.muted)),
            ]),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                  color: theme.accent, borderRadius: BorderRadius.circular(8)),
              child: Text('GERIR',
                  style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 13,
                      color:
                          theme.id == 'neon' ? Colors.black : ForgeColors.bg)),
            ),
          ),
        ],
      ),
    );
  }
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
