import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/admin_parcel.dart';
import '../models/parcel.dart';
import 'admin_parcel_tile.dart';
import '../screens/admin/admin_parcel_details_screen.dart';

class AdminParcelList extends StatefulWidget {
  const AdminParcelList({super.key});

  @override
  State<AdminParcelList> createState() => _AdminParcelListState();
}

class _AdminParcelListState extends State<AdminParcelList> {
  String selectedStatus = 'pending';
  final List<String> statusOptions = ['pending', 'found', 'unfound'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          alignment: Alignment.centerLeft,
          child: DropdownButtonFormField<String>(
            value: selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Filter by Status',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: statusOptions
                .map((status) => DropdownMenuItem(
              value: status,
              child: Text(status[0].toUpperCase() + status.substring(1)),
            ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedStatus = value;
                });
              }
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('parcels')
                .where('status', isEqualTo: selectedStatus)
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
                return const Center(child: Text("No parcels found."));
              }

              final parcels = snapshot.data!.docs
                  .map((doc) => AdminParcel.fromFirestore(doc))
                  .toList();

              return ListView.builder(
                itemCount: parcels.length,
                itemBuilder: (context, index) {
                  final parcel = parcels[index];
                  final isPending = parcel.status == ParcelStatus.pending;

                  return GestureDetector(
                    onTap: isPending
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminParcelDetailsScreen(parcel: parcel),
                        ),
                      );
                    }
                        : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Only pending parcels can be viewed in detail.'),
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: !isPending,
                      child: AdminParcelTile(
                        trackingNumber: parcel.trackingNumber,
                        college: parcel.college.name,
                        block: parcel.block.name,
                        matricNumber: parcel.matricNumber,
                        status: parcelStatusToString(parcel.status),
                        isLocked: parcel.status != ParcelStatus.pending,
                        onTap: () {
                          if (parcel.status == ParcelStatus.pending) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminParcelDetailsScreen(parcel: parcel),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Only pending parcels can be opened.')),
                            );
                          }
                        },
                      )

                    ),
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
