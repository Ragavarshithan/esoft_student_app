import 'package:esoft_student_app/src/features/admin/attendance/newAttendance.dart';
import 'package:esoft_student_app/src/models/course_data.dart';
import 'package:esoft_student_app/src/services/lms_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ManageAttendanceScreen extends ConsumerStatefulWidget {
  final String moduleId;
  final String moduleName;
  final String courseId;
  final String courseName;
  const ManageAttendanceScreen({
    super.key,
    required this.moduleId,
    required this.moduleName,
    required this.courseId,
    required this.courseName,
  });

  @override
  ConsumerState<ManageAttendanceScreen> createState() => _ManageAttendanceScreenState();
}

class _ManageAttendanceScreenState extends ConsumerState<ManageAttendanceScreen> {
  final LMSService _lmsService = LMSService();
  List<Attendance> _attendanceList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    final attendance = await _lmsService.getAttendanceByModuleId(widget.moduleId);
    if (mounted) {
      setState(() {
        _attendanceList = attendance;
        _isLoading = false;
      });
    }
  }

  Map<String, List<Attendance>> _groupAttendanceByDate() {
    final Map<String, List<Attendance>> groups = {};
    for (var attendance in _attendanceList) {
      final dateStr = DateFormat('yyyy-MM-dd').format(attendance.date);
      if (!groups.containsKey(dateStr)) {
        groups[dateStr] = [];
      }
      groups[dateStr]!.add(attendance);
    }
    return groups;
  }

  double _calculatePercentage(List<Attendance> list) {
    if (list.isEmpty) return 0.0;
    final presentCount = list.where((a) => a.status?.toUpperCase() == 'PRESENT').length;
    return (presentCount / list.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = _groupAttendanceByDate();
    final sortedDates = groupedData.keys.toList()..sort((a, b) => b.compareTo(a));

    // Overall stats for the top section if needed, or just focus on the list
    final totalPresent = _attendanceList.where((a) => a.status?.toUpperCase() == 'PRESENT').length;
    final totalAbsent = _attendanceList.length - totalPresent;
    final overallPercentage = _calculatePercentage(_attendanceList);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text('${widget.moduleName} Attendance'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _attendanceList.isEmpty
          ? const Center(child: Text('No attendance records found.'))
          : RefreshIndicator(
        onRefresh: _loadAttendance,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sortedDates.length + 1, // +1 for the Overall card
          itemBuilder: (context, index) {
            if (index == 0) {
              // --- Overall Module Summary Card ---
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
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
                            "OVERALL ATTENDANCE",
                            style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${overallPercentage.toStringAsFixed(1)}%",
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$totalPresent Present | $totalAbsent Absent",
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
                              value: totalPresent.toDouble(),
                              color: Colors.greenAccent,
                              title: '',
                              radius: 10,
                            ),
                            PieChartSectionData(
                              value: totalAbsent.toDouble(),
                              color: Colors.redAccent.withOpacity(0.8),
                              title: '',
                              radius: 10,
                            ),
                            if (_attendanceList.isEmpty)
                              PieChartSectionData(
                                value: 1,
                                color: Colors.white24,
                                title: '',
                                radius: 10,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // --- Date-wise Session Summary Card ---
            final dateStr = sortedDates[index - 1];
            final sessionRecords = groupedData[dateStr]!;
            final sessionDate = DateTime.parse(dateStr);
            final sessionPercentage = _calculatePercentage(sessionRecords);
            final sessionPresent = sessionRecords.where((a) => a.status?.toUpperCase() == 'PRESENT').length;
            final sessionAbsent = sessionRecords.length - sessionPresent;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  // Circular Progress Indicator
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: sessionPercentage / 100,
                          backgroundColor: Colors.grey.shade100,
                          color: _getColorForPercentage(sessionPercentage),
                          strokeWidth: 6,
                        ),
                        Center(
                          child: Text(
                            "${sessionPercentage.toInt()}%",
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Date and Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE, MMM dd').format(sessionDate),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$sessionPresent Present · $sessionAbsent Absent",
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ),
            );
          },
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
              builder: (context) => NewAttendanceScreen(
                courseId: widget.courseId,
                courseName: widget.courseName,
                moduleId: widget.moduleId,
                moduleName: widget.moduleName,
              ),
            ),
          );
          _loadAttendance();
        },
      ),
    );
  }

  Color _getColorForPercentage(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  Widget _statRow(Color color, String label, String value) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text("$label: ", style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
