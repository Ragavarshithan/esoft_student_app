import 'package:esoft_student_app/src/features/admin/manageBatch/addBatchScreen.dart';
import 'package:esoft_student_app/src/features/admin/manageStudent/manage_students_screen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../services/mock_data_service.dart';

class ManagebatchScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String courseName;
  const ManagebatchScreen({super.key, required this.courseId, required this.courseName});

  @override
  ConsumerState<ManagebatchScreen> createState() => _ManagebatchScreen();
}

class _ManagebatchScreen extends ConsumerState<ManagebatchScreen> {
  final LMSService _lmsService = LMSService();
  List<Batch> _batches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBatches();

  }

  Future<void> _loadBatches() async {
    final batches = await _lmsService.getBatchByCourseId(courseId: widget.courseId);
    setState(() {
      _batches = batches;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final mockService = ref.watch(mockDataServiceProvider);
    // final batchIds = mockService.courses.where((c) => c.id == widget.courseId).expand((b) => b.batchId.toSet());
    // final filteredBatches = mockService.batches.where((b) => batchIds.contains(b.id)).toList();
    // final courseName = mockService.courses.where((c) => c.id == widget.courseId).map((c) => c.name).first;

    return Scaffold(
      appBar: AppBar(
        title:  Text('${widget.courseName}'),
      ),
      body:_isLoading
          ? const Center(child: CircularProgressIndicator())
          : _batches.isEmpty
          ? const Center(child: Text('No batches found.'))
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
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddBatchScreen(courseId: widget.courseId, courseName: widget.courseName)));
          if(result == true){
            _loadBatches();
          }
          },
      ),
    );
  }
}
