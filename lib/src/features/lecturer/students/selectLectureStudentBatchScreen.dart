import 'package:esoft_student_app/src/features/admin/manageBatch/addBatchScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageStudent/manage_students_screen.dart';
import 'package:esoft_student_app/src/features/lecturer/students/selectLectureStudentModulesScreen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../services/mock_data_service.dart';

class SelectLecturerStudentBatchScreen extends ConsumerStatefulWidget {
  final String courseId;
  const SelectLecturerStudentBatchScreen({super.key, required this.courseId});

  @override
  ConsumerState<SelectLecturerStudentBatchScreen> createState() => _SelectLecturerStudentBatchScreen();
}

class _SelectLecturerStudentBatchScreen extends ConsumerState<SelectLecturerStudentBatchScreen> {
  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final batchIds = mockService.courses.where((c) => c.id == widget.courseId).expand((b) => b.batchId.toSet());
    final filteredBatches = mockService.batches.where((b) => batchIds.contains(b.id)).toList();
    final courseName = mockService.courses.where((c) => c.id == widget.courseId).map((c) => c.name).first;

    return Scaffold(
      appBar: AppBar(
        title:  Text('${courseName}'),
      ),
      body: filteredBatches.isEmpty
          ? const Center(child: Text('No batches found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredBatches.length,
        itemBuilder: (context, index) {
          final batch = filteredBatches[index];

          return InkWell(
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1E3A8A),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(batch.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: TextButton(
                    onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => SelectLecturerStudentModuleScreen(courseId: widget.courseId, courseName: courseName, batchId: batch.id,batchName: batch.name))),
                    child: Text('View Modules', style: const TextStyle(color: Color(0xFF1E3A8A))),
                ),
              ),
            ),
            onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SelectLecturerStudentModuleScreen(courseId: widget.courseId, courseName: courseName, batchId: batch.id,batchName: batch.name)));
            },
          );
        },
      ),
    );
  }
}
