import 'package:isar/isar.dart';
import '../models/personal_record.dart';
import '../models/enums.dart';
import '../../core/database/isar_service.dart';

class PersonalRecordRepository {
  Isar get _db => IsarService.instance;

  Future<List<PersonalRecord>> getAll() =>
      _db.personalRecords.where().findAll();

  Future<List<PersonalRecord>> getByType(WorkoutType type) =>
      _db.personalRecords.filter().workoutTypeEqualTo(type).findAll();

  Future<PersonalRecord?> getByExercise(int exerciseId) => _db.personalRecords
      .filter()
      .exerciseIdEqualTo(exerciseId)
      .sortByValueDesc()
      .findFirst();

  Future<int> save(PersonalRecord pr) =>
      _db.writeTxn(() => _db.personalRecords.put(pr));

  Future<bool> checkAndSavePR(int exerciseId, String exerciseName,
      WorkoutType type, double value, String unit, int sessionId) async {
    final existing = await getByExercise(exerciseId);
    if (existing == null || value > existing.value) {
      final pr = PersonalRecord()
        ..exerciseId = exerciseId
        ..exerciseName = exerciseName
        ..workoutType = type
        ..value = value
        ..unit = unit
        ..sessionId = sessionId
        ..date = DateTime.now();
      await save(pr);
      return true;
    }
    return false;
  }

  Stream<List<PersonalRecord>> watchAll() =>
      _db.personalRecords.where().watch(fireImmediately: true);
}
