// lib/widgets/parcel_tile.dart
import 'package:flutter/material.dart';

class ParcelTile extends StatelessWidget {
  final String trackingNumber;
  final String college;
  final int roomNumber;
  final String status;

  const ParcelTile({
    super.key,
    required this.trackingNumber,
    required this.college,
    required this.roomNumber,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(trackingNumber),
      subtitle: Text('$college - Room $roomNumber'),
      trailing: Text(status),
    );
  }
}
