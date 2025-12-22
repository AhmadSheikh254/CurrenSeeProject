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
    _fetchRates();
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exchange Rates',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.getTextColor(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Search Field
                      TextField(
                        controller: _searchController,
                        onChanged: _filterRates,
                        style: TextStyle(color: themeProvider.getTextColor()),
                        decoration: InputDecoration(
                          hintText: 'Search currencies...',
                          hintStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                          prefixIcon:
                              Icon(Icons.search, color: themeProvider.getSecondaryTextColor()),
                          filled: true,
                          fillColor: themeProvider.getCardBackgroundColor(),
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
                            borderSide:
                                BorderSide(color: themeProvider.getAccentColor(), width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator(color: themeProvider.getAccentColor()))
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
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12.0),
                          itemCount: _filteredRates.length,
                          itemBuilder: (context, index) {
                            final rate = _filteredRates[index];
                            // Use a simple circle avatar with currency code as fallback for flag
                            return FadeInSlide(
                              delay: index < 15 ? index * 0.05 : 0.0,
                              child: ScaleButton(
                                onPressed: () {
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
                              child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: themeProvider.getGlassDecoration(borderRadius: 16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [themeProvider.getAccentColor().withOpacity(0.2), themeProvider.getSecondaryAccentColor().withOpacity(0.2)],
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
                                ],
                              ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


