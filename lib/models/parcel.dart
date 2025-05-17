enum ParcelStatus {
  pending,
  found,
  awaitPayment,
  delivered,
}

enum Courier {
  jnt,
  shopeeXpress,
  flash,
  posLaju,
  gdex,
}

class Parcel {
  final String id; // Firestore document ID
  final String userId; // Firebase UID of student
  final String trackingNumber;
  final Courier courier;
  final DateTime dateArrived;
  final int arrivedDay;
  final int arrivedMonth;
  final int arrivedYear;
  final ParcelStatus status;

  Parcel({
    required this.id,
    required this.userId,
    required this.trackingNumber,
    required this.courier,
    required this.dateArrived,
    required this.arrivedDay,
    required this.arrivedMonth,
    required this.arrivedYear,
    this.status = ParcelStatus.pending,
  });

  /// Convert to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'trackingNumber': trackingNumber,
      'courier': courier.name,
      'dateArrived': dateArrived.toIso8601String(),
      'arrivedDay': arrivedDay,
      'arrivedMonth': arrivedMonth,
      'arrivedYear': arrivedYear,
      'status': status.name,
    };
  }

  /// Construct from Firestore snapshot
  factory Parcel.fromMap(String id, Map<String, dynamic> map) {
    final parsedDate = DateTime.parse(map['dateArrived']);
    return Parcel(
      id: id,
      userId: map['userId'] ?? '',
      trackingNumber: map['trackingNumber'] ?? '',
      courier: Courier.values.firstWhere(
            (e) => e.name == map['courier'],
        orElse: () => Courier.jnt,
      ),
      dateArrived: parsedDate,
      arrivedDay: map['arrivedDay'] ?? parsedDate.day,
      arrivedMonth: map['arrivedMonth'] ?? parsedDate.month,
      arrivedYear: map['arrivedYear'] ?? parsedDate.year,
      status: ParcelStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => ParcelStatus.pending,
      ),
    );
  }
}
