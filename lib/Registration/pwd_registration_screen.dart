import 'package:care_card/Users/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/registration_model.dart';
import 'senior_registration_screen.dart';

class PwdRegistrationScreen extends StatefulWidget {
  final bool isBothFlow;

  const PwdRegistrationScreen({super.key, this.isBothFlow = false});

  @override
  State<PwdRegistrationScreen> createState() => _PwdRegistrationScreenState();
}

class _PwdRegistrationScreenState extends State<PwdRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _conditionController = TextEditingController();
  final _birthDateController = TextEditingController();
  String? _selectedSex; // No default value
  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    final initialData = Provider.of<RegistrationModel>(
      context,
      listen: false,
    ).pwdData;
    _nameController.text = initialData.name;
    _addressController.text = initialData.address;
    _idNumberController.text = initialData.idNumber;
    _conditionController.text = initialData.condition;
    _selectedBirthDate = initialData.birthDate;
    if (_selectedBirthDate != null) {
      _birthDateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(_selectedBirthDate!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _idNumberController.dispose();
    _conditionController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final registration = Provider.of<RegistrationModel>(context, listen: false);
    registration.updatePwdData(
      name: _nameController.text,
      sex: _selectedSex,
      address: _addressController.text,
      idNumber: _idNumberController.text,
      condition: _conditionController.text,
      birthDate: _selectedBirthDate,
    );

    try {
      await registration.submitRegistration();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration submitted successfully!')),
        );
        if (widget.isBothFlow) {
          // Navigate to Senior Registration after PWD
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  const SeniorRegistrationScreen(isBothFlow: true),
            ),
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
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
      appBar: AppBar(title: const Text('PWD Registration')),
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
                      DropdownButtonFormField<String>(
                        initialValue: _selectedSex,
                        decoration: const InputDecoration(labelText: 'Sex'),
                        items: ['Male', 'Female'].map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedSex = newValue;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your sex';
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
                        controller: _birthDateController,
                        decoration: const InputDecoration(
                          labelText: 'Birth Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () => _selectBirthDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your birth date.';
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _conditionController,
                        decoration: const InputDecoration(
                          labelText: 'Disability Condition',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe your condition.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
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
