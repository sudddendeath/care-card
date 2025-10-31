import 'package:flutter/material.dart';
import 'pwd_registration_screen.dart';
import 'senior_registration_screen.dart';

class RegistrationTypeSelectionScreen extends StatelessWidget {
  const RegistrationTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Registration Type')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose your registration type:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PwdRegistrationScreen(),
                  ),
                );
              },
              child: const Text('PWD Registration'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SeniorRegistrationScreen(),
                  ),
                );
              },
              child: const Text('Senior Citizen Registration'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const PwdRegistrationScreen(isBothFlow: true),
                  ),
                );
              },
              child: const Text('Register for Both'),
            ),
          ],
        ),
      ),
    );
  }
}
