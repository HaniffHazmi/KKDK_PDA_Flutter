import 'package:cloud_functions/cloud_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  static Future<void> initiateBulkPayment(List<String> parcelIds) async {
    final functions = FirebaseFunctions.instance;

    try {
      final result = await functions
          .httpsCallable('createSecurePaySession')
          .call({'parcelIds': parcelIds});

      final paymentUrl = result.data['paymentUrl'];

      if (await canLaunchUrl(Uri.parse(paymentUrl))) {
        await launchUrl(Uri.parse(paymentUrl), mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch payment URL';
      }
    } catch (e) {
      print('Payment initiation failed: $e');
      rethrow; // Optional: let the UI handle the error
    }
  }
}
