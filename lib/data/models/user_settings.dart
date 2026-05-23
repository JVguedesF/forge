import 'package:isar/isar.dart';
import 'enums.dart';

part 'user_settings.g.dart';

@collection
class UserSettings {
  Id id = 1;
  String name = 'Atleta';
  double? weight;
  double? height;
  @Enumerated(EnumType.name)
  WeightUnit weightUnit = WeightUnit.kg;
  @Enumerated(EnumType.name)
  HeightUnit heightUnit = HeightUnit.cm;
  DateTime? birthDate;
  int defaultRestSeconds = 90;
  bool timerSoundEnabled = true;
  String? activeMacroCycleId;
  String themeId = 'teal';
}
