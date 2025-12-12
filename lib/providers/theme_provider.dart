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

  // Accent Color (Lime Green)
  static const Color limeAccent = Color(0xFFC1F24E);

  // Dark Mode Colors (Forest Green Theme)
  static const Color darkBg1 = Color(0xFF050F0B); // Very dark green/black
  static const Color darkBg2 = Color(0xFF0D1F18); // Dark forest green
  static const Color darkBg3 = Color(0xFF152A22); // Lighter forest green
  
  // Light Mode Colors (Clean White/Gray)
  static const Color lightBg1 = Color(0xFFF5F7FA);
  static const Color lightBg2 = Color(0xFFFFFFFF);
  static const Color lightBg3 = Color(0xFFE8ECEF);

  // Get gradient colors based on theme
  List<Color> getGradientColors() {
    return _isDarkMode
        ? [darkBg1, darkBg2, darkBg3]
        : [lightBg1, lightBg2, lightBg3];
  }

  // Get accent color
  Color getAccentColor() {
    return limeAccent;
  }

  // Get text color based on theme
  Color getTextColor() {
    return _isDarkMode ? Colors.white : Color(0xFF0A0F24);
  }

  // Get secondary text color based on theme
  Color getSecondaryTextColor() {
    return _isDarkMode ? Colors.white70 : Color(0xFF666666);
  }

  // Get card background color based on theme
  Color getCardBackgroundColor() {
    return _isDarkMode
        ? Color(0xFF1F332B) // Solid dark green card
        : Colors.white;
  }

  // Get border color based on theme
  Color getBorderColor() {
    return _isDarkMode ? Colors.white10 : Colors.grey.withOpacity(0.2);
  }

  // Get bottom nav color based on theme
  Color getBottomNavColor() {
    return _isDarkMode ? Color(0xFF0D1F18) : Colors.white;
  }

  // Get bottom nav text color based on theme
  Color getBottomNavTextColor() {
    return _isDarkMode ? limeAccent : Color(0xFF0A0F24);
  }

  // Get bottom nav unselected color based on theme
  Color getBottomNavUnselectedColor() {
    return _isDarkMode ? Colors.white54 : Color(0xFF888888);
  }
}
