import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/parcel_tile.dart';
import '../models/parcel.dart'; // Make sure you import this to access enums and helpers

class StudentParcelList extends StatelessWidget {
  const StudentParcelList({super.key});

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return Center(child: Text("User not logged in"));
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
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No parcels found"));
        }

        // Filter only parcels with status == pending
        final pendingParcels = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final status = parcelStatusFromString(data['status'] ?? 'pending');
          return status == ParcelStatus.pending;
        }).toList();

        if (pendingParcels.isEmpty) {
          return Center(child: Text("No pending parcels"));
        }

        return ListView.builder(
          itemCount: pendingParcels.length,
          itemBuilder: (context, index) {
            final parcel = pendingParcels[index];
            final data = parcel.data() as Map<String, dynamic>;

            return ParcelTile(
              trackingNumber: data['trackingNumber'],
              college: data['college'],
              roomNumber: data['roomNumber'],
              status: data['status'] ?? 'unknown',
            );
          },
        );
      },
    );
  }
}
