import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/theme_provider.dart';
import '../widgets/animations.dart';

class CurrencyDetailsScreen extends StatelessWidget {
  final String currencyCode;
  final String currencyName;
  final double currentRate;

  const CurrencyDetailsScreen({
    super.key,
    required this.currencyCode,
    required this.currencyName,
    required this.currentRate,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final colors = themeProvider.getGradientColors();
        
        return Scaffold(
          body: Container(
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
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: themeProvider.getTextColor()),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.getTextColor(),
                          ),
                        ),
                        const SizedBox(width: 48), // Placeholder for balance
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          ScaleIn(
                            delay: 0.0,
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [themeProvider.getAccentColor().withOpacity(0.2), themeProvider.getSecondaryAccentColor().withOpacity(0.2)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: themeProvider.getAccentColor().withOpacity(0.2),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                      border: Border.all(
                                        color: themeProvider.getAccentColor().withOpacity(0.5),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        currencyCode[0],
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: themeProvider.getAccentColor(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    currencyName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.getTextColor(),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: themeProvider.getCardBackgroundColor(),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: themeProvider.getBorderColor()),
                                    ),
                                    child: Text(
                                      currencyCode,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider.getSecondaryTextColor(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    '1 USD = $currentRate $currencyCode',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.getTextColor(),
                                    ),
                                  ),
                                  Text(
                                    'Current Exchange Rate',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: themeProvider.getSecondaryTextColor(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Chart Section
                          FadeInSlide(
                            delay: 0.1,
                            child: Row(
                              children: [
                                Icon(Icons.show_chart_rounded, color: themeProvider.getAccentColor()),
                                const SizedBox(width: 8),
                                Text(
                                  'Historical Trend',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.getTextColor(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ScaleIn(
                            delay: 0.2,
                            child: Container(
                              height: 250,
                              padding: const EdgeInsets.all(20),
                              decoration: themeProvider.getGlassDecoration(borderRadius: 24),
                              child: LineChart(
                                _buildChartData(themeProvider),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Additional Info
                          FadeInSlide(
                            delay: 0.3,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: themeProvider.getGlassDecoration(borderRadius: 24),
                              child: Column(
                                children: [
                                  _buildInfoRow(themeProvider, 'Open', '${(currentRate * 0.99).toStringAsFixed(4)}', Icons.lock_open_rounded),
                                  const Divider(height: 24),
                                  _buildInfoRow(themeProvider, 'High', '${(currentRate * 1.02).toStringAsFixed(4)}', Icons.arrow_upward_rounded),
                                  const Divider(height: 24),
                                  _buildInfoRow(themeProvider, 'Low', '${(currentRate * 0.98).toStringAsFixed(4)}', Icons.arrow_downward_rounded),
                                  const Divider(height: 24),
                                  _buildInfoRow(themeProvider, 'Close', '${currentRate.toStringAsFixed(4)}', Icons.lock_outline_rounded),
                                ],
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
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(ThemeProvider themeProvider, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: themeProvider.getSecondaryTextColor(),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: themeProvider.getSecondaryTextColor(),
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: themeProvider.getTextColor(),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData(ThemeProvider themeProvider) {
    // Generate mock historical data based on current rate
    final List<FlSpot> spots = [];
    for (int i = 0; i < 7; i++) {
      // Create a slight random variation for the chart
      double variation = (i - 3) * 0.01 * currentRate; 
      if (i % 2 == 0) variation *= -1;
      spots.add(FlSpot(i.toDouble(), currentRate + variation));
    }

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              if (value.toInt() >= 0 && value.toInt() < days.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    days[value.toInt()],
                    style: TextStyle(
                      color: themeProvider.getSecondaryTextColor(),
                      fontSize: 12,
                    ),
                  ),
                );
              }
              return const Text('');
            },
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: currentRate * 0.9,
      maxY: currentRate * 1.1,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: themeProvider.getAccentColor(),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: themeProvider.getAccentColor().withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}
