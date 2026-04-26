import 'package:esoft_student_app/src/features/admin/attendance/selectBatchAttendanceScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageStudent/selectBatchScreen.dart';
import 'package:esoft_student_app/src/features/admin/marks/selectBatchMarksScreen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../services/mock_data_service.dart';
import '../../../models/user.dart';

class SelectcourseMarksScreen extends ConsumerStatefulWidget {
  const SelectcourseMarksScreen({super.key});

  @override
  ConsumerState<SelectcourseMarksScreen> createState() => _SelectcourseMarksScreen();
}

class _SelectcourseMarksScreen extends ConsumerState<SelectcourseMarksScreen> {
  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final courses = mockService.courses.whereType<Course>().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Course'),
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
                trailing: TextButton(
                    onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => SelectBatchMarksScreen(batchId: course.id,course: course.name,courseId: course.id,))),
                    child: const Text('View Batches', style: TextStyle(color: Color(0xFF1E3A8A))),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SelectBatchMarksScreen(batchId: course.id,course: course.name,courseId: course.id,)));
            },
          );
        },
      ),
    );
  }
}
