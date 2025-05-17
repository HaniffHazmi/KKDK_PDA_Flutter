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
  final ParcelStatus status;

  Parcel({
    required this.id,
    required this.userId,
    required this.trackingNumber,
    required this.courier,
    required this.dateArrived,
    this.status = ParcelStatus.pending,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'trackingNumber': trackingNumber,
      'courier': courier.name, // save enum as string
      'dateArrived': dateArrived.toIso8601String(),
      'status': status.name, // save enum as string
    };
  }

  factory Parcel.fromMap(String id, Map<String, dynamic> map) {
    return Parcel(
      id: id,
      userId: map['userId'] ?? '',
      trackingNumber: map['trackingNumber'] ?? '',
      courier: Courier.values.firstWhere(
            (e) => e.name == map['courier'],
        orElse: () => Courier.jnt,
      ),
      dateArrived: DateTime.parse(map['dateArrived']),
      status: ParcelStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => ParcelStatus.pending,
      ),
    );
  }
}
