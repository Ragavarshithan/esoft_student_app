import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/models/user.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';

class NewMarksScreen extends StatefulWidget {
  final String assignmentId;
  final String assignmentTitle;
  final String moduleId;
  final String moduleName;
  final String courseId;
  final String courseName;

  const NewMarksScreen({
    super.key,
    required this.assignmentId,
    required this.assignmentTitle,
    required this.moduleId,
    required this.moduleName,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<NewMarksScreen> createState() => _NewMarksScreenState();
}

class _NewMarksScreenState extends State<NewMarksScreen> {
  final LMSService _lmsService = LMSService();
  List<Batch> _batches = [];
  String? _selectedBatchId;
  List<Student> _students = [];
  Map<String, TextEditingController> _controllers = {};
  bool _isLoadingBatches = true;
  bool _isLoadingStudents = false;

  @override
  void initState() {
    super.initState();
    _loadBatches();
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadBatches() async {
    final batches = await _lmsService.getBatchByCourseId(courseId: widget.courseId);
    if (mounted) {
      setState(() {
        _batches = batches;
        _isLoadingBatches = false;
      });
    }
  }

  Future<void> _loadStudents(String batchId) async {
    setState(() {
      _isLoadingStudents = true;
      _students = [];
      _controllers.clear();
    });

    final students = await _lmsService.getStudentsByBatchId(batchId: batchId);
    if (mounted) {
      setState(() {
        _students = students;
        for (var student in students) {
          _controllers[student.id] = TextEditingController();
        }
        _isLoadingStudents = false;
      });
    }
  }

  Future<void> _submitMarks() async {
    if (_selectedBatchId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a batch first')),
      );
      return;
    }

    int count = 0;
    bool hasError = false;

    for (var student in _students) {
      final scoreText = _controllers[student.id]?.text.trim() ?? '';
      if (scoreText.isNotEmpty) {
        final score = int.tryParse(scoreText);
        if (score != null) {
          final success = await _lmsService.submitMark(
            studentId: student.studentId,
            assignmentId: widget.assignmentId,
            score: score,
            feedback: 'Submitted via Marks Registry',
          );
          if (success) {
            count++;
          } else {
            hasError = true;
          }
        }
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Marks submitted for $count students.${hasError ? " Some errors occurred." : ""}'),
          backgroundColor: hasError ? Colors.orange : Colors.green,
        ),
      );
      if (count > 0) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Enter Marks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "MARKS REGISTRY",
              style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              widget.assignmentTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "${widget.moduleName} | ${widget.courseName}",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),

            /// Batch Dropdown
            _isLoadingBatches
                ? const LinearProgressIndicator()
                : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: const Text("Select Batch"),
                  isExpanded: true,
                  value: _selectedBatchId,
                  items: _batches.map((batch) {
                    return DropdownMenuItem(
                      value: batch.id,
                      child: Text(batch.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedBatchId = value);
                      _loadStudents(value);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Student Roll (${_students.length})",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  const Expanded(child: Text("Student", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                  Text("Marks /100", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),

            Expanded(
              child: _isLoadingStudents
                  ? const Center(child: CircularProgressIndicator())
                  : _students.isEmpty
                  ? Center(child: Text(_selectedBatchId == null ? "Select a batch to see students" : "No students found in this batch"))
                  : ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final student = _students[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(student.email, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),

                        SizedBox(
                          width: 72,
                          height: 44,
                          child: TextField(
                            controller: _controllers[student.id],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 3,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "—",
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              filled: true,
                              fillColor: Colors.blue.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _students.isEmpty ? null : _submitMarks,
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text("SUBMIT MARKS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}