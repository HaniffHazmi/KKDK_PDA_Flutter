import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/parcel.dart';
import '../../services/parcel_service.dart';
import '../../services/student_user_service.dart';
import '../../models/student_user.dart';

class ParcelFormScreen extends StatefulWidget {
  const ParcelFormScreen({super.key});

  @override
  _ParcelFormScreenState createState() => _ParcelFormScreenState();
}

class _ParcelFormScreenState extends State<ParcelFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _trackingNumberController = TextEditingController();

  final ParcelService _parcelService = ParcelService();
  final StudentUserService _studentService = StudentUserService();

  College? _selectedCollege;
  Block? _selectedBlock;
  Level? _selectedLevel;
  Courier? _selectedCourier;
  DateTime? _selectedDate;

  StudentUser? _student;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    final student = await _studentService.fetchCurrentStudent();
    if (mounted) {
      setState(() {
        _student = student;
        _selectedCollege = College.values.firstWhere((c) => c.name == student?.college, orElse: () => College.TunDrIsmail);
        _selectedBlock = Block.values.firstWhere((b) => b.name == student?.block, orElse: () => Block.A);
        _selectedLevel = Level.values.firstWhere((l) => l.index == student?.level, orElse: () => Level.zero);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null || _student == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in or student data missing')));
        setState(() => _isSubmitting = false);
        return;
      }

      final newParcel = Parcel(
        id: '',
        trackingNumber: _trackingNumberController.text.trim(),
        name: _student!.name,
        matricNumber: _student!.matricNo,
        phoneNumber: _student!.phoneNumber,
        college: _selectedCollege!,
        block: _selectedBlock!,
        level: _selectedLevel!,
        roomNumber: _student!.roomNumber,
        courier: _selectedCourier!,
        dateArrived: _selectedDate!,
      );

      try {
        await _parcelService.addParcel(newParcel);
        _formKey.currentState?.reset();
        _trackingNumberController.clear();
        setState(() {
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
    if (_student == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Submit Parcel')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                        initialValue: _student!.name,
                        decoration: InputDecoration(labelText: 'Name'),
                        enabled: false,
                      )),
                      _buildFormField(TextFormField(
                        initialValue: _student!.matricNo,
                        decoration: InputDecoration(labelText: 'Matric Number'),
                        enabled: false,
                      )),
                      _buildFormField(TextFormField(
                        initialValue: _student!.phoneNumber,
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        enabled: false,
                      )),
                      _buildFormField(TextFormField(
                        initialValue: _student!.roomNumber.toString(),
                        decoration: InputDecoration(labelText: 'Room Number'),
                        enabled: false,
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
