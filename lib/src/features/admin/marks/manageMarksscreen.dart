import 'dart:math';

import 'package:esoft_student_app/src/features/admin/attendance/newAttendance.dart';
import 'package:esoft_student_app/src/features/admin/manageStudent/viewEditStudentScreen.dart';
import 'package:esoft_student_app/src/features/admin/marks/newMarksScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_data_service.dart';
import '../../../models/user.dart';

class ManageMarksScreen extends ConsumerStatefulWidget {
  final String batchId;
  final String course;
  final String batch;
  const ManageMarksScreen({super.key, required this.batchId, required this.batch, required this.course});

  @override
  ConsumerState<ManageMarksScreen> createState() => _ManageMarksScreenState();
}

class _ManageMarksScreenState extends ConsumerState<ManageMarksScreen> {

  final Random random = Random();
  late List<int> _randomMarks;
  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final students = mockService.users.whereType<Student>().toList();
    final myMarks = mockService.marks;
    _randomMarks = List.generate(students.length, (_) => random.nextInt(61) + 30);


    return Scaffold(
      appBar: AppBar(
        title:  Text('${widget.batch} Students'),
      ),
      body: students.isEmpty
          ? const Center(child: Text('No students found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                
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
                      trailing: Text('${_randomMarks[index]}%',
                        style: TextStyle(color: Color(0xFF1E3A8A),
                            fontSize: 16
                        ),
                      )
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
         Navigator.push(context, MaterialPageRoute(builder: (context) => NewMarksScreen()));
        },
      ),
    );
  }
}
