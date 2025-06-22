import 'package:flutter/material.dart';
import '../models/admin_parcel.dart';

class DeliveryHistoryTile extends StatelessWidget {
  final AdminParcel parcel;

  const DeliveryHistoryTile({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    final address = '${parcel.block.name}-${parcel.level.value}-${parcel.roomNumber}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(parcel.trackingNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Matric: ${parcel.matricNumber}'),
            Text('College: ${parcel.college.name}'),
            Text('Address: $address'),
            Text('Courier: ${parcel.courier.name}'),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Delivered',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
