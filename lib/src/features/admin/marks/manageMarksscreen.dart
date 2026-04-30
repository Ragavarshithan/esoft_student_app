import 'package:esoft_student_app/src/features/admin/marks/newMarksScreen.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

class ManageMarksScreen extends ConsumerStatefulWidget {
  final String assignmentId;
  final String assignmentTitle;
  final String moduleId;
  final String moduleName;
  final String courseId;
  final String courseName;

  const ManageMarksScreen({
    super.key,
    required this.assignmentId,
    required this.assignmentTitle,
    required this.moduleId,
    required this.moduleName,
    required this.courseId,
    required this.courseName,
  });

  @override
  ConsumerState<ManageMarksScreen> createState() => _ManageMarksScreenState();
}

class _ManageMarksScreenState extends ConsumerState<ManageMarksScreen> {
  final LMSService _lmsService = LMSService();
  List<Mark> _marks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMarks();
  }

  Future<void> _loadMarks() async {
    final marks = await _lmsService.getMarksByAssignmentId(widget.assignmentId);
    if (mounted) {
      setState(() {
        _marks = marks;
        _isLoading = false;
      });
    }
  }

  double _getAverageScore() {
    if (_marks.isEmpty) return 0.0;
    final total = _marks.fold(0, (sum, m) => sum + m.score);
    return total / _marks.length;
  }

  @override
  Widget build(BuildContext context) {
    final avgScore = _getAverageScore();
    final passCount = _marks.where((m) => m.score >= 40).length;
    final failCount = _marks.length - passCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(widget.assignmentTitle),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _marks.isEmpty
          ? const Center(child: Text('No marks recorded for this assignment.'))
          : RefreshIndicator(
        onRefresh: _loadMarks,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // --- Statistics Card ---
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "AVERAGE SCORE",
                            style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${avgScore.toStringAsFixed(1)}%",
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$passCount Passed | $failCount Failed",
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 20,
                          sections: [
                            PieChartSectionData(
                              value: passCount.toDouble(),
                              color: Colors.greenAccent,
                              title: '',
                              radius: 10,
                            ),
                            PieChartSectionData(
                              value: failCount.toDouble(),
                              color: Colors.redAccent,
                              title: '',
                              radius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- Marks List ---
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _marks.length,
                itemBuilder: (context, index) {
                  final mark = _marks[index];
                  final isPass = mark.score >= 40;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isPass ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        child: Text(
                          mark.score.toString(),
                          style: TextStyle(
                            color: isPass ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      title: Text(
                        mark.studentName ?? 'Unknown Student',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(mark.feedback ?? 'No feedback'),
                      trailing: Icon(
                        isPass ? Icons.check_circle : Icons.error,
                        color: isPass ? Colors.green : Colors.red,
                        size: 18,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewMarksScreen(
                assignmentId: widget.assignmentId,
                assignmentTitle: widget.assignmentTitle,
                moduleId: widget.moduleId,
                moduleName: widget.moduleName,
                courseId: widget.courseId,
                courseName: widget.courseName,
              ),
            ),
          );
          _loadMarks();
        },
      ),
    );
  }
}
