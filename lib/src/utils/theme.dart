import 'package:flutter/material.dart';

// AppTheme class holds all the theme-related configurations for the application.
class AppTheme {
  // This method generates a ThemeData object based on the provided parameters.
  static ThemeData buildTheme({
    // Brightness defines whether the theme is light or dark.
    Brightness brightness = Brightness.light,
  }) {
    return ThemeData.from(
      // Using Material 3 (also known as Material You) for enhanced theming capabilities.
      useMaterial3: true,
      // ColorScheme defines a set of colors used in the app, generated from a seed color.
      colorScheme: ColorScheme.fromSeed(
        // Set brightness based on user preference.
        brightness: brightness,
        // Seed color used to generate the color scheme.
        seedColor: Colors.indigo,
        // The dynamicSchemeVariant can customize the color generation algorithm (optional).
        // dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
      ),
    );
  }
}
