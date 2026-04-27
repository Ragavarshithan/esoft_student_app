import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_data_service.dart';

class MyAttendanceScreen extends ConsumerWidget {
  const MyAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mockService = ref.watch(mockDataServiceProvider);
    final user = ref.watch(currentUserProvider);

    final myAttendances = mockService.attendanceRecords.where((m) => m.studentId == user?.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Attendance'),
      ),
      body: myAttendances.isEmpty
          ? const Center(child: Text('Attendance not available.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: myAttendances.length,
        itemBuilder: (context, index) {
          final myAttendance = myAttendances[index];
          final course = mockService.courses.firstWhere((u) => u.id == myAttendance.moduleId);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF1E3A8A),
                child: Icon(Icons.grade, color: Colors.white),
              ),
              title: Text('${course.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${myAttendance.status}'),
            ),
          );
        },
      ),
    );
  }
}
