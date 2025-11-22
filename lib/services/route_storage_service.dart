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

  /// In-memory cache of all routes for quick access
  static List<RouteDouble> _routes = [];

  /// Returns the current in-memory list of routes.
  ///
  /// This is a live reference, so modifications to the returned list
  /// will not be persisted unless [saveRoutes] is called.
  static List<RouteDouble> getRoutes() => _routes;

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

    if (jsonString == null) {
      _routes = [];
      return false; // No saved routes
    }

    try {
      final jsonList = json.decode(jsonString) as List;
      _routes = jsonList
          .map((item) => RouteDouble.fromJson(item as Map<String, dynamic>))
          .toList();
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
    _routes = [];
  }
}
