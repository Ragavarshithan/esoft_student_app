import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_data_service.dart';

class MyMarksScreen extends ConsumerWidget {
  const MyMarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mockService = ref.watch(mockDataServiceProvider);
    final user = ref.watch(currentUserProvider);
    
    final myMarks = mockService.marks.where((m) => m.studentId == user?.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Marks'),
      ),
      body: myMarks.isEmpty
          ? const Center(child: Text('No marks available.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myMarks.length,
              itemBuilder: (context, index) {
                final mark = myMarks[index];
                final course = mockService.courses.firstWhere((c) => c.id == mark.moduleId);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF1E3A8A),
                      child: Icon(Icons.grade, color: Colors.white),
                    ),
                    title: Text('${course.name} - ${mark.score}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Feedback: ${mark.feedback}'),
                  ),
                );
              },
            ),
    );
  }
}
