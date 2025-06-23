// screens/admin/delivery_history_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/admin_parcel.dart';
import '../../models/parcel.dart';
import '../../widgets/delivery_history_tile.dart';

class DeliveryHistoryScreen extends StatefulWidget {
  const DeliveryHistoryScreen({super.key});

  @override
  State<DeliveryHistoryScreen> createState() => _DeliveryHistoryScreenState();
}

class _DeliveryHistoryScreenState extends State<DeliveryHistoryScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery History')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search by tracking number',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('parcels')
                  .where('status', isEqualTo: parcelStatusToString(ParcelStatus.delivered))
                  .orderBy('dateArrived', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final parcels = snapshot.data!.docs
                    .map((doc) => AdminParcel.fromFirestore(doc))
                    .where((parcel) =>
                    parcel.trackingNumber.toLowerCase().contains(_searchQuery))
                    .toList();

                if (parcels.isEmpty) {
                  return const Center(child: Text('No matching deliveries.'));
                }

                return ListView.builder(
                  itemCount: parcels.length,
                  itemBuilder: (context, index) =>
                      DeliveryHistoryTile(parcel: parcels[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
