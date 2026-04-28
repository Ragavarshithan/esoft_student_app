import 'package:esoft_student_app/src/features/admin/manageStudent/manage_students_screen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_data_service.dart';

class Selectbatchscreen extends ConsumerStatefulWidget {
  final String courseId;
  final String courseName;
  const Selectbatchscreen({super.key, required this.courseId, required this.courseName});

  @override
  ConsumerState<Selectbatchscreen> createState() => _SelectbatchscreenState();
}

class _SelectbatchscreenState extends ConsumerState<Selectbatchscreen> {
  final LMSService _lmsService = LMSService();
  List<Batch> _batches = [];

  @override
  void initState() {
    super.initState();
    _loadBatches();
  }

  Future<void> _loadBatches() async {
    final batches = await _lmsService.getBatchByCourseId(courseId: widget.courseId);
    setState(() {
      _batches = batches;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final batches = mockService.batches.whereType<Batch>().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.courseName}'),
      ),
      body: _batches == [] || _batches.isEmpty
          ? const Center(child: Text('No Batch found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _batches.length,
        itemBuilder: (context, index) {
          final batch = _batches[index];

          return InkWell(
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1E3A8A),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(batch.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: TextButton(
                    onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => ManageStudentsScreen(batchId: batch.id ,batch: batch.name,courseName: widget.courseName,))),
                    child: const Text('View Students', style: TextStyle(color: Color(0xFF1E3A8A))),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ManageStudentsScreen(batchId: batch.id ,batch: batch.name,courseName: widget.courseName,)));

            },
          );
        },
      ),
    );
  }
}
