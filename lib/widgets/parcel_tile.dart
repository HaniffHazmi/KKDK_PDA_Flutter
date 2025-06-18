// lib/widgets/parcel_tile.dart
import 'package:flutter/material.dart';

class ParcelTile extends StatelessWidget {
  final String trackingNumber;
  final String courier;
  final DateTime dateArrived;
  final String status;

  const ParcelTile({
    super.key,
    required this.trackingNumber,
    required this.courier,
    required this.dateArrived,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trackingNumber,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Courier: $courier',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Arrived: ${dateArrived.day}/${dateArrived.month}/${dateArrived.year}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
