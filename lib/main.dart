import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/auth_model.dart';
import 'models/registration_model.dart';
import 'models/accessibility_settings_model.dart';
import 'widgets/home_page.dart';
import 'Users/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:care_card/utils/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final authModel = AuthModel();
  authModel.setupAuthListener();

  runApp(MyApp(authModel: authModel));
}

class MyApp extends StatelessWidget {
  final AuthModel authModel;

  const MyApp({super.key, required this.authModel});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authModel),
        ChangeNotifierProvider(create: (context) => RegistrationModel()),
        ChangeNotifierProvider(
          create: (context) => AccessibilitySettingsModel(),
        ),
      ],
      child: Consumer<AccessibilitySettingsModel>(
        builder: (context, settings, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Care Card',
            theme: settings.isHighContrastModeEnabled
                ? buildHighContrastTheme(settings.textSizeMultiplier)
                : buildLightTheme(settings.textSizeMultiplier),
            darkTheme: settings.isHighContrastModeEnabled
                ? buildHighContrastTheme(settings.textSizeMultiplier)
                : buildLightTheme(settings.textSizeMultiplier),
            themeMode: ThemeMode.light,
            home: Consumer<AuthModel>(
              builder: (context, auth, child) {
                return auth.isAuthenticated
                    ? const HomePage()
                    : const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
