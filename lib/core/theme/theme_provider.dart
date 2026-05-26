import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'app_theme.dart';
import '../../core/database/isar_service.dart';
import '../../data/models/user_settings.dart';

class ThemeNotifier extends AsyncNotifier<ForgeTheme> {
  Isar get _db => IsarService.instance;

  @override
  Future<ForgeTheme> build() async {
    final settings = await _db.userSettings.get(1);
    final id = settings?.themeId ?? 'teal';
    return ForgeThemes.byId(id);
  }

  Future<void> setTheme(String id) async {
    final settings = await _db.userSettings.get(1) ?? UserSettings();
    settings.themeId = id;
    await _db.writeTxn(() => _db.userSettings.put(settings));
    state = AsyncData(ForgeThemes.byId(id));
  }
}

final themeProvider = AsyncNotifierProvider<ThemeNotifier, ForgeTheme>(
  ThemeNotifier.new,
);
