import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/parcel.dart';
import '../../widgets/student_parcel_history_tile.dart';

class StudentParcelHistoryScreen extends StatelessWidget {
  const StudentParcelHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Parcel History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('parcels')
            .where('userId', isEqualTo: userId)
            .where('status', isEqualTo: parcelStatusToString(ParcelStatus.delivered))
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final parcels = snapshot.data!.docs.map((doc) => Parcel.fromFirestore(doc)).toList();

          if (parcels.isEmpty) {
            return const Center(child: Text('No delivered parcels found.'));
          }

          return ListView.builder(
            itemCount: parcels.length,
            itemBuilder: (context, index) => StudentParcelHistoryTile(parcel: parcels[index]),
          );
        },
      ),
    );
  }
}
