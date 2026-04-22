

import 'package:flutter/material.dart';

class Customnavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const Customnavbar({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200,
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0,-2)
            )
          ]
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        elevation: 0,
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, 0),
              // _buildNavItem(Icons.person_outline, Icons.person, 1)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData activeIcon, int index) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? Color(0xFF0A1F44) : Colors.grey.shade400,
          size: 28,
        ),
      ),
    );
  }
}
