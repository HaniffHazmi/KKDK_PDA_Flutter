//This is admin class

class Admin {
  final String name;
  final String matricNumber;
  final String email;

  Admin({
    required this.name,
    required this.matricNumber,
    required this.email,
  });

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      name: map['name'] ?? '',
      matricNumber: map['matricNumber'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'matricNumber': matricNumber,
      'email': email,
    };
  }
}
