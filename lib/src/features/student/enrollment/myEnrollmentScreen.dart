import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/models/user.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';

class MyEnrollmentScreen extends StatefulWidget {
  const MyEnrollmentScreen({super.key});

  @override
  State<MyEnrollmentScreen> createState() => _MyEnrollmentScreenState();
}

class _MyEnrollmentScreenState extends State<MyEnrollmentScreen> {
  final LMSService _lmsService = LMSService();
  Course? _course;
  List<Module> _modules = [];
  List<Endrollment> _enrollments = [];
  Student? _student;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEnrollmentData();
  }

  Future<void> _loadEnrollmentData() async {
    setState(() => _isLoading = true);
    try {
      // // 1. Get student profile to find batchId
      // final student = await _lmsService.getStudentProfile();
      // if (student == null) throw Exception("Student profile not found");
      // _student = student;
      //
      // // 2. Get batch details to find courseId
      // final batch = await _lmsService.getBatchById(student.batchId);
      // if (batch == null || batch.courseId == null) throw Exception("Batch or course info not found");

      // 3. Get course details (optional but good for title) and modules
      final modules = await _lmsService.getModuleBycourseId(courseId: "45cb332f-ba00-4e99-9b53-b8c3e439ceee");
      final enrollments = await _lmsService.getEnrollmentsByStudentId("f31db78f-4b75-4f8d-857e-58d43f02f4ec");

      setState(() {
        _modules = modules;
        _enrollments = enrollments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  bool _isEnrolled(String moduleId) {
    return _enrollments.any((e) => e.moduleId == moduleId);
  }

  Future<void> _enroll(String moduleId) async {
    if (_student == null) return;

    final success = await _lmsService.createEnrollment(
      studentId: _student!.studentId,
      moduleId: moduleId,
    );

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully enrolled!'), backgroundColor: Colors.green),
        );
      }
      final enrollments = await _lmsService.getEnrollmentsByStudentId(_student!.studentId);
      setState(() {
        _enrollments = enrollments;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enrollment failed'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Module Enrollment'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Modules',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enroll in your course modules below:',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _modules.isEmpty
                        ? const Center(child: Text('No modules available for your course.'))
                        : ListView.builder(
                            itemCount: _modules.length,
                            itemBuilder: (context, index) {
                              final module = _modules[index];
                              final enrolled = _isEnrolled(module.id);
                              
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  title: Text(module.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  subtitle: Text('ID: ${module.id}'),
                                  trailing: ElevatedButton(
                                    onPressed: enrolled ? null : () => _enroll(module.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: enrolled ? Colors.green : Colors.grey[400],
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor: Colors.green,
                                      disabledForegroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: Text(enrolled ? 'Enrolled' : 'Enroll'),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
