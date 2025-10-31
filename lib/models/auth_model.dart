import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthModel extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userEmail;
  String? _userFullName;
  String? _lastError;

  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;
  String? get userFullName => _userFullName;
  String? get lastError => _lastError;

  AuthModel() {
    // Constructor now only initializes variables; listener setup moved to separate method
  }

  void setupAuthListener() {
    // Check for existing session on startup
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      _isAuthenticated = true;
      _userEmail = session.user.email;
      _userFullName = session.user.userMetadata?['full_name'];
      notifyListeners();
    }

    // Set up listener for future auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      try {
        final AuthChangeEvent event = data.event;
        final Session? session = data.session;
        debugPrint('Auth state change: $event');
        if (event == AuthChangeEvent.signedIn && session != null) {
          _isAuthenticated = true;
          _userEmail = session.user.email;
          _userFullName = session.user.userMetadata?['full_name'];
          debugPrint('User signed in: $_userEmail');
        } else if (event == AuthChangeEvent.signedOut) {
          _isAuthenticated = false;
          _userEmail = null;
          _userFullName = null;
          _lastError = null;
          debugPrint('User signed out');
        }
        notifyListeners();
      } catch (e) {
        debugPrint('Error in auth state change listener: $e');
      }
    });
  }

  Future<bool> login(String email, String password) async {
    try {
      debugPrint('Attempting login for: $email');
      final response = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password)
          .timeout(const Duration(seconds: 10));

      if (response.session != null) {
        debugPrint('✅ Login successful');
        _isAuthenticated = true;
        _userEmail = response.session!.user.email;
        _userFullName = response.session!.user.userMetadata?['full_name'];
        _lastError = null;
        notifyListeners();
        return true;
      }

      // No session returned -> treat as invalid credentials
      debugPrint('⚠️ Login failed: No session returned');
      _isAuthenticated = false;
      _lastError = 'Login failed: incorrect email or password.';
      notifyListeners();
      return false;
    } on TimeoutException {
      debugPrint('Login timed out after 10 seconds');
      _isAuthenticated = false;
      _lastError =
          'Login request timed out. Please check your internet connection and try again.';
      notifyListeners();
      return false;
    } on AuthApiException catch (e) {
      // Handles known Supabase Auth errors explicitly
      debugPrint('Auth error: ${e.message} (code: ${e.code})');
      _isAuthenticated = false;
      // Prefer a friendly message for invalid credentials
      if ((e.code ?? '').toString().toLowerCase().contains('invalid')) {
        _lastError = 'Invalid email or password';
      } else {
        _lastError = e.message;
      }
      notifyListeners();
      return false;
    } catch (e, st) {
      // Catches any other exception type (including newer/renamed auth exceptions)
      debugPrint('Unexpected error during login: $e');
      debugPrint('$st');
      _isAuthenticated = false;
      // Try to extract a human friendly message if available on the exception
      String message = 'An unexpected error occurred. Please try again.';
      try {
        final dyn = e as dynamic;
        if (dyn?.message is String && (dyn.message as String).isNotEmpty) {
          message = dyn.message as String;
        }
      } catch (_) {
        // Ignore reflection/extraction errors
      }
      _lastError = message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(
    String email,
    String password,
    String fullName,
    String phoneNumber,
  ) async {
    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'phone_number': phoneNumber},
      );

      // signUp may return a session immediately or require email confirmation.
      // Consider signup successful if no exception was thrown.
      _lastError = null;
      notifyListeners();
      return true;
    } on AuthApiException catch (e) {
      debugPrint('Signup auth error: ${e.message} (code: ${e.code})');
      _lastError = e.message;
      notifyListeners();
      return false;
    } catch (e, st) {
      debugPrint('Unexpected error during signup: $e');
      debugPrint('$st');
      String message = 'An unexpected error occurred during signup.';
      try {
        final dyn = e as dynamic;
        if (dyn?.message is String && (dyn.message as String).isNotEmpty) {
          message = dyn.message as String;
        }
      } catch (_) {}
      _lastError = message;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    // Wrap signOut in a try/catch in case the client throws.
    Supabase.instance.client.auth.signOut().catchError((e, st) {
      debugPrint('Error signing out: $e');
      debugPrint('$st');
      // Still allow listener to update state; record last error for UI if needed
      _lastError = 'Error signing out. Please try again.';
      notifyListeners();
    });
    // State will be updated via listener on successful signOut
  }
}
