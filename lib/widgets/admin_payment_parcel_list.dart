// widgets/admin_payment_parcel_list.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'admin_payment_parcel_tile.dart';

class AdminPaymentParcelList extends StatelessWidget {
  const AdminPaymentParcelList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('payment_proofs')
          .where('status', isEqualTo: 'pending')
          .orderBy('timestamp', descending: true)
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

        final payments = snapshot.data!.docs;

        return ListView.builder(
          itemCount: payments.length,
          itemBuilder: (context, index) {
            final paymentProofId = payments[index].id;

            return AdminPaymentParcelTile(
              paymentProofId: paymentProofId,
            );
          },
        );
      },
    );
  }
}
