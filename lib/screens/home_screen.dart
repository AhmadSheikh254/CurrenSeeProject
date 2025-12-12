import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'currency_rate_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isGuest;

  const HomeScreen({super.key, this.isGuest = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final screens = [
          _buildHomeContent(context),
          const CurrencyRateScreen(),
          const ProfileScreen(),
          const SettingsScreen(),
        ];
        
        return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: themeProvider.getBottomNavColor(),
        selectedItemColor: themeProvider.getBottomNavTextColor(),
        unselectedItemColor: themeProvider.getBottomNavUnselectedColor(),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Rates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      );
      },
    );
  }

  Widget _buildHomeContent(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isGuest ? 'Guest User' : 'Welcome Back!',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.isGuest
                                ? 'Exploring CurrenSee'
                                : 'Manage your currencies',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          widget.isGuest ? Icons.person_outline : Icons.person,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Quick Conversion
                  Text(
                    'Quick Conversion',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.getTextColor(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: themeProvider.getCardBackgroundColor(),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: themeProvider.getBorderColor()),
                    ),
                    child: Column(
                      children: [
                        // From Currency
                        TextField(
                          style: TextStyle(color: themeProvider.getTextColor()),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter amount',
                            hintStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                            prefixText: '\$ ',
                            prefixStyle: TextStyle(
                              color: themeProvider.getTextColor(),
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: themeProvider.getBorderColor()),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: themeProvider.getBorderColor()),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: themeProvider.getAccentColor(), width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeProvider.getCardBackgroundColor(),
                              border: Border.all(color: themeProvider.getBorderColor()),
                            ),
                            child: Icon(
                              Icons.swap_vert,
                              color: themeProvider.getTextColor(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // To Currency
                        TextField(
                          style: TextStyle(color: themeProvider.getTextColor()),
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                            prefixText: '€ ',
                            prefixStyle: TextStyle(
                              color: themeProvider.getTextColor(),
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: themeProvider.getBorderColor()),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: themeProvider.getBorderColor()),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Conversion feature coming soon'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeProvider.getAccentColor(),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Convert',
                              style: TextStyle(
                                color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Recent Conversions
                  const Text(
                    'Recent Conversions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildConversionCardContent(themeProvider, 'USD to EUR', '100 USD', '92.50 EUR'),
                  const SizedBox(height: 12),
                  _buildConversionCardContent(themeProvider, 'GBP to INR', '50 GBP', '5,250 INR'),
                  const SizedBox(height: 12),
                  _buildConversionCardContent(themeProvider, 'JPY to USD', '10,000 JPY', '67.50 USD'),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConversionCardContent(ThemeProvider themeProvider, String title, String from, String to) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.getCardBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
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
                from,
                style: TextStyle(
                  fontSize: 14,
                  color: themeProvider.getSecondaryTextColor(),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.arrow_forward, color: themeProvider.getSecondaryTextColor()),
              const SizedBox(height: 4),
              Text(
                to,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.getTextColor(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


}
