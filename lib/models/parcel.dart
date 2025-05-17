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
  awaitingPayment,
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

class Parcel {
  String trackingNumber;
  String name;
  String matricNumber;
  String phoneNumber;
  College college;
  Block block;
  Level level;
  int roomNumber;
  Courier courier;               // ✅ New
  DateTime dateArrived;          // ✅ New
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
}
