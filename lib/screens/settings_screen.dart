import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import '../providers/user_settings_provider.dart';
import '../data/models/user_settings.dart';
import '../data/models/enums.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider).valueOrNull ?? ForgeThemes.teal;
    final settingsAsync = ref.watch(userSettingsProvider);

    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(onBack: () => context.pop()),
            Expanded(
              child: settingsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                    child: Text('Erro: $e',
                        style: const TextStyle(color: ForgeColors.muted))),
                data: (settings) {
                  final s = settings ?? UserSettings();
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Avatar(
                            name: s.name,
                            theme: theme,
                            onTap: () => _editName(context, ref, s)),
                        const SizedBox(height: 26),
                        const _SLabel('Tema do app'),
                        _ThemeGrid(current: theme, ref: ref),
                        const SizedBox(height: 20),
                        const _SLabel('Perfil físico'),
                        _PrefRow(
                          label: 'Peso',
                          value: s.weight != null
                              ? '${s.weight!.toStringAsFixed(1)} ${s.weightUnit.name}'
                              : '—',
                          icon: LucideIcons.pencil,
                          onTap: () => _editWeight(context, ref, s),
                        ),
                        const SizedBox(height: 8),
                        _PrefRow(
                          label: 'Altura',
                          value: s.height != null
                              ? '${s.height!.toStringAsFixed(0)} ${s.heightUnit.name}'
                              : '—',
                          icon: LucideIcons.pencil,
                          onTap: () => _editHeight(context, ref, s),
                        ),
                        const SizedBox(height: 10),
                        const _SLabel('Preferências'),
                        _PrefRow(
                          label: 'Descanso padrão',
                          value: '${s.defaultRestSeconds}s',
                          icon: LucideIcons.chevron_right,
                          onTap: () => _editRest(context, ref, s),
                        ),
                        const SizedBox(height: 8),
                        _SwitchRow(
                          label: 'Som do timer',
                          value: s.timerSoundEnabled,
                          onChanged: (v) async {
                            s.timerSoundEnabled = v;
                            await ref
                                .read(userSettingsRepositoryProvider)
                                .save(s);
                          },
                        ),
                        const SizedBox(height: 8),
                        _PrefRow(
                          label: 'Unidades',
                          value: s.weightUnit == WeightUnit.kg
                              ? 'Métrico'
                              : 'Imperial',
                          icon: LucideIcons.chevron_right,
                          onTap: () => _toggleUnits(ref, s),
                        ),
                        const SizedBox(height: 10),
                        const _SLabel('Ciclo ativo'),
                        _ActiveCycleRow(
                            theme: theme, onTap: () => context.push('/macro')),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editName(
      BuildContext context, WidgetRef ref, UserSettings s) async {
    final ctrl = TextEditingController(text: s.name);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ForgeColors.card,
        title: const Text('Nome',
            style: TextStyle(
                color: ForgeColors.text,
                fontFamily: 'BebasNeue',
                fontSize: 22)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: const TextStyle(color: ForgeColors.text),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ForgeColors.border)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF00e5c8))),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar',
                  style: TextStyle(color: ForgeColors.muted))),
          TextButton(
              onPressed: () => Navigator.pop(context, ctrl.text),
              child: const Text('Salvar',
                  style: TextStyle(color: Color(0xFF00e5c8)))),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      s.name = result;
      await ref.read(userSettingsRepositoryProvider).save(s);
    }
  }

  Future<void> _editWeight(
      BuildContext context, WidgetRef ref, UserSettings s) async {
    final ctrl = TextEditingController(text: s.weight?.toString() ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ForgeColors.card,
        title: const Text('Peso (kg)',
            style: TextStyle(
                color: ForgeColors.text,
                fontFamily: 'BebasNeue',
                fontSize: 22)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: ForgeColors.text),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ForgeColors.border)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF00e5c8))),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar',
                  style: TextStyle(color: ForgeColors.muted))),
          TextButton(
              onPressed: () => Navigator.pop(context, ctrl.text),
              child: const Text('Salvar',
                  style: TextStyle(color: Color(0xFF00e5c8)))),
        ],
      ),
    );
    if (result != null) {
      s.weight = double.tryParse(result);
      await ref.read(userSettingsRepositoryProvider).save(s);
    }
  }

  Future<void> _editHeight(
      BuildContext context, WidgetRef ref, UserSettings s) async {
    final ctrl = TextEditingController(text: s.height?.toString() ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ForgeColors.card,
        title: const Text('Altura (cm)',
            style: TextStyle(
                color: ForgeColors.text,
                fontFamily: 'BebasNeue',
                fontSize: 22)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: ForgeColors.text),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ForgeColors.border)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF00e5c8))),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar',
                  style: TextStyle(color: ForgeColors.muted))),
          TextButton(
              onPressed: () => Navigator.pop(context, ctrl.text),
              child: const Text('Salvar',
                  style: TextStyle(color: Color(0xFF00e5c8)))),
        ],
      ),
    );
    if (result != null) {
      s.height = double.tryParse(result);
      await ref.read(userSettingsRepositoryProvider).save(s);
    }
  }

  Future<void> _editRest(
      BuildContext context, WidgetRef ref, UserSettings s) async {
    final options = [30, 60, 90, 120, 150, 180, 240];
    final result = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ForgeColors.card,
        title: const Text('Descanso padrão',
            style: TextStyle(
                color: ForgeColors.text,
                fontFamily: 'BebasNeue',
                fontSize: 22)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map((o) => ListTile(
                    title: Text('${o}s',
                        style: TextStyle(
                            color: s.defaultRestSeconds == o
                                ? const Color(0xFF00e5c8)
                                : ForgeColors.text)),
                    trailing: s.defaultRestSeconds == o
                        ? const Icon(Icons.check,
                            color: Color(0xFF00e5c8), size: 16)
                        : null,
                    onTap: () => Navigator.pop(context, o),
                  ))
              .toList(),
        ),
      ),
    );
    if (result != null) {
      s.defaultRestSeconds = result;
      await ref.read(userSettingsRepositoryProvider).save(s);
    }
  }

  Future<void> _toggleUnits(WidgetRef ref, UserSettings s) async {
    s.weightUnit =
        s.weightUnit == WeightUnit.kg ? WeightUnit.lb : WeightUnit.kg;
    s.heightUnit =
        s.heightUnit == HeightUnit.cm ? HeightUnit.ft : HeightUnit.cm;
    await ref.read(userSettingsRepositoryProvider).save(s);
  }
}

class _AppBar extends StatelessWidget {
  final VoidCallback onBack;
  const _AppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Row(children: [
        _XBtn(onTap: onBack, icon: LucideIcons.arrow_left),
        const SizedBox(width: 12),
        const Text('Configurações',
            style: TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 22,
                color: ForgeColors.text)),
      ]),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final ForgeTheme theme;
  final VoidCallback onTap;
  const _Avatar({required this.name, required this.theme, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'A';
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Column(children: [
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
                child: Text(initial,
                    style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 30,
                        color: theme.accent,
                        letterSpacing: 0))),
          ),
          const SizedBox(height: 10),
          Text(name,
              style: const TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 28,
                  color: ForgeColors.text)),
          const Text('Toque para editar',
              style: TextStyle(fontSize: 12, color: ForgeColors.muted)),
        ]),
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
          child: Column(children: [
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
          ]),
        );
      }).toList(),
    );
  }
}

class _PrefRow extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final VoidCallback? onTap;
  const _PrefRow(
      {required this.label,
      required this.value,
      required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
            color: ForgeColors.card,
            border: Border.all(color: ForgeColors.border),
            borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Text(label,
              style: const TextStyle(fontSize: 14, color: ForgeColors.text)),
          const Spacer(),
          Text(value,
              style: const TextStyle(fontSize: 14, color: ForgeColors.muted)),
          const SizedBox(width: 8),
          Icon(icon, color: ForgeColors.muted2, size: 14),
        ]),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool) onChanged;
  const _SwitchRow(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
          color: ForgeColors.card,
          border: Border.all(color: ForgeColors.border),
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Text(label,
            style: const TextStyle(fontSize: 14, color: ForgeColors.text)),
        const Spacer(),
        Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF00e5c8)),
      ]),
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
      child: Row(children: [
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
                    color: theme.id == 'neon' ? Colors.black : ForgeColors.bg)),
          ),
        ),
      ]),
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
