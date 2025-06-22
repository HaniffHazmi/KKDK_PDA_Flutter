import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin_parcel.dart';
import '../models/payment_proof.dart';
import 'admin_unpaid_parcel_tile.dart';

class AdminUnpaidParcelList extends StatelessWidget {
  const AdminUnpaidParcelList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('parcels')
          .where('status', isEqualTo: 'found')
          .get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> parcelSnapshot) {
        if (!parcelSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final parcelDocs = parcelSnapshot.data!.docs;

        return FutureBuilder(
          future: FirebaseFirestore.instance.collection('payment_proofs').get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> proofSnapshot) {
            if (!proofSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final proofs = proofSnapshot.data!.docs.map((doc) => PaymentProof.fromFirestore(doc)).toList();
            final paidParcelIds = proofs.map((e) => e.parcelId).toSet();

            final unpaidDocs = parcelDocs.where((doc) => !paidParcelIds.contains(doc.id)).toList();
            final unpaidParcels = unpaidDocs.map((doc) => AdminParcel.fromFirestore(doc)).toList();

            if (unpaidParcels.isEmpty) {
              return const Center(child: Text('No unpaid parcels found.'));
            }

            return ListView.builder(
              itemCount: unpaidParcels.length,
              itemBuilder: (context, index) {
                return AdminUnpaidParcelTile(parcel: unpaidParcels[index]);
              },
            );
          },
        );
      },
    );
  }
}
