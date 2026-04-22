import 'package:esoft_student_app/src/features/admin/manageBatch/manageBatch.dart';
import 'package:esoft_student_app/src/features/admin/manageLecturer/manageLecturerScreen.dart';
import 'package:esoft_student_app/src/features/auth/landingScreen.dart';
import 'package:esoft_student_app/src/features/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/mock_data_service.dart';
import 'manageAssignment/manageAssignmentScreen.dart';
import 'manageCourse/manageCourseScreen.dart';
import 'manageStudent/selectCourseScreen.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
          _DashboardCard(title: 'Students', icon: Icons.people, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  Selectcoursescreen()))),
          _DashboardCard(title: 'Lecturers', icon: Icons.person_outline, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  ManageLecturerScreen()))),
          _DashboardCard(title: 'Batches', icon: Icons.group_work, onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) =>  ManagebatchScreen()))),
          _DashboardCard(title: 'Courses', icon: Icons.book, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  ManageCourseScreen()))),
          _DashboardCard(title: 'Assignments', icon: Icons.assignment, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  ManageAssignmentScreen()))),
          _DashboardCard(title: 'Messages', icon: Icons.message, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  ChatScreen())))
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

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
            Icon(icon, size: 48, color: const Color(0xFF0A1F44)),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
