import 'package:flutter/material.dart';

class AppTheme {
  // ── Premium Color Palette ──────────────────────────────────────────────────
  // Dark Mode: Deep Space + Electric Indigo (Stripe × Linear × Revolut)
  static const Color darkBg1 = Color(0xFF05060A);        // Deepest abyss
  static const Color darkBg2 = Color(0xFF0A0C14);        // GitHub-style surface
  static const Color darkBg3 = Color(0xFF12141E);        // Elevated surface
  static const Color darkBg4 = Color(0xFF1C1F2E);        // Borders & dividers
  static const Color darkBg5 = Color(0xFF252839);        // Subtle hover state
  static const Color darkAccentIndigo = Color(0xFF6366F1); // Primary indigo
  static const Color darkAccentViolet = Color(0xFF8B5CF6); // Violet accent
  static const Color darkAccentCyan = Color(0xFF06B6D4);   // Cyan highlights
  static const Color darkAccentBlue = Color(0xFF3B82F6);   // Info blue
  static const Color darkAccentPink = Color(0xFFEC4899);   // Pink accent
  static const Color darkTextPrimary = Color(0xFFEDF2F7);  // High contrast text
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Muted text (≥4.5:1 on dark)
  static const Color darkTextTertiary = Color(0xFF64748B);  // Very muted (≥3:1 for UI glyphs)

  // Light Mode: Soft Pearl + Professional Indigo
  static const Color lightBg1 = Color(0xFFF1F3F8);       // Canvas background
  static const Color lightBg2 = Color(0xFFFFFFFF);        // Pure white surface
  static const Color lightBg3 = Color(0xFFF7F8FC);        // Subtle alt surface
  static const Color lightBg4 = Color(0xFFE2E5F0);        // Borders
  static const Color lightBg5 = Color(0xFFD1D5E0);        // Hover state
  static const Color lightAccentIndigo = Color(0xFF4F46E5); // Deeper indigo
  static const Color lightAccentViolet = Color(0xFF7C3AED); // Professional violet
  static const Color lightAccentPink = Color(0xFFDB2777);   // Pink accent
  static const Color lightTextPrimary = Color(0xFF1A1D2E);  // Near black
  static const Color lightTextSecondary = Color(0xFF6B7280); // Muted gray
  static const Color lightTextTertiary = Color(0xFF9CA3AF);  // Very muted

  // Status Colors (shared)
  static const Color successGreen = Color(0xFF10B981);
  static const Color successGreenLight = Color(0xFF34D399);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color warningOrangeLight = Color(0xFFFBBF24);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color errorRedLight = Color(0xFFF87171);
  static const Color infoBlue = Color(0xFF3B82F6);

  // Rate change colors
  static const Color rateUp = Color(0xFF10B981);
  static const Color rateUpLight = Color(0xFF34D399);
  static const Color rateDown = Color(0xFFEF4444);
  static const Color rateDownLight = Color(0xFFF87171);
  static const Color rateNeutral = Color(0xFF7F8EA3);

  // ── Design Tokens ────────────────────────────────────────────────────────
  static const double radiusXs = 6.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;
  static const double radiusFull = 999.0;

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // ── Typography ───────────────────────────────────────────────────────────
  static const String fontFamily = 'Inter';
  static const String fontFamilyMono = 'JetBrains Mono';

  static TextStyle get displayLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -1.0,
  );

  static TextStyle get displayMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.15,
    letterSpacing: -0.75,
  );

  static TextStyle heading1(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: color,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle heading2(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: color,
    height: 1.25,
    letterSpacing: -0.3,
  );

  static TextStyle heading3(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color,
    height: 1.3,
    letterSpacing: -0.2,
  );

  static TextStyle subtitle(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: color,
    height: 1.4,
    letterSpacing: 0.0,
  );

  static TextStyle body(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.6,
    letterSpacing: 0.0,
  );

  static TextStyle bodyMedium(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: color,
    height: 1.5,
    letterSpacing: 0.0,
  );

  static TextStyle caption(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: color,
    height: 1.4,
    letterSpacing: 0.2,
  );

  static TextStyle overline(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: color,
    height: 1.3,
    letterSpacing: 0.8,
  );

  static TextStyle monetary(Color color) => TextStyle(
    fontFamily: fontFamilyMono,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: color,
    height: 1.2,
    letterSpacing: -0.3,
  );

  // ── Shadow Presets ─────────────────────────────────────────────────────
  static List<BoxShadow> shadowSm(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.06),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: color.withValues(alpha: 0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> shadowMd(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: color.withValues(alpha: 0.04),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowLg(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.12),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: color.withValues(alpha: 0.06),
      blurRadius: 6,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowXl(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.15),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: color.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowAccent(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.25),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: color.withValues(alpha: 0.12),
      blurRadius: 6,
      offset: const Offset(0, 3),
    ),
  ];

  // ── Gradient Presets ─────────────────────────────────────────────────────
  static LinearGradient get accentGradient => const LinearGradient(
    colors: [darkAccentIndigo, darkAccentViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get accentGradientLight => const LinearGradient(
    colors: [lightAccentIndigo, lightAccentViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient successGradient = LinearGradient(
    colors: [successGreen, successGreenLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient errorGradient = LinearGradient(
    colors: [errorRed, errorRedLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient warningGradient = LinearGradient(
    colors: [warningOrange, warningOrangeLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Theme Data ───────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: fontFamily,
      primaryColor: lightAccentIndigo,
      colorScheme: const ColorScheme.light(
        primary: lightAccentIndigo,
        secondary: lightAccentViolet,
        tertiary: lightAccentPink,
        surface: lightBg2,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: lightBg1,
      cardTheme: CardThemeData(
        color: lightBg2,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: lightBg4, width: 0.5),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: lightTextPrimary,
          letterSpacing: -0.3,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightBg2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: lightBg4, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: lightBg4, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: lightAccentIndigo, width: 1.5),
        ),
        labelStyle: TextStyle(
          color: lightTextSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: lightTextSecondary.withValues(alpha: 0.5),
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightAccentIndigo,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: lightBg4,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: lightAccentIndigo,
        unselectedItemColor: lightTextTertiary,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      primaryColor: darkAccentIndigo,
      colorScheme: const ColorScheme.dark(
        primary: darkAccentIndigo,
        secondary: darkAccentViolet,
        tertiary: darkAccentPink,
        surface: darkBg2,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: darkBg1,
      cardTheme: CardThemeData(
        color: darkBg2,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: darkBg4, width: 0.5),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: darkTextPrimary,
          letterSpacing: -0.3,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkBg3,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: darkBg4, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: darkBg4, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: darkAccentIndigo, width: 1.5),
        ),
        labelStyle: TextStyle(
          color: darkTextSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: darkTextSecondary.withValues(alpha: 0.5),
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkAccentIndigo,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBg4,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: darkAccentIndigo,
        unselectedItemColor: darkTextTertiary,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
