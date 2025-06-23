import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_proof.dart';
import '../screens/admin/parcel_payment_verify.dart';

class AdminPaymentParcelTile extends StatefulWidget {
  final PaymentProof paymentProof;

  const AdminPaymentParcelTile({super.key, required this.paymentProof});

  @override
  State<AdminPaymentParcelTile> createState() => _AdminPaymentParcelTileState();
}

class _AdminPaymentParcelTileState extends State<AdminPaymentParcelTile> {
  String studentName = '';
  String studentMatric = '';
  String trackingNumber = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLinkedData();
  }

  Future<void> _loadLinkedData() async {
    try {
      // Load parcel details
      final parcelDoc = await FirebaseFirestore.instance
          .collection('parcels')
          .doc(widget.paymentProof.parcelId)
          .get();

      if (parcelDoc.exists) {
        final parcelData = parcelDoc.data()!;
        trackingNumber = parcelData['trackingNumber'] ?? '';
        studentMatric = parcelData['matricNumber'] ?? '';
        studentName = parcelData['name'] ?? '';
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading linked data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: $studentName", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Matric No: $studentMatric"),
            Text("Tracking #: $trackingNumber"),
            const SizedBox(height: 8),
            Text("Uploaded At: ${widget.paymentProof.uploadedAt.toLocal()}"),
            const SizedBox(height: 8),
            Image.network(widget.paymentProof.imageUrl, height: 150, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ParcelPaymentVerify(paymentProofId: widget.paymentProof.id),
                    ),
                  );
                },
                child: const Text('Verify'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
