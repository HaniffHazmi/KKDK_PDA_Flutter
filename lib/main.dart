import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterapp/screens/admin/admin_dashboard_screen.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'screens/home_screen.dart';  // Import the Home Screen
import 'firebase_options.dart';

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
      title: 'Auth App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/admin-dashboard': (context) => AdminDashboardScreen(), // New admin route
      },
    );
  }
}
