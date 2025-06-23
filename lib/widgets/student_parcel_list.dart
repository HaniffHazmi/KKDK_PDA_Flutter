import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/student/single_parcel_payment_screen.dart';
import '../widgets/parcel_tile.dart';
import '../models/parcel.dart'; // For ParcelStatus and helpers

class StudentParcelList extends StatefulWidget {
  const StudentParcelList({super.key});

  @override
  State<StudentParcelList> createState() => _StudentParcelListState();
}

class _StudentParcelListState extends State<StudentParcelList> {
  ParcelStatus? selectedStatus;
  final List<ParcelStatus> filterOptions = [
    ParcelStatus.pending,
    ParcelStatus.found,
    ParcelStatus.inDelivery,
    ParcelStatus.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: Text("User not logged in"));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: DropdownButtonFormField<ParcelStatus>(
            value: selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Filter by Status',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: filterOptions.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(parcelStatusToString(status).toUpperCase()),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                selectedStatus = val;
              });
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
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

              final parcels = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final status = parcelStatusFromString(data['status'] ?? 'pending');
                return selectedStatus == null || selectedStatus == status;
              }).toList();

              if (parcels.isEmpty) {
                return const Center(child: Text("No parcels match this status"));
              }

              return ListView.builder(
                itemCount: parcels.length,
                itemBuilder: (context, index) {
                  final parcel = parcels[index];
                  final data = parcel.data() as Map<String, dynamic>;
                  final parcelId = parcel.id;

                  final trackingNumber = data['trackingNumber'] ?? 'Unknown';
                  final courier = data['courier'] ?? 'Unknown';
                  final timestamp = data['dateArrived'] as Timestamp?;
                  final status = data['status'] ?? 'unknown';

                  // Use FutureBuilder to check if payment proof exists
                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('payment_proofs')
                        .where('studentId', isEqualTo: uid)
                        .where('parcelId', isEqualTo: parcelId)
                        .limit(1)
                        .get(),
                    builder: (context, proofSnapshot) {
                      final isPaid = proofSnapshot.hasData && proofSnapshot.data!.docs.isNotEmpty;

                      return ParcelTile(
                        trackingNumber: trackingNumber,
                        courier: courier,
                        dateArrived: timestamp?.toDate() ?? DateTime.now(),
                        status: status,
                        isPaid: isPaid,
                        onPay: (status.toLowerCase() == 'found' && !isPaid)
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SingleParcelPaymentScreen(parcelId: parcelId),
                            ),
                          );
                        }
                            : null,
                      );
                    },
                  );
                },
              );

            },
          ),
        ),
      ],
    );
  }
}

