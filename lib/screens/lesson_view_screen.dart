import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../core/theme/app_theme.dart';
import 'flashcard_screen.dart'; // For Day 1 & Day 3 practice
import 'quiz_screen.dart'; // For Day 7 test

class LessonViewScreen extends StatelessWidget {
  final Lesson lesson;

  const LessonViewScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                lesson.title,
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (lesson.imageUrl != null)
                    Image.network(lesson.imageUrl!, fit: BoxFit.cover)
                  else
                    Container(color: AppTheme.primaryColor),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stage Indicator
                  _buildStageChip(lesson.stage),
                  const SizedBox(height: 16),

                  // Content
                  Text(
                    lesson.content,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons based on Stage
                  // Action Buttons based on Stage
                  if (lesson.stage == LessonStage.day1) ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Study Tools',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildActionButton(
                      context,
                      'Practice Flashcards',
                      Icons.style,
                      () => _openFlashcards(context),
                    ),
                    const SizedBox(height: 12),
                    if (lesson.videoUrl != null)
                      _buildActionButton(
                        context,
                        'Watch Video',
                        Icons.play_circle_filled,
                        () {
                          // Open Video
                        },
                        isSecondary: true,
                      ),
                    // STRICT 1-3-7 ENFORCEMENT
                  ] else if (!lesson.isDue &&
                      lesson.stage != LessonStage.learned) ...[
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.lock_clock,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Review Locked",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "According to the 1-3-7 method, you must wait before reviewing this topic to maximize memory retention.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Next Review: ${_formatDate(lesson.nextReviewDate)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else if (lesson.stage == LessonStage.day3) ...[
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Day 3 Revision: Quick Refresh",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildActionButton(
                      context,
                      'Start Flashcard Review',
                      Icons.refresh,
                      () => _openFlashcards(context),
                    ),
                  ] else if (lesson.stage == LessonStage.day7) ...[
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Day 7 Challenge: Prove your knowledge!",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildActionButton(
                      context,
                      'Take Assessment',
                      Icons.quiz,
                      () => _openQuiz(context),
                    ),
                  ],

                  // Mark Complete Button (Demo/Debug only - show if Day 1 or if Due)
                  if (lesson.stage == LessonStage.day1 || lesson.isDue) ...[
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // Mark complete manually for prototype (Simulated)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Lesson marked as complete!'),
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Mark Stage Complete (Demo Skip)'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFlashcards(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FlashcardScreen(lesson: lesson)),
    );
  }

  void _openQuiz(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QuizScreen(lesson: lesson)),
    );
  }

  Widget _buildStageChip(LessonStage stage) {
    String label = '';
    Color color = AppTheme.primaryColor;

    switch (stage) {
      case LessonStage.day1:
        label = 'Day 1: Learning Phase';
        break;
      case LessonStage.day3:
        label = 'Day 3: Memory Recall';
        color = AppTheme.secondaryColor;
        break;
      case LessonStage.day7:
        label = 'Day 7: Deep Test';
        color = AppTheme.accentColor;
        break;
      case LessonStage.learned:
        label = 'Mastered';
        color = Colors.green;
        break;
    }

    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isSecondary = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSecondary ? Colors.white : AppTheme.primaryColor,
        foregroundColor: isSecondary ? AppTheme.primaryColor : Colors.white,
        side: isSecondary
            ? const BorderSide(color: AppTheme.primaryColor)
            : null,
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
