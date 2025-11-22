// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'EgoEvde';

  @override
  String get homePage => 'Home';

  @override
  String get addRouteButton => 'Add Stop Pair +';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get lastUpdate => 'Last update: ';

  @override
  String get secondsAgo => 'seconds ago';

  @override
  String get minutesAgo => 'minutes ago';

  @override
  String get hoursAgo => 'hours ago';

  @override
  String get showStopInfo => 'Show Stop Info';

  @override
  String get addNewRouteTitle => 'Add New Stop Pair';

  @override
  String get routeNameLabel => 'Route Pair Name';

  @override
  String get routeNameHint => 'E.g: Home to Work';

  @override
  String get routeNameRequired => 'Route pair name is required';

  @override
  String get firstStop => 'First Stop';

  @override
  String get secondStop => 'Second Stop';

  @override
  String get stopNumberLabel => 'Stop No';

  @override
  String get stopNumberHint => 'E.g: 12345';

  @override
  String get stopNumberRequired => 'Stop number is required';

  @override
  String get lineNumberLabel => 'Line No';

  @override
  String get lineNumberHint => 'E.g: 123';

  @override
  String get lineNumberRequired => 'Line number is required';

  @override
  String get stopNameLabel => 'Stop Name';

  @override
  String get stopNameHint => 'E.g: Home/Work Direction';

  @override
  String get saveRouteButton => 'Save Stop Pair';

  @override
  String get routeAddedSuccess => 'Stop pair added successfully!';

  @override
  String get direction1 => 'Direction 1';

  @override
  String get direction2 => 'Direction 2';

  @override
  String get lineAbbr => 'Line';

  @override
  String get estimatedArrival => 'Estimated Arrival';

  @override
  String get vehicleNumber => 'Vehicle No';

  @override
  String get plate => 'Plate';

  @override
  String get stopOrder => 'Stop Order';

  @override
  String get features => 'Features';

  @override
  String get noBusesFound => 'No buses found on route.';

  @override
  String get deleteRoutes => 'Delete Routes';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteRouteConfirmation => 'Delete route';

  @override
  String get delete => 'Delete';

  @override
  String get editRoutes => 'Edit Routes';

  @override
  String get editRouteTitle => 'Edit Stop Pair';

  @override
  String get updateRouteButton => 'Update Stop Pair';

  @override
  String get routeUpdatedSuccess => 'Stop pair updated successfully!';

  @override
  String get arrived => 'Arrived';
}
