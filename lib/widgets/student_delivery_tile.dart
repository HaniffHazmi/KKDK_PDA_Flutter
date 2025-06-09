import 'package:flutter/material.dart';
import '../../models/admin_parcel.dart';

class StudentDeliveryTile extends StatelessWidget {
  final AdminParcel parcel;

  const StudentDeliveryTile({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(parcel.trackingNumber),
        subtitle: Text(
          '${parcel.courier.name} | ${parcel.college.name}, Room ${parcel.roomNumber}',
        ),
        trailing: const Text('In Delivery', style: TextStyle(color: Colors.orange)),
      ),
    );
  }
}
