import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currensee/providers/theme_provider.dart';
import 'package:currensee/services/currency_service.dart';
import 'package:currensee/widgets/animations.dart';
import 'package:currensee/features/currency/presentation/screens/currency_details_screen.dart';
import 'package:currensee/shared/widgets/responsive.dart';
import 'package:currensee/shared/widgets/app_states.dart';

class CurrencyRateScreen extends StatefulWidget {
  const CurrencyRateScreen({super.key});

  @override
  State<CurrencyRateScreen> createState() => _CurrencyRateScreenState();
}

class _CurrencyRateScreenState extends State<CurrencyRateScreen> {
  late TextEditingController _searchController;
  List<Map<String, dynamic>> _currencyRates = [];
  bool _isLoading = true;
  String? _errorMessage;
  final CurrencyService _currencyService = CurrencyService();

  late List<Map<String, dynamic>> _filteredRates;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredRates = [];
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _fetchRates();
  }

  Future<void> _fetchRates() async {
    try {
      final rates = await _currencyService.fetchRates();
      setState(() {
        _currencyRates = rates;
        _filteredRates = rates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRates(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRates = _currencyRates;
      } else {
        _filteredRates = _currencyRates
            .where((rate) =>
                rate['code'].toLowerCase().contains(query.toLowerCase()) ||
                rate['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

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
            child: Column(
              children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    child: ResponsiveCenter(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GradientText(
                              'Exchange Rates',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.0,
                              ),
                              colors: [
                                themeProvider.getTextColor(),
                                themeProvider.getAccentColor(),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                                  child: Row(
                                children: [
                                  const PulsingDot(color: Colors.green),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'LIVE',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ScaleIn(
                          delay: 0.1,
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: _filterRates,
                              style: TextStyle(color: themeProvider.getTextColor()),
                              decoration: InputDecoration(
                                hintText: 'Search currencies...',
                                hintStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                                prefixIcon: Icon(Icons.search_rounded, color: themeProvider.getAccentColor()),
                                filled: true,
                                fillColor: themeProvider.getCardBackgroundColor().withValues(alpha: 0.8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: themeProvider.getAccentColor(), width: 1.5),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Trending',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: themeProvider.getTextColor(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _buildTrendingChip(themeProvider, 'USD', '1.0000', true),
                              _buildTrendingChip(themeProvider, 'EUR', '0.9542', false),
                              _buildTrendingChip(themeProvider, 'GBP', '0.7891', true),
                              // _buildTrendingChip(themeProvider, 'JPY', '155.42', true),
                            ],
                          ),
                        ),
                        _buildQuickActions(themeProvider),
                      ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: _isLoading
                        ? SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: const ResponsiveCenter(
                              child: SkeletonList(itemCount: 8, itemHeight: 80),
                            ),
                          )
                        : _errorMessage != null
                            ? ErrorState(
                                title: 'Unable to load rates',
                                message:
                                    'Check your internet connection and try again.',
                                onRetry: () {
                                  setState(() {
                                    _isLoading = true;
                                    _errorMessage = null;
                                  });
                                  _fetchRates();
                                },
                              )
                            : _filteredRates.isEmpty
                                ? EmptyState(
                                    icon: Icons.search_off_rounded,
                                    title: 'No currencies found',
                                    message:
                                        'Try a different search term or clear the search to see all currencies.',
                                  )
                                : ResponsiveCenter(
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                      decoration: themeProvider.getGlassDecoration(borderRadius: 24),
                                      clipBehavior: Clip.hardEdge,
                                      child: ListView.builder(
                                        padding: const EdgeInsets.only(bottom: 76),
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: _filteredRates.length,
                                        itemBuilder: (context, index) {
                                          final rate = _filteredRates[index];
                                          final isLast = index == _filteredRates.length - 1;

                                          return FadeInSlide(
                                            delay: index < 15 ? index * 0.05 : 0.0,
                                            child: _buildRateItem(themeProvider, rate, isLast),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                  ),
                ],
              ),
            ),
          );
        },
      );
  }

  Widget _buildQuickActions(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: themeProvider.getTextColor(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionButton(themeProvider, Icons.swap_horiz_rounded, 'Convert'),
            _buildActionButton(themeProvider, Icons.analytics_rounded, 'Analysis'),
            _buildActionButton(themeProvider, Icons.notifications_active_rounded, 'Alerts'),
            _buildActionButton(themeProvider, Icons.history_rounded, 'History'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(ThemeProvider themeProvider, IconData icon, String label) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: themeProvider.getGlassDecoration(borderRadius: 16),
            child: Icon(
              icon,
              color: themeProvider.getAccentColor(),
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: themeProvider.getTextColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildTrendingChip(ThemeProvider themeProvider, String code, String rate, bool isUp) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(4),
      decoration: themeProvider.getGlassDecoration(borderRadius: 30),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeProvider.getCardBackgroundColor(),
              shape: BoxShape.circle,
            ),
            child: Text(
              code,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: themeProvider.getTextColor(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                rate,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: themeProvider.getTextColor(),
                ),
              ),
              Row(
                children: [
                  Icon(
                    isUp ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                    color: isUp ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  Text(
                    isUp ? '+0.4%' : '-0.2%', // Mock data for visual
                    style: TextStyle(
                      fontSize: 10,
                      color: isUp ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
  // Currencies whose flag cannot be derived from the ISO country prefix
  static const Map<String, String> _flagOverrides = {
    'EUR': '🇪🇺', // Euro — EU flag
    'XAF': '🇨🇲', // Central African CFA franc
    'XOF': '🇸🇳', // West African CFA franc
    'XPF': '🇵🇫', // CFP franc
    'XCD': '🇦🇬', // East Caribbean dollar
    'XDR': '🏳️', // IMF special drawing rights
    'ANG': '🇨🇼', // Netherlands Antillean guilder
    'STN': '🇸🇹', // São Tomé dobra
    'FOK': '🇫🇴', // Faroese króna
    'KID': '🇰🇮', // Kiribati dollar
    'TVD': '🇹🇻', // Tuvaluan dollar
    'GGP': '🇬🇬', // Guernsey pound
    'IMP': '🇮🇲', // Manx pound
    'JEP': '🇯🇪', // Jersey pound
  };

  /// Derives a flag for any ISO-4217 code: explicit override first, then the
  /// first two letters as a country code (USD→US→🇺🇸, PKR→PK→🇵🇰, …).
  static String _flagForCurrency(String code) {
    final override = _flagOverrides[code.toUpperCase()];
    if (override != null) return override;
    final cc = code.toUpperCase();
    if (cc.length >= 2 &&
        cc.codeUnitAt(0) >= 65 && cc.codeUnitAt(0) <= 90 &&
        cc.codeUnitAt(1) >= 65 && cc.codeUnitAt(1) <= 90) {
      return String.fromCharCodes([
        0x1F1E6 + cc.codeUnitAt(0) - 65,
        0x1F1E6 + cc.codeUnitAt(1) - 65,
      ]);
    }
    return '🏳️';
  }

  // Deterministic mock change % based on currency code (looks real)
  double _getMockChange(String code) {
    final seed = code.codeUnits.fold(0, (a, b) => a + b);
    final values = [-1.24, 0.87, -0.43, 1.56, -0.91, 0.34, 2.01, -1.73, 0.62, -0.28];
    return values[seed % values.length];
  }

  Widget _buildRateItem(ThemeProvider themeProvider, Map<String, dynamic> rate, bool isLast) {
    final code = rate['code'] as String;
    final name = rate['name'] as String;
    final rateValue = rate['rate'] as double;
    final flag = _flagForCurrency(code);
    final change = _getMockChange(code);
    final isPositive = change >= 0;
    final changeColor = isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final isDark = themeProvider.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CurrencyDetailsScreen(
                currencyCode: code,
                currencyName: name,
                currentRate: rateValue,
              ),
            ),
          );
        },
        splashColor: themeProvider.getAccentColor().withValues(alpha: 0.05),
        highlightColor: themeProvider.getAccentColor().withValues(alpha: 0.03),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // ── Avatar: flag + gradient circle ──────────────────────────
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeProvider.getAccentColor().withValues(alpha: isDark ? 0.18 : 0.10),
                      themeProvider.getSecondaryAccentColor().withValues(alpha: isDark ? 0.12 : 0.07),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: themeProvider.getAccentColor().withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // ── Currency name & code ─────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          code,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: themeProvider.getTextColor(),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Change badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: changeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: changeColor.withValues(alpha: 0.25),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPositive
                                    ? Icons.arrow_upward_rounded
                                    : Icons.arrow_downward_rounded,
                                color: changeColor,
                                size: 9,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: changeColor,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.getSecondaryTextColor(),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // ── Rate & base ──────────────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    rateValue.toStringAsFixed(4),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: themeProvider.getTextColor(),
                      letterSpacing: -0.3,
                      fontFamily: 'JetBrains Mono',
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '1 USD = $code',
                    style: TextStyle(
                      fontSize: 11,
                      color: themeProvider.getSecondaryTextColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              // ── Chevron ──────────────────────────────────────────────────
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: themeProvider.getAccentColor().withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: themeProvider.getAccentColor(),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


