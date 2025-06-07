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

  @override
  void initState() {
    super.initState();
    _loadPaymentProof();
  }

  Future<void> _loadPaymentProof() async {
    final doc = await FirebaseFirestore.instance.collection('payment_proofs').doc(widget.paymentProofId).get();
    if (doc.exists) {
      setState(() {
        proof = PaymentProof.fromMap(doc.id, doc.data()!);
        isLoading = false;
      });
    }
  }

  Future<void> _approvePayment() async {
    if (proof == null) return;

    final batch = FirebaseFirestore.instance.batch();

    // 1. Update payment proof status
    final paymentRef = FirebaseFirestore.instance.collection('payment_proofs').doc(proof!.id);
    batch.update(paymentRef, {'status': 'approved'});

    // 2. Update all parcels in the list
    for (final parcelId in proof!.parcelIds) {
      final parcelRef = FirebaseFirestore.instance.collection('parcels').doc(parcelId);
      batch.update(parcelRef, {'status': parcelStatusToString(ParcelStatus.inDelivery)});
    }

    await batch.commit();
    Navigator.pop(context);
  }

  Future<void> _rejectPayment() async {
    if (proof == null) return;

    await FirebaseFirestore.instance.collection('payments').doc(proof!.id).update({
      'status': 'rejected',
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || proof == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Receipt:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Image.network(proof!.fileUrl, height: 250, fit: BoxFit.contain),
            const SizedBox(height: 16),
            Text('Uploaded by: ${proof!.userId}'),
            Text('Uploaded at: ${proof!.uploadedAt.toLocal().toString().split(' ')[0]}'),
            const SizedBox(height: 16),
            const Text('Associated Parcels:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...proof!.parcelIds.map((id) => Text('• $id')),
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
