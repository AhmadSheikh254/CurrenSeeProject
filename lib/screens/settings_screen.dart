import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/preferences_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/animations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, PreferencesProvider>(
      builder: (context, themeProvider, preferencesProvider, child) {
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
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScaleIn(
                    delay: 0.0,
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.getTextColor(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // App Preferences Section
                  FadeInSlide(
                    delay: 0.1,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: themeProvider.getGlassDecoration(borderRadius: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(themeProvider, 'App Preferences', Icons.tune_rounded),
                          const SizedBox(height: 20),
                          _buildToggleSetting(
                            themeProvider,
                            'Dark Mode',
                            'Use dark theme',
                            themeProvider.isDarkMode,
                            (value) {
                              themeProvider.setDarkMode(value);
                            },
                          ),
                          const SizedBox(height: 16),
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
                  ),
                  const SizedBox(height: 24),
                  // Account Settings Section
                  FadeInSlide(
                    delay: 0.2,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: themeProvider.getGlassDecoration(borderRadius: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(themeProvider, 'Account Settings', Icons.person_outline_rounded),
                          const SizedBox(height: 20),
                          _buildDropdownSetting(
                            themeProvider,
                            'Default Currency',
                            preferencesProvider.defaultBaseCurrency,
                            ['USD', 'EUR', 'GBP', 'JPY', 'INR'],
                            (value) {
                              preferencesProvider.setDefaultBaseCurrency(value);
                            },
                          ),
                          const SizedBox(height: 16),
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
                  ),
                  const SizedBox(height: 24),
                  // Security Section
                  FadeInSlide(
                    delay: 0.3,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: themeProvider.getGlassDecoration(borderRadius: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(themeProvider, 'Security', Icons.security_rounded),
                          const SizedBox(height: 20),
                          _buildSettingsTile(
                            themeProvider,
                            'Change Password',
                            'Update your password',
                            Icons.lock_outline_rounded,
                            () {
                              _showChangePasswordDialog(context, themeProvider);
                            },
                          ),
                          const SizedBox(height: 16),
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
                  ),
                  const SizedBox(height: 24),
                  // About Section
                  FadeInSlide(
                    delay: 0.4,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: themeProvider.getGlassDecoration(borderRadius: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(themeProvider, 'About', Icons.info_outline_rounded),
                          const SizedBox(height: 20),
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
                          const SizedBox(height: 16),
                          _buildSettingsTile(themeProvider, 'Terms of Service', 'Read our terms', Icons.description_outlined, () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening terms of service...'),
                              ),
                            );
                          }),
                          const SizedBox(height: 16),
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
                                  color: Colors.red.withOpacity(0.3),
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
        );
      },
    );
  }

  Widget _buildSectionTitle(ThemeProvider themeProvider, String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: themeProvider.getAccentColor(),
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: themeProvider.getTextColor(),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSetting(
    ThemeProvider themeProvider,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
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
          activeColor: themeProvider.getAccentColor(),
        ),
      ],
    );
  }

  Widget _buildDropdownSetting(
    ThemeProvider themeProvider,
    String title,
    String currentValue,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Row(
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
    );
  }

  Widget _buildSettingsTile(ThemeProvider themeProvider, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeProvider.getCardBackgroundColor(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: themeProvider.getBorderColor().withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: themeProvider.getAccentColor().withOpacity(0.1),
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
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
