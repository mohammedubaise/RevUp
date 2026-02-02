import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/lesson.dart';
import '../core/theme/app_theme.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const LessonCard({super.key, required this.lesson, required this.onTap});

  Color _getStageColor(LessonStage stage) {
    switch (stage) {
      case LessonStage.day1:
        return AppTheme.primaryColor;
      case LessonStage.day3:
        return AppTheme.secondaryColor;
      case LessonStage.day7:
        return AppTheme.accentColor;
      case LessonStage.learned:
        return Colors.green;
    }
  }

  String _getStageLabel(LessonStage stage) {
    switch (stage) {
      case LessonStage.day1:
        return 'Learn Today';
      case LessonStage.day3:
        return 'Review (Day 3)';
      case LessonStage.day7:
        return 'Test (Day 7)';
      case LessonStage.learned:
        return 'Learned';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Lesson Image or Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                  image: lesson.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(lesson.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: lesson.imageUrl == null
                    ? const Icon(Icons.school, color: Colors.grey, size: 30)
                    : null,
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStageColor(lesson.stage).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getStageColor(lesson.stage).withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getStageLabel(lesson.stage),
                        style: TextStyle(
                          color: _getStageColor(lesson.stage),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Action Icon
              if (lesson.isDue)
                Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.accentColor,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .shimmer(delay: 500.ms, duration: 1200.ms)
              else
                const Icon(Icons.check_circle, color: Colors.grey),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }
}
