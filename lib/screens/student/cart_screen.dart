import 'package:flutter/material.dart';

import 'package:flutterapp/screens/student/student_delivery_screen.dart';
import '../../payment/cart_parcel_list.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StudentDeliveryScreen(),
                ),
              );
            },
            child: const Text(
              'Track Parcel',
              style: TextStyle(color: Colors.white   , fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),

      body: const CartParcelList(),

    );
  }
}
