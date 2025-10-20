import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'dart:developer';
import 'models/auth_model.dart';
import 'models/registration_model.dart';
import 'models/accessibility_settings_model.dart';
import 'screens/home_page.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    log(
      '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}',
    );
  });

  // Debug: mark start of main
  // ignore: avoid_print
  print('main: starting initialization');

  // DEBUG FLAG: set to true to skip Supabase/dotenv initialization to
  // determine whether Supabase is the source of a startup crash. Set
  // back to false when you want normal behavior.
  const bool kSkipSupabaseInit = true; // <-- toggle for debugging

  // Load env variables and initialize Supabase in a safe try/catch so
  // initialization errors don't crash the whole app. If initialization
  // fails we'll print the error and continue (app can still run in a
  // degraded mode).
  if (!kSkipSupabaseInit) {
    try {
      // ignore: avoid_print
      print('main: loading .env');
      await dotenv.load(fileName: ".env");

      // Initialize Supabase
      // ignore: avoid_print
      print('main: initializing Supabase');
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      );
      // ignore: avoid_print
      print('main: Supabase initialized');
    } catch (e, st) {
      // ignore: avoid_print
      print('Supabase/dotenv initialization failed: $e\n$st');
    }
  } else {
    // ignore: avoid_print
    print('main: SKIPPING Supabase initialization (kSkipSupabaseInit=true)');
  }

  // ignore: avoid_print
  print('main: calling runApp');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print('MyApp: build called');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthModel()),
        ChangeNotifierProvider(create: (context) => RegistrationModel()),
        ChangeNotifierProvider(
          create: (context) => AccessibilitySettingsModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Care Card',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFBF092F),
            brightness: Brightness.light,
            primary: const Color(0xFFBF092F),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFBF092F),
            foregroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBF092F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFBF092F)),
            ),
            labelStyle: const TextStyle(color: Colors.grey),
          ),
        ),
        // For debugging: force start at LoginScreen so we can isolate crashes
        // related to the Home UI. Change back to the Consumer<AuthModel>
        // approach once you've diagnosed the issue.
        // home: Consumer<AuthModel>(
        //   builder: (context, auth, child) {
        //     return auth.isAuthenticated
        //         ? const HomePage()
        //         : const LoginScreen();
        //   },
        // ),
        home: const SplashScreen(),
      ),
    );
  }
}
