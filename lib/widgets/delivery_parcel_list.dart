// widgets/delivery_parcel_list.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/delivery_parcel.dart';
import '../models/parcel.dart'; // for enums and conversions
import 'delivery_parcel_tile.dart';

class DeliveryParcelList extends StatelessWidget {
  const DeliveryParcelList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('parcels')
          .where('status', whereIn: [
        parcelStatusToString(ParcelStatus.inDelivery),

      ])
          .orderBy('dateArrived', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text('No parcels in delivery.'));
        }

        final parcels = docs.map((doc) => DeliveryParcel.fromFirestore(doc)).toList();

        return ListView.builder(
          itemCount: parcels.length,
          itemBuilder: (context, index) {
            return DeliveryParcelTile(
              parcel: parcels[index],
              onStatusUpdated: () {
                // Optional callback if you want to do anything on update
              },
            );
          },
        );
      },
    );
  }
}
