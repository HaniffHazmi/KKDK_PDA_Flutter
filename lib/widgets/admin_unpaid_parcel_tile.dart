import 'package:flutter/material.dart';
import '../models/admin_parcel.dart';

class AdminUnpaidParcelTile extends StatelessWidget {
  final AdminParcel parcel;

  const AdminUnpaidParcelTile({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tracking Number: ${parcel.trackingNumber}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Name: ${parcel.name}'),
            Text('Matric No: ${parcel.matricNumber}'),
            Text('Block: ${parcel.block.name.toUpperCase()}'),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.bottomRight,
              child: Chip(
                label: Text('Awaiting Receipt'),
                backgroundColor: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
