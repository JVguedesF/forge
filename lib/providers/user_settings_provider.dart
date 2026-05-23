import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_settings.dart';
import '../data/repositories/user_settings_repository.dart';

final userSettingsRepositoryProvider =
    Provider((ref) => UserSettingsRepository());

final userSettingsProvider = StreamProvider<UserSettings?>((ref) {
  return ref.watch(userSettingsRepositoryProvider).watch();
});
