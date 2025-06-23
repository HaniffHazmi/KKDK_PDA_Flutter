import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/parcel.dart';
import 'cart_parcel_tile.dart';

class CartParcelList extends StatelessWidget {
  const CartParcelList({super.key});

  Future<List<String>> _getParcelIdsWithProof(String uid) async {
    final proofSnapshot = await FirebaseFirestore.instance
        .collection('payment_proofs')
        .where('studentId', isEqualTo: uid)
        .get();

    return proofSnapshot.docs
        .map((doc) => doc['parcelId'] as String)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('User not logged in.'));
    }

    return FutureBuilder<List<String>>(
      future: _getParcelIdsWithProof(currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final paidParcelIds = snapshot.data ?? [];

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('parcels')
              .where('userId', isEqualTo: currentUser.uid)
              .where('status', isEqualTo: 'found')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No found parcels to pay for."));
            }

            final parcels = snapshot.data!.docs
                .map((doc) => Parcel.fromFirestore(doc))
                .where((parcel) => !paidParcelIds.contains(parcel.id)) // exclude paid
                .toList();

            if (parcels.isEmpty) {
              return const Center(child: Text("No unpaid parcels."));
            }

            return ListView.builder(
              itemCount: parcels.length,
              itemBuilder: (context, index) => CartParcelTile(parcel: parcels[index]),
            );
          },
        );
      },
    );
  }
}
