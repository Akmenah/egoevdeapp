# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-22

### Added
- Real-time bus tracking for EGO Ankara buses
- Multi-stop route support
- Smart caching mechanism (10-second duration)
- Auto-refresh every 30 seconds
- Dual-view mode for landscape orientation
- Persistent local storage with SharedPreferences
- Bilingual support (Turkish and English)
- ARB-based localization system
- Route management (add, save, load routes)
- Last update time indicator
- Offline-first architecture with cached data

### Features
- Display estimated bus arrival times
- Show bus details (vehicle number, plate, stop order)
- Custom route naming for easy identification
- Automatic data refresh with UI callbacks
- Error handling with user-friendly messages
- Responsive design for different screen sizes

### Technical
- Flutter 3.9.0+ support
- Material Design 3
- HTTP networking layer
- JSON serialization for data models
- Widget preview support for development
