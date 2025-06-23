import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterapp/auth/reset_password_screen.dart';
import 'package:flutterapp/screens/admin/admin_dashboard_screen.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'screens/student/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KKDK Parcel System',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // Set your primary color here
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white, // Prevents pink/gray default
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/reset-password': (context) => ResetPasswordScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/admin-dashboard': (context) => AdminDashboardScreen(),
      },
    );
  }
}
