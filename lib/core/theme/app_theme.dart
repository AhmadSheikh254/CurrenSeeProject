import 'package:flutter/material.dart';

class AppTheme {
  // Premium Color Palette
  // Dark Mode: Deep Midnight & Electric Indigo
  static const Color darkBg1 = Color(0xFF0F172A); // Deep Navy/Slate
  static const Color darkBg2 = Color(0xFF1E293B); // Slate Blue
  static const Color darkBg3 = Color(0xFF334155); // Lighter Slate
  static const Color darkAccentIndigo = Color(0xFF6366F1); // Electric Indigo
  static const Color darkAccentViolet = Color(0xFF8B5CF6); // Vibrant Violet
  
  // Light Mode: Soft Pearl & Royal Blue
  static const Color lightBg1 = Color(0xFFF5F3FF); // Very Soft Indigo Tint
  static const Color lightBg2 = Color(0xFFFFFFFF); // Pure White
  static const Color lightBg3 = Color(0xFFEDE9FE); // Soft Violet Tint
  static const Color lightAccentIndigo = Color(0xFF4F46E5); // Professional Indigo
  static const Color lightAccentViolet = Color(0xFF7C3AED); // Professional Violet

  static const Color errorRed = Color(0xFFEF4444); // Modern Red

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: lightAccentIndigo,
        secondary: lightAccentViolet,
        surface: lightBg2,
        error: errorRed,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: lightBg1,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkAccentIndigo,
        secondary: darkAccentViolet,
        surface: darkBg1,
        error: errorRed,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: darkBg1,
    );
  }
}
