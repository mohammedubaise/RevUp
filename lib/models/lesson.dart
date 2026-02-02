enum LessonStage {
  day1, // New Learning
  day3, // First Revision
  day7, // Strong Test
  learned, // Completed
}

class Flashcard {
  final String id;
  final String question;
  final String answer;
  final String? imageUrl;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    this.imageUrl,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'].toString(),
      question: json['question'],
      answer: json['answer'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final String content; // Paragraph content
  final String? imageUrl;
  final String? videoUrl;
  final List<Flashcard> flashcards;

  // Progress Data
  LessonStage stage;
  DateTime nextReviewDate;
  int streak;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    this.imageUrl,
    this.videoUrl,
    this.flashcards = const [],
    this.stage = LessonStage.day1,
    required this.nextReviewDate,
    this.streak = 0,
  });

  bool get isDue => DateTime.now().isAfter(nextReviewDate);

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      flashcards:
          (json['flashcards'] as List<dynamic>?)
              ?.map((f) => Flashcard.fromJson(f))
              .toList() ??
          [],
      stage: _stageFromString(json['stage']),
      nextReviewDate: DateTime.parse(json['next_review_date']),
      streak: json['streak'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      if (imageUrl != null) 'image_url': imageUrl,
      if (videoUrl != null) 'video_url': videoUrl,
      'flashcards': flashcards.map((f) => f.toJson()).toList(),
    };
  }

  static LessonStage _stageFromString(String stage) {
    switch (stage) {
      case 'day1':
        return LessonStage.day1;
      case 'day3':
        return LessonStage.day3;
      case 'day7':
        return LessonStage.day7;
      case 'learned':
        return LessonStage.learned;
      default:
        return LessonStage.day1;
    }
  }
}
