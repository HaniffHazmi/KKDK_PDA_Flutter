import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterapp/auth/reset_password_screen.dart';
import 'package:flutterapp/screens/admin/admin_dashboard_screen.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'screens/student/home_screen.dart';  // Import the Home Screen
import 'firebase_options.dart';

//This is the main class.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/reset-password': (context) => ResetPasswordScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/admin-dashboard': (context) => AdminDashboardScreen(), // New admin route
      },
    );
  }
}
