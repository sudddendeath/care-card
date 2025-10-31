import 'package:care_card/Users/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/registration_model.dart';

class SeniorRegistrationScreen extends StatefulWidget {
  final bool isBothFlow;

  const SeniorRegistrationScreen({super.key, this.isBothFlow = false});

  @override
  State<SeniorRegistrationScreen> createState() =>
      _SeniorRegistrationScreenState();
}

class _SeniorRegistrationScreenState extends State<SeniorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _idNumberController = TextEditingController();
  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    final initialData = Provider.of<RegistrationModel>(
      context,
      listen: false,
    ).seniorData;
    _nameController.text = initialData.name;
    _addressController.text = initialData.address;
    _idNumberController.text = initialData.idNumber;
    _selectedBirthDate = initialData.birthDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your birth date.')),
      );
      return;
    }

    final registration = Provider.of<RegistrationModel>(context, listen: false);
    registration.updateSeniorData(
      name: _nameController.text,
      address: _addressController.text,
      idNumber: _idNumberController.text,
      birthDate: _selectedBirthDate,
    );

    try {
      await registration.submitRegistration();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration submitted successfully!')),
        );
        // In both flow, after senior registration, navigate to login
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Senior Citizen Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Information',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _idNumberController,
                        decoration: const InputDecoration(
                          labelText: 'ID Number',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your ID number.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Birth Date'),
                  trailing: Text(
                    _selectedBirthDate == null
                        ? 'Not set'
                        : DateFormat.yMMMd().format(_selectedBirthDate!),
                  ),
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit Registration'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
