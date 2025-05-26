import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin.dart';

//This class is to handle admin login by searching for their credentials in Firebase.

class AdminService {
  final CollectionReference _adminCollection =
  FirebaseFirestore.instance.collection('admins');

  Future<Admin?> getAdminByEmail(String email) async {
    try {
      final querySnapshot = await _adminCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Admin.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching admin: $e');
      return null;
    }
  }

  Future<bool> isAdmin(String email) async {
    final admin = await getAdminByEmail(email);
    return admin != null;
  }
}
