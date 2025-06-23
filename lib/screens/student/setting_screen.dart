import 'package:flutter/material.dart';
import 'package:flutterapp/screens/student/student_edit_profile_screen.dart';
import 'package:flutterapp/screens/student/student_parcel_history_screen.dart';
import '../../../services/auth_service.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => StudentEditProfileScreen()));
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: buttonStyle.copyWith(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => StudentParcelHistoryScreen()));
              },
              icon: const Icon(Icons.history),
              label: const Text('Parcel History'),
              style: buttonStyle.copyWith(
                backgroundColor: MaterialStateProperty.all(Colors.teal),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                AuthService.instance.logout(context);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: buttonStyle.copyWith(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
