import 'package:esoft_student_app/src/features/admin/manageStudent/selectBatchScreen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/mock_data_service.dart';

class MyCourseScreen extends ConsumerStatefulWidget {
  const MyCourseScreen({super.key});

  @override
  ConsumerState<MyCourseScreen> createState() => _MyCourseScreen();
}

class _MyCourseScreen extends ConsumerState<MyCourseScreen> {

  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final lecturer = mockService.users.whereType<Lecturer>().toList();
    final courses = mockService.courses
        .where((c) => lecturer
        .expand((l) => l.assignedCourseIds)
        .contains(c.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: courses.isEmpty
          ? const Center(child: Text('No course found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];

          return InkWell(
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1E3A8A),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => Selectbatchscreen(batchId: course.id)));
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
