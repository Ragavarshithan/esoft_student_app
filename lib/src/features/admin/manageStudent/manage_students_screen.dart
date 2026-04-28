import 'package:esoft_student_app/src/features/admin/manageStudent/viewEditStudentScreen.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_data_service.dart';
import '../../../models/user.dart';
import 'addStudentScreen.dart';

class ManageStudentsScreen extends ConsumerStatefulWidget {
  final String batchId;
  final String courseName;
  final String batch;
  const ManageStudentsScreen({super.key, required this.batchId, required this.batch, required this.courseName});

  @override
  ConsumerState<ManageStudentsScreen> createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends ConsumerState<ManageStudentsScreen> {
  final LMSService _lmsService = LMSService();
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async{
    final students = await _lmsService.getStudentsByBatchId(batchId: widget.batchId);
    setState(() {
      _students = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final students = mockService.users.whereType<Student>().toList();

    return Scaffold(
      appBar: AppBar(
        title:  Text('${widget.batch} Students'),
      ),
      body: _students.isEmpty
          ? const Center(child: Text('No students found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                
                return GestureDetector(
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF1E3A8A),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(student.email),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: () {
                          // Edit generic action
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEditStudentScreen(course: widget.courseName, batch: widget.batch, studentName: student.name, studentEmail: student.email,batchId: student.batchId,studentId: student.id,)));
                        },
                      ),
                    ),
                  ),
                  onTap: () {},
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) => AddStudentScreen(course: widget.courseName, batch: widget.batch,batchId: '')));
        },
      ),
    );
  }
}
