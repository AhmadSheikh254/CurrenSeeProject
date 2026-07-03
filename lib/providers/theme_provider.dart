import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

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

  // ── Gradient backgrounds ───────────────────────────────────────────────────
  List<Color> getGradientColors() {
    return _isDarkMode
        ? [AppTheme.darkBg1, const Color(0xFF050710)]
        : [const Color(0xFFF0F2FF), AppTheme.lightBg2];
  }

  // ── Accent colors ─────────────────────────────────────────────────────────
  Color getAccentColor() {
    return _isDarkMode ? AppTheme.darkAccentIndigo : AppTheme.lightAccentIndigo;
  }

  Color getSecondaryAccentColor() {
    return _isDarkMode ? AppTheme.darkAccentViolet : AppTheme.lightAccentViolet;
  }

  // ── Text colors ────────────────────────────────────────────────────────────
  Color getTextColor() {
    return _isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
  }

  Color getSecondaryTextColor() {
    return _isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
  }

  Color getTertiaryTextColor() {
    return _isDarkMode ? AppTheme.darkTextTertiary : AppTheme.lightTextTertiary;
  }

  // ── Surface colors ────────────────────────────────────────────────────────
  Color getCardBackgroundColor() {
    return _isDarkMode
        ? AppTheme.darkBg2.withValues(alpha: 0.85)
        : AppTheme.lightBg2.withValues(alpha: 0.95);
  }

  Color getSurfaceColor() {
    return _isDarkMode ? AppTheme.darkBg3 : AppTheme.lightBg3;
  }

  Color getElevatedSurfaceColor() {
    return _isDarkMode ? AppTheme.darkBg3 : AppTheme.lightBg2;
  }

  // ── Border & divider colors ────────────────────────────────────────────────
  Color getBorderColor() {
    return _isDarkMode ? AppTheme.darkBg4 : const Color(0xFFE5E7EB);
  }

  Color getSubtleBorderColor() {
    return _isDarkMode
        ? AppTheme.darkBg4.withValues(alpha: 0.5)
        : const Color(0xFFF0F0F0);
  }

  // ── Navigation colors ─────────────────────────────────────────────────────
  Color getBottomNavColor() {
    return _isDarkMode
        ? AppTheme.darkBg1.withValues(alpha: 0.97)
        : AppTheme.lightBg2.withValues(alpha: 0.97);
  }

  Color getBottomNavTextColor() => getAccentColor();

  Color getBottomNavUnselectedColor() {
    return _isDarkMode ? const Color(0xFF484F58) : const Color(0xFF94A3B8);
  }

  // ── Status colors ──────────────────────────────────────────────────────────
  Color getErrorColor() => AppTheme.errorRed;
  Color getSuccessColor() => AppTheme.successGreen;
  Color getWarningColor() => AppTheme.warningOrange;

  // ── Sidebar colors ────────────────────────────────────────────────────────
  Color getSidebarBackground() {
    return _isDarkMode ? const Color(0xFF0A0D14) : const Color(0xFFF8F9FB);
  }

  Color getSidebarActiveItemBg() {
    return getAccentColor().withValues(alpha: _isDarkMode ? 0.12 : 0.08);
  }

  Color getSidebarActiveIndicator() => getAccentColor();

  // ── Premium card decoration ────────────────────────────────────────────────
  BoxDecoration getGlassDecoration({double borderRadius = 16.0}) {
    return BoxDecoration(
      color: getCardBackgroundColor(),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: getBorderColor().withValues(alpha: _isDarkMode ? 0.6 : 1.0),
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: _isDarkMode ? 0.3 : 0.03),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        if (!_isDarkMode)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
      ],
    );
  }

  // ── Premium elevated card ──────────────────────────────────────────────────
  BoxDecoration getElevatedDecoration({double borderRadius = 16.0}) {
    return BoxDecoration(
      color: getElevatedSurfaceColor(),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: getSubtleBorderColor(),
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: _isDarkMode ? 0.25 : 0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ── Accent gradient decoration ─────────────────────────────────────────────
  BoxDecoration getAccentGradientDecoration({double borderRadius = 12.0}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: LinearGradient(
        colors: [getAccentColor(), getSecondaryAccentColor()],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: getAccentColor().withValues(alpha: 0.3),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
