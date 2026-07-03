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
        ? [AppTheme.darkBg1, const Color(0xFF040512)]
        : [const Color(0xFFEEF0F7), AppTheme.lightBg2];
  }

  // ── Accent colors ─────────────────────────────────────────────────────────
  Color getAccentColor() {
    return _isDarkMode ? AppTheme.darkAccentIndigo : AppTheme.lightAccentIndigo;
  }

  Color getSecondaryAccentColor() {
    return _isDarkMode ? AppTheme.darkAccentViolet : AppTheme.lightAccentViolet;
  }

  Color getTertiaryAccentColor() {
    return _isDarkMode ? AppTheme.darkAccentPink : AppTheme.lightAccentPink;
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
        ? AppTheme.darkBg2
        : AppTheme.lightBg2;
  }

  Color getSurfaceColor() {
    return _isDarkMode ? AppTheme.darkBg3 : AppTheme.lightBg3;
  }

  Color getElevatedSurfaceColor() {
    return _isDarkMode ? AppTheme.darkBg3 : AppTheme.lightBg2;
  }

  Color getHoverColor() {
    return _isDarkMode ? AppTheme.darkBg5 : AppTheme.lightBg5;
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
        ? AppTheme.darkBg1.withValues(alpha: 0.98)
        : AppTheme.lightBg2.withValues(alpha: 0.98);
  }

  Color getBottomNavTextColor() => getAccentColor();

  Color getBottomNavUnselectedColor() {
    return _isDarkMode ? const Color(0xFF3D4452) : const Color(0xFF9CA3AF);
  }

  // ── Status colors ──────────────────────────────────────────────────────────
  Color getErrorColor() => AppTheme.errorRed;
  Color getSuccessColor() => AppTheme.successGreen;
  Color getWarningColor() => AppTheme.warningOrange;

  // ── Decoration Presets ────────────────────────────────────────────────────

  /// Premium glass card decoration
  BoxDecoration getGlassDecoration({double borderRadius = AppTheme.radiusLg}) {
    return BoxDecoration(
      color: getCardBackgroundColor().withValues(alpha: _isDarkMode ? 0.85 : 0.95),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: getBorderColor().withValues(alpha: _isDarkMode ? 0.6 : 1.0),
        width: 0.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: _isDarkMode ? 0.3 : 0.04),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: _isDarkMode ? 0.1 : 0.02),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Premium elevated card
  BoxDecoration getElevatedDecoration({double borderRadius = AppTheme.radiusLg}) {
    return BoxDecoration(
      color: getElevatedSurfaceColor(),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: getSubtleBorderColor(),
        width: 0.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: _isDarkMode ? 0.25 : 0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: _isDarkMode ? 0.1 : 0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Accent gradient decoration with glow
  BoxDecoration getAccentGradientDecoration({double borderRadius = AppTheme.radiusMd}) {
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

  /// Subtle surface decoration for list items
  BoxDecoration getItemDecoration({double borderRadius = AppTheme.radiusMd}) {
    return BoxDecoration(
      color: getCardBackgroundColor().withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: getBorderColor().withValues(alpha: 0.1),
        width: 0.5,
      ),
    );
  }

  /// Input field decoration
  BoxDecoration getInputDecoration({double borderRadius = AppTheme.radiusMd, bool isFocused = false}) {
    return BoxDecoration(
      color: _isDarkMode ? AppTheme.darkBg3 : const Color(0xFFF6F8FA),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isFocused ? getAccentColor() : getBorderColor(),
        width: isFocused ? 1.5 : 1.0,
      ),
      boxShadow: isFocused
          ? [
              BoxShadow(
                color: getAccentColor().withValues(alpha: _isDarkMode ? 0.15 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ]
          : [],
    );
  }

  /// Badge decoration
  BoxDecoration getBadgeDecoration({Color? color}) {
    final c = color ?? getAccentColor();
    return BoxDecoration(
      color: c.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      border: Border.all(color: c.withValues(alpha: 0.25), width: 0.8),
    );
  }

  /// Active state indicator
  BoxDecoration getActiveIndicator() {
    return BoxDecoration(
      color: getAccentColor(),
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(4),
        bottomRight: Radius.circular(4),
      ),
    );
  }

  /// Rating / Status dot decoration
  BoxDecoration getDotDecoration({Color? color}) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: color ?? getSuccessColor(),
      boxShadow: [
        BoxShadow(
          color: (color ?? getSuccessColor()).withValues(alpha: 0.4),
          blurRadius: 6,
          spreadRadius: 1,
        ),
      ],
    );
  }
}
