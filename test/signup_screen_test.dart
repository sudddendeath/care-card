import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:care_card/models/auth_model.dart';
import 'package:care_card/Users/signup_screen.dart';

void main() {
  group('SignupScreen', () {
    late AuthModel authModel;

    setUp(() {
      authModel = AuthModel();
    });

    testWidgets('renders all form fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthModel>.value(
            value: authModel,
            child: const SignupScreen(),
          ),
        ),
      );

      expect(find.text('Create your account'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthModel>.value(
            value: authModel,
            child: const SignupScreen(),
          ),
        ),
      );

      // Tap the create account button without filling fields
      await tester.tap(find.text('Create Account'));
      await tester.pump();

      expect(find.text('Please enter your full name.'), findsOneWidget);
      expect(find.text('Please enter your phone number.'), findsOneWidget);
      expect(find.text('Please enter a valid email.'), findsOneWidget);
      expect(
        find.text('Password must be at least 6 characters.'),
        findsOneWidget,
      );
    });

    testWidgets('password visibility toggle works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthModel>.value(
            value: authModel,
            child: const SignupScreen(),
          ),
        ),
      );

      // Find password field
      final passwordField = find.byType(TextFormField).at(3);
      expect(passwordField, findsOneWidget);

      // Initially, password should be obscured
      // Note: Testing obscureText directly on TextFormField is not possible
      // Instead, we can test that the icon changes
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap the visibility icon
      await tester.tap(find.byIcon(Icons.visibility_off).first);
      await tester.pump();

      // Icon should change to visibility
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('confirm password validation works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthModel>.value(
            value: authModel,
            child: const SignupScreen(),
          ),
        ),
      );

      // Fill form fields
      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(find.byType(TextFormField).at(1), '1234567890');
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(3), 'password123');
      await tester.enterText(
        find.byType(TextFormField).at(4),
        'differentpassword',
      );

      // Tap the create account button
      await tester.tap(find.text('Create Account'));
      await tester.pump();

      expect(find.text('Passwords do not match.'), findsOneWidget);
    });
  });
}
