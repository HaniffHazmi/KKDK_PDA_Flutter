class StudentUser {
  final String uid;
  final String name;
  final String matricNo;
  final String email;
  final String phoneNumber;
  final String college; // TDI or TF
  final String block;   // A, B, C, D
  final int level;      // 0 to 3
  final int roomNumber; // 1 to 16

  StudentUser({
    required this.uid,
    required this.name,
    required this.matricNo,
    required this.email,
    required this.phoneNumber,
    required this.college,
    required this.block,
    required this.level,
    required this.roomNumber,
  });

  // Convert Firestore document to StudentUser
  factory StudentUser.fromMap(Map<String, dynamic> data, String documentId) {
    return StudentUser(
      uid: documentId,
      name: data['name'] ?? '',
      matricNo: data['matricNo'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      college: data['college'] ?? '',
      block: data['block'] ?? '',
      level: data['level'] ?? 0,
      roomNumber: data['roomNumber'] ?? 1,
    );
  }

  // Convert StudentUser to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'matricNo': matricNo,
      'email': email,
      'phoneNumber': phoneNumber,
      'college': college,
      'block': block,
      'level': level,
      'roomNumber': roomNumber,
    };
  }
}
