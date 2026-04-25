import 'package:esoft_student_app/src/features/admin/attendance/manageAttendancescreen.dart';
import 'package:esoft_student_app/src/features/admin/attendance/selectModuleAttendanceScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageStudent/manage_students_screen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_data_service.dart';

class SelectBatchAttendanceScreen extends ConsumerStatefulWidget {
  final String batchId;
  final String course;
  const SelectBatchAttendanceScreen({super.key, required this.batchId, required this.course});

  @override
  ConsumerState<SelectBatchAttendanceScreen> createState() => _SelectBatchAttendanceScreenState();
}

class _SelectBatchAttendanceScreenState extends ConsumerState<SelectBatchAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final batches = mockService.batches.whereType<Batch>().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.course}'),
      ),
      body: batches.isEmpty
          ? const Center(child: Text('No Batch found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: batches.length,
        itemBuilder: (context, index) {
          final batch = batches[index];

          return InkWell(
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1E3A8A),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(batch.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SelectModuleAttendanceScreen(courseId: widget.course, courseName: widget.course, batchId: widget.batchId)));

            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          // Add action hook
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create student to be integrated with backend!')));
        },
      ),
    );
  }
}
