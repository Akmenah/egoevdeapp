/// Model for bus stop (durak) information with auto-refresh and caching capabilities.
///
/// This class manages bus data for a specific stop, including:
/// - Fetching real-time bus information from the EGO API
/// - Caching data for 10 seconds to reduce network calls
/// - Auto-refreshing data every 30 seconds
/// - Notifying listeners when data is updated
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/otobus_info.dart';

import '../services/otobus_service.dart';

/// Represents a bus stop with auto-refresh and caching functionality.
class DurakInfo {
  /// Bus stop number (e.g., "12345")
  final String durakNo;

  /// Bus line number (e.g., "590"), optional
  final String? hatNo;

  /// Bus stop name for display purposes, optional
  final String? durakAdi;

  /// List of buses currently at or approaching this stop
  List<OtobusInfo> _buses = [];

  /// Service instance for fetching bus data from API
  final svc = OtobusService();

  /// Timestamp of the last successful data fetch
  DateTime? _lastFetchTime;

  /// How long to cache data before fetching again (10 seconds)
  static const Duration _cacheDuration = Duration(seconds: 10);

  /// Timer for automatic data refresh
  Timer? _refreshTimer;

  /// Interval between automatic refreshes (30 seconds)
  static const Duration _refreshInterval = Duration(seconds: 30);

  /// Callback function called when data is refreshed
  VoidCallback? _onDataRefreshed;

  /// Creates a new DurakInfo instance.
  ///
  /// [durakNo] is required, [hatNo] and [durakAdi] are optional.
  DurakInfo({required this.durakNo, this.hatNo, this.durakAdi});

  /// Converts this DurakInfo to a JSON map for storage.
  ///
  /// Returns a map containing durakNo, hatNo, and durakAdi.
  Map<String, dynamic> toJson() {
    return {'durakNo': durakNo, 'hatNo': hatNo, 'durakAdi': durakAdi};
  }

  /// Creates a DurakInfo instance from a JSON map.
  ///
  /// Used when loading saved routes from local storage.
  factory DurakInfo.fromJson(Map<String, dynamic> json) {
    return DurakInfo(
      durakNo: json['durakNo'] as String,
      hatNo: json['hatNo'] as String?,
      durakAdi: json['durakAdi'] as String?,
    );
  }

  /// Fetches bus data with smart caching to avoid redundant network calls.
  ///
  /// If [forceRefresh] is false (default), returns cached data if it was
  /// fetched within the last 10 seconds. Set [forceRefresh] to true to
  /// bypass the cache and fetch fresh data.
  ///
  /// Updates [_buses] and [_lastFetchTime] on successful fetch.
  /// Throws an exception if the network request fails.
  Future<void> fetchBuses({bool forceRefresh = false}) async {
    final now = DateTime.now();

    // Check if we have recent cached data
    if (!forceRefresh &&
        _lastFetchTime != null &&
        now.difference(_lastFetchTime!) < _cacheDuration) {
      return; // Use cached data
    }

    final data = await svc.fetchBusInfo(
      durakNo: durakNo,
      hatNo: hatNo ?? '',
      durakAdi: durakAdi ?? '',
    );
    _buses = data;
    _lastFetchTime = now;
  }

  /// Starts automatic refresh timer that fetches bus data every 30 seconds.
  ///
  /// [onDataRefreshed] is an optional callback that will be called after each
  /// successful refresh. This is useful for updating the UI.
  ///
  /// Automatically cancels any existing timer before starting a new one.
  /// Errors during refresh are silently handled to prevent timer cancellation.
  void startAutoRefresh({VoidCallback? onDataRefreshed}) {
    stopAutoRefresh(); // Cancel any existing timer
    _onDataRefreshed = onDataRefreshed;

    _refreshTimer = Timer.periodic(_refreshInterval, (timer) async {
      try {
        await fetchBuses(forceRefresh: true);
        _onDataRefreshed?.call(); // Notify when data is refreshed
      } catch (e) {
        // Silently handle errors during auto-refresh
        // You could add logging here if needed
      }
    });
  }

  /// Stops the auto-refresh timer if it's running.
  ///
  /// Safe to call even if no timer is active.
  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Disposes the timer when the DurakInfo is no longer needed.
  ///
  /// Should be called when disposing widgets that use this instance.
  void disposeTimer() {
    stopAutoRefresh();
  }

  /// Clears all cached bus data and resets the last fetch time.
  ///
  /// Use this to force a fresh fetch on the next [fetchBuses] call.
  void clearBuses() {
    _buses = [];
    _lastFetchTime = null;
  }

  /// Returns the list of buses currently cached for this stop.
  ///
  /// Returns an empty list if no data has been fetched yet.
  List<OtobusInfo>? getBuses() {
    return _buses;
  }

  /// Returns the timestamp of the last successful data fetch.
  ///
  /// Returns null if data has never been fetched.
  /// Useful for displaying "last updated" information to the user.
  DateTime? getLastFetchTime() {
    return _lastFetchTime;
  }
}
