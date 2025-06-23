import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/parcel.dart';
import '../../widgets/student_parcel_history_tile.dart';

class StudentParcelHistoryScreen extends StatefulWidget {
  const StudentParcelHistoryScreen({super.key});

  @override
  State<StudentParcelHistoryScreen> createState() => _StudentParcelHistoryScreenState();
}

class _StudentParcelHistoryScreenState extends State<StudentParcelHistoryScreen> {
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Parcel History')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by Tracking Number',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => setState(() => _searchTerm = value.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                final allParcels = snapshot.data!.docs.map((doc) => Parcel.fromFirestore(doc)).toList();

                final filteredParcels = allParcels.where((p) =>
                    p.trackingNumber.toLowerCase().contains(_searchTerm)
                ).toList();

                if (filteredParcels.isEmpty) {
                  return const Center(child: Text('No delivered parcels found.'));
                }

                return ListView.builder(
                  itemCount: filteredParcels.length,
                  itemBuilder: (context, index) => StudentParcelHistoryTile(parcel: filteredParcels[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
