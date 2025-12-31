import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/history_provider.dart';
import '../providers/alert_provider.dart';
import '../providers/preferences_provider.dart';
import '../providers/auth_provider.dart';
import 'profile_screen.dart';
import 'news_screen.dart';
import 'settings_screen.dart';
import 'currency_rate_screen.dart';
import 'history_screen.dart';
import '../models/conversion.dart';
import '../services/currency_service.dart';
import '../widgets/animations.dart';
import 'alerts_screen.dart';

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
  bool _isSidebarExpanded = false;

  final List<Map<String, dynamic>> _currencyRates = [
    {'code': 'USD', 'name': 'US Dollar', 'rate': 1.0, 'symbol': '$'},
    {'code': 'EUR', 'name': 'Euro', 'rate': 0.95, 'symbol': '€'},
    {'code': 'GBP', 'name': 'British Pound', 'rate': 0.78, 'symbol': '£'},
    {'code': 'JPY', 'name': 'Japanese Yen', 'rate': 155.0, 'symbol': '¥'},
    {'code': 'AUD', 'name': 'Australian Dollar', 'rate': 1.58, 'symbol': 'A$'},
    {'code': 'CAD', 'name': 'Canadian Dollar', 'rate': 1.37, 'symbol': 'C$'},
    {'code': 'CHF', 'name': 'Swiss Franc', 'rate': 0.88, 'symbol': 'Fr'},
    {'code': 'CNY', 'name': 'Chinese Yuan', 'rate': 7.25, 'symbol': '¥'},
    {'code': 'INR', 'name': 'Indian Rupee', 'rate': 84.50, 'symbol': '₹'},
    {'code': 'MXN', 'name': 'Mexican Peso', 'rate': 18.00, 'symbol': '$'},
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
              // Background Decorative Elements
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeProvider.getAccentColor().withOpacity(0.15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: BackdropFilter(
                      filter: ColorFilter.mode(
                        themeProvider.getAccentColor().withOpacity(0.1),
                        BlendMode.srcATop,
                      ),
                      child: Container(),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                left: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeProvider.getSecondaryAccentColor().withOpacity(0.1),
                  ),
                ),
              ),
              
              // Main Content Area (Full Screen)
              screens[_selectedIndex],
              
              // Glassy Top Bar (Fixed)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: MediaQuery.of(context).padding.top + 60,
                      decoration: BoxDecoration(
                        color: themeProvider.getCardBackgroundColor().withOpacity(0.2),
                        border: Border(
                          bottom: BorderSide(
                            color: themeProvider.getBorderColor().withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Floating Menu Button (Minimal & Top-Left)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: _isSidebarExpanded ? -60 : 16,
                top: 12, 
                child: SafeArea(
                  child: ScaleButton(
                    onPressed: () {
                      setState(() {
                        _isSidebarExpanded = true;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: themeProvider.getGlassDecoration(borderRadius: 10).copyWith(
                        color: themeProvider.getCardBackgroundColor().withOpacity(0.4),
                      ),
                      child: Icon(
                        Icons.menu_rounded,
                        color: themeProvider.getTextColor(),
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),

              // Sidebar Overlay (Drawer)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: _isSidebarExpanded ? 0 : -280,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: themeProvider.getCardBackgroundColor().withOpacity(0.95),
                    border: Border(
                      right: BorderSide(
                        color: themeProvider.getBorderColor().withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    boxShadow: [
                      if (_isSidebarExpanded)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(5, 0),
                        ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
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
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.currency_exchange, color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'CurrenSee',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.getTextColor(),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.close_rounded, color: themeProvider.getTextColor()),
                                onPressed: () {
                                  setState(() {
                                    _isSidebarExpanded = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                _buildDrawerItem(themeProvider, 0, Icons.dashboard_rounded, 'Home'),
                                _buildDrawerItem(themeProvider, 1, Icons.candlestick_chart_rounded, 'Exchange Rates'),
                                _buildDrawerItem(themeProvider, 2, Icons.receipt_long_rounded, 'History'),
                                _buildDrawerItem(themeProvider, 3, Icons.account_circle_rounded, 'Profile'),
                                const SizedBox(height: 20),
                                Divider(color: themeProvider.getBorderColor().withOpacity(0.2)),
                                const SizedBox(height: 20),
                                _buildDrawerItem(themeProvider, 4, Icons.tune_rounded, 'Settings'),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'v1.0.0',
                            style: TextStyle(
                              color: themeProvider.getSecondaryTextColor(),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildDrawerItem(ThemeProvider themeProvider, int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? themeProvider.getAccentColor().withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? themeProvider.getAccentColor() : themeProvider.getSecondaryTextColor(),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? themeProvider.getAccentColor() : themeProvider.getTextColor(),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
            _isSidebarExpanded = false; // Close drawer on selection
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
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
              padding: const EdgeInsets.fromLTRB(20.0, 110.0, 20.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  FadeInSlide(
                    delay: 0.0,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: themeProvider.getGlassDecoration(borderRadius: 28).copyWith(
                        color: themeProvider.getCardBackgroundColor().withOpacity(0.35),
                        border: Border.all(
                          color: themeProvider.getBorderColor().withOpacity(0.15),
                          width: 1.5,
                        ),
                      ),
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          final user = authProvider.user;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.isGuest ? 'Guest User' : 'Welcome, ${user?.name.split(' ')[0] ?? 'Back'}!',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.5,
                                        color: themeProvider.getTextColor(),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        _buildPulsingDot(Colors.green),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Market Live • ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green.withOpacity(0.9),
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Hero(
                                tag: 'profile_avatar',
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        themeProvider.getAccentColor(),
                                        themeProvider.getSecondaryAccentColor(),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: themeProvider.getAccentColor().withOpacity(0.4),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: themeProvider.getCardBackgroundColor(),
                                      image: (!widget.isGuest && user?.photoUrl != null)
                                          ? DecorationImage(
                                              image: NetworkImage(user!.photoUrl!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: (widget.isGuest || user?.photoUrl == null)
                                        ? Icon(
                                            widget.isGuest ? Icons.person_outline : Icons.person,
                                            color: themeProvider.getAccentColor(),
                                            size: 26,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Quick Conversion
                  FadeInSlide(
                    delay: 0.1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quick Conversion',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                color: themeProvider.getTextColor(),
                              ),
                            ),
                            Icon(Icons.auto_graph_rounded, color: themeProvider.getAccentColor().withOpacity(0.5), size: 20),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: themeProvider.getGlassDecoration(borderRadius: 28).copyWith(
                            color: themeProvider.getCardBackgroundColor().withOpacity(0.3),
                            border: Border.all(
                              color: themeProvider.getBorderColor().withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              // From Currency
                              Container(
                                decoration: BoxDecoration(
                                  color: themeProvider.getCardBackgroundColor().withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: themeProvider.getBorderColor().withOpacity(0.1)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _amountController,
                                        onChanged: (value) => _convertCurrency(),
                                        style: TextStyle(
                                          color: themeProvider.getTextColor(),
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        decoration: InputDecoration(
                                          labelText: 'Amount',
                                          labelStyle: TextStyle(
                                            color: themeProvider.getSecondaryTextColor(),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          hintText: '0.00',
                                          hintStyle: TextStyle(color: themeProvider.getSecondaryTextColor().withOpacity(0.5)),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                    _buildCurrencyPicker(themeProvider, _fromCurrency, (value) {
                                      setState(() {
                                        _fromCurrency = value;
                                        _convertCurrency();
                                      });
                                    }),
                                  ],
                                ),
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
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: themeProvider.getAccentColor().withOpacity(0.15),
                                      border: Border.all(color: themeProvider.getAccentColor().withOpacity(0.3), width: 1.5),
                                    ),
                                    child: Icon(
                                      Icons.swap_vert_rounded,
                                      color: themeProvider.getAccentColor(),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // To Currency
                              Container(
                                decoration: BoxDecoration(
                                  color: themeProvider.getCardBackgroundColor().withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: themeProvider.getBorderColor().withOpacity(0.1)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _resultController,
                                        style: TextStyle(
                                          color: themeProvider.getTextColor(),
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          labelText: 'Converted Amount',
                                          labelStyle: TextStyle(
                                            color: themeProvider.getSecondaryTextColor(),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          hintText: '0.00',
                                          hintStyle: TextStyle(color: themeProvider.getSecondaryTextColor().withOpacity(0.5)),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                    _buildCurrencyPicker(themeProvider, _toCurrency, (value) {
                                      setState(() {
                                        _toCurrency = value;
                                        _convertCurrency();
                                      });
                                    }),
                                  ],
                                ),
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
                                          color: themeProvider.getAccentColor().withOpacity(0.4),
                                          blurRadius: 15,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 4),
                                        ),
                                        BoxShadow(
                                          color: themeProvider.getSecondaryAccentColor().withOpacity(0.2),
                                          blurRadius: 25,
                                          spreadRadius: -2,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: _isConverting
                                        ? CustomAnimatedLoader(
                                            size: 20,
                                            color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                                          )
                                        : const Text(
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Popular Pairs
                  FadeInSlide(
                    delay: 0.15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Popular Pairs',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.getTextColor(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _buildPopularPair(themeProvider, 'USD/EUR', '0.95', '+0.2%'),
                              _buildPopularPair(themeProvider, 'GBP/USD', '1.27', '-0.1%'),
                              _buildPopularPair(themeProvider, 'USD/JPY', '155.4', '+0.5%'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Quick Actions
                  FadeInSlide(
                    delay: 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuickAction(themeProvider, Icons.notifications_active_outlined, 'Alerts', () {
                          // Navigate to Alerts
                        }),
                        _buildQuickAction(themeProvider, Icons.analytics_outlined, 'Trends', () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsScreen()));
                        }),
                        _buildQuickAction(themeProvider, Icons.star_outline_rounded, 'Favorites', () {}),
                        _buildQuickAction(themeProvider, Icons.share_outlined, 'Share', () {}),
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
                              themeProvider.getAccentColor(),
                              themeProvider.getSecondaryAccentColor(),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: themeProvider.getAccentColor().withOpacity(0.3),
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
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Market Insights',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Check latest trends & news',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                            ),
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
      decoration: themeProvider.getGlassDecoration(borderRadius: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: themeProvider.getAccentColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.currency_exchange_rounded,
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.getTextColor(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  from,
                  style: TextStyle(
                    fontSize: 13,
                    color: themeProvider.getSecondaryTextColor(),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                to,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.getAccentColor(),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Completed',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.green.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildCurrencyPicker(ThemeProvider themeProvider, String currentValue, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: themeProvider.getAccentColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.getAccentColor().withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          dropdownColor: themeProvider.getCardBackgroundColor(),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: themeProvider.getAccentColor(), size: 20),
          items: _currencyRates.map<DropdownMenuItem<String>>((currency) {
            return DropdownMenuItem<String>(
              value: currency['code'] as String,
              child: Text(
                currency['code'] as String,
                style: TextStyle(
                  color: themeProvider.getTextColor(),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) => onChanged(value!),
        ),
      ),
    );
  }

  Widget _buildPopularPair(ThemeProvider themeProvider, String pair, String rate, String change) {
    final isPositive = change.startsWith('+');
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      width: 140,
      decoration: themeProvider.getGlassDecoration(borderRadius: 24).copyWith(
        color: themeProvider.getCardBackgroundColor().withOpacity(0.3),
        border: Border.all(color: themeProvider.getBorderColor().withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pair,
            style: TextStyle(
              color: themeProvider.getSecondaryTextColor(),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            rate,
            style: TextStyle(
              color: themeProvider.getTextColor(),
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              change,
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(ThemeProvider themeProvider, IconData icon, String label, VoidCallback onTap) {
    return ScaleButton(
      onPressed: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: themeProvider.getGlassDecoration(borderRadius: 20).copyWith(
              color: themeProvider.getCardBackgroundColor().withOpacity(0.3),
              border: Border.all(color: themeProvider.getBorderColor().withOpacity(0.1)),
            ),
            child: Icon(
              icon,
              color: themeProvider.getAccentColor(),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: themeProvider.getTextColor().withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingDot(Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color.withOpacity(value),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(value * 0.5),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}