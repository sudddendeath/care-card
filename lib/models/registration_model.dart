import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum RegistrationType { none, pwd, seniorCitizen }

class RegistrationData {
  String name;
  String sex;
  String address;
  String idNumber;
  DateTime? birthDate;

  RegistrationData({
    this.name = '',
    this.sex = '',
    this.address = '',
    this.idNumber = '',
    this.birthDate,
  });
}

class PwdRegistrationData extends RegistrationData {
  String condition;

  PwdRegistrationData({
    super.name,
    super.sex,
    super.address,
    super.idNumber,
    super.birthDate,
    this.condition = '',
  });
}

class SeniorRegistrationData extends RegistrationData {
  SeniorRegistrationData({
    super.name,
    super.sex,
    super.address,
    super.idNumber,
    super.birthDate,
  });
}

class RegistrationModel extends ChangeNotifier {
  PwdRegistrationData _pwdData = PwdRegistrationData();
  SeniorRegistrationData _seniorData = SeniorRegistrationData();
  RegistrationType _registrationType = RegistrationType.none;

  PwdRegistrationData get pwdData => _pwdData;
  SeniorRegistrationData get seniorData => _seniorData;
  RegistrationType get registrationType => _registrationType;

  RegistrationModel();

  void setRegistrationType(RegistrationType type) {
    _registrationType = type;
    notifyListeners();
  }

  void updatePwdData({
    String? name,
    String? sex,
    String? address,
    String? idNumber,
    String? condition,
    DateTime? birthDate,
  }) {
    _pwdData = PwdRegistrationData(
      name: name ?? _pwdData.name,
      sex: sex ?? _pwdData.sex,
      address: address ?? _pwdData.address,
      idNumber: idNumber ?? _pwdData.idNumber,
      condition: condition ?? _pwdData.condition,
      birthDate: birthDate ?? _pwdData.birthDate,
    );
    notifyListeners();
  }

  void updateSeniorData({
    String? name,
    String? sex,
    String? address,
    String? idNumber,
    DateTime? birthDate,
  }) {
    _seniorData = SeniorRegistrationData(
      name: name ?? _seniorData.name,
      sex: sex ?? _seniorData.sex,
      address: address ?? _seniorData.address,
      idNumber: idNumber ?? _seniorData.idNumber,
      birthDate: birthDate ?? _seniorData.birthDate,
    );
    notifyListeners();
  }

  Future<void> submitRegistration() async {
    final client = Supabase.instance.client;
    final currentUser = client.auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in.');
    }

    Map<String, dynamic> data = {
      'id': currentUser.id,
      'email': currentUser.email,
      'name': '',
      'sex': '',
      'address': '',
      'id_number': '',
      'birth_date': null,
      'condition': null,
      'user_type': _registrationType.toString().split('.').last,
    };

    if (_registrationType == RegistrationType.pwd) {
      data.addAll({
        'name': _pwdData.name,
        'sex': _pwdData.sex,
        'address': _pwdData.address,
        'id_number': _pwdData.idNumber,
        'birth_date': _pwdData.birthDate?.toIso8601String(),
        'condition': _pwdData.condition,
      });
    } else if (_registrationType == RegistrationType.seniorCitizen) {
      data.addAll({
        'name': _seniorData.name,
        'sex': _seniorData.sex,
        'address': _seniorData.address,
        'id_number': _seniorData.idNumber,
        'birth_date': _seniorData.birthDate?.toIso8601String(),
      });
    }

    final response = await client.from('users').upsert(data);

    if (response.error != null) {
      throw Exception('Failed to submit registration: ${response.error!.message}');
    }
  }
}
