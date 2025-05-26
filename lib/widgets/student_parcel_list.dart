import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/parcel_tile.dart';  // Import the new widget

//This is the StudentParcelList class.
//It uses the ParcelTile class and fetch the student submitted parcel in HomeScreen class.

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
          print('No parcels found for user $uid');
          return Center(child: Text("No parcels found"));
        }

        final parcels = snapshot.data!.docs;
        print('Parcels count: ${parcels.length}');

        return ListView.builder(
          itemCount: parcels.length,
          itemBuilder: (context, index) {
            final parcel = parcels[index];
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

