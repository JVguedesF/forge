import 'package:isar/isar.dart';
import 'enums.dart';

part 'training_session.g.dart';

@collection
class TrainingSession {
  Id? id;
  int? workoutId;
  String workoutName = '';
  @Enumerated(EnumType.name)
  WorkoutType workoutType = WorkoutType.musculacao;
  int workoutColorValue = 0xFF3b82f6;
  late DateTime startTime;
  DateTime? endTime;
  int durationSeconds = 0;
  List<SessionExercise> exercises = [];
  double totalVolume = 0;
  double totalDistanceKm = 0;
  int totalActiveSeconds = 0;
  int completedSets = 0;
  List<double> kmPaces = [];
  double avgPaceSeconds = 0;
  int? perceivedEffort;
  String? notes;
  int? macroCycleId;
  int? macroPhaseIndex;
}

@embedded
class SessionExercise {
  int? exerciseId;
  String exerciseName = '';
  List<SessionSet> sets = [];
}

@embedded
class SessionSet {
  int setIndex = 0;
  double? weight;
  int? reps;
  int? durationSeconds;
  bool completed = false;
  bool isPR = false;
}
