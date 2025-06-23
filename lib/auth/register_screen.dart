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
        setState(() => _errorMessage = e.toString());
      }
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      labelStyle: TextStyle(fontSize: 13),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/login');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Create Your KKDK PDA Account',
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: nameController,
                          decoration: _inputDecoration('Full Name'),
                          validator: (val) => val!.isEmpty ? 'Enter name' : null,
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: matricNoController,
                          decoration: _inputDecoration('Matric Number'),
                          validator: (val) => val!.isEmpty ? 'Enter matric no' : null,
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: phoneController,
                          decoration: _inputDecoration('Phone Number'),
                          validator: (val) => val!.isEmpty ? 'Enter phone number' : null,
                        ),
                        const SizedBox(height: 16),

                        Divider(),
                        const Text('Residence Info', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),

                        DropdownButtonFormField(
                          value: selectedCollege,
                          decoration: _inputDecoration('College'),
                          items: ['TDI', 'TF']
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (val) => setState(() => selectedCollege = val as String),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField(
                                value: selectedBlock,
                                decoration: _inputDecoration('Block'),
                                items: ['A', 'B', 'C', 'D']
                                    .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                                    .toList(),
                                onChanged: (val) => setState(() => selectedBlock = val as String),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField(
                                value: selectedLevel,
                                decoration: _inputDecoration('Level'),
                                items: List.generate(4, (i) =>
                                    DropdownMenuItem(value: i, child: Text('L$i'))),
                                onChanged: (val) => setState(() => selectedLevel = val as int),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField(
                                value: selectedRoom,
                                decoration: _inputDecoration('Room'),
                                items: List.generate(16, (i) =>
                                    DropdownMenuItem(value: i + 1, child: Text('${i + 1}'))),
                                onChanged: (val) => setState(() => selectedRoom = val as int),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Divider(),
                        const Text('Login Credentials', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: emailController,
                          decoration: _inputDecoration('Gmail Address'),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Enter email';
                            final isValid = RegExp(r"^[\w-\.]+@gmail\.com$").hasMatch(val);
                            return isValid ? null : 'Only Gmail (@gmail.com) addresses allowed';
                          },
                        ),
                        const SizedBox(height: 12),

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
                          val != null && val.length >= 8 && RegExp(r'(?=.*[A-Za-z])(?=.*\d)').hasMatch(val)
                              ? null
                              : 'Min 8 chars, include letters and numbers',
                        ),

                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(_errorMessage, style: TextStyle(color: Colors.red, fontSize: 12)),
                          ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.check),
                            onPressed: _register,
                            label: const Text('Register'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
