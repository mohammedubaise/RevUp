import 'package:flutter/material.dart';
import '../../models/lesson.dart';
import '../../services/admin_data_service.dart';
import 'admin_lesson_detail_screen.dart';

class AdminContentScreen extends StatefulWidget {
  const AdminContentScreen({super.key});

  @override
  State<AdminContentScreen> createState() => _AdminContentScreenState();
}

class _AdminContentScreenState extends State<AdminContentScreen> {
  final AdminDataService _dataService = AdminDataService();
  List<Lesson> _lessons = [];

  @override
  void initState() {
    super.initState();
    _refreshLessons();
  }

  void _refreshLessons() {
    setState(() {
      _lessons = _dataService.getLessons();
    });
  }

  void _showLessonDialog({Lesson? lesson}) {
    // ... (Preserving dialog logic, re-implementing for valid file replacement)
    final isEditing = lesson != null;
    final titleController = TextEditingController(text: lesson?.title ?? '');
    final contentController = TextEditingController(
      text: lesson?.content ?? '',
    );
    final descController = TextEditingController(
      text: lesson?.description ?? '',
    );
    LessonStage stage = lesson?.stage ?? LessonStage.day1;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(isEditing ? 'Edit Lesson' : 'Add Lesson'),
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
                    if (isEditing) {
                      final updatedLesson = Lesson(
                        id: lesson!.id,
                        title: titleController.text,
                        content: contentController.text,
                        description: descController.text,
                        stage: stage,
                        nextReviewDate: lesson.nextReviewDate,
                        streak: lesson.streak,
                      );
                      _dataService.updateLesson(updatedLesson);
                    } else {
                      final newLesson = Lesson(
                        id: 'p${DateTime.now().millisecondsSinceEpoch}',
                        title: titleController.text,
                        content: contentController.text,
                        description: descController.text,
                        stage: stage,
                        nextReviewDate: DateTime.now(),
                        streak: 0,
                      );
                      _dataService.addLesson(newLesson);
                    }
                    Navigator.pop(ctx);
                    _refreshLessons();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Studio'),
        // Unified Theme
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showLessonDialog(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _lessons.length,
        itemBuilder: (context, index) {
          final lesson = _lessons[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminLessonDetailScreen(lesson: lesson),
                  ),
                );
                _refreshLessons();
              },
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStageColor(lesson.stage).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.book, color: _getStageColor(lesson.stage)),
              ),
              title: Text(
                lesson.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${lesson.stage.toString().split('.').last} • ${lesson.description}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
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
