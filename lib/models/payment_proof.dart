import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PaymentProof {
  final String id;
  final String userId;
  final List<String> parcelIds;
  final String fileUrl;
  final String fileName;
  final DateTime uploadedAt;
  final String status; // e.g. pending, approved, rejected

  PaymentProof({
    required this.id,
    required this.userId,
    required this.parcelIds,
    required this.fileUrl,
    required this.fileName,
    required this.uploadedAt,
    required this.status,
  });

  factory PaymentProof.fromMap(String id, Map<String, dynamic> data) {
    return PaymentProof(
      id: id,
      userId: data['userId'],
      parcelIds: List<String>.from(data['parcelIds'] ?? []),
      fileUrl: data['fileUrl'],
      fileName: data['fileName'],
      uploadedAt: (data['uploadedAt'] as Timestamp).toDate(),
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'parcelIds': parcelIds,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'status': status,
    };
  }
}
