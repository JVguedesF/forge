import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/exercise.dart';
import '../../data/models/workout.dart';
import '../../data/models/training_session.dart';
import '../../data/models/macro_cycle.dart';
import '../../data/models/personal_record.dart';
import '../../data/models/user_settings.dart';

class IsarService {
  static late Isar _isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        ExerciseSchema,
        WorkoutSchema,
        TrainingSessionSchema,
        MacroCycleSchema,
        PersonalRecordSchema,
        UserSettingsSchema,
      ],
      directory: dir.path,
    );
  }

  static Isar get instance => _isar;
}
