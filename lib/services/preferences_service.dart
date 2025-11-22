/// Service for managing app preferences.
///
/// Handles storage and retrieval of user preferences like language and theme mode.
library;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// Service for managing user preferences
class PreferencesService {
  static const String _localeKey = 'locale';
  static const String _themeModeKey = 'themeMode';

  /// Get the saved locale
  static Future<Locale?> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      return Locale(localeCode);
    }
    return null;
  }

  /// Save the locale
  static Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  /// Get the saved theme mode
  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeModeKey);
    if (themeModeString != null) {
      return ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
    }
    return ThemeMode.system;
  }

  /// Save the theme mode
  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.toString());
  }
}
