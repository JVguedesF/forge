import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      GoRoute(path: '/macro', builder: (c, s) => const MacroScreen()),
      GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
      GoRoute(
        path: '/session',
        builder: (c, s) {
          final mode = s.uri.queryParameters['mode'] ?? 'musculacao';
          final workoutId = int.tryParse(s.uri.queryParameters['id'] ?? '');
          final workoutName =
              Uri.decodeComponent(s.uri.queryParameters['name'] ?? '');
          final sessionMode = switch (mode) {
            'timed' => SessionMode.timed,
            'corrida' => SessionMode.corrida,
            _ => SessionMode.musculacao,
          };
          return SessionScreen(
              mode: sessionMode,
              workoutId: workoutId,
              workoutName: workoutName);
        },
      ),
      GoRoute(path: '/session/form', builder: (c, s) => const RunFormScreen()),
      GoRoute(
          path: '/session/summary',
          builder: (c, s) => const SessionSummaryScreen()),
    ],
  );
});
