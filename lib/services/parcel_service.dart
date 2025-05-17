import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/parcel.dart';

class ParcelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _parcelCollection => _firestore.collection('parcels');

  /// Add a new parcel to Firestore
  Future<void> addParcel(Parcel parcel) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _parcelCollection.add({
      'trackingNumber': parcel.trackingNumber,
      'name': parcel.name,
      'matricNumber': parcel.matricNumber,
      'phoneNumber': parcel.phoneNumber,
      'college': parcel.college.name,
      'block': parcel.block.name,
      'level': parcel.level.name,
      'roomNumber': parcel.roomNumber,
      'courier': parcel.courier.name,
      'dateArrived': Timestamp.fromDate(parcel.dateArrived),
      'status': parcelStatusToString(parcel.status),
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get list of parcels for current user
  Stream<List<Parcel>> getUserParcels({ParcelStatus? filterStatus}) {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    Query query = _parcelCollection.where('userId', isEqualTo: user.uid);

    if (filterStatus != null) {
      query = query.where('status', isEqualTo: parcelStatusToString(filterStatus));
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Parcel(
          trackingNumber: data['trackingNumber'],
          name: data['name'],
          matricNumber: data['matricNumber'],
          phoneNumber: data['phoneNumber'],
          college: College.values.firstWhere((c) => c.name == data['college']),
          block: Block.values.firstWhere((b) => b.name == data['block']),
          level: Level.values.firstWhere((l) => l.name == data['level']),
          roomNumber: data['roomNumber'],
          courier: Courier.values.firstWhere((c) => c.name == data['courier']),
          dateArrived: (data['dateArrived'] as Timestamp).toDate(),
          status: data['status'] != null
              ? parcelStatusFromString(data['status'])
              : ParcelStatus.pending,
        );
      }).toList();
    });
  }
}
