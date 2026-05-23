import 'package:isar/isar.dart';
import '../models/workout.dart';
import '../../core/database/isar_service.dart';
import '../models/enums.dart';

class WorkoutRepository {
  Isar get _db => IsarService.instance;

  Future<List<Workout>> getAll() => _db.workouts.where().findAll();

  Future<List<Workout>> getByType(WorkoutType type) =>
      _db.workouts.filter().typeEqualTo(type).findAll();

  Future<Workout?> getById(int id) => _db.workouts.get(id);

  Future<int> save(Workout workout) async {
    return _db.writeTxn(() {
      workout.updatedAt = DateTime.now();
      return _db.workouts.put(workout);
    });
  }

  Future<void> delete(int id) => _db.writeTxn(() => _db.workouts.delete(id));

  Stream<List<Workout>> watchAll() =>
      _db.workouts.where().watch(fireImmediately: true);
}
