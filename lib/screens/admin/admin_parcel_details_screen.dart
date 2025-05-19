import 'package:flutter/material.dart';
import '../../models/admin_parcel.dart';
import '../../models/parcel.dart';

class AdminParcelDetailsScreen extends StatelessWidget {
  final AdminParcel parcel;

  const AdminParcelDetailsScreen({super.key, required this.parcel});

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Parcel Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📦 Recipient Info',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        )),
                    const SizedBox(height: 12),
                    _buildDetail('Name', parcel.name),
                    _buildDetail('Matric Number', parcel.matricNumber),
                    _buildDetail('Phone', parcel.phoneNumber),
                    _buildDetail('College', parcel.college.name),
                    _buildDetail('Block', parcel.block.name),
                    _buildDetail('Level', parcel.level.value.toString()),
                    _buildDetail('Room Number', parcel.roomNumber.toString()),

                    const Divider(height: 32, thickness: 1.2),

                    Text('📄 Parcel Details',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        )),
                    const SizedBox(height: 12),
                    _buildDetail('Tracking Number', parcel.trackingNumber),
                    _buildDetail('Courier', parcel.courier.name.toUpperCase()),
                    _buildDetail('Date Arrived', _formatDate(parcel.dateArrived)),
                    _buildDetail('Status', parcelStatusToString(parcel.status)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  onPressed: () {}, // Add logic here
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Found', style: TextStyle(fontSize: 16)),
                ),
                FilledButton(
                  onPressed: () {}, // Add logic here
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Unfound', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('$title:',
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 5,
            child: Text(value,
                style: const TextStyle(
                  color: Colors.black87,
                )),
          ),
        ],
      ),
    );
  }
}
