import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/accessibility_settings_model.dart';

class AccessibilitySettingsScreen extends StatelessWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AccessibilitySettingsModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: const Text('High Contrast Mode'),
                subtitle: const Text('Increase contrast for better readability'),
                value: settings.isHighContrastModeEnabled,
                onChanged: (value) => settings.toggleHighContrastMode(value),
                secondary: const Icon(Icons.contrast),
              ),
            ),
            const SizedBox(height: 16),
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
                      'Text Size',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: settings.textSizeMultiplier,
                      min: 0.8,
                      max: 1.5,
                      divisions: 7,
                      label: settings.textSizeMultiplier.toStringAsFixed(1),
                      onChanged: (value) => settings.setTextSizeMultiplier(value),
                    ),
                    Center(
                      child: Text(
                        'Preview Text',
                        style: TextStyle(
                          fontSize: 16 * settings.textSizeMultiplier,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}