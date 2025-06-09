import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/admin_parcel.dart';
import '../../models/parcel.dart';
import 'student_delivery_tile.dart';

class StudentDeliveryList extends StatelessWidget {
  final String userId;

  const StudentDeliveryList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('parcels')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: parcelStatusToString(ParcelStatus.inDelivery))
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

        final parcels = docs.map((doc) => AdminParcel.fromFirestore(doc)).toList();

        return ListView.builder(
          itemCount: parcels.length,
          itemBuilder: (context, index) {
            return StudentDeliveryTile(parcel: parcels[index]);
          },
        );
      },
    );
  }
}
