import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currensee/widgets/page_transitions.dart';
import 'package:currensee/providers/theme_provider.dart';
import 'package:currensee/features/auth/presentation/providers/auth_provider.dart';
import 'package:currensee/providers/history_provider.dart';
import 'package:currensee/providers/alert_provider.dart';
import 'package:currensee/providers/preferences_provider.dart';
import 'package:currensee/providers/feedback_provider.dart';
import 'package:currensee/features/currency/presentation/screens/splash_screen.dart';
import 'package:currensee/features/auth/presentation/screens/login_screen.dart';
import 'package:currensee/features/auth/presentation/screens/signup_screen.dart';
import 'package:currensee/features/currency/presentation/screens/home_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:currensee/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize providers
  final authProvider = AuthProvider();
  
  // Load saved data
  await authProvider.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProxyProvider<AuthProvider, HistoryProvider>(
          create: (_) => HistoryProvider(),
          update: (_, auth, history) {
            final historyProvider = history ?? HistoryProvider();
            if (historyProvider.userId != auth.user?.id) {
              historyProvider.updateUserId(auth.user?.id);
            }
            return historyProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => AlertProvider()),
        ChangeNotifierProvider(create: (_) => PreferencesProvider()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'CurrenSee',
            theme: AppTheme.lightTheme.copyWith(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionsBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionsBuilder(),
                  TargetPlatform.windows: CustomPageTransitionsBuilder(),
                  TargetPlatform.macOS: CustomPageTransitionsBuilder(),
                  TargetPlatform.linux: CustomPageTransitionsBuilder(),
                },
              ),
            ),
            darkTheme: AppTheme.darkTheme.copyWith(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionsBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionsBuilder(),
                  TargetPlatform.windows: CustomPageTransitionsBuilder(),
                  TargetPlatform.macOS: CustomPageTransitionsBuilder(),
                  TargetPlatform.linux: CustomPageTransitionsBuilder(),
                },
              ),
            ),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            themeAnimationDuration: const Duration(milliseconds: 400),
            themeAnimationCurve: Curves.easeOutCubic,
          home: const SplashScreen(),
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/home': (context) => const HomeScreen(isGuest: false),
            '/home_guest': (context) => const HomeScreen(isGuest: true),
          },
        );
      },
    );
  }
}


