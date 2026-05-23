import 'package:isar/isar.dart';
import '../models/exercise.dart';
import '../../core/database/isar_service.dart';

class ExerciseRepository {
  Isar get _db => IsarService.instance;

  Future<List<Exercise>> getAll() => _db.exercises.where().findAll();

  Future<Exercise?> getById(int id) => _db.exercises.get(id);

  Future<int> save(Exercise exercise) =>
      _db.writeTxn(() => _db.exercises.put(exercise));

  Future<void> delete(int id) => _db.writeTxn(() => _db.exercises.delete(id));

  Stream<List<Exercise>> watchAll() =>
      _db.exercises.where().watch(fireImmediately: true);
}
