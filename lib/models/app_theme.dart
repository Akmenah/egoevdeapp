/// Application theme configuration.
///
/// Defines all colors and theme data used throughout the app,
/// providing consistent styling for both light and dark modes.
library;

import 'package:flutter/material.dart';

/// App theme configuration with light and dark themes
class AppTheme {
  // Prevent instantiation
  AppTheme._();

  // Seed color for Material 3 color scheme
  static const Color _seedColor = Color(0xFF7BC0E5);

  /// App colors that adapt to theme mode
  static AppColors colors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.dark : AppColors.light;
  }

  /// Light theme configuration
  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }

  /// Dark theme configuration
  static ThemeData darkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
}

/// Color palette for the application
class AppColors {
  const AppColors({
    required this.settingsIcon,
    required this.addIcon,
    required this.editIcon,
    required this.editIconDisabled,
    required this.editModeBackground,
    required this.deleteIcon,
    required this.deleteIconDisabled,
    required this.deleteModeBackground,
    required this.closeIcon,
    required this.iconDisabled,
    required this.error,
    required this.deleteRouteBackground,
    required this.editRouteBackground,
    required this.deleteAction,
    required this.deleteActionText,
    required this.stopHeaderBackground,
    required this.stopHeaderText,
    required this.stopNameText,
    required this.cardBorder,
    required this.busIcon,
    required this.arrivalTimeText,
    required this.detailText,
  });

  // Button icons
  final Color settingsIcon;
  final Color addIcon;
  final Color editIcon;
  final Color editIconDisabled;
  final Color deleteIcon;
  final Color deleteIconDisabled;
  final Color closeIcon;
  final Color iconDisabled;

  // Mode backgrounds
  final Color editModeBackground;
  final Color deleteModeBackground;

  // Route button backgrounds
  final Color deleteRouteBackground;
  final Color editRouteBackground;

  // Error and action colors
  final Color error;
  final Color deleteAction;
  final Color deleteActionText;

  // Bus info widget colors
  final Color stopHeaderBackground;
  final Color stopHeaderText;
  final Color stopNameText;
  final Color cardBorder;
  final Color busIcon;
  final Color arrivalTimeText;
  final Color detailText;

  /// Light mode colors
  static const AppColors light = AppColors(
    settingsIcon: Colors.blueGrey,
    addIcon: Colors.green,
    editIcon: Colors.blueAccent,
    editIconDisabled: Colors.grey,
    editModeBackground: Colors.blue,
    deleteIcon: Colors.redAccent,
    deleteIconDisabled: Colors.grey,
    deleteModeBackground: Colors.red,
    closeIcon: Colors.white,
    iconDisabled: Colors.grey,
    error: Colors.red,
    deleteRouteBackground: Color(0xFFFFCDD2), // Colors.red.shade100
    editRouteBackground: Color(0xFFBBDEFB), // Colors.blue.shade100
    deleteAction: Colors.red,
    deleteActionText: Colors.red,
    stopHeaderBackground: Color(0xFF7BC0E5), // Light blue header
    stopHeaderText: Colors.black,
    stopNameText: Colors.blue,
    cardBorder: Color(0xFFE0E0E0), // Colors.grey.shade300
    busIcon: Colors.blue,
    arrivalTimeText: Color(0xFFB80000), // Dark red
    detailText: Colors.black,
  );

  /// Dark mode colors
  static const AppColors dark = AppColors(
    settingsIcon: Colors.blueGrey,
    addIcon: Colors.green,
    editIcon: Colors.blueAccent,
    editIconDisabled: Colors.grey,
    editModeBackground: Colors.blue,
    deleteIcon: Colors.redAccent,
    deleteIconDisabled: Colors.grey,
    deleteModeBackground: Colors.red,
    closeIcon: Colors.white,
    iconDisabled: Colors.grey,
    error: Colors.red,
    deleteRouteBackground: Color(0xFFB71C1C), // Colors.red.shade900
    editRouteBackground: Color(0xFF0D47A1), // Colors.blue.shade900
    deleteAction: Colors.red,
    deleteActionText: Colors.red,
    stopHeaderBackground: Color.fromARGB(255, 51, 101, 128), // Dark blue header
    stopHeaderText: Colors.white,
    stopNameText: Colors.blue,
    cardBorder: Color(0xFFE0E0E0), // Colors.grey.shade300
    busIcon: Colors.blue,
    arrivalTimeText: Color(0xFFB80000), // Dark red
    detailText: Colors.white,
  );
}
