// widgets/delivery_history_tile.dart

import 'package:flutter/material.dart';
import '../models/admin_parcel.dart';

class DeliveryHistoryTile extends StatelessWidget {
  final AdminParcel parcel;

  const DeliveryHistoryTile({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(parcel.trackingNumber),
        subtitle: Text('${parcel.name} (${parcel.college.name}, Room ${parcel.roomNumber})\nDelivered by: ${parcel.courier.name}'),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
