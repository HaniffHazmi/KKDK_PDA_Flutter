import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/admin_parcel.dart'; // Use AdminParcel
import '../models/parcel.dart';
import 'admin_parcel_tile.dart';
import '../screens/admin/admin_parcel_details_screen.dart';

//This is the admin parcel list class.
//This class is used to display all student parcel in ManageParcelsScreen class for admin.

class AdminParcelList extends StatelessWidget {
  const AdminParcelList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('parcels')
          .where('status', isEqualTo: 'pending')
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

