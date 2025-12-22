import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/history_provider.dart';
import 'providers/alert_provider.dart';
import 'providers/preferences_provider.dart';
import 'providers/feedback_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
          final colors = themeProvider.getGradientColors();
          final accentColor = themeProvider.getAccentColor();
          
          return MaterialApp(
            title: 'CurrenSee',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: accentColor,
                primary: accentColor, // Explicitly set primary to ensure it's used
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: colors.first, // Ensure background matches gradient start or solid
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: accentColor,
                brightness: Brightness.dark,
                primary: accentColor,
                surface: colors.first, // Dark mode surface
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: colors.first,
            ),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
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

