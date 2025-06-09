import 'package:flutter/material.dart';
import 'package:flutterapp/screens/admin/admin_delivery_screen.dart';
import 'package:flutterapp/screens/admin/manage_payments_screen.dart';
import '../../widgets/dashboard_drawer.dart'; // Import the drawer widget
import 'manage_parcels_screen.dart';
//This is the main dashboard page for admin.

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Dashboard Home', style: TextStyle(fontSize: 24))),
    ManageParcelsScreen(),
    ManagePaymentsScreen(),
    AdminDeliveryScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Parcels',
    'Payments',
    'Delivery',
  ];

  void _onSelectDrawerItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      drawer: DashboardDrawer(
        selectedIndex: _selectedIndex,
        onItemSelected: _onSelectDrawerItem,
      ),
      body: _pages[_selectedIndex],
    );
  }
}
