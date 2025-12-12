import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CurrencyRateScreen extends StatefulWidget {
  const CurrencyRateScreen({super.key});

  @override
  State<CurrencyRateScreen> createState() => _CurrencyRateScreenState();
}

class _CurrencyRateScreenState extends State<CurrencyRateScreen> {
  late TextEditingController _searchController;
  final List<Map<String, dynamic>> _currencyRates = [
    {'code': 'USD', 'name': 'US Dollar', 'rate': 1.0, 'change': '+0.2%'},
    {'code': 'EUR', 'name': 'Euro', 'rate': 0.925, 'change': '-0.5%'},
    {'code': 'GBP', 'name': 'British Pound', 'rate': 0.795, 'change': '+0.3%'},
    {'code': 'JPY', 'name': 'Japanese Yen', 'rate': 145.50, 'change': '-0.1%'},
    {'code': 'AUD', 'name': 'Australian Dollar', 'rate': 1.52, 'change': '+0.4%'},
    {'code': 'CAD', 'name': 'Canadian Dollar', 'rate': 1.35, 'change': '+0.2%'},
    {'code': 'CHF', 'name': 'Swiss Franc', 'rate': 0.885, 'change': '-0.2%'},
    {'code': 'CNY', 'name': 'Chinese Yuan', 'rate': 7.24, 'change': '+0.1%'},
    {'code': 'INR', 'name': 'Indian Rupee', 'rate': 83.45, 'change': '-0.3%'},
    {'code': 'MXN', 'name': 'Mexican Peso', 'rate': 17.05, 'change': '+0.5%'},
    {'code': 'PKR', 'name': 'Pakistani Rupee', 'rate': 278.50, 'change': '+0.1%'},
  ];

  late List<Map<String, dynamic>> _filteredRates;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredRates = _currencyRates;
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
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: themeProvider.getBorderColor()),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: themeProvider.getBorderColor()),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: themeProvider.getAccentColor(), width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _filteredRates.isEmpty
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
                            final isPositive =
                                rate['change'].toString().startsWith('+');
                            return GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${rate['code']}: ${rate['rate']} ${rate['change']}'),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: themeProvider.getCardBackgroundColor(),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: themeProvider.getBorderColor()),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          rate['rate'].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: themeProvider.getTextColor(),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isPositive
                                                ? Colors.green.withOpacity(0.3)
                                                : Colors.red.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                              color: isPositive
                                                  ? Colors.greenAccent
                                                  : Colors.redAccent,
                                            ),
                                          ),
                                          child: Text(
                                            rate['change'],
                                            style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isPositive
                                                ? Colors.greenAccent
                                                : Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ],
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


