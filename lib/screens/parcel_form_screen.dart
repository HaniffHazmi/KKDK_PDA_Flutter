import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/parcel.dart';
import '../services/parcel_service.dart';

class ParcelFormScreen extends StatefulWidget {
  @override
  _ParcelFormScreenState createState() => _ParcelFormScreenState();
}

class _ParcelFormScreenState extends State<ParcelFormScreen> {
  final _trackingNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _matricNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _roomNumberController = TextEditingController();

  final ParcelService _parcelService = ParcelService();

  College? _selectedCollege;
  Block? _selectedBlock;
  Level? _selectedLevel;
  Courier? _selectedCourier;
  DateTime? _selectedDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      Parcel newParcel = Parcel(
        trackingNumber: _trackingNumberController.text.trim(),
        name: _nameController.text.trim(),
        matricNumber: _matricNumberController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        college: _selectedCollege!,
        block: _selectedBlock!,
        level: _selectedLevel!,
        roomNumber: int.parse(_roomNumberController.text.trim()),
        courier: _selectedCourier!,
        dateArrived: _selectedDate!,
      );

      try {
        await _parcelService.addParcel(newParcel);
        _formKey.currentState?.reset();
        setState(() {
          _selectedCollege = null;
          _selectedBlock = null;
          _selectedLevel = null;
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
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parcel Form')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _trackingNumberController,
                    decoration: InputDecoration(labelText: 'Tracking Number'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Tracking number is required' : null,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Name is required' : null,
                  ),
                  TextFormField(
                    controller: _matricNumberController,
                    decoration: InputDecoration(labelText: 'Matric Number'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Matric number is required' : null,
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Phone number is required' : null,
                  ),
                  DropdownButtonFormField<College>(
                    value: _selectedCollege,
                    decoration: InputDecoration(labelText: 'College'),
                    items: College.values.map((college) {
                      return DropdownMenuItem(
                        value: college,
                        child: Text(college.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedCollege = value),
                    validator: (value) =>
                    value == null ? 'Please select a college' : null,
                  ),
                  DropdownButtonFormField<Block>(
                    value: _selectedBlock,
                    decoration: InputDecoration(labelText: 'Block'),
                    items: Block.values.map((block) {
                      return DropdownMenuItem(
                        value: block,
                        child: Text(block.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedBlock = value),
                    validator: (value) =>
                    value == null ? 'Please select a block' : null,
                  ),
                  DropdownButtonFormField<Level>(
                    value: _selectedLevel,
                    decoration: InputDecoration(labelText: 'Level'),
                    items: Level.values.map((level) {
                      return DropdownMenuItem(
                        value: level,
                        child: Text(level.index.toString()), // Show 0, 1, 2, 3
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedLevel = value),
                    validator: (value) =>
                    value == null ? 'Please select a level' : null,
                  ),
                  TextFormField(
                    controller: _roomNumberController,
                    decoration: InputDecoration(labelText: 'Room Number'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Room number is required';
                      }
                      int room = int.tryParse(value) ?? 0;
                      if (!Parcel.isValidRoomNumber(room)) {
                        return 'Room number must be between 1 and 16';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<Courier>(
                    value: _selectedCourier,
                    decoration: InputDecoration(labelText: 'Courier'),
                    items: Courier.values.map((courier) {
                      return DropdownMenuItem(
                        value: courier,
                        child: Text(courier.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedCourier = value),
                    validator: (value) =>
                    value == null ? 'Please select a courier' : null,
                  ),
                  GestureDetector(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Date Arrived',
                          hintText: 'Select date',
                        ),
                        controller: TextEditingController(
                          text: _selectedDate != null
                              ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                              : '',
                        ),
                        validator: (value) =>
                        _selectedDate == null ? 'Please select a date' : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    child: _isSubmitting
                        ? CircularProgressIndicator()
                        : Text('Submit Parcel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
