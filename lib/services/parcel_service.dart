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

    await _parcelCollection.add(parcel.toMap());
  }

  /// Get list of parcels for current user (optionally filtered by status)
  Stream<List<Parcel>> getUserParcels({ParcelStatus? filterStatus}) {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    Query query = _parcelCollection.where('userId', isEqualTo: user.uid);

    if (filterStatus != null) {
      query = query.where('status', isEqualTo: filterStatus.name);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Parcel.fromMap(doc.id, data);
      }).toList();
    });
  }

  /// Get all parcels (admin use)
  Stream<List<Parcel>> getAllParcels({ParcelStatus? filterStatus}) {
    Query query = _parcelCollection;

    if (filterStatus != null) {
      query = query.where('status', isEqualTo: filterStatus.name);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Parcel.fromMap(doc.id, data);
      }).toList();
    });
  }

  /// Update parcel status (admin use)
  Future<void> updateParcelStatus(String parcelId, ParcelStatus status) async {
    await _parcelCollection.doc(parcelId).update({
      'status': status.name,
    });
  }

  /// Optional: Delete a parcel (admin or owner)
  Future<void> deleteParcel(String parcelId) async {
    await _parcelCollection.doc(parcelId).delete();
  }
}
