import 'package:flutter/material.dart';
import 'package:flutterapp/services/auth_service.dart';

//This is the dashboard drawer class for navigation.
//It is shared and used by admin screen only.

class DashboardDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const DashboardDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Admin Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard Home'),
            selected: selectedIndex == 0,
            onTap: () => onItemSelected(0),
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: const Text('Manage Parcels'),
            selected: selectedIndex == 1,
            onTap: () => onItemSelected(1),
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Student Payments'),
            selected: selectedIndex == 2,
            onTap: () => onItemSelected(2),
          ),
          ListTile(
            leading: const Icon(Icons.delivery_dining),
            title: const Text('Delivery'),
            selected: selectedIndex == 3,
            onTap: () => onItemSelected(3),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // TODO: Add logout logic here
              Navigator.pop(context);
              AuthService.instance.logout(context);
            },
          ),
        ],
      ),
    );
  }
}
