import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../models/student_user.dart';

class StudentEditProfileScreen extends StatefulWidget {
  const StudentEditProfileScreen({super.key});

  @override
  State<StudentEditProfileScreen> createState() => _StudentEditProfileScreenState();
}

class _StudentEditProfileScreenState extends State<StudentEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  StudentUser? student;
  bool isLoading = true;

  // Editable fields
  late String phone;
  late String college;
  late String block;
  late int level;
  late int roomNumber;

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  Future<void> _loadStudent() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      final data = StudentUser.fromMap(doc.data()!, doc.id);
      setState(() {
        student = data;
        phone = data.phoneNumber;
        college = data.college;
        block = data.block;
        level = data.level;
        roomNumber = data.roomNumber;
        isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || student == null) return;
    _formKey.currentState!.save();

    final updated = StudentUser(
      uid: student!.uid,
      name: student!.name,
      matricNo: student!.matricNo,
      email: student!.email,
      phoneNumber: phone,
      college: college,
      block: block,
      level: level,
      roomNumber: roomNumber,
    );

    await FirebaseFirestore.instance
        .collection('students')
        .doc(updated.uid)
        .update(updated.toMap());

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Non-editable fields
              TextFormField(
                initialValue: student!.name,
                decoration: const InputDecoration(labelText: 'Name'),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: student!.matricNo,
                decoration: const InputDecoration(labelText: 'Matric No'),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: student!.email,
                decoration: const InputDecoration(labelText: 'Email'),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Editable fields
              TextFormField(
                initialValue: phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                onSaved: (val) => phone = val!,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: college,
                decoration: const InputDecoration(labelText: 'College'),
                items: ['TDI', 'TF']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => college = val!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: block,
                decoration: const InputDecoration(labelText: 'Block'),
                items: ['A', 'B', 'C', 'D']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => block = val!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: level,
                decoration: const InputDecoration(labelText: 'Level'),
                items: List.generate(
                    4, (i) => DropdownMenuItem(value: i, child: Text('Level $i'))),
                onChanged: (val) => level = val!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: roomNumber,
                decoration: const InputDecoration(labelText: 'Room Number'),
                items: List.generate(
                    16, (i) => DropdownMenuItem(value: i + 1, child: Text('Room ${i + 1}'))),
                onChanged: (val) => roomNumber = val!,
              ),
              const SizedBox(height: 24),

              // Save button
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
