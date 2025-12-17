import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/history_provider.dart';
import '../providers/alert_provider.dart';
import 'alerts_screen.dart';
import 'support_screen.dart';
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
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
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.getTextColor(),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: themeProvider.getCardBackgroundColor(),
                            shape: BoxShape.circle,
                            border: Border.all(color: themeProvider.getBorderColor()),
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: themeProvider.getTextColor(),
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
                      
                      // Print user information to console
                      if (user != null) {
                        print('=== LOGGED IN USER INFO ===');
                        print('User ID: ${user.id}');
                        print('Name: ${user.name}');
                        print('Email: ${user.email}');
                        print('Photo URL: ${user.photoUrl}');
                        print('==========================');
                      } else {
                        print('No user logged in');
                      }
                      
                      return FadeInSlide(
                        delay: 0.1,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: themeProvider.getCardBackgroundColor(),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: themeProvider.getBorderColor()),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: themeProvider.getAccentColor(),
                                    width: 3,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(user?.photoUrl ?? 'https://i.pravatar.cc/150?img=11'),
                                    fit: BoxFit.cover,
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
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: themeProvider.getAccentColor().withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: themeProvider.getAccentColor(),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              'PRO',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: themeProvider.getAccentColor(),
                                              ),
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
                      return FadeInSlide(
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
                        Text(
                          'General',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.getTextColor(),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                                  icon: Icons.person_outline,
                                  title: 'Personal Info',
                                  subtitle: 'Edit your name, email, and address',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                                    );
                                  },
                                ),
                                _buildMenuOption(
                                  themeProvider,
                                  icon: Icons.security,
                                  title: 'Security',
                                  subtitle: 'Change password and 2FA',
                                  onTap: () {},
                                ),
                              ],
                            );
                          },
                        ),
                        _buildMenuOption(
                          themeProvider,
                          icon: Icons.language,
                          title: 'Language',
                          subtitle: 'English (US)',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  FadeInSlide(
                    delay: 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Support',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.getTextColor(),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                        _buildMenuOption(
                          themeProvider,
                          icon: Icons.logout,
                          title: 'Log Out',
                          subtitle: 'Sign out of your account',
                          onTap: () async {
                            final authProvider = Provider.of<AuthProvider>(context, listen: false);
                            final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
                            await authProvider.logout();
                            await historyProvider.updateUserId(null);
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
          ),
        );
      },
    );
  }

  Widget _buildStatCard(ThemeProvider themeProvider, String title, String value, IconData icon, VoidCallback onTap) {
    return ScaleButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeProvider.getCardBackgroundColor(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: themeProvider.getBorderColor()),
        ),
        child: Column(
          children: [
            Icon(icon, color: themeProvider.getAccentColor(), size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.getTextColor(),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
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
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withOpacity(0.1)
              : themeProvider.getAccentColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : themeProvider.getAccentColor(),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDestructive ? Colors.red : themeProvider.getTextColor(),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: themeProvider.getSecondaryTextColor(),
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: themeProvider.getSecondaryTextColor(),
        size: 20,
      ),
    );
  }
}
