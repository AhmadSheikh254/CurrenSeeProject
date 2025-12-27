import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/history_provider.dart';
import '../providers/alert_provider.dart';
import '../providers/preferences_provider.dart';
import 'profile_screen.dart';
import 'news_screen.dart';
import 'settings_screen.dart';
import 'currency_rate_screen.dart';
import 'history_screen.dart';
import '../models/conversion.dart';
import '../services/currency_service.dart';
import '../widgets/animations.dart';

class HomeScreen extends StatefulWidget {
  final bool isGuest;

  const HomeScreen({super.key, this.isGuest = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  final CurrencyService _currencyService = CurrencyService();
  bool _isConverting = false;

  final List<Map<String, dynamic>> _currencyRates = [
    {'code': 'USD', 'name': 'US Dollar', 'rate': 1.0, 'symbol': '\$'},
    {'code': 'EUR', 'name': 'Euro', 'rate': 0.95, 'symbol': '€'},
    {'code': 'GBP', 'name': 'British Pound', 'rate': 0.78, 'symbol': '£'},
    {'code': 'JPY', 'name': 'Japanese Yen', 'rate': 155.0, 'symbol': '¥'},
    {'code': 'AUD', 'name': 'Australian Dollar', 'rate': 1.58, 'symbol': 'A\$'},
    {'code': 'CAD', 'name': 'Canadian Dollar', 'rate': 1.37, 'symbol': 'C\$'},
    {'code': 'CHF', 'name': 'Swiss Franc', 'rate': 0.88, 'symbol': 'Fr'},
    {'code': 'CNY', 'name': 'Chinese Yuan', 'rate': 7.25, 'symbol': '¥'},
    {'code': 'INR', 'name': 'Indian Rupee', 'rate': 84.50, 'symbol': '₹'},
    {'code': 'MXN', 'name': 'Mexican Peso', 'rate': 18.00, 'symbol': '\$'},
    {'code': 'PKR', 'name': 'Pakistani Rupee', 'rate': 280.50, 'symbol': 'Rs'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize from currency with user preference
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefs = Provider.of<PreferencesProvider>(context, listen: false);
      setState(() {
        _fromCurrency = prefs.defaultBaseCurrency;
      });
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  Future<void> _convertCurrency() async {
    if (_amountController.text.isEmpty) {
      _resultController.clear();
      return;
    }

    setState(() {
      _isConverting = true;
    });

    try {
      double amount = double.tryParse(_amountController.text) ?? 0.0;
      double result = await _currencyService.convertCurrency(_fromCurrency, _toCurrency, amount);
      
      if (!mounted) return;

      setState(() {
        _resultController.text = result.toStringAsFixed(2);
        _isConverting = false;
      });

      // Check for alerts
      if (!mounted) return;
      final prefs = Provider.of<PreferencesProvider>(context, listen: false);
      
      if (prefs.notificationsEnabled) {
        final rate = result / amount;
        final alertProvider = Provider.of<AlertProvider>(context, listen: false);
        final triggeredAlerts = alertProvider.checkAlerts(rate, _fromCurrency, _toCurrency);

        if (triggeredAlerts.isNotEmpty) {
          for (var alert in triggeredAlerts) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.notifications_active, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('Rate Alert Triggered!'),
                  ],
                ),
                content: Text(
                  'The rate for ${_fromCurrency}/${_toCurrency} is now ${rate.toStringAsFixed(4)}, which is ${alert.isAbove ? 'above' : 'below'} your target of ${alert.targetRate}.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () {
                      alertProvider.toggleAlert(alert.id); // Turn off alert
                      Navigator.pop(context);
                    },
                    child: const Text('Turn Off Alert'),
                  ),
                ],
              ),
            );
          }
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isConverting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Conversion failed: ${e.toString()}')),
      );
    }
  }

  void _saveConversion() {
    if (_amountController.text.isEmpty || _resultController.text.isEmpty) return;
    
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    double result = double.tryParse(_resultController.text) ?? 0.0;

    final conversion = Conversion(
      fromCurrency: _fromCurrency,
      toCurrency: _toCurrency,
      amount: amount,
      result: result,
      date: DateTime.now(),
    );

    Provider.of<HistoryProvider>(context, listen: false).addConversion(conversion);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final screens = [
          _buildHomeContent(context),
          const CurrencyRateScreen(),
          const HistoryScreen(),
          const ProfileScreen(),
          const SettingsScreen(),
        ];
        
        return Scaffold(
          body: Stack(
            children: [
              screens[_selectedIndex],
              Positioned(
                left: 0,
                right: 0,
                bottom: 32,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      height: 70,
                      constraints: const BoxConstraints(maxWidth: 400),
                      decoration: BoxDecoration(
                        color: themeProvider.getBottomNavColor().withOpacity(0.9),
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(themeProvider.isDarkMode ? 0.5 : 0.15),
                            blurRadius: 25,
                            offset: const Offset(0, 12),
                          ),
                        ],
                        border: Border.all(
                          color: themeProvider.getBorderColor().withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: BottomNavigationBar(
                          currentIndex: _selectedIndex,
                          type: BottomNavigationBarType.fixed,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          selectedItemColor: themeProvider.getBottomNavTextColor(),
                          unselectedItemColor: themeProvider.getBottomNavUnselectedColor(),
                          showSelectedLabels: true,
                          showUnselectedLabels: false,
                          onTap: (index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          items: const [
                            BottomNavigationBarItem(
                              icon: Icon(Icons.home_rounded),
                              label: 'Home',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.currency_exchange_rounded),
                              label: 'Rates',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.history_rounded),
                              label: 'History',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.person_rounded),
                              label: 'Profile',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.settings_rounded),
                              label: 'Settings',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  FadeInSlide(
                    delay: 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isGuest ? 'Guest User' : 'Welcome Back!',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.getTextColor(),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.isGuest
                                  ? 'Exploring CurrenSee'
                                  : 'Manage your currencies',
                              style: TextStyle(
                                fontSize: 14,
                                color: themeProvider.getSecondaryTextColor(),
                              ),
                            ),
                          ],
                        ),
                        Hero(
                          tag: 'profile_avatar',
                          child: Container(
                            width: 50,
                            height: 50,
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
                            ),
                            child: Icon(
                              widget.isGuest ? Icons.person_outline : Icons.person,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Quick Conversion
                  FadeInSlide(
                    delay: 0.1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Conversion',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.getTextColor(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeInSlide(
                          delay: 0.1,
                          beginOffset: const Offset(0, 0.1),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: themeProvider.getGlassDecoration(),
                            child: Column(
                              children: [
                                // From Currency
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _amountController,
                                        onChanged: (value) => _convertCurrency(),
                                        style: TextStyle(color: themeProvider.getTextColor()),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Amount',
                                          labelStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                                          hintText: 'Enter amount',
                                          hintStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(color: themeProvider.getBorderColor()),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(color: themeProvider.getBorderColor()),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide:
                                                BorderSide(color: themeProvider.getAccentColor(), width: 1.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: themeProvider.getGlassDecoration(borderRadius: 12),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _fromCurrency,
                                          dropdownColor: themeProvider.getCardBackgroundColor(),
                                          icon: Icon(Icons.arrow_drop_down, color: themeProvider.getTextColor()),
                                          items: _currencyRates.map<DropdownMenuItem<String>>((currency) {
                                            return DropdownMenuItem<String>(
                                              value: currency['code'] as String,
                                              child: Text(
                                                currency['code'] as String,
                                                style: TextStyle(
                                                  color: themeProvider.getTextColor(),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _fromCurrency = value!;
                                              _convertCurrency();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: ScaleButton(
                                    onPressed: () {
                                      setState(() {
                                        final temp = _fromCurrency;
                                        _fromCurrency = _toCurrency;
                                        _toCurrency = temp;
                                        _convertCurrency();
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: themeProvider.getCardBackgroundColor().withOpacity(0.8),
                                        border: Border.all(color: themeProvider.getBorderColor(), width: 1.5),
                                      ),
                                      child: Icon(
                                        Icons.swap_vert,
                                        color: themeProvider.getTextColor(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // To Currency
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _resultController,
                                        style: TextStyle(color: themeProvider.getTextColor()),
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          labelText: 'Converted Amount',
                                          labelStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                                          hintText: '0.00',
                                          hintStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            borderSide: BorderSide(color: themeProvider.getBorderColor()),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            borderSide: BorderSide(color: themeProvider.getBorderColor()),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            borderSide: BorderSide(color: themeProvider.getAccentColor(), width: 1.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: themeProvider.getCardBackgroundColor().withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: themeProvider.getBorderColor()),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _toCurrency,
                                          dropdownColor: themeProvider.getCardBackgroundColor(),
                                          icon: Icon(Icons.arrow_drop_down, color: themeProvider.getTextColor()),
                                          items: _currencyRates.map<DropdownMenuItem<String>>((currency) {
                                            return DropdownMenuItem<String>(
                                              value: currency['code'] as String,
                                              child: Text(
                                                currency['code'] as String,
                                                style: TextStyle(
                                                  color: themeProvider.getTextColor(),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _toCurrency = value!;
                                              _convertCurrency();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ScaleButton(
                                    onPressed: _isConverting ? null : () async {
                                      await _convertCurrency();
                                      _saveConversion();
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [themeProvider.getAccentColor(), themeProvider.getSecondaryAccentColor()],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: themeProvider.getAccentColor().withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: _isConverting
                                          ? CustomAnimatedLoader(
                                              size: 20,
                                              color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                                            )
                                          : Text(
                                              'Convert',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Recent Conversions
                  FadeInSlide(
                    delay: 0.2,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Conversions',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.getTextColor(),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedIndex = 2; // Switch to History tab
                                });
                              },
                              child: Text(
                                'See All',
                                style: TextStyle(color: themeProvider.getAccentColor()),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Consumer<HistoryProvider>(
                          builder: (context, historyProvider, child) {
                            final recentConversions = historyProvider.conversions.take(5).toList();
                            
                            if (recentConversions.isEmpty) {
                              return Text(
                                'No recent conversions',
                                style: TextStyle(color: themeProvider.getSecondaryTextColor()),
                              );
                            }
                            
                            return StaggeredList(
                              children: recentConversions.map((conversion) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _buildConversionCardContent(
                                  themeProvider,
                                  '${conversion.fromCurrency} to ${conversion.toCurrency}',
                                  '${conversion.amount.toStringAsFixed(2)} ${conversion.fromCurrency}',
                                  '${conversion.result.toStringAsFixed(2)} ${conversion.toCurrency}',
                                ),
                              )).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Market News Section
                  FadeInSlide(
                    delay: 0.3,
                    child: ScaleButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NewsScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              themeProvider.getAccentColor().withOpacity(0.8),
                              themeProvider.getAccentColor(),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: themeProvider.getAccentColor().withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.newspaper, color: Colors.black, size: 28),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Market News',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Stay updated with latest trends',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
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
      decoration: themeProvider.getGlassDecoration(borderRadius: 12),
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
