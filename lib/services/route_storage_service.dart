/// Service for persisting and managing bus routes in local storage.
///
/// This service uses SharedPreferences to store route data as JSON,
/// allowing routes to persist across app restarts. It maintains an
/// in-memory list for quick access.
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/route_double.dart';

/// Centralized service for managing route storage and retrieval.
///
/// All methods are static as this is a singleton service that maintains
/// a single source of truth for route data.
class RouteStorageService {
  /// Key used to store routes in SharedPreferences
  static const String _routesKey = 'saved_routes';

  /// Key used to store the last chosen route index
  static const String _lastChosenRouteIndexKey = 'last_chosen_route_index';

  /// In-memory cache of all routes for quick access
  static List<RouteDouble> _routes = [];

  /// Index of the last chosen route
  static int? _lastChosenRouteIndex;

  /// Returns the current in-memory list of routes.
  ///
  /// This is a live reference, so modifications to the returned list
  /// will not be persisted unless [saveRoutes] is called.
  static List<RouteDouble> getRoutes() => _routes;

  /// Returns the last chosen route, or the first route if none was chosen.
  ///
  /// Returns null if no routes exist.
  static RouteDouble? getLastChosenRoute() {
    if (_routes.isEmpty) return null;
    if (_lastChosenRouteIndex != null &&
        _lastChosenRouteIndex! >= 0 &&
        _lastChosenRouteIndex! < _routes.length) {
      return _routes[_lastChosenRouteIndex!];
    }
    return _routes.first;
  }

  /// Sets the last chosen route by its index.
  static Future<void> setLastChosenRouteIndex(int index) async {
    if (index >= 0 && index < _routes.length) {
      _lastChosenRouteIndex = index;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastChosenRouteIndexKey, index);
    }
  }

  /// Gets the index of a specific route in the list.
  ///
  /// Returns -1 if the route is not found.
  static int getRouteIndex(RouteDouble route) {
    return _routes.indexOf(route);
  }

  /// Adds a new route to the list and saves to local storage.
  ///
  /// The route is added to the end of the list and immediately persisted.
  static Future<void> addRoute(RouteDouble route) async {
    _routes.add(route);
    await saveRoutes();
  }

  /// Removes a route at the specified index and saves to local storage.
  ///
  /// Does nothing if the index is out of bounds.
  /// The removal is immediately persisted.
  static Future<void> removeRoute(int index) async {
    if (index >= 0 && index < _routes.length) {
      _routes.removeAt(index);
      await saveRoutes();
    }
  }

  /// Updates a route at the specified index and saves to local storage.
  ///
  /// Does nothing if the index is out of bounds.
  /// The update is immediately persisted.
  static Future<void> updateRoute(int index, RouteDouble route) async {
    if (index >= 0 && index < _routes.length) {
      _routes[index] = route;
      await saveRoutes();
    }
  }

  /// Saves the current in-memory routes list to local storage.
  ///
  /// Serializes all routes to JSON and stores them in SharedPreferences.
  /// This should be called after any modification to the routes list.
  static Future<void> saveRoutes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _routes.map((route) => route.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await prefs.setString(_routesKey, jsonString);
  }

  /// Loads routes from local storage into memory.
  ///
  /// Returns `true` if routes were successfully loaded, `false` if no saved
  /// routes exist or if loading failed. On failure, the routes list is
  /// initialized as empty.
  ///
  /// This should be called during app initialization, before the UI is shown.
  static Future<bool> loadRoutes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_routesKey);

    // Load last chosen route index
    _lastChosenRouteIndex = prefs.getInt(_lastChosenRouteIndexKey);

    if (jsonString == null) {
      _routes = [];
      return false; // No saved routes
    }

    try {
      final jsonList = json.decode(jsonString) as List;
      _routes = jsonList
          .map((item) => RouteDouble.fromJson(item as Map<String, dynamic>))
          .toList();

      // Validate last chosen route index
      if (_lastChosenRouteIndex != null &&
          (_lastChosenRouteIndex! < 0 ||
              _lastChosenRouteIndex! >= _routes.length)) {
        _lastChosenRouteIndex = null;
      }

      return true;
    } catch (e) {
      _routes = [];
      return false;
    }
  }

  /// Clears all saved routes from both memory and local storage.
  ///
  /// This action cannot be undone. The routes list will be empty after this call.
  static Future<void> clearRoutes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_routesKey);
    await prefs.remove(_lastChosenRouteIndexKey);
    _routes = [];
    _lastChosenRouteIndex = null;
  }
}
