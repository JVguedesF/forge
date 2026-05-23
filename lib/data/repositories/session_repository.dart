import 'package:isar/isar.dart';
import '../models/training_session.dart';
import '../../core/database/isar_service.dart';
import '../models/enums.dart';

class SessionRepository {
  Isar get _db => IsarService.instance;

  Future<List<TrainingSession>> getAll() =>
      _db.trainingSessions.where().sortByStartTimeDesc().findAll();

  Future<List<TrainingSession>> getByMonth(int year, int month) => _db
      .trainingSessions
      .filter()
      .startTimeBetween(DateTime(year, month, 1), DateTime(year, month + 1, 1))
      .findAll();

  Future<List<TrainingSession>> getByType(WorkoutType type) =>
      _db.trainingSessions.filter().workoutTypeEqualTo(type).findAll();

  Future<TrainingSession?> getById(int id) => _db.trainingSessions.get(id);

  Future<int> save(TrainingSession session) =>
      _db.writeTxn(() => _db.trainingSessions.put(session));

  Future<void> delete(int id) =>
      _db.writeTxn(() => _db.trainingSessions.delete(id));

  Future<int> getStreakDays() async {
    final sessions = await getAll();
    if (sessions.isEmpty) return 0;
    int streak = 0;
    DateTime? last;
    for (final s in sessions) {
      final day =
          DateTime(s.startTime.year, s.startTime.month, s.startTime.day);
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

  Stream<List<TrainingSession>> watchAll() =>
      _db.trainingSessions.where().watch(fireImmediately: true);
}
