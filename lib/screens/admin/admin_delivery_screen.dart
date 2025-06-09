// screens/admin/admin_delivery_screen.dart

import 'package:flutter/material.dart';
import '../../widgets/delivery_parcel_list.dart';
import 'delivery_history_screen.dart'; // New screen

class AdminDeliveryScreen extends StatelessWidget {
  const AdminDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeliveryHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: const DeliveryParcelList(),
    );
  }
}
