import 'package:flutter/material.dart';
import 'package:flutterapp/screens/student/parcel_form_screen.dart';
import 'package:flutterapp/screens/student/setting_screen.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/student_parcel_list.dart';
import 'cart_screen.dart';
//This is the home page for student screen. It includes list of parcel they have submitted with status of it.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const StudentParcelList(), // Home
    const CartScreen(),        // Payment
    const SettingScreen(),     // Settings
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ParcelFormScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Submit Parcel"),
      )
          : null,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        showFormTab: false,
      ),
    );
  }
}
