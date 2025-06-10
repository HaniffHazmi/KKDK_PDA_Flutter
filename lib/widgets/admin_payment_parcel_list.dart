import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_proof.dart';
import 'admin_payment_parcel_tile.dart';

class AdminPaymentParcelList extends StatelessWidget {
  const AdminPaymentParcelList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('payment_proofs')
          .where('isVerified', isEqualTo: false)
          .orderBy('uploadedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No pending payments."));
        }

        final payments = snapshot.data!.docs.map((doc) {
          return PaymentProof.fromFirestore(doc);
        }).toList();

        return ListView.builder(
          itemCount: payments.length,
          itemBuilder: (context, index) {
            return AdminPaymentParcelTile(paymentProof: payments[index]);
          },
        );
      },
    );
  }
}
