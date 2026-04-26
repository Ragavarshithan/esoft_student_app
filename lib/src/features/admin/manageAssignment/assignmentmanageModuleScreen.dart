import 'package:esoft_student_app/src/features/admin/manageAssignment/assignmentManageBatch.dart';
import 'package:esoft_student_app/src/features/admin/manageAssignment/manageAssignmentScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageStudent/selectBatchScreen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../services/mock_data_service.dart';
import '../../../models/user.dart';

class AssignmentManageModuleScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String courseName;
  const AssignmentManageModuleScreen({super.key, required this.courseId, required this.courseName});

  @override
  ConsumerState<AssignmentManageModuleScreen> createState() => _AssignmentManageModuleScreen();
}

class _AssignmentManageModuleScreen extends ConsumerState<AssignmentManageModuleScreen> {
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
                trailing: TextButton(
                    onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => AssignmentManagebatchScreen(courseId: widget.courseId,moduleId: module.id,moduleName: module.name,))),
                    child: const Text('View Batches', style: TextStyle(color: Color(0xFF1E3A8A))),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  AssignmentManagebatchScreen(courseId: widget.courseId,moduleId: module.id,moduleName: module.name,)));
            },
          );
        },
      ),
    );
  }
}
