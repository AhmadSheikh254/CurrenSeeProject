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
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                          itemCount: conversions.length,
                          itemBuilder: (context, index) {
                            final conversion = conversions[index];
                            return FadeInSlide(
                              delay: index < 10 ? index * 0.05 : 0.0,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: themeProvider.getGlassDecoration(borderRadius: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: themeProvider.getAccentColor().withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.swap_horiz_rounded,
                                          color: themeProvider.getAccentColor(),
                                          size: 24,
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
                                                  '${conversion.fromCurrency} → ${conversion.toCurrency}',
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
                                      ),
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
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                '${conversion.amount.toStringAsFixed(2)} ${conversion.fromCurrency}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: themeProvider.getSecondaryTextColor(),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              ScaleButton(
                                                onPressed: () {
                                                  historyProvider.toggleSaved(index);
                                                },
                                                child: Icon(
                                                  conversion.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                                  size: 18,
                                                  color: conversion.isSaved ? themeProvider.getAccentColor() : themeProvider.getSecondaryTextColor(),
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
