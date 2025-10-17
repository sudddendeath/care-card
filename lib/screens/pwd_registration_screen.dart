import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/registration_model.dart';

class PwdRegistrationScreen extends StatefulWidget {
  const PwdRegistrationScreen({super.key});

  @override
  State<PwdRegistrationScreen> createState() => _PwdRegistrationScreenState();
}

class _PwdRegistrationScreenState extends State<PwdRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _conditionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initialData = Provider.of<RegistrationModel>(context, listen: false).pwdData;
    _nameController.text = initialData.name;
    _addressController.text = initialData.address;
    _idNumberController.text = initialData.idNumber;
    _conditionController.text = initialData.condition;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _idNumberController.dispose();
    _conditionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final registration = Provider.of<RegistrationModel>(context, listen: false);
    registration.updatePwdData(
      name: _nameController.text,
      address: _addressController.text,
      idNumber: _idNumberController.text,
      condition: _conditionController.text,
    );

    try {
      await registration.submitRegistration();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration submitted successfully!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('PWD Registration'),
      ),
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
                        decoration: const InputDecoration(labelText: 'Full Name'),
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
                        decoration: const InputDecoration(labelText: 'ID Number'),
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
                        decoration: const InputDecoration(labelText: 'Disability Condition'),
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