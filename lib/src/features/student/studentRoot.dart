import 'package:esoft_student_app/src/features/admin/adminProfileScreen.dart';
import 'package:esoft_student_app/src/features/admin/admin_dashboard.dart';
import 'package:esoft_student_app/src/features/student/studentProfileScreen.dart';
import 'package:esoft_student_app/src/features/student/student_dashboard.dart';
import 'package:esoft_student_app/src/utils/commonWidget.dart';
import 'package:flutter/material.dart';

class StudentRoot extends StatefulWidget {
  const StudentRoot({super.key});

  @override
  State<StudentRoot> createState() => _StudentRoot();
}

class _StudentRoot extends State<StudentRoot> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    StudentDashboard(),
    StudentProfileScreen()
  ];

  void _onItemTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Customnavbar(selectedIndex: _currentIndex, onItemTapped: _onItemTapped,)
    );
  }
}