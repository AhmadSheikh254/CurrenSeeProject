import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/history_provider.dart';
import '../providers/alert_provider.dart';
import 'alerts_screen.dart';
import 'feedback_screen.dart';
import 'personal_info_screen.dart';
import '../widgets/animations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final colors = themeProvider.getGradientColors();

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 110, 24, 120),
              child: Column(
                children: [
                  // Header
                  FadeInSlide(
                    delay: 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                            color: themeProvider.getTextColor(),
                          ),
                        ),
                        ScaleButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AlertsScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: themeProvider.getGlassDecoration(borderRadius: 16).copyWith(
                              color: themeProvider.getCardBackgroundColor().withOpacity(0.35),
                              border: Border.all(color: themeProvider.getBorderColor().withOpacity(0.15)),
                            ),
                            child: Icon(
                              Icons.notifications_active_rounded,
                              color: themeProvider.getTextColor(),
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Profile Card
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      final user = authProvider.user;
                      
                      return ScaleIn(
                        delay: 0.1,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: themeProvider.getGlassDecoration(borderRadius: 20),
                          child: Row(
                            children: [
                              Hero(
                                tag: 'profile_avatar',
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [themeProvider.getAccentColor(), themeProvider.getSecondaryAccentColor()],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: themeProvider.getAccentColor().withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                      image: DecorationImage(
                                        image: NetworkImage(user?.photoUrl ?? 'https://api.dicebear.com/7.x/lorelei/png?seed=CurrenSee'),
                                        fit: BoxFit.cover,
                                      ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          user?.name ?? 'Guest User',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: themeProvider.getTextColor(),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (user != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [themeProvider.getAccentColor(), themeProvider.getSecondaryAccentColor()],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: themeProvider.getAccentColor().withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.star, color: Colors.white, size: 10),
                                                SizedBox(width: 4),
                                                Text(
                                                  'PRO',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user?.email ?? 'Sign in to see details',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: themeProvider.getSecondaryTextColor(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (user != null)
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color: themeProvider.getAccentColor(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Stats Grid
                  Consumer2<HistoryProvider, AlertProvider>(
                    builder: (context, historyProvider, alertProvider, child) {
                      return ScaleIn(
                        delay: 0.2,
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                themeProvider,
                                'Conversions',
                                historyProvider.conversions.length.toString(),
                                Icons.swap_horiz,
                                () {
                                  // Navigate to history tab (index 2)
                                  // This assumes the parent is HomeScreen and we can switch tabs
                                  // For now, we'll just show a snackbar or do nothing as History is on main screen
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                themeProvider,
                                'Saved',
                                historyProvider.savedCount.toString(),
                                Icons.bookmark_outline,
                                () {},
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                themeProvider,
                                'Alerts',
                                alertProvider.alerts.length.toString(),
                                Icons.notifications_active_outlined,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AlertsScreen()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Menu Section
                  FadeInSlide(
                    delay: 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 12),
                          child: Text(
                            'General',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.getTextColor(),
                            ),
                          ),
                        ),
                        Container(
                          decoration: themeProvider.getGlassDecoration(borderRadius: 24),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            children: [
                              Consumer<AuthProvider>(
                                builder: (context, authProvider, child) {
                                  final isGuest = authProvider.user == null;
                                  
                                  if (isGuest) {
                                    return _buildMenuOption(
                                      themeProvider,
                                      icon: Icons.login,
                                      title: 'Sign In / Sign Up',
                                      subtitle: 'Create an account to save data',
                                      onTap: () {
                                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                                      },
                                    );
                                  }
                                  
                                  return Column(
                                    children: [
                                      _buildMenuOption(
                                        themeProvider,
                                        icon: Icons.person_outline_rounded,
                                        title: 'Personal Info',
                                        subtitle: 'Edit your name, email, and address',
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Divider(height: 1, color: themeProvider.getBorderColor().withOpacity(0.3)),
                                      ),
                                      _buildMenuOption(
                                        themeProvider,
                                        icon: Icons.security_rounded,
                                        title: 'Security',
                                        subtitle: 'Change password and 2FA',
                                        onTap: () {},
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Divider(height: 1, color: themeProvider.getBorderColor().withOpacity(0.3)),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              _buildMenuOption(
                                themeProvider,
                                icon: Icons.language_rounded,
                                title: 'Language',
                                subtitle: 'English (US)',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  FadeInSlide(
                    delay: 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 12),
                          child: Text(
                            'Support',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.getTextColor(),
                            ),
                          ),
                        ),
                        Container(
                          decoration: themeProvider.getGlassDecoration(borderRadius: 24),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            children: [
                              _buildMenuOption(
                                themeProvider,
                                icon: Icons.feedback_outlined,
                                title: 'Feedback',
                                subtitle: 'Send us your feedback or report issues',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(height: 1, color: themeProvider.getBorderColor().withOpacity(0.3)),
                              ),
                              _buildMenuOption(
                                themeProvider,
                                icon: Icons.logout_rounded,
                                title: 'Log Out',
                                subtitle: 'Sign out of your account',
                                isDestructive: true,
                                onTap: () async {
                                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                  await authProvider.logout();
                                  if (context.mounted) {
                                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  FadeInSlide(
                    delay: 0.5,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: themeProvider.getGlassDecoration(borderRadius: 20),
                        child: Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            fontSize: 12,
                            color: themeProvider.getSecondaryTextColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(ThemeProvider themeProvider, String title, String value, IconData icon, VoidCallback onTap) {
    return ScaleButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: themeProvider.getGlassDecoration(borderRadius: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: themeProvider.getAccentColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: themeProvider.getAccentColor(), size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: themeProvider.getTextColor(),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: themeProvider.getSecondaryTextColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    ThemeProvider themeProvider, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? Colors.red.withOpacity(0.1)
                      : themeProvider.getAccentColor().withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? Colors.red : themeProvider.getAccentColor(),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? Colors.red : themeProvider.getTextColor(),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: themeProvider.getSecondaryTextColor(),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: themeProvider.getSecondaryTextColor(),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
