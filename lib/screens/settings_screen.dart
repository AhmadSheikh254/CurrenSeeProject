import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedCurrency = 'USD';
  String _selectedLanguage = 'English';

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
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.getTextColor(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // App Preferences Section
                  _buildSectionTitle(themeProvider, 'App Preferences'),
                  const SizedBox(height: 12),
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
                    _notificationsEnabled,
                    (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  // Account Settings Section
                  _buildSectionTitle(themeProvider, 'Account Settings'),
                  const SizedBox(height: 12),
                  _buildDropdownSetting(
                    themeProvider,
                    'Default Currency',
                    _selectedCurrency,
                    ['USD', 'EUR', 'GBP', 'JPY', 'INR'],
                    (value) {
                      setState(() {
                        _selectedCurrency = value;
                      });
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
                  const SizedBox(height: 32),
                  // Security Section
                  _buildSectionTitle(themeProvider, 'Security'),
                  const SizedBox(height: 12),
                  _buildSettingsTile(
                    themeProvider,
                    'Change Password',
                    'Update your password',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Change password feature coming soon'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsTile(
                    themeProvider,
                    'Two-Factor Authentication',
                    'Enable 2FA for security',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('2FA feature coming soon'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // About Section
                  _buildSectionTitle(themeProvider, 'About'),
                  const SizedBox(height: 12),
                  _buildSettingsTile(
                    themeProvider,
                    'Privacy Policy',
                    'Read our privacy policy',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening privacy policy...'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSettingsTile(themeProvider, 'Terms of Service', 'Read our terms', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening terms of service...'),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  _buildSettingsTile(themeProvider, 'About CurrenSee', 'Version 1.0.0', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'CurrenSee v1.0.0 - Currency Conversion App',
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 32),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context, themeProvider);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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

  Widget _buildSectionTitle(ThemeProvider themeProvider, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: themeProvider.getTextColor(),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: themeProvider.getCardBackgroundColor(),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: themeProvider.getBorderColor()),
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: themeProvider.getAccentColor(),
            activeTrackColor: themeProvider.getAccentColor().withOpacity(0.3),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: themeProvider.getCardBackgroundColor(),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: themeProvider.getBorderColor()),
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
            ],
          ),
          DropdownButton<String>(
            value: currentValue,
            dropdownColor: themeProvider.getCardBackgroundColor(),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: TextStyle(color: themeProvider.getTextColor()),
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
            icon: Icon(Icons.arrow_drop_down, color: themeProvider.getTextColor()),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(ThemeProvider themeProvider, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: themeProvider.getCardBackgroundColor(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: themeProvider.getBorderColor()),
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
            Icon(
              Icons.arrow_forward_ios,
              color: themeProvider.getSecondaryTextColor(),
              size: 16,
            ),
          ],
        ),
      ),
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
