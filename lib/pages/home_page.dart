/// Main page of the application showing real-time bus information.
///
/// Displays bus arrival times for saved routes, with automatic refresh
/// and support for viewing two stops simultaneously in landscape mode.
library;

import 'dart:async';
import 'package:egoevdeapp/models/durak_info.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '/widgets/otobus_info_widget.dart';
import '../services/route_storage_service.dart';
import 'add_route_double.dart';

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
              _routeButtons(),
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
                style: const TextStyle(color: Colors.red),
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
          style: const TextStyle(color: Colors.red, fontSize: detailFontSize),
        ),
      ),
    );
  }

  SizedBox _routeButtons() {
    final routeInfos = RouteStorageService.getRoutes();
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(8.0, 36.0, 8.0, 8),
        itemCount: routeInfos.length + 1, // +1 for the add button
        itemBuilder: (context, index) {
          // Last item is the add button
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddRouteDoublePage(),
                          ),
                        );
                        // Refresh UI after returning from add route page
                        if (mounted) setState(() {});
                      },
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(AppLocalizations.of(context)!.addRouteButton),
              ),
            );
          }

          // Route buttons
          final routeDouble = routeInfos[index - 1];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() {
                        isLoading = true;
                        error = null;
                      });
                      try {
                        // Stop timers of previous duraks if any
                        firstDurak?.disposeTimer();
                        secondDurak?.disposeTimer();

                        // Fetch buses for the selected route double
                        await routeDouble.fetchBuses();

                        setState(() {
                          firstDurak = routeDouble.first;
                          secondDurak = routeDouble.second;
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
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      '${routeDouble.preferredName} ${AppLocalizations.of(context)!.showStopInfo}',
                    ),
            ),
          );
        },
      ),
    );
  }
}
