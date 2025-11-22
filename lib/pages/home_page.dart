/// Main page of the application showing real-time bus information.
///
/// Displays bus arrival times for saved routes, with automatic refresh
/// and support for viewing two stops simultaneously in landscape mode.
library;

import 'dart:async';
import 'package:egoevdeapp/models/durak_info.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/app_theme.dart';
import '/widgets/otobus_info_widget.dart';
import '../widgets/route_buttons_widget.dart';
import '../services/route_storage_service.dart';

/// Home page widget displaying bus tracking information.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  /// Title displayed in the app bar
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State for the HomePage widget.
class _HomePageState extends State<HomePage> {
  /// First bus stop being tracked (e.g., outbound direction)
  DurakInfo? firstDurak;

  /// Second bus stop being tracked (e.g., return direction)
  DurakInfo? secondDurak;

  /// Whether data is currently being loaded
  bool isLoading = false;

  /// Error message if fetching data failed
  String? error;

  /// Timer for updating the "last updated" time indicator
  Timer? _timeUpdateTimer;

  @override
  void initState() {
    super.initState();
    initTable();
    // Start timer to update the "last updated" display every 5 seconds
    _timeUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // Clean up timers to prevent memory leaks
    _timeUpdateTimer?.cancel();
    firstDurak?.disposeTimer();
    secondDurak?.disposeTimer();
    super.dispose();
  }

  /// Initializes the display by loading and fetching the first saved route.
  ///
  /// If routes exist, loads the first one and starts auto-refresh timers.
  /// Updates UI state to show loading/error/success.
  void initTable() async {
    final routeInfos = RouteStorageService.getRoutes();
    if (routeInfos.isEmpty) return;

    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      // Stop timers of previous duraks if any
      firstDurak?.disposeTimer();
      secondDurak?.disposeTimer();

      // Fetch buses for the selected route double
      await routeInfos.first.fetchBuses();

      setState(() {
        firstDurak = routeInfos.first.first;
        secondDurak = routeInfos.first.second;
        isLoading = false;
      });

      // Start auto-refresh timers for the selected duraks
      firstDurak?.startAutoRefresh(
        onDataRefreshed: () {
          if (mounted) setState(() {});
        },
      );
      secondDurak?.startAutoRefresh(
        onDataRefreshed: () {
          if (mounted) setState(() {});
        },
      );
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  /// Calculates and formats the time elapsed since the last data fetch.
  ///
  /// Returns a localized string like "5 seconds ago", "2 minutes ago", etc.
  /// Returns empty string if no fetch has occurred yet.
  String _getTimeSinceLastFetch(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lastFetch = firstDurak?.getLastFetchTime();
    if (lastFetch == null) return '';

    final now = DateTime.now();
    final difference = now.difference(lastFetch);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ${l10n.secondsAgo}';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${l10n.minutesAgo}';
    } else {
      return '${difference.inHours} ${l10n.hoursAgo}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // Route selection buttons
              RouteButtonsWidget(
                isLoading: isLoading,
                onLoadingChanged: (loading) {
                  setState(() {
                    isLoading = loading;
                  });
                },
                onRouteSelected: (first, second) {
                  if (first == null || second == null) {
                    setState(() {
                      error = 'Failed to load route';
                    });
                    return;
                  }

                  setState(() {
                    error = null;
                  });

                  // Stop timers of previous duraks if any
                  firstDurak?.disposeTimer();
                  secondDurak?.disposeTimer();

                  setState(() {
                    firstDurak = first;
                    secondDurak = second;
                  });

                  // Start auto-refresh timers for the selected duraks
                  firstDurak?.startAutoRefresh(
                    onDataRefreshed: () {
                      if (mounted) setState(() {});
                    },
                  );
                  secondDurak?.startAutoRefresh(
                    onDataRefreshed: () {
                      if (mounted) setState(() {});
                    },
                  );
                },
                onAddRoute: () {
                  if (mounted) setState(() {});
                },
              ),
              // Display bus info or loading/error state
              _otobusTable(),
              // Last fetch time indicator
              if (firstDurak != null && firstDurak!.getLastFetchTime() != null)
                _timeIndicator(context),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _otobusTable() {
    return Expanded(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Text(
                '${AppLocalizations.of(context)!.errorPrefix}$error',
                style: TextStyle(color: AppTheme.colors(context).error),
              ),
            )
          : OtobusInfoWidget(firstDurak: firstDurak, secondDurak: secondDurak),
    );
  }

  Widget _timeIndicator(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Text(
          '${l10n.lastUpdate}${_getTimeSinceLastFetch(context)}',
          style: TextStyle(
            color: AppTheme.colors(context).error,
            fontSize: detailFontSize,
          ),
        ),
      ),
    );
  }
}
