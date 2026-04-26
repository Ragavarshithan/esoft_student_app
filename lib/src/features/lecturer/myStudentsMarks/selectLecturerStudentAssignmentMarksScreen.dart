import 'package:esoft_student_app/src/features/admin/manageAssignment/newAssignmentScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageAssignment/viewEditAssignmentScreen.dart';
import 'package:esoft_student_app/src/features/lecturer/myStudentsMarks/myStudentsMarksScreen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_data_service.dart';

class selectLecturerStudentAssignmentMarksScreen extends ConsumerStatefulWidget {
  final String moduleId;
  final String moduleName;
  const selectLecturerStudentAssignmentMarksScreen({super.key, required this.moduleId, required this.moduleName});

  @override
  ConsumerState<selectLecturerStudentAssignmentMarksScreen> createState() => _selectLecturerStudentAssignmentMarksScreen();
}

class _selectLecturerStudentAssignmentMarksScreen extends ConsumerState<selectLecturerStudentAssignmentMarksScreen> {
  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final assignments = mockService.assignments.where((a) => a.moduleId == widget.moduleId).toList();


    return Scaffold(
      appBar: AppBar(
        title:  Text('${widget.moduleName}'),
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
                  child: Icon(Icons.assignment, color: Colors.white),
                ),
                title: Text(assignment.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: TextButton(
                    onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyStudentsMArksScreen())),
                    child: Text('View Marks', style: TextStyle(color: Color(0xFF1E3A8A)))
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyStudentsMArksScreen()));
            },
          );
        },
      ),
    );
  }
}
