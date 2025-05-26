//This is register screen for user.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/student_user.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final nameController = TextEditingController();
  final matricNoController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String selectedCollege = 'TDI';
  String selectedBlock = 'A';
  int selectedLevel = 0;
  int selectedRoom = 1;

  String _errorMessage = '';
  bool _obscurePassword = true;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final uid = credential.user!.uid;

        final student = StudentUser(
          uid: uid,
          name: nameController.text.trim(),
          matricNo: matricNoController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          college: selectedCollege,
          block: selectedBlock,
          level: selectedLevel,
          roomNumber: selectedRoom,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(student.toMap());

        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      labelStyle: TextStyle(fontSize: 13),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create Account', style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20)),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: nameController,
                    decoration: _inputDecoration('Full Name'),
                    validator: (val) => val!.isEmpty ? 'Enter name' : null,
                  ),
                  SizedBox(height: 10),

                  TextFormField(
                    controller: matricNoController,
                    decoration: _inputDecoration('Matric Number'),
                    validator: (val) => val!.isEmpty ? 'Enter matric no' : null,
                  ),
                  SizedBox(height: 10),

                  TextFormField(
                    controller: phoneController,
                    decoration: _inputDecoration('Phone Number'),
                    validator: (val) => val!.isEmpty ? 'Enter phone number' : null,
                  ),
                  SizedBox(height: 10),

                  DropdownButtonFormField(
                    value: selectedCollege,
                    items: ['TDI', 'TF'].map((c) => DropdownMenuItem(value: c, child: Text(c, style: TextStyle(fontSize: 13)))).toList(),
                    onChanged: (val) => setState(() => selectedCollege = val as String),
                    decoration: _inputDecoration('College'),
                  ),
                  SizedBox(height: 10),

                  DropdownButtonFormField(
                    value: selectedBlock,
                    items: ['A', 'B', 'C', 'D'].map((b) => DropdownMenuItem(value: b, child: Text(b, style: TextStyle(fontSize: 13)))).toList(),
                    onChanged: (val) => setState(() => selectedBlock = val as String),
                    decoration: _inputDecoration('Block'),
                  ),
                  SizedBox(height: 10),

                  DropdownButtonFormField(
                    value: selectedLevel,
                    items: List.generate(4, (i) => DropdownMenuItem(value: i, child: Text('Level $i', style: TextStyle(fontSize: 13)))),
                    onChanged: (val) => setState(() => selectedLevel = val as int),
                    decoration: _inputDecoration('Level'),
                  ),
                  SizedBox(height: 10),

                  DropdownButtonFormField(
                    value: selectedRoom,
                    items: List.generate(16, (i) => DropdownMenuItem(value: i + 1, child: Text('Room ${i + 1}', style: TextStyle(fontSize: 13)))),
                    onChanged: (val) => setState(() => selectedRoom = val as int),
                    decoration: _inputDecoration('Room Number'),
                  ),
                  SizedBox(height: 10),

                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration('Email'),
                    validator: (val) => val != null &&
                        RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(val)
                        ? null
                        : 'Enter valid email',
                  ),
                  SizedBox(height: 10),

                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: _inputDecoration('Password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (val) =>
                    val != null &&
                        val.length >= 8 &&
                        RegExp(r'(?=.*[A-Za-z])(?=.*\d)').hasMatch(val)
                        ? null
                        : 'Min 8 chars, include letters and numbers',
                  ),

                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(_errorMessage, style: TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _register,
                      child: Text('Register'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
