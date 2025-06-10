import 'package:flutter/material.dart';
import 'package:flutterapp/screens/student/single_parcel_payment_screen.dart';
import '../../models/parcel.dart';
import '../../student/single_parcel_payment_screen.dart';

class CartParcelTile extends StatelessWidget {
  final Parcel parcel;

  const CartParcelTile({
    super.key,
    required this.parcel,
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
            Text('Tracking #: ${parcel.trackingNumber}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Courier: ${parcel.courier.name}'),
            const SizedBox(height: 4),
            Text('Arrived: ${parcel.dateArrived.toLocal().toString().split(' ')[0]}'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.payment),
              label: const Text('Pay RM1.00'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SingleParcelPaymentScreen(parcelId: parcel.id),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
