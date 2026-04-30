import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_data_service.dart';
import 'performancePopup.dart';

class MyMarksScreen extends ConsumerStatefulWidget {
  const MyMarksScreen({super.key});

  @override
  ConsumerState<MyMarksScreen> createState() => _MyMarksScreenState();
}

class _MyMarksScreenState extends ConsumerState<MyMarksScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      late bool isGood;
      final mockService = ref.read(mockDataServiceProvider);
      final myMarks = mockService.marks
          .where((m) => m.studentId == "s1")
          .toList();
      final average = myMarks.isEmpty
          ? 0.0
          : myMarks.map((m) => m.score).reduce((a, b) => a + b) / myMarks.length;
      if(average >= 50){
        setState(() {
          isGood = true;
        });
      }
      else{
        setState(() {
          isGood = false;
        });
      }
      showDialog(
        context: context,
        builder: (context) => performanceDialog(context, isGood),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final user = ref.watch(currentUserProvider);

    final myMarks = mockService.marks
        .where((m) => m.studentId == "s1")  // Filter marks for current user
        .toList();

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
                final assignment = mockService.assignments
                    .firstWhere((a) => a.id == mark.assignmentId);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF1E3A8A),
                      child: Icon(Icons.grade, color: Colors.white),
                    ),
                    title: Text('${assignment.title} - ${mark.score}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Feedback: ${mark.feedback}'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => performanceDialog(context, mark.score >= 50),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
