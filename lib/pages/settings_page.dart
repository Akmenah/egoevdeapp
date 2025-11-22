/// Settings page for app configuration.
///
/// Allows users to:
/// - Choose language (English/Turkish)
/// - Choose theme mode (Light/Dark/System)
library;

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/preferences_service.dart';
import '../main.dart';

/// Settings page widget.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/// State for the SettingsPage widget.
class _SettingsPageState extends State<SettingsPage> {
  ThemeMode _currentThemeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  /// Load current theme mode
  Future<void> _loadThemeMode() async {
    final themeMode = await PreferencesService.getThemeMode();
    setState(() {
      _currentThemeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          // Language Selection
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(l10n.languageSubtitle),
            trailing: DropdownButton<Locale>(
              value: Localizations.localeOf(context),
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
                DropdownMenuItem(value: Locale('tr'), child: Text('Türkçe')),
              ],
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  MyApp.of(context)?.setLocale(newLocale);
                }
              },
            ),
          ),
          const Divider(),

          // Theme Mode Selection
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(l10n.themeMode),
            subtitle: Text(l10n.themeModeSubtitle),
            trailing: DropdownButton<ThemeMode>(
              value: _currentThemeMode,
              items: [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(l10n.lightMode),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(l10n.darkMode),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(l10n.systemMode),
                ),
              ],
              onChanged: (ThemeMode? newMode) {
                if (newMode != null) {
                  setState(() {
                    _currentThemeMode = newMode;
                  });
                  MyApp.of(context)?.setThemeMode(newMode);
                }
              },
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
