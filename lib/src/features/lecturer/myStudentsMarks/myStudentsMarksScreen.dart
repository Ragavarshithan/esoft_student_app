import 'package:esoft_student_app/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_data_service.dart';

class MyStudentsMArksScreen extends ConsumerStatefulWidget {
  const MyStudentsMArksScreen({super.key});

  @override
  ConsumerState<MyStudentsMArksScreen> createState() => _MyStudentsMArksScreen();
}

class _MyStudentsMArksScreen extends ConsumerState<MyStudentsMArksScreen> {

  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final students = mockService.users.whereType<Student>().toList();
    final allMarks = mockService.marks;
    final assignments = mockService.assignments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Marks'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          final studentMarks = allMarks
              .where((m) => m.studentId == student.id)
              .toList();

          if (studentMarks.isEmpty) return const SizedBox.shrink();

          final average = studentMarks
              .map((m) => m.score)
              .reduce((a, b) => a + b) /
              studentMarks.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student header with average
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFF1E3A8A),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                    // ✅ Show real average instead of hardcoded value
                    Text(
                      'Avg: ${average.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: average >= 50 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Individual marks
              ...studentMarks.map((mark) {
                final assignment = assignments.firstWhere(
                      (a) => a.id == mark.assignmentId,
                  orElse: () => throw Exception('Assignment not found'),
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 8, left: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: mark.score >= 50
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      child: Text(
                        '${mark.score}',
                        style: TextStyle(
                          color: mark.score >= 50 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    title: Text(
                      assignment.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(mark.feedback ?? ''),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: mark.score >= 50
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        mark.score >= 50 ? 'Pass' : 'Fail',
                        style: TextStyle(
                          color: mark.score >= 50 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),

              const Divider(),
            ],
          );
        },
      ),
    );
  }
}