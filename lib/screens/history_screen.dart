import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../providers/history_provider.dart';
import '../widgets/animations.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, HistoryProvider>(
      builder: (context, themeProvider, historyProvider, child) {
        final colors = themeProvider.getGradientColors();
        final conversions = historyProvider.conversions;

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'History',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                          color: themeProvider.getTextColor(),
                        ),
                      ),
                      if (conversions.isNotEmpty)
                        ScaleButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: themeProvider.getCardBackgroundColor(),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                title: Text('Clear History', style: TextStyle(color: themeProvider.getTextColor(), fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                                content: Text('Are you sure you want to delete all conversion history?', style: TextStyle(color: themeProvider.getSecondaryTextColor(), fontSize: 15)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel', style: TextStyle(color: themeProvider.getSecondaryTextColor(), fontWeight: FontWeight.w600)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      historyProvider.clearHistory();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Clear All', style: TextStyle(color: themeProvider.getErrorColor(), fontWeight: FontWeight.w800)),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: themeProvider.getGlassDecoration(borderRadius: 16).copyWith(
                              color: themeProvider.getErrorColor().withOpacity(0.1),
                              border: Border.all(color: themeProvider.getErrorColor().withOpacity(0.2)),
                            ),
                            child: Icon(
                              Icons.delete_sweep_rounded,
                              color: themeProvider.getErrorColor(),
                              size: 24,
                            ),
                          ),
                        ),

                    ],
                  ),
                ),
                if (conversions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: themeProvider.getGlassDecoration(borderRadius: 20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: themeProvider.getAccentColor().withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.bar_chart_rounded,
                              color: themeProvider.getAccentColor(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Conversions',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeProvider.getSecondaryTextColor(),
                                ),
                              ),
                              Text(
                                conversions.length.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.getTextColor(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: conversions.isEmpty
                      ? Center(
                          child: ScaleIn(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    color: themeProvider.getAccentColor().withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.history_rounded,
                                    size: 80,
                                    color: themeProvider.getAccentColor().withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'No History Yet',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.getTextColor(),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: Text(
                                    'Your currency conversions will appear here. Start converting to see your history!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: themeProvider.getSecondaryTextColor(),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: conversions.length,
                            itemBuilder: (context, index) {
                              final conversion = conversions[index];
                              final isLast = index == conversions.length - 1;
                              final bool showHeader = index == 0 ||
                                  !_isSameDay(conversion.date, conversions[index - 1].date);

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (showHeader) _buildDateHeader(themeProvider, conversion.date),
                                  FadeInSlide(
                                    delay: index < 15 ? index * 0.05 : 0.0,
                                    child: _buildHistoryItem(themeProvider, historyProvider, conversion, index, isLast),
                                  ),
                                ],
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
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  Widget _buildDateHeader(ThemeProvider themeProvider, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    String label;
    if (dateToCheck == today) {
      label = 'Today';
    } else if (dateToCheck == yesterday) {
      label = 'Yesterday';
    } else {
      label = DateFormat('MMMM d, yyyy').format(date);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: themeProvider.getCardBackgroundColor(),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: themeProvider.getBorderColor().withOpacity(0.2),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: themeProvider.getAccentColor(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Divider(
              color: themeProvider.getBorderColor().withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    ThemeProvider themeProvider,
    HistoryProvider historyProvider,
    dynamic conversion,
    int index,
    bool isLast,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: themeProvider.getCardBackgroundColor().withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: themeProvider.getBorderColor().withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        themeProvider.getAccentColor().withOpacity(0.2),
                        themeProvider.getSecondaryAccentColor().withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      conversion.toCurrency[0],
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
                      Row(
                        children: [
                          Text(
                            conversion.fromCurrency,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: themeProvider.getTextColor(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: themeProvider.getSecondaryTextColor(),
                            ),
                          ),
                          Text(
                            conversion.toCurrency,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: themeProvider.getTextColor(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('h:mm a').format(conversion.date),
                        style: TextStyle(
                          fontSize: 12,
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
                      conversion.result.toStringAsFixed(2),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: themeProvider.getTextColor(),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          conversion.amount.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 12,
                            color: themeProvider.getSecondaryTextColor(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            historyProvider.toggleSaved(index);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: conversion.isSaved 
                                  ? themeProvider.getAccentColor().withOpacity(0.1) 
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              conversion.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              size: 16,
                              color: conversion.isSaved
                                  ? themeProvider.getAccentColor()
                                  : themeProvider.getSecondaryTextColor(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
