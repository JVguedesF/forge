import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/workout.dart';
import '../data/repositories/workout_repository.dart';
import '../data/repositories/exercise_repository.dart';
import '../data/models/enums.dart';

final workoutRepositoryProvider = Provider((ref) => WorkoutRepository());
final exerciseRepositoryProvider = Provider((ref) => ExerciseRepository());

final workoutsProvider = StreamProvider<List<Workout>>((ref) {
  return ref.watch(workoutRepositoryProvider).watchAll();
});

final workoutsByTypeProvider =
    FutureProvider.family<List<Workout>, WorkoutType>((ref, type) {
  return ref.watch(workoutRepositoryProvider).getByType(type);
});
