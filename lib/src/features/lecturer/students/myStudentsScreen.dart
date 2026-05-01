import 'package:esoft_student_app/src/features/admin/manageStudent/selectBatchScreen.dart';
import 'package:esoft_student_app/src/features/lecturer/students/viewMyStudentScreen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_data_service.dart';

class MyStudentsScreen extends ConsumerStatefulWidget {
  final String courseName;
  final String batchName;
  const MyStudentsScreen({super.key, required this.courseName, required this.batchName});

  @override
  ConsumerState<MyStudentsScreen> createState() => _MyStudentsScreen();
}

class _MyStudentsScreen extends ConsumerState<MyStudentsScreen> {

  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final lecturer = mockService.users.whereType<Lecturer>().toList();
    final student = mockService.users.whereType<Student>().toList();

    final lecturerCourseIds = lecturer
        .expand((l) => l.assignedCourseIds!)
        .toSet();

    final myStudents = student
        .where((s) => s.enrolledCourseIds!
        .any((courseId) => lecturerCourseIds.contains(courseId)))
        .toList();


    return Scaffold(
      appBar: AppBar(
        title: const Text('My Students'),
      ),
      body: myStudents.isEmpty
          ? const Center(child: Text('No Students found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: myStudents.length,
        itemBuilder: (context, index) {
          final myStudent = myStudents[index];

          return InkWell(
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1E3A8A),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(myStudent.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewMyStudentScreen(course: widget.courseName, batch: widget.batchName, studentName: myStudent.name, studentEmail: myStudent.email,)));
                   }, child: Text('Click to view Details'),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewMyStudentScreen(course: widget.courseName, batch: widget.batchName, studentName: myStudent.name, studentEmail: myStudent.email,)));
            },
          );
        },
      ),
    );
  }
}
