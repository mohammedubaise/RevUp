import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class CreateLessonScreen extends StatefulWidget {
  const CreateLessonScreen({super.key});

  @override
  State<CreateLessonScreen> createState() => _CreateLessonScreenState();
}

class _CreateLessonScreenState extends State<CreateLessonScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _contentController = TextEditingController();
  final _videoUrlController = TextEditingController();
  final _imageUrlController = TextEditingController();

  // Dynamic Flashcards
  final List<FlashcardController> _flashcardControllers = [
    FlashcardController(),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _contentController.dispose();
    _videoUrlController.dispose();
    _imageUrlController.dispose();
    for (var fc in _flashcardControllers) {
      fc.dispose();
    }
    super.dispose();
  }

  void _addFlashcard() {
    setState(() {
      _flashcardControllers.add(FlashcardController());
    });
  }

  void _removeFlashcard(int index) {
    if (_flashcardControllers.length > 1) {
      setState(() {
        _flashcardControllers[index].dispose();
        _flashcardControllers.removeAt(index);
      });
    }
  }

  Future<void> _saveLesson() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;

        // Success - go back
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lesson Created Successfully! (Frontend Mock)'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating lesson: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Lesson'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Lesson Details'),
              TextFormField(
                controller: _titleController,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g. French Basics',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Title required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  labelText: 'Short Description',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Description required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                enabled: !_isLoading,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Study Content (Paragraph)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Content required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  labelText: 'Image URL (Optional)',
                  prefixIcon: Icon(Icons.image),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _videoUrlController,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  labelText: 'Video Link (Optional)',
                  prefixIcon: Icon(Icons.video_library),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader('Flashcards & Q/A'),
              const Text(
                'Add questions to test yourself later (Day 1, 3, 7)',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _flashcardControllers.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Card ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              if (_flashcardControllers.length > 1 &&
                                  !_isLoading)
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removeFlashcard(index),
                                ),
                            ],
                          ),
                          TextFormField(
                            controller: _flashcardControllers[index].question,
                            enabled: !_isLoading,
                            decoration: const InputDecoration(
                              labelText: 'Question',
                            ),
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Question required'
                                : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _flashcardControllers[index].answer,
                            enabled: !_isLoading,
                            decoration: const InputDecoration(
                              labelText: 'Answer',
                            ),
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Answer required'
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              Center(
                child: TextButton.icon(
                  onPressed: _isLoading ? null : _addFlashcard,
                  icon: const Icon(Icons.add_circle),
                  label: const Text('Add Another Flashcard'),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveLesson,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Save Lesson to Database'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}

class FlashcardController {
  final TextEditingController question = TextEditingController();
  final TextEditingController answer = TextEditingController();

  void dispose() {
    question.dispose();
    answer.dispose();
  }
}
