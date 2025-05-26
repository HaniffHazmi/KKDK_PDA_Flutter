import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parcel.dart';

//This class is to handle status update of the parcel.
//Admin will update the parcel in AdminParcelDetailsScreen class.

class StatusUpdateService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'parcels';

  /// Update the status of a parcel identified by trackingNumber
  Future<void> updateParcelStatus(String trackingNumber, ParcelStatus newStatus) async {
    try {
      // Query parcel document by trackingNumber (assuming unique)
      final querySnapshot = await _firestore
          .collection(collectionPath)
          .where('trackingNumber', isEqualTo: trackingNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Parcel not found with tracking number: $trackingNumber');
      }

      final docId = querySnapshot.docs.first.id;

      // Update only the status field
      await _firestore.collection(collectionPath).doc(docId).update({
        'status': parcelStatusToString(newStatus),
      });
    } catch (e) {
      // Handle error or rethrow
      throw Exception('Failed to update parcel status: $e');
    }
  }
}
