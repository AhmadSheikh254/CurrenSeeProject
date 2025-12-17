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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'History',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.getTextColor(),
                        ),
                      ),
                      if (conversions.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: themeProvider.getErrorColor()),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Clear History'),
                                content: const Text('Are you sure you want to delete all conversion history?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      historyProvider.clearHistory();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Clear', style: TextStyle(color: themeProvider.getErrorColor())),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: conversions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                size: 64,
                                color: themeProvider.getSecondaryTextColor().withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No conversion history',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: themeProvider.getSecondaryTextColor(),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: conversions.length,
                          itemBuilder: (context, index) {
                            final conversion = conversions[index];
                            return FadeInSlide(
                              delay: index < 10 ? index * 0.05 : 0.0,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
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
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Icon(
                                                Icons.arrow_forward,
                                                size: 16,
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
                                          DateFormat('MMM d, yyyy • h:mm a').format(conversion.date),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: themeProvider.getSecondaryTextColor(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              conversion.result.toStringAsFixed(2),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: themeProvider.getAccentColor(),
                                              ),
                                            ),
                                            Text(
                                              '${conversion.amount.toStringAsFixed(2)} ${conversion.fromCurrency}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: themeProvider.getSecondaryTextColor(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ScaleButton(
                                          onPressed: () {
                                            historyProvider.toggleSaved(index);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              conversion.isSaved ? Icons.bookmark : Icons.bookmark_border,
                                              color: conversion.isSaved ? themeProvider.getAccentColor() : themeProvider.getSecondaryTextColor(),
                                            ),
                                          ),
                                        ),
                                      ],
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
