import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentProof {
  String id;
  String parcelId; // <-- Firestore Parcel Document ID
  String studentId;
  String imageUrl;
  DateTime uploadedAt;
  bool isVerified;

  PaymentProof({
    required this.id,
    required this.parcelId,
    required this.studentId,
    required this.imageUrl,
    required this.uploadedAt,
    this.isVerified = false,
  });

  factory PaymentProof.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentProof(
      id: doc.id,
      parcelId: data['parcelId'] ?? '',
      studentId: data['studentId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      uploadedAt: (data['uploadedAt'] as Timestamp).toDate(),
      isVerified: data['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parcelId': parcelId,
      'studentId': studentId,
      'imageUrl': imageUrl,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'isVerified': isVerified,
    };
  }
}
