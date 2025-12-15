import 'package:flutter/material.dart';
import '../models/conversion.dart';

class HistoryProvider extends ChangeNotifier {
  final List<Conversion> _conversions = [];

  List<Conversion> get conversions => List.unmodifiable(_conversions);

  void addConversion(Conversion conversion) {
    _conversions.insert(0, conversion);
    notifyListeners();
  }

  void clearHistory() {
    _conversions.clear();
    notifyListeners();
  }
}
