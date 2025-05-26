import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/admin_parcel.dart';
import '../models/parcel.dart';
import 'admin_parcel_tile.dart';
import '../screens/admin/admin_parcel_details_screen.dart';

// This widget shows parcels with status 'found' (awaiting student payment).

class AdminPaymentParcelList extends StatelessWidget {
  const AdminPaymentParcelList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('parcels')
          .where('status', isEqualTo: 'found') // ✅ Only found parcels
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
          return const Center(child: Text("No parcels awaiting payment"));
        }

        final parcelDocs = snapshot.data!.docs;
        final parcels = parcelDocs.map((doc) => AdminParcel.fromFirestore(doc)).toList();

        return ListView.builder(
          itemCount: parcels.length,
          itemBuilder: (context, index) {
            final parcel = parcels[index];

            return AdminParcelTile(
              trackingNumber: parcel.trackingNumber,
              college: parcel.college.name,
              block: parcel.block.name,
              matricNumber: parcel.matricNumber,
              status: parcelStatusToString(parcel.status),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminParcelDetailsScreen(parcel: parcel),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
