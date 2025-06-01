import 'package:flutter/material.dart';
import '../../models/parcel.dart'; // Make sure this model contains the needed fields

class CartParcelTile extends StatelessWidget {
  final Parcel parcel;
  final VoidCallback onPay;

  const CartParcelTile({
    super.key,
    required this.parcel,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tracking #: ${parcel.trackingNumber}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Courier: ${parcel.courier.name}'),
            const SizedBox(height: 4),
            Text('Arrived: ${parcel.dateArrived.toLocal().toString().split(' ')[0]}'),
            const SizedBox(height: 12),

          ],
        ),
      ),
    );
  }
}
