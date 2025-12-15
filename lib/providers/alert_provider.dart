import 'package:flutter/material.dart';
import '../models/rate_alert.dart';

class AlertProvider extends ChangeNotifier {
  final List<RateAlert> _alerts = [];

  List<RateAlert> get alerts => List.unmodifiable(_alerts);

  void addAlert(RateAlert alert) {
    _alerts.add(alert);
    notifyListeners();
  }

  void removeAlert(String id) {
    _alerts.removeWhere((alert) => alert.id == id);
    notifyListeners();
  }

  void toggleAlert(String id) {
    final index = _alerts.indexWhere((alert) => alert.id == id);
    if (index != -1) {
      _alerts[index].isActive = !_alerts[index].isActive;
      notifyListeners();
    }
  }

  List<RateAlert> checkAlerts(double currentRate, String from, String to) {
    List<RateAlert> triggered = [];
    for (var alert in _alerts) {
      if (alert.isActive && alert.fromCurrency == from && alert.toCurrency == to) {
        if (alert.isAbove && currentRate >= alert.targetRate) {
          triggered.add(alert);
        } else if (!alert.isAbove && currentRate <= alert.targetRate) {
          triggered.add(alert);
        }
      }
    }
    return triggered;
  }
}
