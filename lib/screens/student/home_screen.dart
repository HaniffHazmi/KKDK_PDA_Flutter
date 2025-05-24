import 'package:flutter/material.dart';
import 'package:flutterapp/screens/student/parcel_form_screen.dart';
import 'package:flutterapp/screens/student/student_profile_screen.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/student_parcel_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    StudentParcelList(),
    ParcelFormScreen(), // Placeholder
    Center(child: Text('Cart Screen')), // Placeholder
    StudentProfileScreen(),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcel App'),
        backgroundColor: const Color(0xFF42A2A2),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
