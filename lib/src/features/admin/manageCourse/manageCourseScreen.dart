import 'package:esoft_student_app/src/features/admin/manageCourse/newCourseScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageCourse/viewEditCourseScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageStudent/selectBatchScreen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../services/mock_data_service.dart';
import '../../../models/user.dart';

class ManageCourseScreen extends ConsumerStatefulWidget {
  const ManageCourseScreen({super.key});

  @override
  ConsumerState<ManageCourseScreen> createState() => _ManageCourseScreen();
}

class _ManageCourseScreen extends ConsumerState<ManageCourseScreen> {
  final LMSService _lmsService = LMSService();
  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
     final courses = await _lmsService.getAllCourses();
     setState(() {
       _courses = courses;
     });
  }

  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final coursess = mockService.courses.whereType<Course>().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: _courses.isEmpty
          ? const Center(child: Text('No course found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];

          return InkWell(
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1E3A8A),
                  child: Icon(Icons.book, color: Colors.white),
                ),
                title: Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEditCourseScreen(courseData: course)));
                    if (result == true) {
                      _loadCourses();
                    }
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
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => newCourseScreen()));
          if (result == true) {
            _loadCourses();
          }
        },
      ),
    );
  }
}
