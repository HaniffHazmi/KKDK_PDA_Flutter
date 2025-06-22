import 'package:flutter/material.dart';

class AdminParcelTile extends StatelessWidget {
  final String trackingNumber;
  final String college;
  final String block;
  final String matricNumber;
  final String status;
  final VoidCallback onTap;

  const AdminParcelTile({
    super.key,
    required this.trackingNumber,
    required this.college,
    required this.block,
    required this.matricNumber,
    required this.status,
    required this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'found':
        return Colors.green;
      case 'inDelivery':
        return Colors.blue;
      case 'delivered':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tracking #: $trackingNumber',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text('College: $college • Block $block'),
                  Text('Matric No: $matricNumber'),
                ],
              ),

              // Right: Status Chip
              Chip(
                label: Text(status),
                backgroundColor: _getStatusColor(status),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
