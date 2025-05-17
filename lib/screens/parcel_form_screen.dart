import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/parcel.dart';
import '../services/parcel_service.dart';

class ParcelFormScreen extends StatefulWidget {
  @override
  _ParcelFormScreenState createState() => _ParcelFormScreenState();
}

class _ParcelFormScreenState extends State<ParcelFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _trackingNumberController = TextEditingController();
  Courier? _selectedCourier;
  bool _isSubmitting = false;
  final ParcelService _parcelService = ParcelService();

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
        setState(() => _isSubmitting = false);
        return;
      }

      try {
        final parcel = Parcel(
          id: '', // Firestore auto-generated
          userId: user.uid,
          trackingNumber: _trackingNumberController.text.trim(),
          courier: _selectedCourier!,
          dateArrived: DateTime.now(),
          status: ParcelStatus.pending,
        );

        await _parcelService.addParcel(parcel);

        _formKey.currentState?.reset();
        setState(() {
          _selectedCourier = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Parcel submitted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit parcel: $e')),
        );
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _trackingNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submit Parcel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tracking Number Field
              TextFormField(
                controller: _trackingNumberController,
                decoration: InputDecoration(labelText: 'Tracking Number'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tracking number is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Courier Dropdown
              DropdownButtonFormField<Courier>(
                value: _selectedCourier,
                decoration: InputDecoration(labelText: 'Courier'),
                items: Courier.values.map((courier) {
                  return DropdownMenuItem<Courier>(
                    value: courier,
                    child: Text(courier.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCourier = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a courier' : null,
              ),
              SizedBox(height: 24),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting
                      ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text('Submit Parcel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
