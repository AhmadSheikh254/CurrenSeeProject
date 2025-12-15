import 'package:flutter/material.dart';
import '../models/feedback_entry.dart';

class FeedbackProvider extends ChangeNotifier {
  final List<FeedbackEntry> _feedbacks = [];

  List<FeedbackEntry> get feedbacks => List.unmodifiable(_feedbacks);

  void addFeedback(FeedbackEntry entry) {
    _feedbacks.add(entry);
    notifyListeners();
  }
}
