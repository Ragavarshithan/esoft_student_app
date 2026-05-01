import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../services/mock_data_service.dart';

class MyAttendanceScreen extends ConsumerWidget {
  const MyAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mockService = ref.watch(mockDataServiceProvider);
    
    final myAttendances = mockService.attendanceRecords;
    final totalSessions = myAttendances.length;
    final presentCount = myAttendances.where((a) => a.isPresent == true).length;
    final absentCount = totalSessions - presentCount;
    final attendancePercentage = totalSessions > 0 ? (presentCount / totalSessions) * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Attendance'),
      ),
      body: myAttendances.isEmpty
          ? const Center(child: Text('Attendance not available.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: myAttendances.length + 1, // +1 for the summary card
        itemBuilder: (context, index) {
          if (index == 0) {
            // --- Attendance Summary Card ---
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "OVERALL ATTENDANCE",
                          style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${attendancePercentage.toStringAsFixed(1)}%",
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$presentCount Present | $absentCount Absent",
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
                            value: presentCount.toDouble(),
                            color: Colors.greenAccent,
                            title: '',
                            radius: 10,
                          ),
                          PieChartSectionData(
                            value: absentCount.toDouble(),
                            color: Colors.redAccent.withOpacity(0.8),
                            title: '',
                            radius: 10,
                          ),
                          if (totalSessions == 0)
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

          final myAttendance = myAttendances[index - 1];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: myAttendance.isPresent! ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                child: Icon(
                  myAttendance.isPresent! ? Icons.check_circle : Icons.cancel,
                  color: myAttendance.isPresent! ? Colors.green : Colors.red,
                ),
              ),
              title: Text('${myAttendance.date.year}-${myAttendance.date.month.toString().padLeft(2, '0')}-${myAttendance.date.day.toString().padLeft(2, '0')}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(myAttendance.isPresent! ? 'Present' : 'Absent'),
            ),
          );
        },
      ),
    );
  }
}
