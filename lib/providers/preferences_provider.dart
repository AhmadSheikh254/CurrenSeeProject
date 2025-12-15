import 'package:flutter/material.dart';

class PreferencesProvider extends ChangeNotifier {
  String _defaultBaseCurrency = 'USD';
  bool _notificationsEnabled = true;

  String get defaultBaseCurrency => _defaultBaseCurrency;
  bool get notificationsEnabled => _notificationsEnabled;

  void setDefaultBaseCurrency(String currency) {
    _defaultBaseCurrency = currency;
    notifyListeners();
  }

  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
    notifyListeners();
  }
}
