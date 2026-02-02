import 'package:flutter/material.dart';
import '../../models/lesson.dart';
import '../../services/admin_data_service.dart';

class AdminLessonDetailScreen extends StatefulWidget {
  final Lesson lesson;

  const AdminLessonDetailScreen({super.key, required this.lesson});

  @override
  State<AdminLessonDetailScreen> createState() =>
      _AdminLessonDetailScreenState();
}

class _AdminLessonDetailScreenState extends State<AdminLessonDetailScreen> {
  final AdminDataService _dataService = AdminDataService();
  late Lesson _lesson;

  @override
  void initState() {
    super.initState();
    _lesson = widget.lesson;
  }

  void _showEditDialog() {
    final titleController = TextEditingController(text: _lesson.title);
    final contentController = TextEditingController(text: _lesson.content);
    final descController = TextEditingController(text: _lesson.description);
    LessonStage stage = _lesson.stage;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Lesson'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      labelText: 'Content / Question',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: 'Description / Answer',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<LessonStage>(
                    value: stage,
                    items: LessonStage.values.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(s.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => stage = val!);
                    },
                    decoration: const InputDecoration(labelText: 'Stage'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      contentController.text.isNotEmpty) {
                    final updatedLesson = Lesson(
                      id: _lesson.id,
                      title: titleController.text,
                      content: contentController.text,
                      description: descController.text,
                      stage: stage,
                      nextReviewDate: _lesson.nextReviewDate,
                      streak: _lesson.streak,
                    );
                    _dataService.updateLesson(updatedLesson);
                    setState(() {
                      _lesson = updatedLesson;
                    });
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteLesson() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this lesson?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _dataService.deleteLesson(_lesson.id);
              Navigator.pop(ctx); // Close Dialog
              Navigator.of(context).pop(); // Close Detail Screen
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_lesson.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteLesson,
            tooltip: 'Delete Lesson',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getStageColor(_lesson.stage).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getStageColor(_lesson.stage).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.book,
                    size: 32,
                    color: _getStageColor(_lesson.stage),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _lesson.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Stage: ${_lesson.stage.toString().split('.').last.toUpperCase()}",
                          style: TextStyle(
                            color: _getStageColor(_lesson.stage),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Content / Question",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(_lesson.content, style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            const Text(
              "Description / Answer",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              _lesson.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showEditDialog,
                icon: const Icon(Icons.edit),
                label: const Text("Edit Lesson Content"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStageColor(LessonStage stage) {
    switch (stage) {
      case LessonStage.day1:
        return Colors.blue;
      case LessonStage.day3:
        return Colors.purple;
      case LessonStage.day7:
        return Colors.orange;
      case LessonStage.learned:
        return Colors.green;
    }
  }
}
