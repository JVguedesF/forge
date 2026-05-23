import 'package:isar/isar.dart';
import 'enums.dart';

part 'workout.g.dart';

@collection
class Workout {
  Id? id;
  late String name;
  @Enumerated(EnumType.name)
  late WorkoutType type;
  int colorValue = 0xFF3b82f6;
  String iconName = 'dumbbell';
  List<String> tags = [];
  late List<WorkoutBlock> blocks;
  DateTime? createdAt;
  DateTime? updatedAt;
  int estimatedMinutes = 0;
}

@embedded
class WorkoutBlock {
  bool isCircuit = false;
  String? circuitName;
  int sets = 3;
  int restAfterSeconds = 90;
  int orderIndex = 0;
  List<WorkoutExercise> exercises = [];
}

@embedded
class WorkoutExercise {
  int? exerciseId;
  String exerciseName = '';
  @Enumerated(EnumType.name)
  ExerciseType type = ExerciseType.weightReps;
  String reps = '10';
  double? suggestedWeight;
  int durationSeconds = 30;
  double? targetDistanceKm;
  bool hasSides = false;
  int orderIndex = 0;
  List<String> tags = [];
}
