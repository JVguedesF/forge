import 'package:isar/isar.dart';
import 'enums.dart';

part 'macro_cycle.g.dart';

@collection
class MacroCycle {
  Id? id;
  String name = '';
  String? description;
  List<Phase> phases = [];
  int currentPhaseIndex = 0;
  late DateTime startDate;
  bool isActive = false;
}

@embedded
class Phase {
  String name = '';
  String? objective;
  int durationWeeks = 4;
  int targetSessions = 16;
  int completedSessions = 0;
  double? intensityPercent;
  int? recommendedSets;
  String? recommendedReps;
  List<int> deloadWeeks = [];
  List<DaySchedule> weeklySchedule = [];
  List<PhaseGoal> goals = [];
  DateTime? startDate;
  bool isCompleted = false;
}

@embedded
class DaySchedule {
  int weekday = 1;
  List<int> workoutIds = [];
  List<String> workoutNames = [];
}

@embedded
class PhaseGoal {
  @Enumerated(EnumType.name)
  GoalType type = GoalType.sessions;
  @Enumerated(EnumType.name)
  WorkoutType? workoutType;
  String description = '';
  String unit = '';
  double target = 0;
  double current = 0;
  int? exerciseId;
  String? exerciseName;
}
