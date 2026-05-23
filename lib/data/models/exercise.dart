import 'package:isar/isar.dart';
import 'enums.dart';

part 'exercise.g.dart';

@collection
class Exercise {
  Id? id;
  late String name;
  @Enumerated(EnumType.name)
  late ExerciseType type;
  List<String> tags = [];
  int defaultSets = 3;
  String defaultReps = '10';
  double? defaultWeight;
  int defaultDurationSeconds = 30;
  int defaultRestSeconds = 90;
  bool hasSides = false;
  String? notes;
}
