import 'package:flutter/material.dart';
import '../../models/parcel.dart';
import '../../widgets/admin_parcel_list.dart';

class ManageParcelsScreen extends StatelessWidget {
  const ManageParcelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Parcels')),
      body: const AdminParcelList(),
    );
  }
}

