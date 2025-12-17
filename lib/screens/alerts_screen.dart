import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/alert_provider.dart';
import '../models/rate_alert.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, AlertProvider>(
      builder: (context, themeProvider, alertProvider, child) {
        final colors = themeProvider.getGradientColors();
        final alerts = alertProvider.alerts;

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
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: themeProvider.getTextColor()),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Text(
                              'Rate Alerts',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.getTextColor(),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline, color: themeProvider.getAccentColor(), size: 32),
                          onPressed: () => _showAddAlertDialog(context, themeProvider, alertProvider),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: alerts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_off_outlined,
                                  size: 64,
                                  color: themeProvider.getSecondaryTextColor().withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No active alerts',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: themeProvider.getSecondaryTextColor(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap + to create a new alert',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeProvider.getSecondaryTextColor(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: alerts.length,
                            itemBuilder: (context, index) {
                              final alert = alerts[index];
                              return Dismissible(
                                key: Key(alert.id),
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: const Icon(Icons.delete, color: Colors.white),
                                ),
                                onDismissed: (direction) {
                                  alertProvider.removeAlert(alert.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Alert removed')),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${alert.fromCurrency}/${alert.toCurrency}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: themeProvider.getTextColor(),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                alert.isAbove ? Icons.trending_up : Icons.trending_down,
                                                color: alert.isAbove ? Colors.green : Colors.red,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Target: ${alert.targetRate.toStringAsFixed(4)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: themeProvider.getSecondaryTextColor(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Switch(
                                        value: alert.isActive,
                                        onChanged: (value) {
                                          alertProvider.toggleAlert(alert.id);
                                        },
                                        activeColor: themeProvider.getAccentColor(),
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
          ),
        );
      },
    );
  }

  void _showAddAlertDialog(BuildContext context, ThemeProvider themeProvider, AlertProvider alertProvider) {
    String fromCurrency = 'USD';
    String toCurrency = 'EUR';
    final TextEditingController rateController = TextEditingController();
    bool isAbove = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: themeProvider.getCardBackgroundColor(),
            title: Text('Set Rate Alert', style: TextStyle(color: themeProvider.getTextColor())),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: fromCurrency,
                      dropdownColor: themeProvider.getCardBackgroundColor(),
                      style: TextStyle(color: themeProvider.getTextColor()),
                      items: ['USD', 'EUR', 'GBP', 'JPY'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() => fromCurrency = newValue!);
                      },
                    ),
                    Icon(Icons.arrow_forward, color: themeProvider.getTextColor()),
                    DropdownButton<String>(
                      value: toCurrency,
                      dropdownColor: themeProvider.getCardBackgroundColor(),
                      style: TextStyle(color: themeProvider.getTextColor()),
                      items: ['USD', 'EUR', 'GBP', 'JPY'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() => toCurrency = newValue!);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: rateController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: themeProvider.getTextColor()),
                  decoration: InputDecoration(
                    labelText: 'Target Rate',
                    labelStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeProvider.getBorderColor()),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeProvider.getAccentColor()),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alert when rate is:', style: TextStyle(color: themeProvider.getTextColor())),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Above'),
                          selected: isAbove,
                          onSelected: (selected) {
                            setState(() => isAbove = true);
                          },
                          selectedColor: Colors.green.withOpacity(0.2),
                          labelStyle: TextStyle(color: isAbove ? Colors.green : themeProvider.getSecondaryTextColor()),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Below'),
                          selected: !isAbove,
                          onSelected: (selected) {
                            setState(() => isAbove = false);
                          },
                          selectedColor: Colors.red.withOpacity(0.2),
                          labelStyle: TextStyle(color: !isAbove ? Colors.red : themeProvider.getSecondaryTextColor()),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (rateController.text.isNotEmpty) {
                    final alert = RateAlert(
                      id: DateTime.now().toString(),
                      fromCurrency: fromCurrency,
                      toCurrency: toCurrency,
                      targetRate: double.parse(rateController.text),
                      isAbove: isAbove,
                    );
                    alertProvider.addAlert(alert);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: themeProvider.getAccentColor()),
                child: const Text('Set Alert' , style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        },
      ),
    );
  }
}
