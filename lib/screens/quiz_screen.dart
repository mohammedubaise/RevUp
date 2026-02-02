import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../core/theme/app_theme.dart';

class QuizScreen extends StatefulWidget {
  final Lesson lesson;
  const QuizScreen({super.key, required this.lesson});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _answerController = TextEditingController();
  bool _isSubmitted = false;

  void _submit() {
    setState(() {
      _isSubmitted = true;
    });

    // Mock validation logic
    Future.delayed(const Duration(seconds: 2), () {
      _showResult();
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Assessment Complete'),
        content: const Text('Your answer has been recorded. Great effort!'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Assessment Completed!')),
              );
              Navigator.pop(ctx);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // For prototype, we generate a generic question from content if no specific quiz data
    // In real app, Lesson model would have a 'quizzes' list
    final question =
        "Explain the main concept of '${widget.lesson.title}' in your own words.";

    return Scaffold(
      appBar: AppBar(title: const Text('Day 7 Assessment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Short Answer Question",
              style: TextStyle(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _answerController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: "Type your answer here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitted ? null : _submit,
                child: _isSubmitted
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Submit Answer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
