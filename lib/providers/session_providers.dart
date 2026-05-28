import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/training_session.dart';
import '../data/repositories/session_repository.dart';
import '../data/repositories/personal_record_repository.dart';
import '../data/repositories/macro_cycle_repository.dart';

final sessionRepositoryProvider = Provider((ref) => SessionRepository());
final prRepositoryProvider = Provider((ref) => PersonalRecordRepository());
final macroCycleRepositoryProvider = Provider((ref) => MacroCycleRepository());

final sessionsProvider = StreamProvider<List<TrainingSession>>((ref) {
  return ref.watch(sessionRepositoryProvider).watchAll();
});

final activeMacroCycleProvider = StreamProvider((ref) {
  return ref.watch(macroCycleRepositoryProvider).watchActive();
});

// Streak derivado direto do stream — atualiza automaticamente após salvar sessão
final streakProvider = Provider<int>((ref) {
  final sessionsAsync = ref.watch(sessionsProvider);
  return sessionsAsync.when(
    data: (sessions) => _calcStreak(sessions),
    loading: () => 0,
    error: (_, __) => 0,
  );
});

int _calcStreak(List<TrainingSession> sessions) {
  if (sessions.isEmpty) return 0;
  int streak = 0;
  DateTime? last;
  for (final s in sessions) {
    final day = DateTime(s.startTime.year, s.startTime.month, s.startTime.day);
    if (last == null) {
      last = day;
      streak = 1;
      continue;
    }
    final diff = last.difference(day).inDays;
    if (diff == 1) {
      streak++;
      last = day;
    } else if (diff > 1) break;
  }
  return streak;
}

final monthSessionsProvider =
    FutureProvider.family<List<TrainingSession>, (int, int)>((ref, ym) {
  return ref.watch(sessionRepositoryProvider).getByMonth(ym.$1, ym.$2);
});
