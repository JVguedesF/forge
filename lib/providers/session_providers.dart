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

final streakProvider = FutureProvider<int>((ref) {
  return ref.watch(sessionRepositoryProvider).getStreakDays();
});

final monthSessionsProvider =
    FutureProvider.family<List<TrainingSession>, (int, int)>((ref, ym) {
  return ref.watch(sessionRepositoryProvider).getByMonth(ym.$1, ym.$2);
});
