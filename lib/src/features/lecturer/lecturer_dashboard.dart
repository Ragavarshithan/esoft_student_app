import 'package:esoft_student_app/src/features/auth/landingScreen.dart';
import 'package:esoft_student_app/src/features/chat/chat_screen.dart';
import 'package:esoft_student_app/src/features/lecturer/myCoursesScreen.dart';
import 'package:esoft_student_app/src/features/lecturer/myStudentsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/mock_data_service.dart';

class LecturerDashboard extends ConsumerWidget {
  const LecturerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecturer Portal'),
        leading: IconButton(
          icon: Icon(Icons.school),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  Landingscreen()))
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _DashboardCard(title: 'My Courses', icon: Icons.class_, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyCourseScreen()))),
          _DashboardCard(title: 'Students', icon: Icons.people, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyStudentsScreen()))),
          _DashboardCard(title: 'Marks & Grading', icon: Icons.grade, onTap: () {}),
          _DashboardCard(title: 'Messages', icon: Icons.message, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  ChatScreen()))),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xFF1E3A8A)),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
