import 'package:esoft_student_app/src/features/admin/adminProfileScreen.dart';
import 'package:esoft_student_app/src/features/admin/admin_dashboard.dart';
import 'package:esoft_student_app/src/features/lecturer/lecturerProfileScreen.dart';
import 'package:esoft_student_app/src/features/lecturer/lecturer_dashboard.dart';
import 'package:esoft_student_app/src/features/student/studentProfileScreen.dart';
import 'package:esoft_student_app/src/features/student/student_dashboard.dart';
import 'package:esoft_student_app/src/utils/commonWidget.dart';
import 'package:flutter/material.dart';

class LecturerRoot extends StatefulWidget {
  const LecturerRoot({super.key});

  @override
  State<LecturerRoot> createState() => _LecturerRoot();
}

class _LecturerRoot extends State<LecturerRoot> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    LecturerDashboard(),
    LecturerProfileScreen()
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