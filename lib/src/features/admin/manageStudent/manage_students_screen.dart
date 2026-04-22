import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_data_service.dart';
import '../../../models/user.dart';

class ManageStudentsScreen extends ConsumerStatefulWidget {
  final String StudentId;
  const ManageStudentsScreen({super.key, required this.StudentId});

  @override
  ConsumerState<ManageStudentsScreen> createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends ConsumerState<ManageStudentsScreen> {
  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final students = mockService.users.whereType<Student>().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Students'),
      ),
      body: students.isEmpty
          ? const Center(child: Text('No students found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF1E3A8A),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(student.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      onPressed: () {
                        // Edit generic action
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit feature coming soon!')));
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
           // Add action hook
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create student to be integrated with backend!')));
        },
      ),
    );
  }
}
