class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin' or 'user'
  final DateTime joinedDate;
  bool isBanned;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
    required this.joinedDate,
    this.isBanned = false,
  });
}
