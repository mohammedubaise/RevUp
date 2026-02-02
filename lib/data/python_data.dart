import '../models/lesson.dart';

class PythonDummyData {
  static final List<Map<String, dynamic>> rawQuestions = [
    {
      'id': 'p1',
      'question': 'What represents a comment in Python?',
      'answer': '#',
      'stage': 'day1',
      'description': 'Comments in Python start with a hash symbol.',
      'streak': 0,
    },
    {
      'id': 'p2',
      'question': 'Which function outputs text to the console?',
      'answer': 'print()',
      'stage': 'day1',
      'description':
          'print("Hello") is the standard way to output string data.',
      'streak': 0,
    },
    {
      'id': 'p3',
      'question': 'How do you create a variable?',
      'answer': 'x = 5',
      'stage': 'day1',
      'description': 'Variables are assigned using the = operator.',
      'streak': 0,
    },
    {
      'id': 'p4',
      'question': 'What is the boolean for true?',
      'answer': 'True',
      'stage': 'day3',
      'description': 'Python uses Capitalized Booleans: True and False.',
      'streak': 2,
    },
    {
      'id': 'p5',
      'question': 'Which keyword defines a function?',
      'answer': 'def',
      'stage': 'day3',
      'description': 'Functions are defined using "def function_name():"',
      'streak': 2,
    },
    {
      'id': 'p6',
      'question': 'How do you start a for loop?',
      'answer': 'for x in y:',
      'stage': 'day3',
      'description': 'Iteration is done with "for item in iterable:" syntax.',
      'streak': 2,
    },
    {
      'id': 'p7',
      'question': 'What data type is [1, 2, 3]?',
      'answer': 'list',
      'stage': 'day7',
      'description': 'Square brackets denote a mutable list.',
      'streak': 6,
    },
    {
      'id': 'p8',
      'question': 'How do you import a module?',
      'answer': 'import math',
      'stage': 'day7',
      'description': 'The import keyword brings in external modules.',
      'streak': 6,
    },
    {
      'id': 'p9',
      'question': 'What is the output of 2 ** 3?',
      'answer': '8',
      'stage': 'day7',
      'description': '** is the exponentiation operator.',
      'streak': 6,
    },
    {
      'id': 'p10',
      'question': 'Which method adds to a list?',
      'answer': '.append()',
      'stage': 'learned',
      'description': 'list.append(item) adds an element to the end.',
      'streak': 7,
    },
  ];

  static List<Lesson> getLessons() {
    return rawQuestions.map((q) {
      return Lesson(
        id: q['id'],
        title: 'Python Concept: ${q['answer']}',
        description: q['description'],
        content: q['question'], // Using content as the question context
        nextReviewDate: DateTime.now(), // Dummy logic
        stage: _parseStage(q['stage']),
        streak: q['streak'],
        flashcards: [
          Flashcard(
            id: q['id'] + '_f',
            question: q['question'],
            answer: q['answer'],
          ),
        ],
      );
    }).toList();
  }

  static LessonStage _parseStage(String stageStr) {
    switch (stageStr) {
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
