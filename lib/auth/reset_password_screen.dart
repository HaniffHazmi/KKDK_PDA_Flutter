import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  Future<void> _sendResetLink() async {
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reset link sent. Check your email.')),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Error occurred.';
      if (e.code == 'user-not-found') {
        message = 'No account found with this email.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Enter your email to receive a password reset link."),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value != null && value.contains('@') ? null : 'Enter a valid email',
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) _sendResetLink();
                },
                child: _loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Send Reset Link'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
