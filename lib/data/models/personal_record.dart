import 'package:isar/isar.dart';
import 'enums.dart';

part 'personal_record.g.dart';

@collection
class PersonalRecord {
  Id? id;
  int? exerciseId;
  String exerciseName = '';
  @Enumerated(EnumType.name)
  WorkoutType workoutType = WorkoutType.musculacao;
  double value = 0;
  String unit = 'kg';
  int? sessionId;
  late DateTime date;
}
