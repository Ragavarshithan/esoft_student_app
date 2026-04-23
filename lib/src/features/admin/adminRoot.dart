import 'package:esoft_student_app/src/features/admin/adminProfileScreen.dart';
import 'package:esoft_student_app/src/features/admin/admin_dashboard.dart';
import 'package:esoft_student_app/src/utils/commonWidget.dart';
import 'package:flutter/material.dart';

class AdminRoot extends StatefulWidget {
  const AdminRoot({super.key});

  @override
  State<AdminRoot> createState() => _AdminRoot();
}

class _AdminRoot extends State<AdminRoot> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    AdminDashboard(),
    AdminProfileScreen()
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