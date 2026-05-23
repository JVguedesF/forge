import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith('/library')) return 1;
    if (loc.startsWith('/stats')) return 2;
    if (loc.startsWith('/history')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final idx = _currentIndex(context);
    return Scaffold(
      backgroundColor: ForgeColors.bg,
      body: child,
      bottomNavigationBar: _ForgeNav(currentIndex: idx, theme: theme),
    );
  }
}

class _ForgeNav extends StatelessWidget {
  final int currentIndex;
  final ForgeTheme theme;
  const _ForgeNav({required this.currentIndex, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xF70a0a0a),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, thickness: 1, color: ForgeColors.border),
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 14),
            child: Row(
              children: [
                _NavItem(
                    icon: LucideIcons.house,
                    label: 'Início',
                    index: 0,
                    current: currentIndex,
                    route: '/home',
                    accent: theme.accent),
                _NavItem(
                    icon: LucideIcons.layout_grid,
                    label: 'Treinos',
                    index: 1,
                    current: currentIndex,
                    route: '/library',
                    accent: theme.accent),
                _FabItem(accent: theme.accent, bgColor: theme.bg),
                _NavItem(
                    icon: LucideIcons.chart_column,
                    label: 'Stats',
                    index: 2,
                    current: currentIndex,
                    route: '/stats',
                    accent: theme.accent),
                _NavItem(
                    icon: LucideIcons.calendar,
                    label: 'Histórico',
                    index: 3,
                    current: currentIndex,
                    route: '/history',
                    accent: theme.accent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final String route;
  final Color accent;
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.index,
      required this.current,
      required this.route,
      required this.accent});

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    final color = active ? accent : ForgeColors.muted2;
    return Expanded(
      child: GestureDetector(
        onTap: () => context.go(route),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 21),
            const SizedBox(height: 3),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                  fontSize: 9,
                  color: color,
                  letterSpacing: .3,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _FabItem extends StatelessWidget {
  final Color accent;
  final Color bgColor;
  const _FabItem({required this.accent, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Transform.translate(
            offset: const Offset(0, -22),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
                border: Border.all(color: bgColor, width: 3),
              ),
              child: Icon(LucideIcons.play,
                  color: bgColor == const Color(0xFF0a0a0a)
                      ? Colors.white
                      : Colors.black,
                  size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
