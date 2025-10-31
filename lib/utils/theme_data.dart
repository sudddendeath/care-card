import 'package:flutter/material.dart';

ThemeData buildLightTheme(double textSizeMultiplier) {
  return ThemeData(
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
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFBF092F),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20 * textSizeMultiplier,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFBF092F),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      labelStyle: TextStyle(
        color: Colors.grey,
        fontSize: 16 * textSizeMultiplier,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 16 * textSizeMultiplier),
      bodyMedium: TextStyle(fontSize: 14 * textSizeMultiplier),
      displayLarge: TextStyle(fontSize: 96 * textSizeMultiplier),
      displayMedium: TextStyle(fontSize: 60 * textSizeMultiplier),
      displaySmall: TextStyle(fontSize: 48 * textSizeMultiplier),
      headlineMedium: TextStyle(fontSize: 34 * textSizeMultiplier),
      headlineSmall: TextStyle(fontSize: 24 * textSizeMultiplier),
      titleLarge: TextStyle(fontSize: 22 * textSizeMultiplier),
      titleMedium: TextStyle(fontSize: 16 * textSizeMultiplier),
      titleSmall: TextStyle(fontSize: 14 * textSizeMultiplier),
      bodySmall: TextStyle(fontSize: 12 * textSizeMultiplier),
      labelLarge: TextStyle(fontSize: 14 * textSizeMultiplier),
      labelSmall: TextStyle(fontSize: 11 * textSizeMultiplier),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

ThemeData buildDarkTheme(double textSizeMultiplier) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFBF092F),
      brightness: Brightness.dark,
      primary: const Color(0xFFBF092F),
      onPrimary: Colors.white,
      surface: Colors.grey[850]!,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFBF092F),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20 * textSizeMultiplier,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFBF092F),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      labelStyle: TextStyle(
        color: Colors.grey,
        fontSize: 16 * textSizeMultiplier,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 16 * textSizeMultiplier),
      bodyMedium: TextStyle(fontSize: 14 * textSizeMultiplier),
      displayLarge: TextStyle(fontSize: 96 * textSizeMultiplier),
      displayMedium: TextStyle(fontSize: 60 * textSizeMultiplier),
      displaySmall: TextStyle(fontSize: 48 * textSizeMultiplier),
      headlineMedium: TextStyle(fontSize: 34 * textSizeMultiplier),
      headlineSmall: TextStyle(fontSize: 24 * textSizeMultiplier),
      titleLarge: TextStyle(fontSize: 22 * textSizeMultiplier),
      titleMedium: TextStyle(fontSize: 16 * textSizeMultiplier),
      titleSmall: TextStyle(fontSize: 14 * textSizeMultiplier),
      bodySmall: TextStyle(fontSize: 12 * textSizeMultiplier),
      labelLarge: TextStyle(fontSize: 14 * textSizeMultiplier),
      labelSmall: TextStyle(fontSize: 11 * textSizeMultiplier),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

ThemeData buildHighContrastTheme(double textSizeMultiplier) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Colors.yellow,
      onPrimary: Colors.black,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 20 * textSizeMultiplier,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: Colors.black,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16 * textSizeMultiplier,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 14 * textSizeMultiplier,
      ),
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 96 * textSizeMultiplier,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 60 * textSizeMultiplier,
      ),
      displaySmall: TextStyle(
        color: Colors.white,
        fontSize: 48 * textSizeMultiplier,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 34 * textSizeMultiplier,
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontSize: 24 * textSizeMultiplier,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 22 * textSizeMultiplier,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 16 * textSizeMultiplier,
      ),
      titleSmall: TextStyle(
        color: Colors.white,
        fontSize: 14 * textSizeMultiplier,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 12 * textSizeMultiplier,
      ),
      labelLarge: TextStyle(
        color: Colors.white,
        fontSize: 14 * textSizeMultiplier,
      ),
      labelSmall: TextStyle(
        color: Colors.yellow,
        fontSize: 11 * textSizeMultiplier,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.yellow),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      labelStyle: TextStyle(
        color: Colors.yellow,
        fontSize: 16 * textSizeMultiplier,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.yellow;
        }
        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.yellow.withAlpha(128);
        }
        return Colors.grey.withAlpha(128);
      }),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
