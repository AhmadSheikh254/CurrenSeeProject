import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool useHover;
  final Color? customBgColor;
  final bool hasBorder;
  final double? width;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.padding,
    this.margin,
    this.onTap,
    this.useHover = false,
    this.customBgColor,
    this.hasBorder = true,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    Widget card = Container(
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: customBgColor ?? themeProvider.getCardBackgroundColor().withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(borderRadius),
        border: hasBorder
            ? Border.all(
                color: themeProvider.getBorderColor().withValues(alpha: themeProvider.isDarkMode ? 0.6 : 0.8),
                width: 0.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: themeProvider.isDarkMode ? 0.3 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: themeProvider.isDarkMode ? 0.1 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // Specular top edge — the "liquid glass" light-catching highlight
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.08],
          colors: [
            Colors.white.withValues(alpha: themeProvider.isDarkMode ? 0.06 : 0.5),
            Colors.white.withValues(alpha: 0.0),
          ],
        ),
      ),
      padding: padding ?? const EdgeInsets.all(20),
      child: child,
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: themeProvider.getAccentColor().withValues(alpha: 0.05),
          highlightColor: themeProvider.getAccentColor().withValues(alpha: 0.03),
          child: card,
        ),
      );
    }

    return card;
  }
}
