import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthModel extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  late final StreamSubscription<AuthState> _authStateSubscription;
  User? _user;

  bool get isAuthenticated => _user != null;
  String? get userEmail => _user?.email;
  User? get user => _user;

  AuthModel() {
    _user = _supabase.auth.currentUser;
    _authStateSubscription =
        _supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  Future<void> login(String email, String password) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signup(
      String email, String password, String fullName, String phoneNumber) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone_number': phoneNumber,
      },
    );
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
