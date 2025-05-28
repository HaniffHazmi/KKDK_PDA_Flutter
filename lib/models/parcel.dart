import 'package:cloud_firestore/cloud_firestore.dart';

enum College { TunFatimah, TunDrIsmail }

enum Block { A, B, C, D }

/// Updated Level enum with values 0 to 3
enum Level {
  zero(0),
  one(1),
  two(2),
  three(3);

  final int value;
  const Level(this.value);
}

/// Parcel status for lifecycle tracking
enum ParcelStatus {
  pending,
  found,
  unfound,
  inDelivery,
  paid,
  delivered,
}

/// Courier options
enum Courier {
  jnt,
  flash,
  spx,
  poslaju,
  gdex,
  ninjavan,
}

// Convert string to ParcelStatus enum
ParcelStatus parcelStatusFromString(String status) {
  return ParcelStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == status.toLowerCase(),
    orElse: () => ParcelStatus.pending,
  );
}

// Convert ParcelStatus enum to string
String parcelStatusToString(ParcelStatus status) {
  return status.name;
}

College collegeFromString(String value) {
  return College.values.firstWhere(
        (e) => e.name.toLowerCase() == value.toLowerCase(),
    orElse: () => College.TunFatimah,
  );
}

Block blockFromString(String value) {
  return Block.values.firstWhere(
        (e) => e.name.toLowerCase() == value.toLowerCase(),
    orElse: () => Block.A,
  );
}

Level levelFromString(dynamic value) {
  if (value is int) {
    return Level.values.firstWhere((e) => e.value == value, orElse: () => Level.zero);
  }
  return Level.zero;
}

Courier courierFromString(String value) {
  return Courier.values.firstWhere(
        (e) => e.name.toLowerCase() == value.toLowerCase(),
    orElse: () => Courier.jnt,
  );
}


class Parcel {
  String trackingNumber;
  String name;
  String matricNumber;
  String phoneNumber;
  College college;
  Block block;
  Level level;
  int roomNumber;
  Courier courier;
  DateTime dateArrived;
  ParcelStatus status;

  Parcel({
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
    this.status = ParcelStatus.pending,
  });

  /// Room number constraint: 1 to 16
  static bool isValidRoomNumber(int roomNumber) {
    return roomNumber >= 1 && roomNumber <= 16;
  }

  factory Parcel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Parcel(
      trackingNumber: data['trackingNumber'] ?? '',
      name: data['name'] ?? '',
      matricNumber: data['matricNumber'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      college: collegeFromString(data['college']),
      block: blockFromString(data['block']),
      level: levelFromString(data['level']),
      roomNumber: data['roomNumber'] ?? 0,
      courier: courierFromString(data['courier']),
      dateArrived: (data['dateArrived'] as Timestamp).toDate(),
      status: parcelStatusFromString(data['status']),
    );
  }

}


