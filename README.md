# EgoEvde 🚌

[![Flutter](https://img.shields.io/badge/Flutter-3.9.0+-02569B?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A real-time bus tracking application for Ankara's EGO public transportation system. Track your buses at multiple stops simultaneously with automatic refresh and smart caching.

## Features ✨

- **Real-Time Bus Tracking**: Get live bus arrival times for any EGO bus stop
- **Multi-Stop Support**: Monitor multiple bus routes simultaneously
- **Smart Caching**: Reduces unnecessary network calls with 10-second cache duration
- **Auto-Refresh**: Automatic data updates every 30 seconds
- **Dual-View Mode**: Track two different routes side-by-side in landscape mode
- **Persistent Storage**: Your saved routes are stored locally and restored on app restart
- **Bilingual Support**: Full localization in Turkish and English
- **Offline-First**: Cached data remains available when network is unavailable

## Screenshots 📱

<!-- Add screenshots here when available -->

## Getting Started 🚀

### Prerequisites

- Flutter SDK 3.9.0 or higher
- Dart SDK
- Android SDK (for Android builds) or Xcode (for iOS builds)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/egoevdeapp.git
cd egoevdeapp
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate localization files:
```bash
flutter gen-l10n
```

4. Run the app:
```bash
flutter run
```

### Building for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## Usage 💡

1. **Add a Route**: Tap the "+" button to add a new bus stop pair
2. **Enter Stop Details**: 
   - Stop Number (e.g., 12345)
   - Line Number (e.g., 590)
   - Stop Name (optional, for easier identification)
3. **View Bus Times**: Select your saved route to see real-time bus arrival information
4. **Landscape Mode**: Rotate your device to see both directions simultaneously

## Technical Details 🔧

### Architecture

- **State Management**: StatefulWidget with manual state control
- **Data Persistence**: SharedPreferences for local storage
- **Network Layer**: HTTP requests to ego.gov.tr API
- **Localization**: Flutter's ARB-based internationalization system

### Key Components

- `DurakInfo`: Bus stop model with built-in caching and auto-refresh
- `RouteStorageService`: Centralized service for route persistence
- `OtobusService`: Network service for fetching live bus data
- `OtobusInfoWidget`: Reusable widget for displaying bus information

### Dependencies

- `http`: ^1.6.0 - HTTP client for API calls
- `shared_preferences`: ^2.3.3 - Local data persistence
- `flutter_html`: ^3.0.0 - HTML rendering
- `html`: ^0.15.4 - HTML parsing
- `flutter_localizations`: Internationalization support

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Roadmap 🗺️

- [ ] Add favorite routes
- [ ] Push notifications for arriving buses
- [ ] Route planning and navigation
- [ ] Historical data and analytics
- [ ] Widget support for home screen
- [ ] Dark mode support

## Known Issues ⚠️

- Network errors may occur if ego.gov.tr API is unavailable
- Some bus stops may not return data during off-peak hours

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments 🙏

- Data provided by [EGO Genel Müdürlüğü](https://www.ego.gov.tr/)
- Built with [Flutter](https://flutter.dev/)

## Contact 📧

Project Link: [https://github.com/yourusername/egoevdeapp](https://github.com/yourusername/egoevdeapp)

---

**Note**: This is an unofficial application and is not affiliated with EGO Genel Müdürlüğü.
