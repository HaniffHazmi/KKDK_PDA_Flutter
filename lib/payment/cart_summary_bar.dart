import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/payment_service.dart';


class CartSummaryBar extends StatelessWidget {
  const CartSummaryBar({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('parcels')
          .where('userId', isEqualTo: uid)
          .where('status', isEqualTo: 'found')
          .snapshots(),
      builder: (context, snapshot) {
        final totalCount = snapshot.data?.docs.length ?? 0;
        final totalCost = totalCount * 1.00; // RM1 per parcel

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: RM${totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ElevatedButton(
              onPressed: totalCount == 0
              ? null
                  : () async {
                    final parcelIds = snapshot.data!.docs.map((doc) => doc.id).toList();

                    try {
                      await PaymentService.initiateBulkPayment(parcelIds);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to start payment: $e')),
                      );
                    }
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Pay'),
              ),
            ],
          ),
        );
      },
    );
  }
}
