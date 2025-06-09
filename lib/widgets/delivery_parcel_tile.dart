// widgets/delivery_parcel_tile.dart

import 'package:flutter/material.dart';
import '../models/delivery_parcel.dart';
import '../models/parcel.dart'; // for ParcelStatus and conversion functions
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryParcelTile extends StatelessWidget {
  final DeliveryParcel parcel;
  final VoidCallback? onStatusUpdated; // optional callback to refresh parent widget

  const DeliveryParcelTile({
    super.key,
    required this.parcel,
    this.onStatusUpdated,
  });

  Future<void> _markAsDelivered(BuildContext context) async {
    final shouldProceed = parcel.status == ParcelStatus.inDelivery;

    if (shouldProceed) {
      await FirebaseFirestore.instance
          .collection('parcels')
          .doc(parcel.id)
          .update({'status': parcelStatusToString(ParcelStatus.delivered)});

      if (onStatusUpdated != null) onStatusUpdated!();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parcel marked as delivered.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(parcel.trackingNumber),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${parcel.name}'),
            Text('Matric: ${parcel.matricNumber}'),
            Text('Courier: ${parcel.courier.name}'),
            Text('Status: ${parcelStatusToString(parcel.status)}'),
          ],
        ),
        trailing: parcel.status == ParcelStatus.inDelivery
            ? ElevatedButton(
          onPressed: () => _markAsDelivered(context),
          child: const Text('Mark as Delivered'),
        )
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
