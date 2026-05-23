import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme.dart';

class ThemeNotifier extends Notifier<ForgeTheme> {
  @override
  ForgeTheme build() => ForgeThemes.teal;

  void setTheme(String id) => state = ForgeThemes.byId(id);
}

final themeProvider = NotifierProvider<ThemeNotifier, ForgeTheme>(
  ThemeNotifier.new,
);
