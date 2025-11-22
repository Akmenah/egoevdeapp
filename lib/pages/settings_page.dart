/// Settings page for app configuration.
///
/// Allows users to:
/// - Choose language (English/Turkish)
/// - Choose theme mode (Light/Dark/System)
/// - Delete all saved route data
library;

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/app_theme.dart';
import '../services/route_storage_service.dart';
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

  /// Deletes all saved routes after user confirmation.
  Future<void> _deleteAllData(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteAll),
        content: Text(l10n.deleteAllDataConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.colors(context).deleteAction,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Delete all routes
      final routes = RouteStorageService.getRoutes();
      for (int i = routes.length - 1; i >= 0; i--) {
        await RouteStorageService.removeRoute(i);
      }

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.allDataDeleted)));

      // Return to previous screen
      Navigator.pop(context, true);
    }
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

          // Delete All Data
          ListTile(
            leading: Icon(
              Icons.delete_forever,
              color: AppTheme.colors(context).deleteActionText,
            ),
            title: Text(
              l10n.deleteAllData,
              style: TextStyle(
                color: AppTheme.colors(context).deleteActionText,
              ),
            ),
            subtitle: Text(l10n.deleteAllDataSubtitle),
            onTap: () => _deleteAllData(context),
          ),
        ],
      ),
    );
  }
}
