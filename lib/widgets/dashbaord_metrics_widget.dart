import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardMetricsWidget extends StatelessWidget {
  const DashboardMetricsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: _fetchDashboardMetrics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("Unable to load data"));
        }

        final data = snapshot.data!;
        final totalUsers = data[0];
        final parcelsPending = data[1];
        final parcelsToBePaid = data[2];
        final parcelsToBeDelivered = data[3];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard("Users", totalUsers, Colors.blue),
              _buildStatCard("Pending Parcels", parcelsPending, Colors.orange),
              _buildStatCard("To Be Paid", parcelsToBePaid, Colors.red),
              _buildStatCard("To Be Delivered", parcelsToBeDelivered, Colors.green),
            ],
          ),
        );
      },
    );
  }

  Stream<List<int>> _fetchDashboardMetrics() async* {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final parcelsRef = FirebaseFirestore.instance.collection('parcels');

    await for (final _ in Stream.periodic(const Duration(seconds: 5))) {
      final usersSnap = await usersRef.get();
      final pendingSnap = await parcelsRef.where('status', isEqualTo: 'pending').get();
      final foundSnap = await parcelsRef.where('status', isEqualTo: 'found').get();
      final deliverySnap = await parcelsRef.where('status', isEqualTo: 'inDelivery').get();

      yield [
        usersSnap.size,
        pendingSnap.size,
        foundSnap.size,
        deliverySnap.size,
      ];
    }
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('$count',
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
