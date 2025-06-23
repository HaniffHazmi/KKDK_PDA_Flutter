import 'package:flutter/material.dart';

//This is a shared bottom navbar.
//It is shared and used for all student screen.

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool showFormTab; // New flag

  const AppBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    this.showFormTab = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      if (showFormTab)
        const BottomNavigationBarItem(
          icon: Icon(Icons.add_box),
          label: 'Form',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.payment_rounded),
        label: 'Payment',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];

    return BottomNavigationBar(
      backgroundColor: Colors.blue,
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      type: BottomNavigationBarType.fixed,
    );
  }
}
