import 'package:flutter/material.dart';
import '../../../models/parcel.dart';

class StudentParcelHistoryTile extends StatelessWidget {
  final Parcel parcel;

  const StudentParcelHistoryTile({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(parcel.trackingNumber),
        subtitle: Text('${parcel.courier.name} - Delivered on ${parcel.dateArrived.toLocal().toString().split(' ')[0]}'),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
