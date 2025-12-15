import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/conversion.dart';

class HistoryProvider extends ChangeNotifier {
  final List<Conversion> _conversions = [];

  List<Conversion> get conversions => List.unmodifiable(_conversions);

  // Initialize and load saved history
  Future<void> init() async {
    await _loadHistory();
  }

  // Load saved conversion history
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('conversion_history');
    
    if (historyJson != null) {
      final List<dynamic> historyList = json.decode(historyJson);
      _conversions.clear();
      _conversions.addAll(
        historyList.map((item) => Conversion.fromJson(item)).toList()
      );
      notifyListeners();
    }
  }

  // Save conversion history
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = _conversions.map((c) => c.toJson()).toList();
    await prefs.setString('conversion_history', json.encode(historyList));
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
}
