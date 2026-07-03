import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currensee/providers/theme_provider.dart';
import 'package:currensee/providers/preferences_provider.dart';
import 'package:currensee/features/auth/presentation/providers/auth_provider.dart';
import 'package:currensee/widgets/animations.dart';
import 'package:currensee/core/utils/avatar_helper.dart';
import 'package:currensee/shared/widgets/responsive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, PreferencesProvider, AuthProvider>(
      builder: (context, themeProvider, preferencesProvider, authProvider, child) {
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
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              child: ResponsiveCenter(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScaleIn(
                    delay: 0.0,
                    child: _buildProfileHeader(themeProvider, authProvider),
                  ),
                  const SizedBox(height: 32),
                  // App Preferences Section
                  FadeInSlide(
                    delay: 0.1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(themeProvider, 'App Preferences', Icons.tune_rounded),
                        const SizedBox(height: 16),
                        _buildToggleSetting(
                          themeProvider,
                          'Dark Mode',
                          'Use dark theme',
                          themeProvider.isDarkMode,
                          (value) {
                            themeProvider.setDarkMode(value);
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildToggleSetting(
                          themeProvider,
                          'Push Notifications',
                          'Receive currency alerts',
                          preferencesProvider.notificationsEnabled,
                          (value) {
                            preferencesProvider.setNotificationsEnabled(value);
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Notifications enabled')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Account Settings Section
                  FadeInSlide(
                    delay: 0.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(themeProvider, 'Account Settings', Icons.person_outline_rounded),
                        const SizedBox(height: 16),
                        _buildDropdownSetting(
                          themeProvider,
                          'Default Currency',
                          preferencesProvider.defaultBaseCurrency,
                          ['USD', 'EUR', 'GBP', 'JPY', 'INR'],
                          (value) {
                            preferencesProvider.setDefaultBaseCurrency(value);
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownSetting(
                          themeProvider,
                          'Language',
                          _selectedLanguage,
                          ['English', 'Spanish', 'French', 'German', 'Chinese'],
                          (value) {
                            setState(() {
                              _selectedLanguage = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Security Section
                  FadeInSlide(
                    delay: 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(themeProvider, 'Security', Icons.security_rounded),
                        const SizedBox(height: 16),
                        _buildSettingsTile(
                          themeProvider,
                          'Change Password',
                          'Update your password',
                          Icons.lock_outline_rounded,
                          () {
                            _showChangePasswordDialog(context, themeProvider);
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildSettingsTile(
                          themeProvider,
                          'Two-Factor Authentication',
                          'Enable 2FA for security',
                          Icons.verified_user_outlined,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('2FA feature coming soon'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // About Section
                  FadeInSlide(
                    delay: 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(themeProvider, 'About', Icons.info_outline_rounded),
                        const SizedBox(height: 16),
                        _buildSettingsTile(
                          themeProvider,
                          'Privacy Policy',
                          'Read our privacy policy',
                          Icons.privacy_tip_outlined,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening privacy policy...'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildSettingsTile(themeProvider, 'Terms of Service', 'Read our terms', Icons.description_outlined, () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Opening terms of service...'),
                            ),
                          );
                        }),
                        const SizedBox(height: 12),
                        _buildSettingsTile(themeProvider, 'About CurrenSee', 'Version 1.0.0', Icons.apps_rounded, () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'CurrenSee v1.0.0 - Currency Conversion App',
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Logout Button
                  FadeInSlide(
                    delay: 0.5,
                    child: SizedBox(
                      width: double.infinity,
                        child: ScaleButton(
                          onPressed: () {
                            _showLogoutDialog(context, themeProvider);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red.shade400, Colors.red.shade700],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                                SizedBox(width: 12),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(ThemeProvider themeProvider, AuthProvider authProvider) {
    final user = authProvider.user;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: themeProvider.getGlassDecoration(borderRadius: 28).copyWith(
        color: themeProvider.getCardBackgroundColor().withValues(alpha: 0.35),
        border: Border.all(
          color: themeProvider.getBorderColor().withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [themeProvider.getAccentColor(), themeProvider.getSecondaryAccentColor()],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: themeProvider.getAccentColor().withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeProvider.getCardBackgroundColor(),
                image: DecorationImage(
                  image: getUserAvatarProvider(user?.photoUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'User',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: themeProvider.getTextColor(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'user@example.com',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: themeProvider.getSecondaryTextColor(),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        themeProvider.getAccentColor(),
                        themeProvider.getSecondaryAccentColor(),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: themeProvider.getAccentColor().withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'PRO MEMBER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeProvider themeProvider, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: themeProvider.getCardBackgroundColor(),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: themeProvider.getBorderColor().withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: themeProvider.getAccentColor(),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.getAccentColor(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Divider(
              color: themeProvider.getBorderColor().withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSetting(
    ThemeProvider themeProvider,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.getCardBackgroundColor().withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: themeProvider.getBorderColor().withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.getTextColor(),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: themeProvider.getSecondaryTextColor()),
              ),
            ],
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: themeProvider.getAccentColor(),
            activeTrackColor: themeProvider.getAccentColor().withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    ThemeProvider themeProvider,
    String title,
    String currentValue,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.getCardBackgroundColor().withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: themeProvider.getBorderColor().withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: themeProvider.getTextColor(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: themeProvider.getCardBackgroundColor(),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: themeProvider.getBorderColor()),
            ),
            child: DropdownButton<String>(
              value: currentValue,
              dropdownColor: themeProvider.getCardBackgroundColor(),
              items: options.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: TextStyle(
                      color: themeProvider.getTextColor(),
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
              style: TextStyle(color: themeProvider.getTextColor()),
              underline: const SizedBox(),
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: themeProvider.getTextColor(), size: 20),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(ThemeProvider themeProvider, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeProvider.getCardBackgroundColor().withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: themeProvider.getBorderColor().withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeProvider.getAccentColor().withValues(alpha: 0.2),
                    themeProvider.getSecondaryAccentColor().withValues(alpha: 0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: themeProvider.getAccentColor(),
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
                      fontWeight: FontWeight.bold,
                      color: themeProvider.getTextColor(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: themeProvider.getSecondaryTextColor()),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: themeProvider.getSecondaryTextColor(),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, ThemeProvider themeProvider) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: themeProvider.getCardBackgroundColor(),
          title: Text(
            'Change Password',
            style: TextStyle(
              color: themeProvider.getTextColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentPasswordController,
                  obscureText: true,
                  style: TextStyle(color: themeProvider.getTextColor()),
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    labelStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: themeProvider.getBorderColor()),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: themeProvider.getAccentColor()),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  style: TextStyle(color: themeProvider.getTextColor()),
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: themeProvider.getBorderColor()),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: themeProvider.getAccentColor()),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  style: TextStyle(color: themeProvider.getTextColor()),
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    labelStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: themeProvider.getBorderColor()),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: themeProvider.getAccentColor()),
                    ),
                  ),
                  validator: (value) {
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: themeProvider.getTextColor()),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  final success = await authProvider.changePassword(
                    currentPasswordController.text,
                    newPasswordController.text,
                  );
                  
                  if (context.mounted) {
                    Navigator.pop(context);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password changed successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Incorrect current password'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: Text(
                'Update',
                style: TextStyle(
                  color: themeProvider.getAccentColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          backgroundColor: themeProvider.getCardBackgroundColor(),
          titleTextStyle: TextStyle(
            color: themeProvider.getTextColor(),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(
            color: themeProvider.getSecondaryTextColor(),
            fontSize: 16,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: themeProvider.getTextColor()),
              ),
            ),
            TextButton(
              onPressed: () async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                Navigator.of(context).pop();
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

