import 'package:flutter/material.dart';
import '../../widgets/admin_payment_parcel_list.dart';

// This screen displays parcels that have been marked as 'found' and are waiting for student payment.

class ManagePaymentsScreen extends StatelessWidget {
  const ManagePaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Payments')),
      body: const AdminPaymentParcelList(),
    );
  }
}
