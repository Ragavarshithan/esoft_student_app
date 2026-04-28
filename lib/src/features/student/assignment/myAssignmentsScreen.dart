import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_data_service.dart';

class MyAssignmentsScreen extends ConsumerWidget {
  const MyAssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mockService = ref.watch(mockDataServiceProvider);
    final user = ref.watch(currentUserProvider);

    final myAssignments = mockService.assignments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Assignments'),
      ),
      body: myAssignments.isEmpty
          ? const Center(child: Text('Currently no assignments available.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: myAssignments.length,
        itemBuilder: (context, index) {
          final myAssignment = myAssignments[index];


          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF1E3A8A),
                child: Icon(Icons.grade, color: Colors.white),
              ),
              title: Text('${myAssignment.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: '${myAssignment.description}\n'
                    ),
                    TextSpan(
                        text: '${myAssignment.dueDate}'
                    )
                  ],
                  style: TextStyle(
                    color: Colors.black
                  )
                ),

              ),
            ),
          );
        },
      ),
    );
  }
}
