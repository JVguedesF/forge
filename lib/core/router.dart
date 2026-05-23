import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'shell.dart';
import '../screens/home_screen.dart';
import '../screens/library_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/history_screen.dart';
import '../screens/workout_builder_screen.dart';
import '../screens/session_screen.dart';
import '../screens/macro_screen.dart';
import '../screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
          GoRoute(path: '/library', builder: (c, s) => const LibraryScreen()),
          GoRoute(path: '/stats', builder: (c, s) => const StatsScreen()),
          GoRoute(path: '/history', builder: (c, s) => const HistoryScreen()),
        ],
      ),
      GoRoute(
          path: '/builder', builder: (c, s) => const WorkoutBuilderScreen()),
      GoRoute(path: '/session', builder: (c, s) => const SessionScreen()),
      GoRoute(path: '/macro', builder: (c, s) => const MacroScreen()),
      GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
    ],
  );
});
