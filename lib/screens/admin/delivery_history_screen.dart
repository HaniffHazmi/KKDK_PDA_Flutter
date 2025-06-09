// screens/admin/delivery_history_screen.dart

import 'package:flutter/material.dart';
import '../../widgets/delivery_history_list.dart';

class DeliveryHistoryScreen extends StatelessWidget {
  const DeliveryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delivery History')),
      body: const DeliveryHistoryList(),
    );
  }
}
