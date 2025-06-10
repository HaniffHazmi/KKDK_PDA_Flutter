import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/parcel.dart';
import '../../services/parcel_service.dart';

//The is the parcel form submission. Student fills in the form and it will be saved in Firebase.

class ParcelFormScreen extends StatefulWidget {
  const ParcelFormScreen({super.key});

  @override
  _ParcelFormScreenState createState() => _ParcelFormScreenState();
}

class _ParcelFormScreenState extends State<ParcelFormScreen> {
  final _formKey = GlobalKey<FormState>();
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

  bool _isSubmitting = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in')));
        setState(() => _isSubmitting = false);
        return;
      }

      final newParcel = Parcel(
        id: '',
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Parcel submitted successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _buildFormField(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submit Parcel')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildFormField(TextFormField(
                        controller: _trackingNumberController,
                        decoration: InputDecoration(labelText: 'Tracking Number'),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      )),
                      _buildFormField(TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      )),
                      _buildFormField(TextFormField(
                        controller: _matricNumberController,
                        decoration: InputDecoration(labelText: 'Matric Number'),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      )),
                      _buildFormField(TextFormField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      )),
                      _buildFormField(DropdownButtonFormField<College>(
                        value: _selectedCollege,
                        decoration: InputDecoration(labelText: 'College'),
                        items: College.values.map((c) {
                          return DropdownMenuItem(value: c, child: Text(c.name));
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedCollege = val),
                        validator: (val) => val == null ? 'Required' : null,
                      )),
                      _buildFormField(DropdownButtonFormField<Block>(
                        value: _selectedBlock,
                        decoration: InputDecoration(labelText: 'Block'),
                        items: Block.values.map((b) {
                          return DropdownMenuItem(value: b, child: Text(b.name));
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedBlock = val),
                        validator: (val) => val == null ? 'Required' : null,
                      )),
                      _buildFormField(DropdownButtonFormField<Level>(
                        value: _selectedLevel,
                        decoration: InputDecoration(labelText: 'Level'),
                        items: Level.values.map((l) {
                          return DropdownMenuItem(value: l, child: Text('Level ${l.index}'));
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedLevel = val),
                        validator: (val) => val == null ? 'Required' : null,
                      )),
                      _buildFormField(TextFormField(
                        controller: _roomNumberController,
                        decoration: InputDecoration(labelText: 'Room Number'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          int room = int.tryParse(value) ?? 0;
                          if (!Parcel.isValidRoomNumber(room)) return 'Must be 1–16';
                          return null;
                        },
                      )),
                      _buildFormField(DropdownButtonFormField<Courier>(
                        value: _selectedCourier,
                        decoration: InputDecoration(labelText: 'Courier'),
                        items: Courier.values.map((c) {
                          return DropdownMenuItem(value: c, child: Text(c.name));
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedCourier = val),
                        validator: (val) => val == null ? 'Required' : null,
                      )),
                      _buildFormField(GestureDetector(
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
                            validator: (_) =>
                            _selectedDate == null ? 'Please select a date' : null,
                          ),
                        ),
                      )),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48),
                        ),
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
        ),
      ),
    );
  }
}
