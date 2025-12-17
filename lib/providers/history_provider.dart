import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/conversion.dart';

class HistoryProvider extends ChangeNotifier {
  final List<Conversion> _conversions = [];
  String? _userId;

  List<Conversion> get conversions => List.unmodifiable(_conversions);

  // Initialize and load saved history
  Future<void> init([String? userId]) async {
    _userId = userId;
    await _loadHistory();
  }
  
  // Update current user and reload history
  Future<void> updateUserId(String? userId) async {
    _userId = userId;
    await _loadHistory();
  }

  // Load saved conversion history
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _userId != null ? 'conversion_history_$_userId' : 'conversion_history_guest';
    final historyJson = prefs.getString(key);
    
    _conversions.clear();
    if (historyJson != null) {
      final List<dynamic> historyList = json.decode(historyJson);
      _conversions.addAll(
        historyList.map((item) => Conversion.fromJson(item)).toList()
      );
    }
    notifyListeners();
  }

  // Save conversion history
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _userId != null ? 'conversion_history_$_userId' : 'conversion_history_guest';
    final historyList = _conversions.map((c) => c.toJson()).toList();
    await prefs.setString(key, json.encode(historyList));
  }

  void addConversion(Conversion conversion) async {
    _conversions.insert(0, conversion);
    notifyListeners();
    await _saveHistory();
  }

  void clearHistory() async {
    _conversions.clear();
    notifyListeners();
    await _saveHistory();
  }

  // Toggle saved status of a conversion
  void toggleSaved(int index) async {
    if (index >= 0 && index < _conversions.length) {
      final old = _conversions[index];
      _conversions[index] = Conversion(
        fromCurrency: old.fromCurrency,
        toCurrency: old.toCurrency,
        amount: old.amount,
        result: old.result,
        date: old.date,
        isSaved: !old.isSaved,
      );
      notifyListeners();
      await _saveHistory();
    }
  }

  // Get number of saved conversions
  int get savedCount => _conversions.where((c) => c.isSaved).length;
}
