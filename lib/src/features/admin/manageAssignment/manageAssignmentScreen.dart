import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_data_service.dart';

class ManageAssignmentScreen extends ConsumerStatefulWidget {
  const ManageAssignmentScreen({super.key});

  @override
  ConsumerState<ManageAssignmentScreen> createState() => _ManageAssignmentScreen();
}

class _ManageAssignmentScreen extends ConsumerState<ManageAssignmentScreen> {
  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final assignments = mockService.assignments.whereType<Assignment>().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
      ),
      body: assignments.isEmpty
          ? const Center(child: Text('No assignments found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final assignment = assignments[index];

          return InkWell(
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1E3A8A),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(assignment.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    // Edit generic action
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit feature coming soon!')));
                  },
                ),
              ),
            ),
            onTap: () {

            },
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
