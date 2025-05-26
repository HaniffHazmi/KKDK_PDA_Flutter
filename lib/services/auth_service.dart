import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//This class is to ahndle logout for both admin and user.

class AuthService {
  // Singleton pattern
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Logs out the current user (admin or student)
  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();

      // After logout, navigate to login screen and clear navigation stack
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',  // Your login route name here
            (route) => false,
      );
    } catch (e) {
      // You can handle errors here (e.g., show a dialog)
      debugPrint('Logout error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to logout. Please try again.')),
      );
    }
  }
}
