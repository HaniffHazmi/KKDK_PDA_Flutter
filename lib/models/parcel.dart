enum College { TunFatimah, TunDrIsmail }
enum Block { A, B, C, D }
enum Level { Zero, One, Two, Three }

class Parcel {
  String trackingNumber;
  String name;
  String matricNumber;
  String phoneNumber;
  College college;
  Block block;
  Level level;
  int roomNumber;

  Parcel({
    required this.trackingNumber,
    required this.name,
    required this.matricNumber,
    required this.phoneNumber,
    required this.college,
    required this.block,
    required this.level,
    required this.roomNumber,
  });

  // Add validation for room number here (only 1-16)
  static bool isValidRoomNumber(int roomNumber) {
    return roomNumber >= 1 && roomNumber <= 16;
  }
}
