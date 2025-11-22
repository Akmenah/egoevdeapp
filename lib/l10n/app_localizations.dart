import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'EgoEvde'**
  String get appTitle;

  /// Home page title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homePage;

  /// Button to add a new route
  ///
  /// In en, this message translates to:
  /// **'Add Stop Pair +'**
  String get addRouteButton;

  /// Prefix for error messages
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorPrefix;

  /// Label for last update time
  ///
  /// In en, this message translates to:
  /// **'Last update: '**
  String get lastUpdate;

  /// Time unit for seconds
  ///
  /// In en, this message translates to:
  /// **'seconds ago'**
  String get secondsAgo;

  /// Time unit for minutes
  ///
  /// In en, this message translates to:
  /// **'minutes ago'**
  String get minutesAgo;

  /// Time unit for hours
  ///
  /// In en, this message translates to:
  /// **'hours ago'**
  String get hoursAgo;

  /// Button text to show stop information
  ///
  /// In en, this message translates to:
  /// **'Show Stop Info'**
  String get showStopInfo;

  /// Title for add route page
  ///
  /// In en, this message translates to:
  /// **'Add New Stop Pair'**
  String get addNewRouteTitle;

  /// Label for route name field
  ///
  /// In en, this message translates to:
  /// **'Route Pair Name'**
  String get routeNameLabel;

  /// Hint for route name field
  ///
  /// In en, this message translates to:
  /// **'E.g: Home to Work'**
  String get routeNameHint;

  /// Validation message for route name
  ///
  /// In en, this message translates to:
  /// **'Route pair name is required'**
  String get routeNameRequired;

  /// Label for first stop section
  ///
  /// In en, this message translates to:
  /// **'First Stop'**
  String get firstStop;

  /// Label for second stop section
  ///
  /// In en, this message translates to:
  /// **'Second Stop'**
  String get secondStop;

  /// Label for stop number field
  ///
  /// In en, this message translates to:
  /// **'Stop No'**
  String get stopNumberLabel;

  /// Hint for stop number field
  ///
  /// In en, this message translates to:
  /// **'E.g: 12345'**
  String get stopNumberHint;

  /// Validation message for stop number
  ///
  /// In en, this message translates to:
  /// **'Stop number is required'**
  String get stopNumberRequired;

  /// Label for line number field
  ///
  /// In en, this message translates to:
  /// **'Line No'**
  String get lineNumberLabel;

  /// Hint for line number field
  ///
  /// In en, this message translates to:
  /// **'E.g: 123'**
  String get lineNumberHint;

  /// Validation message for line number
  ///
  /// In en, this message translates to:
  /// **'Line number is required'**
  String get lineNumberRequired;

  /// Label for stop name field
  ///
  /// In en, this message translates to:
  /// **'Stop Name'**
  String get stopNameLabel;

  /// Hint for stop name field
  ///
  /// In en, this message translates to:
  /// **'E.g: Home/Work Direction'**
  String get stopNameHint;

  /// Button to save the route
  ///
  /// In en, this message translates to:
  /// **'Save Stop Pair'**
  String get saveRouteButton;

  /// Success message when route is added
  ///
  /// In en, this message translates to:
  /// **'Stop pair added successfully!'**
  String get routeAddedSuccess;

  /// Label for first direction
  ///
  /// In en, this message translates to:
  /// **'Direction 1'**
  String get direction1;

  /// Label for second direction
  ///
  /// In en, this message translates to:
  /// **'Direction 2'**
  String get direction2;

  /// Abbreviation for line
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get lineAbbr;

  /// Label for estimated arrival time
  ///
  /// In en, this message translates to:
  /// **'Estimated Arrival'**
  String get estimatedArrival;

  /// Label for vehicle number
  ///
  /// In en, this message translates to:
  /// **'Vehicle No'**
  String get vehicleNumber;

  /// Label for license plate
  ///
  /// In en, this message translates to:
  /// **'Plate'**
  String get plate;

  /// Label for stop order in route
  ///
  /// In en, this message translates to:
  /// **'Stop Order'**
  String get stopOrder;

  /// Label for bus features
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// Message when no buses are available
  ///
  /// In en, this message translates to:
  /// **'No buses found on route.'**
  String get noBusesFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
