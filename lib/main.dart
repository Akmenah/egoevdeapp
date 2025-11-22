/// EgoEvde - Real-time bus tracking application for Ankara's EGO system
///
/// This app allows users to track bus arrival times at multiple stops
/// with automatic refresh and persistent storage.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'pages/home_page.dart';
import 'services/route_storage_service.dart';
import 'services/preferences_service.dart';
import 'models/app_theme.dart';

/// Application entry point
///
/// Initializes Flutter bindings and loads saved routes from local storage
/// before starting the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved routes from local storage
  await RouteStorageService.loadRoutes();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  /// Global key to access app state from anywhere
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  /// Load saved preferences
  Future<void> _loadPreferences() async {
    final locale = await PreferencesService.getLocale();
    final themeMode = await PreferencesService.getThemeMode();
    setState(() {
      _locale = locale;
      _themeMode = themeMode;
    });
  }

  /// Change app locale
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    PreferencesService.setLocale(locale);
  }

  /// Change app theme mode
  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    PreferencesService.setThemeMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EgoEvde',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('tr')],
      locale: _locale,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: _themeMode,
      home: const HomePage(title: "EgoEvde"),
    );
  }
}
