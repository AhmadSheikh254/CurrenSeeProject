import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  // Premium Color Palette
  // Dark Mode: Deep Midnight & Electric Indigo
  static const Color darkBg1 = Color(0xFF0F172A); // Deep Navy/Slate
  static const Color darkBg2 = Color(0xFF1E293B); // Slate Blue
  static const Color darkBg3 = Color(0xFF334155); // Lighter Slate
  static const Color accentIndigo = Color(0xFF6366F1); // Electric Indigo
  static const Color accentViolet = Color(0xFF8B5CF6); // Vibrant Violet
  
  // Light Mode: Soft Pearl & Royal Blue (Updated to Soft Indigo/Violet)
  static const Color lightBg1 = Color(0xFFF5F3FF); // Very Soft Indigo Tint
  static const Color lightBg2 = Color(0xFFFFFFFF); // Pure White
  static const Color lightBg3 = Color(0xFFEDE9FE); // Soft Violet Tint
  static const Color lightAccentIndigo = Color(0xFF4F46E5); // Professional Indigo
  static const Color lightAccentViolet = Color(0xFF7C3AED); // Professional Violet

  // Get gradient colors based on theme
  List<Color> getGradientColors() {
    return _isDarkMode
        ? [darkBg1, Color(0xFF020617)] // Deep Midnight Gradient
        : [Color(0xFFEEF2FF), lightBg2]; // Soft Indigo to White
  }

  // Get accent color
  Color getAccentColor() {
    return _isDarkMode ? accentIndigo : lightAccentIndigo;
  }

  // Get secondary accent color
  Color getSecondaryAccentColor() {
    return _isDarkMode ? accentViolet : lightAccentViolet;
  }

  // Get text color based on theme
  Color getTextColor() {
    return _isDarkMode ? Color(0xFFF1F5F9) : Color(0xFF1E293B);
  }

  // Get secondary text color based on theme
  Color getSecondaryTextColor() {
    return _isDarkMode ? Color(0xFF94A3B8) : Color(0xFF64748B);
  }

  // Get card background color based on theme
  Color getCardBackgroundColor() {
    return _isDarkMode
        ? Color(0xFF1E293B).withOpacity(0.7) // Translucent for glass effect
        : Colors.white.withOpacity(0.9);
  }

  // Get border color based on theme
  Color getBorderColor() {
    return _isDarkMode ? Colors.white.withOpacity(0.1) : Color(0xFFE0E7FF);
  }

  // Get bottom nav color based on theme
  Color getBottomNavColor() {
    return _isDarkMode ? Color(0xFF0F172A).withOpacity(0.95) : Colors.white.withOpacity(0.95);
  }

  // Get bottom nav text color based on theme
  Color getBottomNavTextColor() {
    return getAccentColor();
  }

  // Get bottom nav unselected color based on theme
  Color getBottomNavUnselectedColor() {
    return _isDarkMode ? Color(0xFF64748B) : Color(0xFF94A3B8);
  }

  // Get error color
  Color getErrorColor() {
    return Color(0xFFEF4444); // Modern Red
  }

  // Glassmorphism helper
  BoxDecoration getGlassDecoration({double borderRadius = 16.0}) {
    return BoxDecoration(
      color: getCardBackgroundColor(),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: getBorderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(_isDarkMode ? 0.3 : 0.05),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}
