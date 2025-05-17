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
  DateTime? _selectedDate;
  bool _isSubmitting = false;
  final ParcelService _parcelService = ParcelService();

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false && _selectedDate != null) {
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
          dateArrived: _selectedDate!,
          arrivedDay: _selectedDate!.day,
          arrivedMonth: _selectedDate!.month,
          arrivedYear: _selectedDate!.year,
          status: ParcelStatus.pending,
        );

        await _parcelService.addParcel(parcel);

        _formKey.currentState?.reset();
        setState(() {
          _selectedCourier = null;
          _selectedDate = null;
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
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date arrived')),
      );
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
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
              SizedBox(height: 16),

              // Date Picker Button
              Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? 'No date selected'
                        : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  ),
                  Spacer(),
                  TextButton.icon(
                    onPressed: () => _pickDate(context),
                    icon: Icon(Icons.calendar_today),
                    label: Text('Pick Date'),
                  ),
                ],
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
