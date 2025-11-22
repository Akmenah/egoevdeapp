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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      theme: darkTheme(),
      home: const HomePage(title: "EgoEvde"),
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
      ).copyWith(brightness: Brightness.dark),
    );
  }
}
