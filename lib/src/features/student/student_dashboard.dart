import 'package:esoft_student_app/src/features/auth/landingScreen.dart';
import 'package:esoft_student_app/src/features/student/assignment/myAssignmentsScreen.dart';
import 'package:esoft_student_app/src/features/student/attendance/myAttendanceScreen.dart';
import 'package:esoft_student_app/src/features/student/enrollment/myEnrollmentScreen.dart';
import 'package:esoft_student_app/src/features/student/marks/my_marks_screen.dart';
import 'package:esoft_student_app/src/utils/commonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/mock_data_service.dart';
import '../chat/chat_screen.dart';

class StudentDashboard extends ConsumerWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Portal'),
        leading: IconButton(
          icon: const Icon(Icons.school),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => showLogoutDialog(context)
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _DashboardCard(title: 'My Marks', icon: Icons.grade, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const MyMarksScreen()))),
          _DashboardCard(title: 'Attendance', icon: Icons.calendar_month, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const MyAttendanceScreen()))),
          _DashboardCard(title: 'Assignments', icon: Icons.assignment, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyAssignmentsScreen()))),
          // _DashboardCard(title: 'Enrollment', icon: Icons.how_to_reg, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const MyEnrollmentScreen()))),
          _DashboardCard(title: 'Messages', icon: Icons.message, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  const ChatScreen()))),
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
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
