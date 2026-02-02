import '../models/user_model.dart';
import '../models/lesson.dart';
import '../data/python_data.dart';

class AdminDataService {
  // Singleton pattern
  static final AdminDataService _instance = AdminDataService._internal();

  factory AdminDataService() {
    return _instance;
  }

  AdminDataService._internal() {
    _initMockData();
  }

  List<User> _users = [];
  List<Lesson> _lessons = [];

  void _initMockData() {
    // Init Users
    _users = [
      User(
        id: 'u1',
        name: 'Admin User',
        email: 'admin@test.com',
        role: 'admin',
        joinedDate: DateTime.now().subtract(const Duration(days: 365)),
      ),
      User(
        id: 'u2',
        name: 'John Student',
        email: 'john@student.com',
        role: 'user',
        joinedDate: DateTime.now().subtract(const Duration(days: 30)),
      ),
      User(
        id: 'u3',
        name: 'Sarah Learner',
        email: 'sarah@student.com',
        role: 'user',
        joinedDate: DateTime.now().subtract(const Duration(days: 15)),
      ),
      User(
        id: 'u4',
        name: 'Bad Actor',
        email: 'bad@student.com',
        role: 'user',
        joinedDate: DateTime.now().subtract(const Duration(days: 2)),
        isBanned: true,
      ),
    ];

    // Init Lessons - get from PythonDummyData initally
    _lessons = List.from(PythonDummyData.getLessons());
  }

  // --- User CRUD ---
  List<User> getUsers() {
    return _users;
  }

  void addUser(User user) {
    _users.add(user);
  }

  void updateUser(User updatedUser) {
    final index = _users.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
    }
  }

  void deleteUser(String id) {
    _users.removeWhere((u) => u.id == id);
  }

  // --- Lesson CRUD ---
  List<Lesson> getLessons() {
    return _lessons;
  }

  void addLesson(Lesson lesson) {
    _lessons.add(lesson);
  }

  void updateLesson(Lesson updatedLesson) {
    final index = _lessons.indexWhere((l) => l.id == updatedLesson.id);
    if (index != -1) {
      _lessons[index] = updatedLesson;
    }
  }

  void deleteLesson(String id) {
    _lessons.removeWhere((l) => l.id == id);
  }
}
