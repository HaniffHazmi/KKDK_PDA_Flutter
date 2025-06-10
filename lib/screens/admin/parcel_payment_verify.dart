import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/parcel.dart';
import '../../models/payment_proof.dart';

class ParcelPaymentVerify extends StatefulWidget {
  final String paymentProofId;

  const ParcelPaymentVerify({super.key, required this.paymentProofId});

  @override
  State<ParcelPaymentVerify> createState() => _ParcelPaymentVerifyState();
}

class _ParcelPaymentVerifyState extends State<ParcelPaymentVerify> {
  PaymentProof? proof;
  bool isLoading = true;
  Parcel? tiedParcel;

  @override
  void initState() {
    super.initState();
    _loadPaymentProof();
  }

  Future<void> _loadPaymentProof() async {
    final doc = await FirebaseFirestore.instance
        .collection('payment_proofs')
        .doc(widget.paymentProofId)
        .get();

    if (doc.exists) {
      setState(() {
        proof = PaymentProof.fromFirestore(doc);
        isLoading = false;
      });
      debugPrint('✅ Loaded PaymentProof: ${proof!.toMap()}');
    } else {
      debugPrint("❌ PaymentProof not found.");
    }
  }

  Future<void> _approvePayment() async {
    if (proof == null) return;

    final batch = FirebaseFirestore.instance.batch();
    debugPrint('🔍 Verifying parcel ID: ${proof!.parcelId}');

    // Get parcel
    final parcelDoc = await FirebaseFirestore.instance
        .collection('parcels')
        .doc(proof!.parcelId)
        .get();

    if (!parcelDoc.exists) {
      debugPrint("❌ Parcel not found: ${proof!.parcelId}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Parcel not found: ${proof!.parcelId}')),
      );
      return;
    }

    // 1. Mark payment as verified
    final paymentRef = FirebaseFirestore.instance
        .collection('payment_proofs')
        .doc(proof!.id);
    batch.update(paymentRef, {'isVerified': true});

    // 2. Update parcel status to "inDelivery"
    final parcelRef = FirebaseFirestore.instance
        .collection('parcels')
        .doc(proof!.parcelId);
    batch.update(parcelRef, {
      'status': parcelStatusToString(ParcelStatus.inDelivery),
    });

    try {
      await batch.commit();
      Navigator.pop(context); // Go back after approval
    } catch (e) {
      debugPrint("❌ Error approving payment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving payment: $e')),
      );
    }
  }

  Future<void> _rejectPayment() async {
    if (proof == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('payment_proofs')
          .doc(proof!.id)
          .delete(); // Or update with rejection flag

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment has been rejected.')),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('❌ Error rejecting payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting payment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || proof == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Receipt:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Image.network(proof!.imageUrl, height: 250, fit: BoxFit.contain),
            const SizedBox(height: 16),
            Text('Uploaded by: ${proof!.studentId}'),
            Text('Uploaded at: ${proof!.uploadedAt.toLocal()}'),
            const SizedBox(height: 16),
            const Text('Associated Parcel:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('• ${proof!.parcelId}'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _approvePayment,
                  icon: const Icon(Icons.check),
                  label: const Text('Approve'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton.icon(
                  onPressed: _rejectPayment,
                  icon: const Icon(Icons.close),
                  label: const Text('Reject'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
