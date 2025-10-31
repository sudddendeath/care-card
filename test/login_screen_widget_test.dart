import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:care_card/Users/login_screen.dart';
import 'package:care_card/models/auth_model.dart';

class FakeAuthModel extends AuthModel {
  final bool _shouldFail = true;

  @override
  Future<bool> login(String email, String password) async {
    // Simulate a small delay then set the lastError and notify listeners
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (_shouldFail) {
      // Use the protected fields via the public API
      // There's no setter, so we use reflection-like approach by calling a
      // helper method if needed. For simplicity, set via a shadowing technique
      // by calling notifyListeners after using a public method that triggers an
      // error. Since AuthModel doesn't expose a setter, we'll call a failed
      // login by returning false and then setting lastError via a custom
      // method added here.
      // But to avoid modifying the original model, we'll use this override to
      // set the private field via `setErrorForTest` helper below.
      setErrorForTest('Invalid credentials (test)');
      return false;
    }
    return true;
  }

  // Helper to set the last error for tests
  void setErrorForTest(String message) {
    // AuthModel._lastError is private; but because FakeAuthModel extends
    // AuthModel we can access it here (it's within the same library? actually
    // it's in another library). Dart's privacy is per-library, so we cannot
    // access private fields from here. Instead, we rely on notifyListeners to
    // communicate error via overriding a public getter. To keep this test
    // simple and avoid further model changes, we'll override lastError getter.
  }

  @override
  String? get lastError => 'Invalid credentials (test)';
}

void main() {
  testWidgets('shows inline error when login fails', (
    WidgetTester tester,
  ) async {
    final fakeAuth = FakeAuthModel();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthModel>.value(
          value: fakeAuth,
          child: const LoginScreen(),
        ),
      ),
    );

    // Enter email and password that pass local validators
    await tester.enterText(find.byType(TextFormField).first, 'a@b.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');

    // Tap the login button
    await tester.tap(find.text('Login'));

    // Wait for async login to complete
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Expect the inline error text to be present
    expect(find.byKey(const Key('login_error_text')), findsOneWidget);
    expect(find.textContaining('Invalid credentials (test)'), findsOneWidget);
  });
}
