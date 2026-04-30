import 'package:esoft_student_app/src/features/admin/marks/selectAssignmentScreen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectModuleMarksScreen extends ConsumerStatefulWidget {
  final String batchId;
  final String courseId;
  final String courseName;
  const SelectModuleMarksScreen({super.key, required this.courseId, required this.courseName, required this.batchId});

  @override
  ConsumerState<SelectModuleMarksScreen> createState() => _SelectModuleMarksScreen();
}

class _SelectModuleMarksScreen extends ConsumerState<SelectModuleMarksScreen> {
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
        title: Text(widget.courseName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _modules.isEmpty
          ? const Center(child: Text('No modules found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _modules.length,
        itemBuilder: (context, index) {
          final module = _modules[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectAssignmentScreen(
                    moduleId: module.id,
                    moduleName: module.name,
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
                  child: Icon(Icons.folder, color: Colors.white),
                ),
                title: Text(module.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              ),
            ),
          );
        },
      ),
    );
  }
}
