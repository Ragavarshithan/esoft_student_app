import 'package:esoft_student_app/src/features/admin/manageAssignment/assignmentmanageModuleScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageModule/manageModuleScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageStudent/selectBatchScreen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../services/mock_data_service.dart';
import '../../../models/user.dart';

class AssignmentManageCourseScreen extends ConsumerStatefulWidget {
  const AssignmentManageCourseScreen({super.key});

  @override
  ConsumerState<AssignmentManageCourseScreen> createState() => _AssignmentManageCourseScreen();
}

class _AssignmentManageCourseScreen extends ConsumerState<AssignmentManageCourseScreen> {
  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final courses = mockService.courses.whereType<Course>().toList();

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
                  child: Icon(Icons.book, color: Colors.white),
                ),
                title: Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: TextButton(
                    onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => AssignmentManageModuleScreen(courseId: course.id,courseName: course.name,))),
                    child: const Text('View Modules', style: TextStyle(color: Color(0xFF1E3A8A))),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  AssignmentManageModuleScreen(courseId: course.id,courseName: course.name,)));
            },
          );
        },
      ),
    );
  }
}
