import 'package:flutter_test/flutter_test.dart';
import 'package:care_card/models/auth_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  setUpAll(() async {
    // Load environment variables
    await dotenv.load(fileName: "assets/.env");
    // Initialize Supabase for testing
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
  });

  tearDownAll(() async {
    // Clean up after all tests
    await Supabase.instance.client.auth.signOut();
  });

  group('AuthModel', () {
    late AuthModel authModel;

    setUp(() {
      authModel = AuthModel();
    });

    tearDown(() {
      // Sign out after each test
      Supabase.instance.client.auth.signOut();
    });

    test('initial state is not authenticated', () {
      expect(authModel.isAuthenticated, false);
      expect(authModel.userEmail, null);
    });

    test('signup with valid credentials should succeed', () async {
      const email = 'test@example.com';
      const password = 'password123';
      const fullName = 'Test User';
      const phoneNumber = '1234567890';

      final result = await authModel.signup(
        email,
        password,
        fullName,
        phoneNumber,
      );
      expect(result, true);
      // Note: User might need email confirmation
    });

    test('signup with invalid email should fail', () async {
      const email = 'invalid-email';
      const password = 'password123';
      const fullName = 'Test User';
      const phoneNumber = '1234567890';

      expect(
        () async =>
            await authModel.signup(email, password, fullName, phoneNumber),
        throwsA(isA<Exception>()),
      );
    });

    test('signup with weak password should fail', () async {
      const email = 'test@example.com';
      const password = '123';
      const fullName = 'Test User';
      const phoneNumber = '1234567890';

      expect(
        () async =>
            await authModel.signup(email, password, fullName, phoneNumber),
        throwsA(isA<Exception>()),
      );
    });

    test('signup with empty full name should fail', () async {
      const email = 'test@example.com';
      const password = 'password123';
      const fullName = '';
      const phoneNumber = '1234567890';

      expect(
        () async =>
            await authModel.signup(email, password, fullName, phoneNumber),
        throwsA(isA<Exception>()),
      );
    });

    test('signup with empty phone number should fail', () async {
      const email = 'test@example.com';
      const password = 'password123';
      const fullName = 'Test User';
      const phoneNumber = '';

      expect(
        () async =>
            await authModel.signup(email, password, fullName, phoneNumber),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'login with non-existent user should fail and set lastError',
      () async {
        const email = 'nonexistent@example.com';
        const password = 'password123';

        final result = await authModel.login(email, password);
        expect(result, false);
        expect(authModel.lastError, isNotNull);
        expect(
          authModel.lastError!.toLowerCase(),
          anyOf(
            contains('incorrect'),
            contains('not found'),
            contains('invalid'),
          ),
        );
      },
    );

    test('logout should clear authentication state', () {
      authModel.logout();
      expect(authModel.isAuthenticated, false);
      expect(authModel.userEmail, null);
    });
  });
}
