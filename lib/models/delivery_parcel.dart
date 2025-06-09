// models/delivery_parcel.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'parcel.dart'; // for enums like College, Block, Level, Courier, ParcelStatus

class DeliveryParcel {
  final String id;
  final String trackingNumber;
  final String name;
  final String matricNumber;
  final String phoneNumber;
  final College college;
  final Block block;
  final Level level;
  final int roomNumber;
  final Courier courier;
  final DateTime dateArrived;
  final ParcelStatus status;

  DeliveryParcel({
    required this.id,
    required this.trackingNumber,
    required this.name,
    required this.matricNumber,
    required this.phoneNumber,
    required this.college,
    required this.block,
    required this.level,
    required this.roomNumber,
    required this.courier,
    required this.dateArrived,
    required this.status,
  });

  factory DeliveryParcel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DeliveryParcel(
      id: doc.id,
      trackingNumber: data['trackingNumber'] ?? '',
      name: data['name'] ?? '',
      matricNumber: data['matricNumber'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      college: collegeFromString(data['college']),
      block: blockFromString(data['block']),
      level: levelFromString(data['level']),
      roomNumber: data['roomNumber'] ?? 0,
      courier: courierFromString(data['courier']),
      dateArrived: (data['dateArrived'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: parcelStatusFromString(data['status']),
    );
  }
}
