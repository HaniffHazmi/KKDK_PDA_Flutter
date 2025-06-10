import 'package:flutter/material.dart';
import '../models/payment_proof.dart';
import '../screens/admin/parcel_payment_verify.dart';

class AdminPaymentParcelTile extends StatelessWidget {
  final PaymentProof paymentProof;

  const AdminPaymentParcelTile({super.key, required this.paymentProof});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Student ID: ${paymentProof.studentId}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Parcel ID: ${paymentProof.parcelId}"),
            const SizedBox(height: 8),
            Text("Uploaded At: ${paymentProof.uploadedAt}"),
            const SizedBox(height: 8),
            Image.network(paymentProof.imageUrl, height: 150), // Preview the uploaded proof
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ParcelPaymentVerify(paymentProofId: paymentProof.id),
                    ),
                  );
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
