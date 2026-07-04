import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currensee/providers/theme_provider.dart';
import 'package:currensee/widgets/animations.dart';

/// Auto-scrolling live market ticker tape — the fintech "trading terminal"
/// strip. Loops seamlessly; freezes when the system requests reduced motion.
class MarketTicker extends StatefulWidget {
  const MarketTicker({super.key});

  static const List<(String, double, double)> _pairs = [
    ('USD/EUR', 0.9500, 0.21),
    ('GBP/USD', 1.2710, -0.14),
    ('USD/JPY', 155.42, 0.48),
    ('USD/PKR', 280.50, -0.32),
    ('EUR/GBP', 0.8320, 0.09),
    ('USD/CAD', 1.3705, 0.17),
    ('AUD/USD', 0.6290, -0.26),
    ('USD/CHF', 0.8810, 0.11),
    ('USD/CNY', 7.2500, -0.05),
    ('USD/INR', 84.50, 0.24),
  ];

  @override
  State<MarketTicker> createState() => _MarketTickerState();
}

class _MarketTickerState extends State<MarketTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 28),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!(MediaQuery.maybeDisableAnimationsOf(context) ?? false)) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: theme.getCardBackgroundColor().withValues(alpha: theme.isDarkMode ? 0.5 : 0.75),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.getBorderColor().withValues(alpha: 0.35),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // LIVE badge
          Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.3),
                width: 0.8,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PulsingDot(color: Color(0xFF10B981), size: 6),
                SizedBox(width: 6),
                Text(
                  'LIVE',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          // Scrolling tape
          Expanded(
            child: ClipRect(
              child: OverflowBox(
                maxWidth: double.infinity,
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => FractionalTranslation(
                    translation: Offset(-_controller.value / 2, 0),
                    child: child,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < 2; i++)
                        for (final pair in MarketTicker._pairs)
                          _TickerItem(
                            pair: pair.$1,
                            rate: pair.$2,
                            change: pair.$3,
                            theme: theme,
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TickerItem extends StatelessWidget {
  final String pair;
  final double rate;
  final double change;
  final ThemeProvider theme;

  const _TickerItem({
    required this.pair,
    required this.rate,
    required this.change,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = change >= 0;
    final changeColor = isUp ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            pair,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
              color: theme.getTextColor(),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            rate.toStringAsFixed(rate >= 100 ? 2 : 4),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFamily: 'JetBrains Mono',
              fontFeatures: const [FontFeature.tabularFigures()],
              color: theme.getSecondaryTextColor(),
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            isUp ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
            color: changeColor,
            size: 18,
          ),
          Text(
            '${change.abs().toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              fontFamily: 'JetBrains Mono',
              color: changeColor,
            ),
          ),
        ],
      ),
    );
  }
}
