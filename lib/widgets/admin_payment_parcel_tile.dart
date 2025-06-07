// widgets/admin_payment_parcel_tile.dart

import 'package:flutter/material.dart';
import '../screens/admin/parcel_payment_verify.dart';

class AdminPaymentParcelTile extends StatelessWidget {
  final String paymentProofId;

  const AdminPaymentParcelTile({
    super.key,
    required this.paymentProofId,
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
            Text("Payment ID: $paymentProofId"),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ParcelPaymentVerify(paymentProofId: paymentProofId),
                  ));
                },
                child: const Text('Verify'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
