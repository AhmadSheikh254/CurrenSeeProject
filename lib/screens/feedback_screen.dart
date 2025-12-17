import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/feedback_provider.dart';
import '../models/feedback_entry.dart';
import '../widgets/animations.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final email = _emailController.text.trim();
    if (title.isEmpty || description.isEmpty) return;

    final entry = FeedbackEntry(
      id: DateTime.now().toIso8601String(),
      title: title,
      description: description,
      email: email,
      date: DateTime.now(),
    );
    Provider.of<FeedbackProvider>(context, listen: false).addFeedback(entry);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your feedback!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final colors = themeProvider.getGradientColors();
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
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: themeProvider.getTextColor()),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Feedback',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.getTextColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInSlide(
                            delay: 0.0,
                            child: TextField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                labelText: 'Title',
                                labelStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: themeProvider.getBorderColor()),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: themeProvider.getAccentColor()),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FadeInSlide(
                            delay: 0.1,
                            child: TextField(
                              controller: _descriptionController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: themeProvider.getBorderColor()),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: themeProvider.getAccentColor()),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FadeInSlide(
                            delay: 0.2,
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email (optional)',
                                labelStyle: TextStyle(color: themeProvider.getSecondaryTextColor()),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: themeProvider.getBorderColor()),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: themeProvider.getAccentColor()),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          FadeInSlide(
                            delay: 0.3,
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeProvider.getAccentColor(),
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                ),
                                onPressed: _submitFeedback,
                                child: const Text('Submit',style: TextStyle(color: Colors.black)),
                              ),
                            ),
                          ),
                        ],
                      ),
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
}
