import 'package:flutter/material.dart';

enum RegistrationType { none, pwd, seniorCitizen }

class RegistrationData {
  String name;
  String address;
  String idNumber;

  RegistrationData({this.name = '', this.address = '', this.idNumber = ''});
}

class PwdRegistrationData extends RegistrationData {
  String condition;

  PwdRegistrationData({
    super.name,
    super.address,
    super.idNumber,
    this.condition = '',
  });
}

class SeniorRegistrationData extends RegistrationData {
  DateTime? birthDate;

  SeniorRegistrationData({
    super.name,
    super.address,
    super.idNumber,
    this.birthDate,
  });
}

class RegistrationModel extends ChangeNotifier {
  PwdRegistrationData _pwdData = PwdRegistrationData();
  SeniorRegistrationData _seniorData = SeniorRegistrationData();
  // RegistrationType _registrationType = RegistrationType.none; // This was declared but never used or updated, removing for simplicity.

  PwdRegistrationData get pwdData => _pwdData;
  SeniorRegistrationData get seniorData => _seniorData;
  // RegistrationType get registrationType => _registrationType; // Removing unused getter

  RegistrationModel();

  void updatePwdData({
    String? name,
    String? address,
    String? idNumber,
    String? condition,
  }) {
    _pwdData = PwdRegistrationData(
      name: name ?? _pwdData.name,
      address: address ?? _pwdData.address,
      idNumber: idNumber ?? _pwdData.idNumber,
      condition: condition ?? _pwdData.condition,
    );
    notifyListeners();
  }

  void updateSeniorData({
    String? name,
    String? address,
    String? idNumber,
    DateTime? birthDate,
  }) {
    _seniorData = SeniorRegistrationData(
      name: name ?? _seniorData.name,
      address: address ?? _seniorData.address,
      idNumber: idNumber ?? _seniorData.idNumber,
      birthDate: birthDate ?? _seniorData.birthDate,
    );
    notifyListeners();
  }

  Future<bool> submitRegistration() async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate successful submission
    return true;
  }
}
