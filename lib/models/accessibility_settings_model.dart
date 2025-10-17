import 'package:flutter/material.dart';

class AccessibilitySettingsModel extends ChangeNotifier {
  bool _isHighContrastModeEnabled = false;
  double _textSizeMultiplier = 1.0;

  bool get isHighContrastModeEnabled => _isHighContrastModeEnabled;
  double get textSizeMultiplier => _textSizeMultiplier;

  AccessibilitySettingsModel();

  void toggleHighContrastMode(bool newValue) {
    _isHighContrastModeEnabled = newValue;
    notifyListeners();
  }

  void setTextSizeMultiplier(double newValue) {
    _textSizeMultiplier = newValue;
    notifyListeners();
  }
}
