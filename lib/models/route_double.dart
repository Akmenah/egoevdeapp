/// Model representing a pair of bus stops (typically opposite directions).
///
/// This allows users to track buses going in both directions of a route
/// simultaneously. Each RouteDouble contains two DurakInfo instances and
/// a user-friendly name.
library;

import 'package:egoevdeapp/models/durak_info.dart';

/// Represents a pair of bus stops, usually for opposite directions.
class RouteDouble {
  /// First bus stop (e.g., outbound direction)
  final DurakInfo first;

  /// Second bus stop (e.g., return direction)
  final DurakInfo second;

  /// User-defined name for easy identification (e.g., "Home-Work")
  final String preferredName;

  /// Creates a new RouteDouble instance.
  ///
  /// All parameters are required.
  RouteDouble({
    required this.first,
    required this.second,
    required this.preferredName,
  });

  /// Converts this RouteDouble to a JSON map for storage.
  ///
  /// Includes both stops and the preferred name.
  Map<String, dynamic> toJson() {
    return {
      'first': first.toJson(),
      'second': second.toJson(),
      'preferredName': preferredName,
    };
  }

  /// Creates a RouteDouble instance from a JSON map.
  ///
  /// Used when loading saved routes from local storage.
  factory RouteDouble.fromJson(Map<String, dynamic> json) {
    return RouteDouble(
      first: DurakInfo.fromJson(json['first'] as Map<String, dynamic>),
      second: DurakInfo.fromJson(json['second'] as Map<String, dynamic>),
      preferredName: json['preferredName'] as String,
    );
  }

  /// Fetches bus data for both stops simultaneously.
  ///
  /// Calls fetchBuses() on both the first and second DurakInfo instances.
  Future<void> fetchBuses() async {
    await first.fetchBuses();
    await second.fetchBuses();
  }

  /// Returns both stops as a tuple record.
  ///
  /// Useful for destructuring: `final (stop1, stop2) = route.getRouteDouble();`
  (DurakInfo, DurakInfo) getRouteDouble() {
    return (first, second);
  }
}
