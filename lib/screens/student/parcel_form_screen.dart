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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in or student data missing')),
        );
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

        // Clear the form
        _formKey.currentState?.reset();
        _trackingNumberController.clear();
        setState(() {
          _selectedCourier = null;
          _selectedDate = null;
        });

        // Show success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Parcel submitted successfully')),
        );

        // ✅ Navigate to HomeScreen
        if (mounted) {
          Navigator.pop(context); // Go back to home screen in bottom nav
        }

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }


  Widget _buildFormField(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    if (_student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Submit Parcel')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Submit Parcel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Parcel Details', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),

                      _buildFormField(TextFormField(
                        controller: _trackingNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Tracking Number',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? 'Required' : null,
                      )),

                      _buildFormField(_buildReadOnlyField('Name', _student!.name)),
                      _buildFormField(_buildReadOnlyField('Matric Number', _student!.matricNo)),
                      _buildFormField(_buildReadOnlyField('Phone Number', _student!.phoneNumber)),
                      _buildFormField(_buildReadOnlyField('Room Number', _student!.roomNumber.toString())),

                      _buildFormField(DropdownButtonFormField<Courier>(
                        value: _selectedCourier,
                        decoration: const InputDecoration(
                          labelText: 'Courier',
                          border: OutlineInputBorder(),
                        ),
                        items: Courier.values
                            .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                            .toList(),
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
                            decoration: const InputDecoration(
                              labelText: 'Date Arrived',
                              hintText: 'Select date',
                              border: OutlineInputBorder(),
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

                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _submitForm,
                        icon: _isSubmitting
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : const Icon(Icons.send),
                        label: const Text('Submit Parcel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 16),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )
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

  Widget _buildReadOnlyField(String label, String value) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
