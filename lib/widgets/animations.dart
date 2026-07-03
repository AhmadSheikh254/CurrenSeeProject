import 'package:flutter/material.dart';
import 'dart:math' as math;

// ──────────────────────────────────────────────────────────────────────────────
// 1. FADE IN SLIDE — Entrance animation with fade + slide
// ──────────────────────────────────────────────────────────────────────────────
class FadeInSlide extends StatefulWidget {
  final Widget child;
  final double delay;
  final double duration;
  final Offset beginOffset;

  const FadeInSlide({
    super.key,
    required this.child,
    this.delay = 0.0,
    this.duration = 0.5,
    this.beginOffset = const Offset(0, 0.15),
  });

  @override
  State<FadeInSlide> createState() => _FadeInSlideState();
}

class _FadeInSlideState extends State<FadeInSlide> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.duration * 1000).round()),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _slideAnimation = Tween<Offset>(begin: widget.beginOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).round()), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 2. SCALE BUTTON — Press-to-scale tactile button
// ──────────────────────────────────────────────────────────────────────────────
class ScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double scale;

  const ScaleButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.scale = 0.96,
  });

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 3. SCALE IN — Scale + fade entrance animation
// ──────────────────────────────────────────────────────────────────────────────
class ScaleIn extends StatefulWidget {
  final Widget child;
  final double delay;
  final double duration;

  const ScaleIn({
    super.key,
    required this.child,
    this.delay = 0.0,
    this.duration = 0.5,
  });

  @override
  State<ScaleIn> createState() => _ScaleInState();
}

class _ScaleInState extends State<ScaleIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.duration * 1000).round()),
    );
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).round()), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 4. STAGGERED LIST — Column with auto-staggered fade-in children
// ──────────────────────────────────────────────────────────────────────────────
class StaggeredList extends StatelessWidget {
  final List<Widget> children;
  final double delayIncrement;

  const StaggeredList({
    super.key,
    required this.children,
    this.delayIncrement = 0.08,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.asMap().entries.map((entry) {
        return FadeInSlide(
          delay: entry.key * delayIncrement,
          child: entry.value,
        );
      }).toList(),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 5. PREMIUM BRANDED LOADER — Currency-themed loading animation
// ──────────────────────────────────────────────────────────────────────────────
class CurrencyLoader extends StatefulWidget {
  final double size;
  final Color? color;
  final String? message;
  final double strokeWidth;

  const CurrencyLoader({
    super.key,
    this.size = 80.0,
    this.color,
    this.message,
    this.strokeWidth = 3.0,
  });

  @override
  State<CurrencyLoader> createState() => _CurrencyLoaderState();
}

class _CurrencyLoaderState extends State<CurrencyLoader>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.color ?? const Color(0xFF6366F1);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: AnimatedBuilder(
                animation: _rotateController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _CurrencyLoaderPainter(
                      color: accentColor,
                      progress: _rotateController.value,
                      strokeWidth: widget.strokeWidth,
                    ),
                    child: Center(
                      child: Text(
                        '¤',
                        style: TextStyle(
                          fontSize: widget.size * 0.32,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 20),
            Text(
              widget.message!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: accentColor.withValues(alpha: 0.7),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CurrencyLoaderPainter extends CustomPainter {
  final Color color;
  final double progress;
  final double strokeWidth;

  _CurrencyLoaderPainter({required this.color, required this.progress, this.strokeWidth = 3.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // Outer track ring
    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius - 2, trackPaint);

    // Inner subtle ring
    final innerTrackPaint = Paint()
      ..color = color.withValues(alpha: 0.04)
      ..strokeWidth = strokeWidth * 0.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius * 0.7, innerTrackPaint);

    // Animated gradient arc
    final sweepAngle = math.pi * 0.8;
    final startAngle = progress * 2 * math.pi - math.pi / 2;

    final arcPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.6),
          color,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius - 2));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 2),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // Leading dot
    final dotX = center.dx + (radius - 2) * math.cos(startAngle + sweepAngle);
    final dotY = center.dy + (radius - 2) * math.sin(startAngle + sweepAngle);
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(dotX, dotY), 3.5, dotPaint);

    // Glow around leading dot
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(dotX, dotY), 5, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _CurrencyLoaderPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// Keep backward-compatible alias
class CustomAnimatedLoader extends StatelessWidget {
  final Color color;
  final double size;

  const CustomAnimatedLoader({
    super.key,
    this.color = Colors.white,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return CurrencyLoader(size: size, color: color);
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 6. FULL SCREEN LOADER — Branded full-screen loading overlay
// ──────────────────────────────────────────────────────────────────────────────
class FullScreenLoader extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? accentColor;

  const FullScreenLoader({
    super.key,
    this.message,
    this.backgroundColor,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? const Color(0xFF090E1A);
    return Container(
      color: bgColor,
      child: Center(
        child: CurrencyLoader(
          size: 80,
          color: accentColor ?? const Color(0xFF6366F1),
          message: message ?? 'Loading...',
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 7. SHIMMER EFFECT — Premium content placeholder
// ──────────────────────────────────────────────────────────────────────────────
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.baseColor ?? const Color(0xFF1E2E4A).withValues(alpha: 0.3);
    final highlight = widget.highlightColor ?? const Color(0xFF6366F1).withValues(alpha: 0.08);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [base, highlight, base],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value,
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 8. HOVER SCALE — Desktop hover effect for cards
// ──────────────────────────────────────────────────────────────────────────────
class HoverScale extends StatefulWidget {
  final Widget child;
  final double scale;
  final double liftAmount;

  const HoverScale({
    super.key,
    required this.child,
    this.scale = 1.02,
    this.liftAmount = 4.0,
  });

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: (Matrix4.identity()
          // ignore: deprecated_member_use
          ..translate(0.0, _isHovered ? -widget.liftAmount : 0.0, 0.0)
          // ignore: deprecated_member_use
          ..scale(_isHovered ? widget.scale : 1.0)),
        child: widget.child,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 9. ANIMATED COUNTER — Counting number animation
// ──────────────────────────────────────────────────────────────────────────────
class AnimatedCounter extends StatelessWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;
  final String? prefix;
  final String? suffix;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 800),
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, val, child) {
        return Text(
          '${prefix ?? ''}$val${suffix ?? ''}',
          style: style,
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 10. PULSING DOT — Live status indicator
// ──────────────────────────────────────────────────────────────────────────────
class PulsingDot extends StatefulWidget {
  final Color color;
  final double size;
  final double glowIntensity;

  const PulsingDot({
    super.key,
    this.color = const Color(0xFF10B981),
    this.size = 8.0,
    this.glowIntensity = 1.0,
  });

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.4 * _controller.value * widget.glowIntensity),
                blurRadius: 6 * _controller.value * widget.glowIntensity,
                spreadRadius: 2 * _controller.value * widget.glowIntensity,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 11. DOTS DECORATION — Background ambient dots for premium feel
// ──────────────────────────────────────────────────────────────────────────────
class AmbientDots extends StatelessWidget {
  final Color color;
  final double opacity;

  const AmbientDots({
    super.key,
    this.color = const Color(0xFF6366F1),
    this.opacity = 0.03,
  });

  @override
  Widget build(BuildContext context) {
    final random = math.Random(42);
    return CustomPaint(
      painter: _DotsPainter(color: color, opacity: opacity, random: random),
    );
  }
}

class _DotsPainter extends CustomPainter {
  final Color color;
  final double opacity;
  final math.Random random;

  _DotsPainter({required this.color, required this.opacity, required this.random});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final dotCount = (size.width * size.height / 80000).round().clamp(5, 40);
    for (int i = 0; i < dotCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final r = random.nextDouble() * 2.5 + 0.5;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ──────────────────────────────────────────────────────────────────────────────
// 12. GLOW OVERLAY — Premium ambient glow positioned
// ──────────────────────────────────────────────────────────────────────────────
class GlowOverlay extends StatelessWidget {
  final Color color;
  final double size;
  final double top;
  final double left;
  final double right;
  final double bottom;
  final double opacity;

  const GlowOverlay({
    super.key,
    required this.color,
    this.size = 300,
    this.top = -100,
    this.left = -100,
    this.right = 0,
    this.bottom = 0,
    this.opacity = 0.12,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: opacity * 0.5),
              blurRadius: size * 0.5,
              spreadRadius: size * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
