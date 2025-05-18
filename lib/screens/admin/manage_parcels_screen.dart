import 'package:flutter/material.dart';
import '../../models/parcel.dart';
import 'parcel_details_screen.dart';

class ManageParcelsScreen extends StatelessWidget {
  final List<Parcel> parcels;

  const ManageParcelsScreen({super.key, required this.parcels});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Parcels'),
      ),
      body: ListView.builder(
        itemCount: parcels.length,
        itemBuilder: (context, index) {
          final parcel = parcels[index];
          return ListTile(
            title: Text(parcel.trackingNumber),
            subtitle: Text(parcel.name),
            trailing: Text(parcelStatusToString(parcel.status)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParcelDetailsScreen(parcel: parcel),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
