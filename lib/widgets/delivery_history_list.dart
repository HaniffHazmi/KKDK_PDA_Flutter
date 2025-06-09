// widgets/delivery_history_list.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/admin_parcel.dart';
import 'delivery_history_tile.dart';
import '../models/parcel.dart';

class DeliveryHistoryList extends StatelessWidget {
  const DeliveryHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('parcels')
          .where('status', isEqualTo: parcelStatusToString(ParcelStatus.delivered))
          .orderBy('dateArrived', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        final parcels = snapshot.data!.docs.map((doc) => AdminParcel.fromFirestore(doc)).toList();

        if (parcels.isEmpty) return const Center(child: Text('No delivery history.'));

        return ListView.builder(
          itemCount: parcels.length,
          itemBuilder: (context, index) => DeliveryHistoryTile(parcel: parcels[index]),
        );
      },
    );
  }
}
