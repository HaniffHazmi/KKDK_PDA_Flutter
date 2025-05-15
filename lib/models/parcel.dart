enum College { TunFatimah, TunDrIsmail }
enum Block { A, B, C, D }
enum Level { Zero, One, Two, Three }

enum ParcelStatus {
  pending,         // Submitted by user, not yet processed
  found,           // Admin located the parcel
  awaitingPayment, // Waiting for student to pay
  delivered        // Student has received parcel
}

ParcelStatus parcelStatusFromString(String status) {
  return ParcelStatus.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() == status.toLowerCase(),
    orElse: () => ParcelStatus.pending,
  );
}

String parcelStatusToString(ParcelStatus status) {
  return status.toString().split('.').last;
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
  ParcelStatus status; // 🔥 New field

  Parcel({
    required this.trackingNumber,
    required this.name,
    required this.matricNumber,
    required this.phoneNumber,
    required this.college,
    required this.block,
    required this.level,
    required this.roomNumber,
    this.status = ParcelStatus.pending, // Default to pending
  });

  // Add validation for room number here (only 1-16)
  static bool isValidRoomNumber(int roomNumber) {
    return roomNumber >= 1 && roomNumber <= 16;
  }
}
