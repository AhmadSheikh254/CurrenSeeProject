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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
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
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final colors = themeProvider.getGradientColors();
        
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleIn(
                    duration: 1.0,
                    child: Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeProvider.getCardBackgroundColor(),
                            border: Border.all(
                              color: themeProvider.getBorderColor(),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: themeProvider.getAccentColor().withValues(alpha: 0.2),
                                blurRadius: 24,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.currency_exchange_rounded,
                            size: 56,
                            color: themeProvider.getAccentColor(),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'CurrenSee',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.getTextColor(),
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Smart Currency Conversion',
                          style: TextStyle(
                            fontSize: 16,
                            color: themeProvider.getSecondaryTextColor(),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 64),
                  CurrencyLoader(
                    color: themeProvider.getAccentColor(),
                    size: 48,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

