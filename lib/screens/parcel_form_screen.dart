import 'package:flutter/material.dart';
import '../models/parcel.dart';
import '../services/parcel_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false; // Track submission state

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true; // Disable button while submitting
      });

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Handle unauthenticated state
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
        setState(() {
          _isSubmitting = false; // Re-enable button on failure
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
      );

      try {
        // Add the parcel using the ParcelService (already handles Firestore)
        await _parcelService.addParcel(newParcel);

        // Clear form and reset state
        _formKey.currentState?.reset();
        setState(() {
          _selectedCollege = null;
          _selectedBlock = null;
          _selectedLevel = null;
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
          _isSubmitting = false; // Re-enable button after submission
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
                  // Tracking Number
                  TextFormField(
                    controller: _trackingNumberController,
                    decoration: InputDecoration(labelText: 'Tracking Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tracking number is required';
                      }
                      return null;
                    },
                  ),
                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  // Matric Number
                  TextFormField(
                    controller: _matricNumberController,
                    decoration: InputDecoration(labelText: 'Matric Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Matric number is required';
                      }
                      return null;
                    },
                  ),
                  // Phone Number
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                  // College Dropdown
                  DropdownButtonFormField<College>(
                    value: _selectedCollege,
                    decoration: InputDecoration(labelText: 'College'),
                    items: College.values.map((college) {
                      return DropdownMenuItem<College>(
                        value: college,
                        child: Text(college.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCollege = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a college';
                      }
                      return null;
                    },
                  ),
                  // Block Dropdown
                  DropdownButtonFormField<Block>(
                    value: _selectedBlock,
                    decoration: InputDecoration(labelText: 'Block'),
                    items: Block.values.map((block) {
                      return DropdownMenuItem<Block>(
                        value: block,
                        child: Text(block.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBlock = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a block';
                      }
                      return null;
                    },
                  ),
                  // Level Dropdown
                  DropdownButtonFormField<Level>(
                    value: _selectedLevel,
                    decoration: InputDecoration(labelText: 'Level'),
                    items: Level.values.map((level) {
                      return DropdownMenuItem<Level>(
                        value: level,
                        child: Text(level.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLevel = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a level';
                      }
                      return null;
                    },
                  ),
                  // Room Number
                  TextFormField(
                    controller: _roomNumberController,
                    decoration: InputDecoration(labelText: 'Room Number'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Room number is required';
                      }
                      int roomNumber = int.parse(value);
                      if (!Parcel.isValidRoomNumber(roomNumber)) {
                        return 'Room number must be between 1 and 16';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Submit Button
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm, // Disable while submitting
                    child: _isSubmitting
                        ? CircularProgressIndicator() // Show loading spinner
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
