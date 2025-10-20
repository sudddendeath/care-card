import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthModel extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  late final StreamSubscription<AuthState> _authStateSubscription;
  User? _user;
  bool _initialized = false;

  /// True once the initial auth state has been determined (recovered session
  /// processed or initial check completed). Consumers can wait for this to
  /// avoid racing between app startup navigation and auth restoration.
  bool get isInitialized => _initialized;

  bool get isAuthenticated => _user != null;
  String? get userEmail => _user?.email;
  User? get user => _user;

  AuthModel() {
    // Log initial user for debugging
    _user = _supabase.auth.currentUser;
    // ignore: avoid_print
    print('AuthModel: currentUser at init: ${_user?.email}');

    _authStateSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      // mark initialized on the first event
      if (!_initialized) _initialized = true;
      // ignore: avoid_print
      print('AuthModel: onAuthStateChange -> user: ${_user?.email}');
      notifyListeners();
    });

    // Fallback: if onAuthStateChange doesn't fire quickly, mark initialized
    // after a short delay so the app can proceed.
    Future.delayed(const Duration(seconds: 2), () {
      if (!_initialized) {
        _initialized = true;
        // ignore: avoid_print
        print('AuthModel: initialization fallback - marking initialized');
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  Future<void> login(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signup(
    String email,
    String password,
    String fullName,
    String phoneNumber,
  ) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'phone_number': phoneNumber},
    );
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
