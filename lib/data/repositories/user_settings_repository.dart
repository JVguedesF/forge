import 'package:isar/isar.dart';
import '../models/user_settings.dart';
import '../../core/database/isar_service.dart';

class UserSettingsRepository {
  Isar get _db => IsarService.instance;

  Future<UserSettings> get() async {
    final settings = await _db.userSettings.get(1);
    if (settings != null) return settings;
    final def = UserSettings();
    await _db.writeTxn(() => _db.userSettings.put(def));
    return def;
  }

  Future<void> save(UserSettings settings) =>
      _db.writeTxn(() => _db.userSettings.put(settings));

  Stream<UserSettings?> watch() =>
      _db.userSettings.watchObject(1, fireImmediately: true);
}
