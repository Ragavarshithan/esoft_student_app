import 'package:esoft_student_app/src/features/admin/manageAssignment/newAssignmentScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageAssignment/viewEditAssignmentScreen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_data_service.dart';

class ManageAssignmentScreen extends ConsumerStatefulWidget {
  final String moduleId;
  final String moduleName;
  final String courseName;
  const ManageAssignmentScreen({super.key, required this.moduleId, required this.moduleName, required this.courseName});

  @override
  ConsumerState<ManageAssignmentScreen> createState() => _ManageAssignmentScreen();
}

class _ManageAssignmentScreen extends ConsumerState<ManageAssignmentScreen> {
  final LMSService _lmsService = LMSService();
  List<Assignment> _assignments = [];

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    final assignments = await _lmsService.getAssignmentsByModuleId(widget.moduleId);
    setState(() {
      _assignments = assignments;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final assignments = mockService.assignments.where((a) => a.moduleId == widget.moduleId).toList();


    return Scaffold(
      appBar: AppBar(
        title:  Text('${widget.moduleName}'),
      ),
      body: _assignments.isEmpty
          ? const Center(child: Text('No assignments found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _assignments.length,
        itemBuilder: (context, index) {
          final assignment = _assignments[index];

          return InkWell(
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1E3A8A),
                  child: Icon(Icons.assignment, color: Colors.white),
                ),
                title: Text(assignment.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () async{
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  ViewEditAssignmentScreen(course: widget.courseName, module: widget.moduleName, assignmentTitle: assignment.title, dueDate: assignment.dueDate, description: assignment.description,moduleId: assignment.moduleId,assignmentId: assignment.id,)));
                    if(result == true) {
                      _loadAssignments();
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
        onPressed: () async{
         final result = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  CreateAssignmentScreen(course: widget.courseName, module: widget.moduleName,moduleId: widget.moduleId,)));
        if(result == true) {
          _loadAssignments();
        }
        },
      ),
    );
  }
}
