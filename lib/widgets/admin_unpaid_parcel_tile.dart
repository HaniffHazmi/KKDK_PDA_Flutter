import 'package:flutter/material.dart';
import '../models/admin_parcel.dart';

class AdminUnpaidParcelTile extends StatelessWidget {
  final AdminParcel parcel;

  const AdminUnpaidParcelTile({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Tracking #: ${parcel.trackingNumber}'),
        subtitle: Text('By ${parcel.name} • ${parcel.courier.name.toUpperCase()}'),
        trailing: const Chip(label: Text('Awaiting Receipt')),
      ),
    );
  }
}
