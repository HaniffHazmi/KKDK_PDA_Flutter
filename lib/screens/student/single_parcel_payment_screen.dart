import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class SingleParcelPaymentScreen extends StatefulWidget {
  final String parcelId;

  const SingleParcelPaymentScreen({super.key, required this.parcelId});

  @override
  State<SingleParcelPaymentScreen> createState() => _SingleParcelPaymentScreenState();
}

class _SingleParcelPaymentScreenState extends State<SingleParcelPaymentScreen> {
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _uploadProof() async {
    if (_selectedImage == null) return;

    setState(() => _isUploading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final filename = path.basename(_selectedImage!.path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storageRef = FirebaseStorage.instance
          .ref('payment_proofs/$uid/${timestamp}_$filename');

      await storageRef.putFile(_selectedImage!);
      final downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('payment_proofs').add({
        'studentId': uid,
        'parcelId': widget.parcelId,
        'imageUrl': downloadUrl,
        'isVerified': false,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment proof uploaded successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      debugPrint('❌ Upload failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload. Try again.')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Payment Proof')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset('assets/QR_Payment.jpg', height: 200)),
            const SizedBox(height: 16),
            const Text('Total: RM1.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text(
              'Step 1: Scan QR and pay.\nStep 2: Upload receipt below.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Select Receipt Image'),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(height: 12),
              Center(child: Image.file(_selectedImage!, height: 150)),
            ],
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _selectedImage == null || _isUploading ? null : _uploadProof,
                child: _isUploading
                    ? const CircularProgressIndicator()
                    : const Text('Upload Proof & Confirm Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
