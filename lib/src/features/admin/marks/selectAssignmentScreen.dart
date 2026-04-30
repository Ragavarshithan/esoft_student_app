import 'package:esoft_student_app/src/features/admin/marks/manageMarksscreen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectAssignmentScreen extends ConsumerStatefulWidget {
  final String moduleId;
  final String moduleName;
  final String courseId;
  final String courseName;
  const SelectAssignmentScreen({
    super.key,
    required this.moduleId,
    required this.moduleName,
    required this.courseId,
    required this.courseName,
  });

  @override
  ConsumerState<SelectAssignmentScreen> createState() => _SelectAssignmentScreen();
}

class _SelectAssignmentScreen extends ConsumerState<SelectAssignmentScreen> {
  final LMSService _lmsService = LMSService();
  List<Assignment> _assignments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    final assignments = await _lmsService.getAssignmentsByModuleId(widget.moduleId);
    if (mounted) {
      setState(() {
        _assignments = assignments;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moduleName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _assignments.isEmpty
          ? const Center(child: Text('No assignments found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _assignments.length,
        itemBuilder: (context, index) {
          final assignment = _assignments[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageMarksScreen(
                    assignmentId: assignment.id,
                    assignmentTitle: assignment.title,
                    moduleId: widget.moduleId,
                    moduleName: widget.moduleName,
                    courseId: widget.courseId,
                    courseName: widget.courseName,
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1E3A8A),
                  child: Icon(Icons.assignment, color: Colors.white),
                ),
                title: Text(assignment.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              ),
            ),
          );
        },
      ),
    );
  }
}
