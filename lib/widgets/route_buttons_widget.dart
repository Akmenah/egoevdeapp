/// Widget for displaying route selection buttons.
///
/// Shows a horizontal list of saved routes with an add button,
/// allowing users to select different bus route pairs to track.
library;

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/durak_info.dart';
import '../models/app_theme.dart';
import '../services/route_storage_service.dart';
import '../pages/add_route_double.dart';
import '../pages/edit_route_double.dart';
import '../pages/settings_page.dart';

/// Horizontal scrollable list of route selection buttons.
class RouteButtonsWidget extends StatefulWidget {
  const RouteButtonsWidget({
    super.key,
    required this.isLoading,
    required this.onRouteSelected,
    required this.onAddRoute,
    required this.onLoadingChanged,
    required this.onRouteDeleted,
  });

  /// Whether data is currently being loaded
  final bool isLoading;

  /// Callback when a route is selected
  final Function(DurakInfo? first, DurakInfo? second) onRouteSelected;

  /// Callback when returning from add route page
  final VoidCallback onAddRoute;

  /// Callback to set loading state
  final Function(bool) onLoadingChanged;

  /// Callback when a route is deleted
  final VoidCallback onRouteDeleted;

  @override
  State<RouteButtonsWidget> createState() => _RouteButtonsWidgetState();
}

class _RouteButtonsWidgetState extends State<RouteButtonsWidget> {
  /// Whether delete mode is active
  bool _isDeleteMode = false;

  /// Whether edit mode is active
  bool _isEditMode = false;

  /// Deletes a route after user confirmation.
  ///
  /// Shows a confirmation dialog before deleting. If confirmed, removes the route
  /// at the specified [index] from storage. Automatically exits delete mode after
  /// the operation completes or if the user cancels.
  ///
  /// Parameters:
  /// - [context]: Build context for showing the dialog
  /// - [index]: Index of the route to delete in the routes list
  Future<void> _deleteRoute(BuildContext context, int index) async {
    final l10n = AppLocalizations.of(context)!;
    final routeInfos = RouteStorageService.getRoutes();
    final routeToDelete = routeInfos[index];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(
          '${l10n.deleteRouteConfirmation} "${routeToDelete.preferredName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await RouteStorageService.removeRoute(index);
      if (mounted) {
        setState(() {
          _isDeleteMode = false;
        });
        widget.onRouteDeleted(); // Refresh parent and reload data
      }
    } else {
      // Exit delete mode if cancelled
      if (mounted) {
        setState(() {
          _isDeleteMode = false;
        });
      }
    }
  }

  /// Opens the edit page for a route.
  ///
  /// Navigates to [EditRouteDoublePage] with the selected route. Automatically
  /// exits edit mode when returning from the edit page. If the route was successfully
  /// updated (result == true), refreshes the parent widget.
  ///
  /// Parameters:
  /// - [context]: Build context for navigation
  /// - [index]: Index of the route to edit in the routes list
  Future<void> _editRoute(BuildContext context, int index) async {
    final routeInfos = RouteStorageService.getRoutes();
    final routeToEdit = routeInfos[index];

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditRouteDoublePage(routeIndex: index, existingRoute: routeToEdit),
      ),
    );

    // Exit edit mode after returning from edit page
    if (mounted) {
      setState(() {
        _isEditMode = false;
      });
      if (result == true) {
        widget.onAddRoute(); // Refresh parent
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeInfos = RouteStorageService.getRoutes();
    // Sort routes alphabetically by name (case-insensitive)
    routeInfos.sort(
      (a, b) => a.preferredName.toLowerCase().compareTo(
        b.preferredName.toLowerCase(),
      ),
    );
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(8.0, 36.0, 8.0, 8),
        itemCount:
            routeInfos.length +
            4, // +4 for settings, add, edit and delete buttons
        itemBuilder: (context, index) {
          // First item is the settings button
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: widget.isLoading || _isDeleteMode || _isEditMode
                    ? null
                    : () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                        // If data was deleted, refresh
                        if (result == true) {
                          widget.onAddRoute();
                        }
                      },
                child: Icon(
                  Icons.settings,
                  color: (_isDeleteMode || _isEditMode)
                      ? AppTheme.colors(context).iconDisabled
                      : AppTheme.colors(context).settingsIcon,
                ),
              ),
            );
          }

          // Second item is the add button
          if (index == 1) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: widget.isLoading || _isDeleteMode || _isEditMode
                    ? null
                    : () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddRouteDoublePage(),
                          ),
                        );
                        widget.onAddRoute();
                      },
                // Icon color: grey when disabled (delete/edit mode active), green otherwise
                child: Icon(
                  Icons.add,
                  color: (_isDeleteMode || _isEditMode)
                      ? AppTheme.colors(context).iconDisabled
                      : AppTheme.colors(context).addIcon,
                ),
              ),
            );
          }

          // Third item is the edit routes button
          if (index == 2) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: widget.isLoading || _isDeleteMode
                    ? null
                    : () {
                        // Toggle edit mode on/off
                        setState(() {
                          _isEditMode = !_isEditMode;
                        });
                      },
                style: ElevatedButton.styleFrom(
                  // Blue background when edit mode is active
                  backgroundColor: _isEditMode
                      ? AppTheme.colors(context).editModeBackground
                      : null,
                ),
                // Show close icon when active, edit icon with conditional color otherwise
                child: _isEditMode
                    ? Icon(
                        Icons.close,
                        color: AppTheme.colors(context).closeIcon,
                      )
                    : Icon(
                        Icons.edit,
                        color: _isDeleteMode
                            ? AppTheme.colors(context).editIconDisabled
                            : AppTheme.colors(context).editIcon,
                      ),
              ),
            );
          }

          // Fourth item is the delete routes button
          if (index == 3) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: widget.isLoading || _isEditMode
                    ? null
                    : () {
                        // Toggle delete mode on/off
                        setState(() {
                          _isDeleteMode = !_isDeleteMode;
                        });
                      },
                style: ElevatedButton.styleFrom(
                  // Red background when delete mode is active
                  backgroundColor: _isDeleteMode
                      ? AppTheme.colors(context).deleteModeBackground
                      : null,
                ),
                // Show close icon when active, delete icon with conditional color otherwise
                child: _isDeleteMode
                    ? Icon(
                        Icons.close,
                        color: AppTheme.colors(context).closeIcon,
                      )
                    : Icon(
                        Icons.delete,
                        color: _isEditMode
                            ? AppTheme.colors(context).deleteIconDisabled
                            : AppTheme.colors(context).deleteIcon,
                      ),
              ),
            );
          }

          // Route buttons - display saved route pairs
          // Index offset by 4 to account for settings, add, edit, and delete buttons
          final routeDouble = routeInfos[index - 4];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: widget.isLoading
                  ? null
                  : () async {
                      // Behavior changes based on active mode:
                      if (_isDeleteMode) {
                        // Delete mode: clicking deletes the route
                        await _deleteRoute(context, index - 4);
                      } else if (_isEditMode) {
                        // Edit mode: clicking opens edit page
                        await _editRoute(context, index - 4);
                      } else {
                        // Normal mode: clicking loads and displays route data
                        widget.onLoadingChanged(true);
                        try {
                          // Save this as the last chosen route
                          await RouteStorageService.setLastChosenRouteIndex(
                            index - 4,
                          );

                          // Fetch buses for the selected route double
                          await routeDouble.fetchBuses();
                          widget.onRouteSelected(
                            routeDouble.first,
                            routeDouble.second,
                          );
                        } catch (e) {
                          // On error, pass null to indicate failure
                          widget.onRouteSelected(null, null);
                        } finally {
                          widget.onLoadingChanged(false);
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                // Background color changes based on active mode
                backgroundColor: _isDeleteMode
                    ? AppTheme.colors(context).deleteRouteBackground
                    : _isEditMode
                    ? AppTheme.colors(context).editRouteBackground
                    : null,
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(routeDouble.preferredName),
            ),
          );
        },
      ),
    );
  }
}
