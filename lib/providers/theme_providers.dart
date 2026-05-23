import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/database/isar_service.dart';
import '../data/models/user_settings.dart';

class ThemeNotifier extends Notifier<ForgeTheme> {
  @override
  ForgeTheme build() {
    _loadSaved();
    return ForgeThemes.teal;
  }

  Future<void> _loadSaved() async {
    final settings = await IsarService.instance.userSettings.get(1);
    if (settings != null) {
      state = ForgeThemes.byId(settings.themeId);
    }
  }

  Future<void> setTheme(String id) async {
    state = ForgeThemes.byId(id);
    final db = IsarService.instance;
    await db.writeTxn(() async {
      final settings = await db.userSettings.get(1) ?? (UserSettings()..id = 1);
      settings.themeId = id;
      await db.userSettings.put(settings);
    });
  }
}

final themeProvider =
    NotifierProvider<ThemeNotifier, ForgeTheme>(ThemeNotifier.new);
