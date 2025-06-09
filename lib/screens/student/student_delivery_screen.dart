import 'package:flutter/material.dart';
import '../../widgets/student_delivery_list.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentDeliveryScreen extends StatelessWidget {
  const StudentDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Track My Delivery')),
      body: StudentDeliveryList(userId: userId),
    );
  }
}
