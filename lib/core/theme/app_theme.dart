import 'package:flutter/material.dart';

class AppTheme {
  // ── Premium Color Palette ──────────────────────────────────────────────────
  // Dark Mode: Deep Space + Electric Indigo (Stripe × Linear × Revolut)
  static const Color darkBg1 = Color(0xFF07090F);        // Deepest abyss
  static const Color darkBg2 = Color(0xFF0D1117);        // GitHub-style surface
  static const Color darkBg3 = Color(0xFF161B22);        // Elevated surface
  static const Color darkBg4 = Color(0xFF21262D);        // Borders & dividers
  static const Color darkAccentIndigo = Color(0xFF6366F1); // Primary indigo
  static const Color darkAccentViolet = Color(0xFF8B5CF6); // Violet accent
  static const Color darkAccentCyan = Color(0xFF06B6D4);   // Cyan highlights
  static const Color darkAccentBlue = Color(0xFF3B82F6);   // Info blue
  static const Color darkTextPrimary = Color(0xFFF0F6FC);  // High contrast text
  static const Color darkTextSecondary = Color(0xFF8B949E); // Muted text
  static const Color darkTextTertiary = Color(0xFF484F58);  // Very muted

  // Light Mode: Soft Pearl + Professional Indigo
  static const Color lightBg1 = Color(0xFFF6F8FA);       // Canvas background
  static const Color lightBg2 = Color(0xFFFFFFFF);        // Pure white surface
  static const Color lightBg3 = Color(0xFFF0F3F6);        // Subtle alt surface
  static const Color lightBg4 = Color(0xFFD0D7DE);        // Borders
  static const Color lightAccentIndigo = Color(0xFF4F46E5); // Deeper indigo
  static const Color lightAccentViolet = Color(0xFF7C3AED); // Professional violet
  static const Color lightTextPrimary = Color(0xFF1F2328);  // Near black
  static const Color lightTextSecondary = Color(0xFF656D76); // Muted gray
  static const Color lightTextTertiary = Color(0xFF8C959F);  // Very muted

  // Status Colors (shared)
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoBlue = Color(0xFF3B82F6);

  // Rate change colors
  static const Color rateUp = Color(0xFF10B981);
  static const Color rateDown = Color(0xFFEF4444);
  static const Color rateNeutral = Color(0xFF8B949E);

  // ── Design Tokens ────────────────────────────────────────────────────────
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusFull = 999.0;

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // ── Typography ───────────────────────────────────────────────────────────
  static const String fontFamily = 'Inter';

  static TextStyle heading1(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: color,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle heading2(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: color,
    height: 1.25,
    letterSpacing: -0.3,
  );

  static TextStyle heading3(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: color,
    height: 1.3,
    letterSpacing: -0.2,
  );

  static TextStyle subtitle(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color,
    height: 1.4,
  );

  static TextStyle body(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.5,
  );

  static TextStyle bodyMedium(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: color,
    height: 1.5,
  );

  static TextStyle caption(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: color,
    height: 1.4,
  );

  static TextStyle overline(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: color,
    height: 1.4,
    letterSpacing: 0.8,
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
        surface: lightBg2,
        error: errorRed,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: lightBg1,
      cardTheme: CardThemeData(
        color: lightBg2,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: lightBg3),
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
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: lightBg3,
        thickness: 1,
        space: 1,
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
        surface: darkBg2,
        error: errorRed,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: darkBg1,
      cardTheme: CardThemeData(
        color: darkBg2,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: darkBg4),
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
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBg4,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
