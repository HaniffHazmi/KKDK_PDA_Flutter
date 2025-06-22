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
  Parcel? tiedParcel;
  bool isLoading = true;

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
      final loadedProof = PaymentProof.fromFirestore(doc);
      final parcelDoc = await FirebaseFirestore.instance
          .collection('parcels')
          .doc(loadedProof.parcelId)
          .get();

      if (parcelDoc.exists) {
        setState(() {
          proof = loadedProof;
          tiedParcel = Parcel.fromFirestore(parcelDoc);
          isLoading = false;
        });
      } else {
        debugPrint('❌ Parcel not found.');
        setState(() => isLoading = false);
      }
    } else {
      debugPrint("❌ PaymentProof not found.");
      setState(() => isLoading = false);
    }
  }

  Future<void> _approvePayment() async {
    if (proof == null) return;

    final batch = FirebaseFirestore.instance.batch();

    final paymentRef = FirebaseFirestore.instance
        .collection('payment_proofs')
        .doc(proof!.id);
    batch.update(paymentRef, {'isVerified': true});

    final parcelRef = FirebaseFirestore.instance
        .collection('parcels')
        .doc(proof!.parcelId);
    batch.update(parcelRef, {
      'status': parcelStatusToString(ParcelStatus.inDelivery),
    });

    try {
      await batch.commit();
      Navigator.pop(context);
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
          .delete();

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
            Text('Name: ${tiedParcel?.name ?? "-"}'),
            Text('Matric No: ${tiedParcel?.matricNumber ?? "-"}'),
            Text('Tracking No: ${tiedParcel?.trackingNumber ?? "-"}'),
            Text('Uploaded at: ${proof!.uploadedAt.toLocal()}'),
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
