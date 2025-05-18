import 'package:flutter/material.dart';
import '../../models/parcel.dart';

class ParcelDetailsScreen extends StatelessWidget {
  final Parcel parcel;

  const ParcelDetailsScreen({super.key, required this.parcel});

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcel: ${parcel.trackingNumber}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recipient: ${parcel.name}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Matric No: ${parcel.matricNumber}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Phone: ${parcel.phoneNumber}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('College: ${parcel.college.name}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Block: ${parcel.block.name}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Level: ${parcel.level.value}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Room: ${parcel.roomNumber}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Courier: ${parcel.courier.name}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Date Arrived: ${_formatDate(parcel.dateArrived)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Status: ${parcelStatusToString(parcel.status)}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
