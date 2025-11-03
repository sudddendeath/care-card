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
        child: Transform.translate(
          offset: const Offset(0, -50),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 7),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PwdRegistrationScreen(),
                          ),
                        );
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.accessible, size: 40),
                          SizedBox(height: 8),
                          Text('PWD', textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const SeniorRegistrationScreen(),
                          ),
                        );
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.elderly, size: 40),
                          SizedBox(height: 8),
                          Text('Senior', textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
      ),
    );
  }
}
