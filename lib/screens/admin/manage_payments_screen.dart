import 'package:flutter/material.dart';
import '../../widgets/admin_payment_parcel_list.dart';
import '../../widgets/admin_unpaid_parcel_list.dart';

class ManagePaymentsScreen extends StatelessWidget {
  const ManagePaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Awaiting Payment'),
              Tab(text: 'To Verify'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AdminUnpaidParcelList(),
            AdminPaymentParcelList(),
          ],
        ),
      ),
    );
  }
}
