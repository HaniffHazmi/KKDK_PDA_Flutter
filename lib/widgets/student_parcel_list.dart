import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentParcelList extends StatelessWidget {
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
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
          return Center(child: Text("No parcels found"));

        final parcels = snapshot.data!.docs;

        return ListView.builder(
          itemCount: parcels.length,
          itemBuilder: (context, index) {
            final parcel = parcels[index];
            return ListTile(
              title: Text(parcel['trackingNumber']),
              subtitle: Text('${parcel['college']} - Room ${parcel['roomNumber']}'),
              trailing: Text(parcel['status']),
            );
          },
        );
      },
    );
  }
}
