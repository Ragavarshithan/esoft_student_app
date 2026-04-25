import 'package:esoft_student_app/src/features/admin/attendance/manageAttendancescreen.dart';
import 'package:esoft_student_app/src/features/admin/manageModule/newModuleScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageModule/viewEditModuleScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageStudent/selectBatchScreen.dart';
import 'package:esoft_student_app/src/features/admin/marks/manageMarksscreen.dart';
import 'package:esoft_student_app/src/features/admin/marks/newMarksScreen.dart';
import 'package:esoft_student_app/src/features/admin/marks/selectAssignmentScreen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../services/mock_data_service.dart';
import '../../../models/user.dart';

class SelectLecturerStudentModuleScreen extends ConsumerStatefulWidget {
  final String batchId;
  final String courseId;
  final String courseName;
  const SelectLecturerStudentModuleScreen({super.key, required this.courseId, required this.courseName, required this.batchId});

  @override
  ConsumerState<SelectLecturerStudentModuleScreen> createState() => _SelectLecturerStudentModuleScreen();
}

class _SelectLecturerStudentModuleScreen extends ConsumerState<SelectLecturerStudentModuleScreen> {
  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final modules = mockService.modules.where((m) => m.courseId == widget.courseId).toList();


    return Scaffold(
      appBar: AppBar(
        title:  Text('${widget.courseName}'),
      ),
      body: modules.isEmpty
          ? const Center(child: Text('No Module found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];

          return InkWell(
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1E3A8A),
                  child: Icon(Icons.newspaper, color: Colors.white),
                ),
                title: Text(module.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectAssignmentScreen(moduleId: '', moduleName: '')));
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewMarksScreen()));

        },
      ),
    );
  }
}
