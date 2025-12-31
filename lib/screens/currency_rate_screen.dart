import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/currency_service.dart';
import '../widgets/animations.dart';
import 'currency_details_screen.dart';

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
                    padding: const EdgeInsets.fromLTRB(20, 110, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Exchange Rates',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.0,
                                color: themeProvider.getTextColor(),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  _buildPulsingDot(Colors.green),
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
                                  color: Colors.black.withOpacity(0.05),
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
                                fillColor: themeProvider.getCardBackgroundColor().withOpacity(0.8),
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
                            fontWeight: FontWeight.bold,
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
                  Expanded(
                    child: _isLoading
                        ? Center(child: CustomAnimatedLoader(color: themeProvider.getAccentColor()))
                      : _errorMessage != null
                          ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Failed to load rates',
                                      style: TextStyle(color: themeProvider.getErrorColor()),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: _fetchRates,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: themeProvider.getAccentColor(),
                                      ),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                          : _filteredRates.isEmpty
                      ? Center(
                            child: Text(
                              'No currencies found',
                              style: TextStyle(
                                fontSize: 16,
                                color: themeProvider.getSecondaryTextColor(),
                              ),
                            ),
                          )
                      : Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          decoration: themeProvider.getGlassDecoration(borderRadius: 24),
                          clipBehavior: Clip.hardEdge,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
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
            fontWeight: FontWeight.bold,
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
  Widget _buildRateItem(ThemeProvider themeProvider, Map<String, dynamic> rate, bool isLast) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CurrencyDetailsScreen(
                    currencyCode: rate['code'],
                    currencyName: rate['name'],
                    currentRate: rate['rate'],
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          themeProvider.getAccentColor().withOpacity(0.2),
                          themeProvider.getSecondaryAccentColor().withOpacity(0.2)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        rate['code'][0],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.getAccentColor(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rate['code'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.getTextColor(),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rate['name'],
                          style: TextStyle(
                            fontSize: 14,
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
                        rate['rate'].toStringAsFixed(4),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.getTextColor(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '1 USD =',
                        style: TextStyle(
                          fontSize: 12,
                          color: themeProvider.getSecondaryTextColor(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: themeProvider.getSecondaryTextColor(),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              height: 1,
              color: themeProvider.getBorderColor().withOpacity(0.3),
            ),
          ),
      ],
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
