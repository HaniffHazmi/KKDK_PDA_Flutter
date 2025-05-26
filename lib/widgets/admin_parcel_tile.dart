import 'package:flutter/material.dart';

//This is the AdminParcelTile used by AdminParcelList

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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(trackingNumber),
      subtitle: Text('$college - Block $block\nMatric: $matricNumber'),
      trailing: Text(
        status,
        style: TextStyle(
          color: status == 'pending' ? Colors.orange :
          status == 'found' ? Colors.green :
          Colors.grey,
        ),
      ),
      isThreeLine: true,
      onTap: onTap,
    );
  }
}
