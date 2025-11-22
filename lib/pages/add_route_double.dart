/// Page for adding a new route pair to the saved routes.
///
/// Allows users to input details for two bus stops (typically opposite
/// directions) and save them as a named route for easy access.
library;

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/durak_info.dart';
import '../models/route_double.dart';
import '../services/route_storage_service.dart';

/// Form page for adding a new route pair.
class AddRouteDoublePage extends StatefulWidget {
  const AddRouteDoublePage({super.key});

  @override
  State<AddRouteDoublePage> createState() => _AddRouteDoublePageState();
}

/// State for the AddRouteDoublePage widget.
class _AddRouteDoublePageState extends State<AddRouteDoublePage> {
  /// Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers for first stop
  /// Controller for first stop's bus stop number
  final _firstDurakNoController = TextEditingController();

  /// Controller for first stop's line number
  final _firstHatNoController = TextEditingController();

  /// Controller for first stop's name/description
  final _firstDurakAdiController = TextEditingController();

  // Text controllers for second stop
  /// Controller for second stop's bus stop number
  final _secondDurakNoController = TextEditingController();

  /// Controller for second stop's line number
  final _secondHatNoController = TextEditingController();

  /// Controller for second stop's name/description
  final _secondDurakAdiController = TextEditingController();

  /// Controller for the user-defined route name
  final _preferredNameController = TextEditingController();

  @override
  void dispose() {
    // Dispose all text controllers to prevent memory leaks
    _firstDurakNoController.dispose();
    _firstHatNoController.dispose();
    _firstDurakAdiController.dispose();
    _secondDurakNoController.dispose();
    _secondHatNoController.dispose();
    _secondDurakAdiController.dispose();
    _preferredNameController.dispose();
    super.dispose();
  }

  /// Validates the form and saves the new route to storage.
  ///
  /// Creates a RouteDouble from the form data, adds it to storage,
  /// shows a success message, and returns to the previous screen.
  void _saveRoute() async {
    if (_formKey.currentState!.validate()) {
      final newRoute = RouteDouble(
        first: DurakInfo(
          durakNo: _firstDurakNoController.text.trim(),
          hatNo: _firstHatNoController.text.trim(),
          durakAdi: _firstDurakAdiController.text.trim(),
        ),
        second: DurakInfo(
          durakNo: _secondDurakNoController.text.trim(),
          hatNo: _secondHatNoController.text.trim(),
          durakAdi: _secondDurakAdiController.text.trim(),
        ),
        preferredName: _preferredNameController.text.trim(),
      );

      await RouteStorageService.addRoute(newRoute);

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.routeAddedSuccess)));

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addNewRouteTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: isPortrait ? 24 : 128.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Preferred Name
                TextFormField(
                  controller: _preferredNameController,
                  decoration: InputDecoration(
                    labelText: l10n.routeNameLabel,
                    hintText: l10n.routeNameHint,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.routeNameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // First Durak Section
                Text(
                  l10n.firstStop,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _firstDurakNoController,
                  decoration: InputDecoration(
                    labelText: l10n.stopNumberLabel,
                    hintText: l10n.stopNumberHint,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.stopNumberRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _firstHatNoController,
                  decoration: InputDecoration(
                    labelText: l10n.lineNumberLabel,
                    hintText: l10n.lineNumberHint,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.lineNumberRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _firstDurakAdiController,
                  decoration: InputDecoration(
                    labelText: l10n.stopNameLabel,
                    hintText: l10n.stopNameHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Second Durak Section
                Text(
                  l10n.secondStop,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _secondDurakNoController,
                  decoration: InputDecoration(
                    labelText: l10n.stopNumberLabel,
                    hintText: l10n.stopNumberHint,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.stopNumberRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _secondHatNoController,
                  decoration: InputDecoration(
                    labelText: l10n.lineNumberLabel,
                    hintText: l10n.lineNumberHint,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.lineNumberRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _secondDurakAdiController,
                  decoration: InputDecoration(
                    labelText: l10n.stopNameLabel,
                    hintText: l10n.stopNameHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),

                // Save Button
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isPortrait ? 24 : 180.0,
                  ),
                  child: ElevatedButton(
                    onPressed: _saveRoute,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      l10n.saveRouteButton,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
