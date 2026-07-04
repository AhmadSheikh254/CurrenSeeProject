import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currensee/providers/theme_provider.dart';
import 'package:currensee/features/auth/presentation/providers/auth_provider.dart';
import 'package:currensee/widgets/animations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.isAuthenticated) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final colors = themeProvider.getGradientColors();
        final accentColor = themeProvider.getAccentColor();

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -120,
                  right: -80,
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withValues(alpha: 0.12),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.08),
                          blurRadius: 80,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100,
                  left: -60,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeProvider.getSecondaryAccentColor().withValues(alpha: 0.08),
                      boxShadow: [
                        BoxShadow(
                          color: themeProvider.getSecondaryAccentColor().withValues(alpha: 0.05),
                          blurRadius: 60,
                          spreadRadius: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleIn(
                        duration: 1.0,
                        child: ScaleTransition(
                          scale: _pulseAnimation,
                          child: Column(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [accentColor, themeProvider.getSecondaryAccentColor()],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accentColor.withValues(alpha: 0.3),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                    BoxShadow(
                                      color: themeProvider.getSecondaryAccentColor().withValues(alpha: 0.2),
                                      blurRadius: 50,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.currency_exchange_rounded,
                                    size: 56,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                'CurrenSee',
                                style: TextStyle(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w800,
                                  color: themeProvider.getTextColor(),
                                  letterSpacing: -1.0,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Smart Currency Conversion',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: themeProvider.getSecondaryTextColor(),
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 64),
                      CurrencyLoader(
                        color: accentColor,
                        size: 48,
                        strokeWidth: 2.5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
