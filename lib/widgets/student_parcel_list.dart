import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/parcel_tile.dart';
import '../models/parcel.dart'; // For ParcelStatus and helpers

class StudentParcelList extends StatelessWidget {
  const StudentParcelList({super.key});

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: Text("User not logged in"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('parcels')
          .where('userId', isEqualTo: uid)
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
          return const Center(child: Text("No parcels found"));
        }

        final pendingParcels = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final status = parcelStatusFromString(data['status'] ?? 'pending');
          return status == ParcelStatus.pending;
        }).toList();

        if (pendingParcels.isEmpty) {
          return const Center(child: Text("No pending parcels"));
        }

        return ListView.builder(
          itemCount: pendingParcels.length,
          itemBuilder: (context, index) {
            final parcel = pendingParcels[index];
            final data = parcel.data() as Map<String, dynamic>;

            // Parse fields
            final trackingNumber = data['trackingNumber'] ?? 'Unknown';
            final courier = data['courier'] ?? 'Unknown';
            final timestamp = data['dateArrived'] as Timestamp?;
            final status = data['status'] ?? 'unknown';

            return ParcelTile(
              trackingNumber: trackingNumber,
              courier: courier,
              dateArrived: timestamp?.toDate() ?? DateTime.now(),
              status: status,
            );
          },
        );
      },
    );
  }
}
