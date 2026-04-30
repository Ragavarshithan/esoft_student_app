import 'package:esoft_student_app/src/features/admin/attendance/manageAttendancescreen.dart';
import 'package:esoft_student_app/src/features/admin/manageModule/newModuleScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageModule/viewEditModuleScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageStudent/selectBatchScreen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../services/lms_service.dart';
import '../../../services/mock_data_service.dart';
import '../../../models/user.dart';

class SelectModuleAttendanceScreen extends ConsumerStatefulWidget {
  final String batchId;
  final String courseId;
  final String courseName;
  const SelectModuleAttendanceScreen({super.key, required this.courseId, required this.courseName, required this.batchId});

  @override
  ConsumerState<SelectModuleAttendanceScreen> createState() => _SelectModuleAttendanceScreen();
}

class _SelectModuleAttendanceScreen extends ConsumerState<SelectModuleAttendanceScreen> {
  final LMSService _lmsService = LMSService();
  List<Module> _modules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    final modules = await _lmsService.getModuleBycourseId(courseId: widget.courseId);
    if (mounted) {
      setState(() {
        _modules = modules;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.courseName}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _modules.isEmpty
          ? const Center(child: Text('No Module found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _modules.length,
        itemBuilder: (context, index) {
          final module = _modules[index];

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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageAttendanceScreen(
                        moduleId: module.id,
                        moduleName: module.name,
                        courseId: widget.courseId,
                        courseName: widget.courseName,
                      ),
                    ),
                  ),
                  child: const Text('View Attendance', style: TextStyle(color: Color(0xFF1E3A8A))),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageAttendanceScreen(
                    moduleId: module.id,
                    moduleName: module.name,
                    courseId: widget.courseId,
                    courseName: widget.courseName,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
