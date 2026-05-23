import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgeColors {
  static const musculacao = Color(0xFF3b82f6);
  static const musculacaoLight = Color(0xFF93c5fd);
  static const corrida = Color(0xFF0ea5e9);
  static const corridaLight = Color(0xFF7dd3fc);
  static const drills = Color(0xFF06b6d4);
  static const drillsLight = Color(0xFF67e8f9);
  static const bola = Color(0xFF22c55e);
  static const bolaLight = Color(0xFF86efac);
  static const mobilidade = Color(0xFF8b5cf6);
  static const mobilidadeLight = Color(0xFFc4b5fd);

  static const bg = Color(0xFF0a0a0a);
  static const surface = Color(0xFF111111);
  static const card = Color(0xFF161616);
  static const border = Color(0xFF222222);
  static const text = Color(0xFFf0f0f0);
  static const muted = Color(0xFF666666);
  static const muted2 = Color(0xFF444444);
  static const muted3 = Color(0xFF333333);

  static Color categoryColor(String type) {
    switch (type) {
      case 'musculacao':
        return musculacao;
      case 'corrida':
        return corrida;
      case 'drills':
        return drills;
      case 'bola':
        return bola;
      case 'mobilidade':
        return mobilidade;
      default:
        return const Color(0xFF00e5c8);
    }
  }
}

class ForgeTheme {
  final String id;
  final String name;
  final Color accent;
  final Color bg;

  const ForgeTheme({
    required this.id,
    required this.name,
    required this.accent,
    required this.bg,
  });
}

class ForgeThemes {
  static const teal = ForgeTheme(
      id: 'teal',
      name: 'Teal',
      accent: Color(0xFF00e5c8),
      bg: Color(0xFF0a0a0a));
  static const forge = ForgeTheme(
      id: 'forge',
      name: 'Forge',
      accent: Color(0xFFff6b35),
      bg: Color(0xFF0a0a0a));
  static const neon = ForgeTheme(
      id: 'neon',
      name: 'Neon',
      accent: Color(0xFFe8ff47),
      bg: Color(0xFF0a0a0a));
  static const blood = ForgeTheme(
      id: 'blood',
      name: 'Blood',
      accent: Color(0xFFef4444),
      bg: Color(0xFF0a0a0a));
  static const frost = ForgeTheme(
      id: 'frost',
      name: 'Frost',
      accent: Color(0xFF7dd3fc),
      bg: Color(0xFF080c10));
  static const void_ = ForgeTheme(
      id: 'void',
      name: 'Void',
      accent: Color(0xFFa78bfa),
      bg: Color(0xFF080808));
  static const carbon = ForgeTheme(
      id: 'carbon',
      name: 'Carbon',
      accent: Color(0xFFd4d4d4),
      bg: Color(0xFF0a0a0a));

  static const all = [teal, forge, neon, blood, frost, void_, carbon];

  static ForgeTheme byId(String id) =>
      all.firstWhere((t) => t.id == id, orElse: () => teal);
}

class AppTheme {
  static ThemeData build(ForgeTheme t) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: t.bg,
      fontFamily: GoogleFonts.dmSans().fontFamily,
      colorScheme: ColorScheme.dark(
        primary: t.accent,
        secondary: t.accent,
        surface: ForgeColors.surface,
        onPrimary: t.id == 'neon' ? Colors.black : ForgeColors.bg,
        onSurface: ForgeColors.text,
      ),
      cardColor: ForgeColors.card,
      dividerColor: ForgeColors.border,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: t.accent,
        foregroundColor: t.id == 'neon' ? Colors.black : ForgeColors.bg,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: t.bg,
        foregroundColor: ForgeColors.text,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: t.bg,
        selectedItemColor: t.accent,
        unselectedItemColor: ForgeColors.muted2,
      ),
      textTheme:
          GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme).copyWith(
        bodyMedium: GoogleFonts.dmSans(color: ForgeColors.text),
        bodySmall: GoogleFonts.dmSans(color: ForgeColors.muted),
      ),
    );
  }
}
