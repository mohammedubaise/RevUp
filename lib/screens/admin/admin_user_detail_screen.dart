import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/user_model.dart';
import '../../services/admin_data_service.dart';

class AdminUserDetailScreen extends StatefulWidget {
  final User user;

  const AdminUserDetailScreen({super.key, required this.user});

  @override
  State<AdminUserDetailScreen> createState() => _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState extends State<AdminUserDetailScreen> {
  final AdminDataService _dataService = AdminDataService();
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  void _toggleBan() {
    final updatedUser = User(
      id: _user.id,
      name: _user.name,
      email: _user.email,
      role: _user.role,
      joinedDate: _user.joinedDate,
      isBanned: !_user.isBanned,
    );
    _dataService.updateUser(updatedUser);
    setState(() {
      _user = updatedUser;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_user.isBanned ? 'User Banned' : 'User Unbanned')),
    );
  }

  void _showEditDialog() {
    final nameController = TextEditingController(text: _user.name);
    final emailController = TextEditingController(text: _user.email);
    String role = _user.role;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit User'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: role,
                    items: const [
                      DropdownMenuItem(value: 'user', child: Text('User')),
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    ],
                    onChanged: (val) {
                      setState(() => role = val!);
                    },
                    decoration: const InputDecoration(labelText: 'Role'),
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
                  if (nameController.text.isNotEmpty &&
                      emailController.text.isNotEmpty) {
                    final updatedUser = User(
                      id: _user.id,
                      name: nameController.text,
                      email: emailController.text,
                      role: role,
                      joinedDate: _user.joinedDate,
                      isBanned: _user.isBanned,
                    );
                    _dataService.updateUser(updatedUser);
                    setState(() {
                      _user = updatedUser;
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

  void _deleteUser() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _dataService.deleteUser(_user.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
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
        title: Text(_user.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteUser,
            tooltip: 'Delete User',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Card
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: _user.isBanned
                        ? Colors.red.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    child: Text(
                      _user.name[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 40,
                        color: _user.isBanned ? Colors.red : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _user.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: _user.isBanned
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  Text(_user.email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(_user.role.toUpperCase()),
                    backgroundColor: _user.role == 'admin'
                        ? Colors.deepPurple.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: _user.role == 'admin'
                          ? Colors.deepPurple
                          : Colors.blue,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().scale(),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),

            // Details
            _buildDetailRow(
              Icons.calendar_today,
              "Joined Date",
              _user.joinedDate.toString().split(' ')[0],
            ),
            _buildDetailRow(
              Icons.security,
              "Status",
              _user.isBanned ? "Banned" : "Active",
            ),

            const SizedBox(height: 40),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showEditDialog,
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Profile"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggleBan,
                    icon: Icon(
                      _user.isBanned ? Icons.check_circle : Icons.block,
                    ),
                    label: Text(_user.isBanned ? "Unban User" : "Ban User"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _user.isBanned
                          ? Colors.green
                          : Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
