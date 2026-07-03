import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currensee/providers/theme_provider.dart';
import 'package:currensee/core/theme/app_theme.dart';
import 'package:currensee/widgets/animations.dart';
import 'package:currensee/shared/widgets/custom_button.dart';

/// Premium empty state: gradient icon badge, title, message, optional action.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final accent = theme.getAccentColor();

    return FadeInSlide(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      accent.withValues(alpha: 0.14),
                      theme.getSecondaryAccentColor().withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(icon, size: 38, color: accent),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTheme.heading3(theme.getTextColor()),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTheme.body(theme.getSecondaryTextColor()),
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 28),
                CustomButton(
                  text: actionLabel!,
                  onPressed: onAction!,
                  isFullWidth: false,
                  width: 220,
                  height: 48,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Premium error state with retry affordance.
class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    this.onRetry,
    this.retryLabel = 'Try Again',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    const errorColor = AppTheme.errorRed;

    return FadeInSlide(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: errorColor.withValues(alpha: 0.1),
                  border: Border.all(
                    color: errorColor.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: 36,
                  color: errorColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTheme.heading3(theme.getTextColor()),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.body(theme.getSecondaryTextColor()),
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 28),
                CustomButton(
                  text: retryLabel,
                  icon: Icons.refresh_rounded,
                  onPressed: onRetry!,
                  isFullWidth: false,
                  width: 200,
                  height: 48,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton building blocks for shimmer loading placeholders.
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = AppTheme.radiusSm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.getHoverColor().withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// A shimmer list of card placeholders shown while content loads.
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const SkeletonList({super.key, this.itemCount = 6, this.itemHeight = 72});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return ShimmerEffect(
      baseColor: theme.getHoverColor().withValues(alpha: 0.35),
      highlightColor: theme.getAccentColor().withValues(alpha: 0.1),
      child: Column(
        children: List.generate(itemCount, (i) {
          return Container(
            height: itemHeight,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.getCardBackgroundColor().withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: Border.all(
                color: theme.getSubtleBorderColor(),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                const SkeletonBox(
                  width: 40,
                  height: 40,
                  borderRadius: AppTheme.radiusFull,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonBox(width: 120, height: 13),
                      SizedBox(height: 8),
                      SkeletonBox(width: 80, height: 11),
                    ],
                  ),
                ),
                const SkeletonBox(width: 64, height: 22),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// Centered branded loader for full-body loading states.
class LoadingState extends StatelessWidget {
  final String? message;

  const LoadingState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: CurrencyLoader(
          size: 56,
          strokeWidth: 2.5,
          color: theme.getAccentColor(),
          message: message,
        ),
      ),
    );
  }
}
