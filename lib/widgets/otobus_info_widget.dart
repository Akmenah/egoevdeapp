/// Widget for displaying real-time bus information in a formatted table.
///
/// Shows bus arrival times, vehicle details, and route information.
/// Supports both single-stop (portrait) and dual-stop (landscape) layouts.
library;

import 'package:egoevdeapp/models/durak_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';
import '../models/otobus_info.dart';

const double headerFontSize = 42;
const double dataFontSize = 96;
const double detailFontSize = 24;

/// Preview showing single route with sample bus data
@Preview(name: 'Single Route - Portrait')
Widget previewSingleRoute() {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('tr')],
    home: Scaffold(
      body: OtobusInfoWidget(
        firstDurak: DurakInfo(
          durakNo: '12345',
          hatNo: '590',
          durakAdi: 'Kızılay → Yaşamkent',
        ),
      ),
    ),
  );
}

/// Preview showing dual routes in landscape
@Preview(name: 'Dual Routes - Landscape')
Widget previewDualRoutes() {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('tr')],
    home: Scaffold(
      body: OtobusInfoWidget(
        firstDurak: DurakInfo(
          durakNo: '10214',
          hatNo: '590',
          durakAdi: 'Yaşamkent Yönü',
        ),
        secondDurak: DurakInfo(
          durakNo: '12345',
          hatNo: '531',
          durakAdi: 'Kızılay Yönü',
        ),
      ),
    ),
  );
}

/// Stateless widget that displays bus information for one or two stops.
///
/// In portrait orientation, shows only [firstDurak].
/// In landscape orientation, shows both [firstDurak] and [secondDurak] side-by-side.

class OtobusInfoWidget extends StatelessWidget {
  final DurakInfo? firstDurak;
  final DurakInfo? secondDurak;

  const OtobusInfoWidget({super.key, this.firstDurak, this.secondDurak});

  /// Helper to localize arrival time string
  String _localizeArrivalTime(BuildContext context, String tahminVarisSuresi) {
    final l10n = AppLocalizations.of(context)!;
    if (tahminVarisSuresi.toLowerCase() == 'geldi') {
      return l10n.arrived;
    }
    return tahminVarisSuresi;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _body(context),
      ),
    );
  }

  /// Builds the main layout based on device orientation.
  ///
  /// Portrait: Shows only first stop
  /// Landscape: Shows both stops side-by-side
  Widget _body(BuildContext context) {
    if (MediaQuery.orientationOf(context) == Orientation.portrait) {
      return _busColumn(
        context,
        firstDurak?.getBuses(),
        firstDurak?.hatNo,
        firstDurak?.durakAdi,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _busColumn(
                  context,
                  firstDurak?.getBuses(),
                  firstDurak?.hatNo,
                  firstDurak?.durakAdi,
                ),
              ),
              Expanded(
                child: _busColumn(
                  context,
                  secondDurak?.getBuses(),
                  secondDurak?.hatNo,
                  secondDurak?.durakAdi,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  /// Builds a column displaying bus information for a single stop.
  ///
  /// Shows:
  /// - Header with line number and stop name
  /// - List of buses with arrival times and details
  /// - Empty state if no buses are available
  Widget _busColumn(
    BuildContext context,
    List<OtobusInfo>? busList,
    String? hatNo,
    String? durakAdi,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Header row with Hat No and Hat Adı
        Container(
          color: const Color(0xFF7BC0E5),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Container(
                width: 140,
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.lineAbbr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: headerFontSize,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.stopNameLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: headerFontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Data row with actual values
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Container(
                width: 140,
                alignment: Alignment.centerLeft,
                child: Text(
                  hatNo ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: headerFontSize,
                    color: Colors.indigo,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  durakAdi ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: headerFontSize,
                    color: Colors.indigo,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),

        if (busList == null || busList.isEmpty) _noBusWidget(),
        if (busList != null)
          ...(busList.map((bus) => _buildBusCard(context, bus)).toList()),
      ],
    );
  }

  /// Displays a message when no buses are available for the stop.
  Widget _noBusWidget() {
    return Builder(
      builder: (context) => Center(
        child: Text(
          AppLocalizations.of(context)!.noBusesFound,
          style: const TextStyle(fontSize: headerFontSize),
        ),
      ),
    );
  }

  /// Builds a card displaying detailed information about a single bus.
  ///
  /// Shows arrival time, vehicle number, license plate, stop order,
  /// and any special features (accessibility, air conditioning, etc.).
  Widget _buildBusCard(BuildContext context, OtobusInfo bus) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Details section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.directions_bus,
                      size: 48,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (bus.tahminVarisSuresi.isNotEmpty)
                            Text(
                              AppLocalizations.of(context)!.estimatedArrival,
                              style: const TextStyle(
                                fontSize: headerFontSize,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB80000),
                              ),
                            ),
                          if (bus.tahminVarisSuresi.isNotEmpty)
                            Text(
                              _localizeArrivalTime(
                                context,
                                bus.tahminVarisSuresi,
                              ),
                              style: const TextStyle(
                                fontSize: dataFontSize,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB80000),
                              ),
                            ),
                          const SizedBox(height: 4),
                          if (bus.aracNo.isNotEmpty)
                            Text(
                              '${AppLocalizations.of(context)!.vehicleNumber}: ${bus.aracNo}',
                              style: const TextStyle(fontSize: detailFontSize),
                            ),
                          if (bus.plaka.isNotEmpty)
                            Text(
                              '${AppLocalizations.of(context)!.plate}: ${bus.plaka}',
                              style: const TextStyle(fontSize: detailFontSize),
                            ),
                          if (bus.durakSirasi.isNotEmpty)
                            Text(
                              '${AppLocalizations.of(context)!.stopOrder}: ${bus.durakSirasi}',
                              style: const TextStyle(fontSize: detailFontSize),
                            ),
                          if (bus.ozellikler.isNotEmpty)
                            Text(
                              bus.ozellikler,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: detailFontSize,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
