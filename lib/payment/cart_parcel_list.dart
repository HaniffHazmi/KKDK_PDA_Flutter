import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/parcel.dart';
import 'cart_parcel_tile.dart';

class CartParcelList extends StatelessWidget {
  const CartParcelList({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('User not logged in.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('parcels')
          .where('userId', isEqualTo: currentUser.uid)
          .where('status', isEqualTo: 'found') // Must match how you store enum in Firestore
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No found parcels to pay for."));
        }

        final parcelDocs = snapshot.data!.docs;
        final parcels = parcelDocs
            .map((doc) => Parcel.fromFirestore(doc))
            .toList();

        return ListView.builder(
          itemCount: parcels.length,
          itemBuilder: (context, index) {
            final parcel = parcels[index];
            return CartParcelTile(
              parcel: parcel,

            );
          },
        );
      },
    );
  }
}
