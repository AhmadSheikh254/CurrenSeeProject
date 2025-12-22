import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/conversion.dart';

class HistoryProvider extends ChangeNotifier {
  final List<Conversion> _conversions = [];
  String? _userId;
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://currensee-ce2a8-default-rtdb.firebaseio.com/',
  );

  List<Conversion> get conversions => List.unmodifiable(_conversions);
  String? get userId => _userId;

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
    _conversions.clear();
    
    if (_userId != null) {
      // Load from Realtime Database for authenticated user
      try {
        final snapshot = await _database
            .ref('users/$_userId/history')
            .get();
            
        if (snapshot.exists) {
          final Map<dynamic, dynamic> data = snapshot.value as Map;
          final List<Conversion> loadedConversions = [];
          
          data.forEach((key, value) {
            final conversionData = Map<String, dynamic>.from(value as Map);
            conversionData['id'] = key; // Use the push key as the ID
            loadedConversions.add(Conversion.fromJson(conversionData));
          });
          
          // Sort by date descending
          loadedConversions.sort((a, b) => b.date.compareTo(a.date));
          _conversions.addAll(loadedConversions);
        }
      } catch (e) {
        debugPrint("Error loading history from Realtime Database: $e");
      }
    } else {
      // Load from SharedPreferences for guest
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('conversion_history_guest');
      
      if (historyJson != null) {
        final List<dynamic> historyList = json.decode(historyJson);
        _conversions.addAll(
          historyList.map((item) => Conversion.fromJson(item)).toList()
        );
      }
    }
    notifyListeners();
  }

  // Save conversion history (Local only for guest)
  Future<void> _saveLocalHistory() async {
    if (_userId == null) {
      final prefs = await SharedPreferences.getInstance();
      final historyList = _conversions.map((c) => c.toJson()).toList();
      await prefs.setString('conversion_history_guest', json.encode(historyList));
    }
  }

  Future<void> addConversion(Conversion conversion) async {
    if (_userId != null) {
      // Add to Realtime Database
      try {
        final newRef = _database.ref('users/$_userId/history').push();
        await newRef.set(conversion.toJson());
            
        // Create new conversion object with the generated ID
        final newConversion = Conversion(
          id: newRef.key,
          fromCurrency: conversion.fromCurrency,
          toCurrency: conversion.toCurrency,
          amount: conversion.amount,
          result: conversion.result,
          date: conversion.date,
          isSaved: conversion.isSaved,
        );
        
        _conversions.insert(0, newConversion);
        notifyListeners();
      } catch (e) {
        debugPrint("Error adding conversion to Realtime Database: $e");
      }
    } else {
      // Guest mode
      _conversions.insert(0, conversion);
      notifyListeners();
      await _saveLocalHistory();
    }
  }

  Future<void> clearHistory() async {
    if (_userId != null) {
      // Clear from Realtime Database
      try {
        await _database.ref('users/$_userId/history').remove();
        _conversions.clear();
        notifyListeners();
      } catch (e) {
        debugPrint("Error clearing history from Realtime Database: $e");
      }
    } else {
      // Guest mode
      _conversions.clear();
      notifyListeners();
      await _saveLocalHistory();
    }
  }

  // Toggle saved status of a conversion
  Future<void> toggleSaved(int index) async {
    if (index >= 0 && index < _conversions.length) {
      final old = _conversions[index];
      final newValue = !old.isSaved;
      
      if (_userId != null && old.id != null) {
        // Update Realtime Database
        try {
          await _database
              .ref('users/$_userId/history/${old.id}')
              .update({'isSaved': newValue});
              
          // Update local state
          _conversions[index] = Conversion(
            id: old.id,
            fromCurrency: old.fromCurrency,
            toCurrency: old.toCurrency,
            amount: old.amount,
            result: old.result,
            date: old.date,
            isSaved: newValue,
          );
          notifyListeners();
        } catch (e) {
          debugPrint("Error updating saved status in Realtime Database: $e");
        }
      } else {
        // Guest mode or missing ID
        _conversions[index] = Conversion(
          id: old.id,
          fromCurrency: old.fromCurrency,
          toCurrency: old.toCurrency,
          amount: old.amount,
          result: old.result,
          date: old.date,
          isSaved: newValue,
        );
        notifyListeners();
        await _saveLocalHistory();
      }
    }
  }

  // Get number of saved conversions
  int get savedCount => _conversions.where((c) => c.isSaved).length;
}
