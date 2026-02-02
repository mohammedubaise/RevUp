import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../core/theme/app_theme.dart';

class FlashcardScreen extends StatefulWidget {
  final Lesson lesson;
  const FlashcardScreen({super.key, required this.lesson});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;

  void _nextCard() {
    if (_currentIndex < widget.lesson.flashcards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      // Finished
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Great Job! 🎉'),
        content: const Text('You have reviewed all flashcards.'),
        actions: [
          TextButton(
            onPressed: () {
              // Mark complete logic (Simulated)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lesson marked as complete!')),
              );
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Back to lesson view
              Navigator.pop(
                context,
              ); // Back to dashboard (optional, depends on flow)
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lesson.flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("No flashcards for this lesson.")),
      );
    }

    final currentCard = widget.lesson.flashcards[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (_currentIndex + 1) / widget.lesson.flashcards.length,
            backgroundColor: Colors.grey[200],
            color: AppTheme.secondaryColor,
          ),
          const SizedBox(height: 20),

          // Counter
          Text(
            'Card ${_currentIndex + 1} / ${widget.lesson.flashcards.length}',
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),

          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showAnswer = !_showAnswer;
                  });
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: _showAnswer
                      ? _buildCardSide(currentCard.answer, Colors.white, true)
                      : _buildCardSide(
                          currentCard.question,
                          AppTheme.primaryColor,
                          false,
                        ),
                ),
              ),
            ),
          ),

          // Controls
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_showAnswer) ...[
                  ElevatedButton.icon(
                    onPressed: _nextCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    icon: const Icon(Icons.close),
                    label: const Text('Forget'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _nextCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text('Recalled'),
                  ),
                ] else
                  const Text(
                    "Tap card to flip",
                    style: TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSide(String text, Color color, bool isAnswer) {
    return Container(
      key: ValueKey(isAnswer),
      width: 300,
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isAnswer ? "ANSWER" : "QUESTION",
            style: TextStyle(
              color: isAnswer ? Colors.grey : Colors.white70,
              fontSize: 14,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isAnswer ? Colors.black87 : Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
