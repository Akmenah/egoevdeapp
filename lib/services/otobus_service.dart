/// Service for fetching real-time bus information from EGO's website.
///
/// This service makes HTTP requests to www.ego.gov.tr and parses the HTML
/// response to extract bus arrival times and details.
library;

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../models/otobus_info.dart';

/// Service class for interacting with the EGO bus tracking API.
class OtobusService {
  /// Fetches real-time bus information for a specific stop.
  ///
  /// Parameters:
  /// - [durakNo]: Bus stop number (required)
  /// - [durakAdi]: Bus stop name (optional, for display)
  /// - [hatNo]: Bus line number (optional, filters by specific line)
  ///
  /// Returns a list of [OtobusInfo] objects containing bus details.
  /// Throws an exception if the request fails or data cannot be parsed.
  ///
  /// This method tries both POST and GET requests to maximize compatibility.
  Future<List<OtobusInfo>> fetchBusInfo({
    required String durakNo,
    String? durakAdi,
    String? hatNo,
  }) async {
    try {
      // First, try POST method as the form might require it
      final url = Uri.parse('https://www.ego.gov.tr/tr/otobusnerede');
      debugPrint('Fetching URL: $url with POST');

      final headers = <String, String>{
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8',
        'Accept-Language': 'tr-TR,tr;q=0.9,en-US;q=0.8,en;q=0.7',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Origin': 'https://www.ego.gov.tr',
        'Referer': 'https://www.ego.gov.tr/tr/otobusnerede',
        'Connection': 'keep-alive',
        'Cache-Control': 'max-age=0',
        'Upgrade-Insecure-Requests': '1',
      };

      // Try POST with form data
      final body = 'durak_no=$durakNo&hat_no=$hatNo';
      var response = await http.post(url, headers: headers, body: body);

      // If POST doesn't work, try GET with parameters
      if (response.statusCode != 200 ||
          !response.body.contains('Tahmini Varış')) {
        debugPrint('POST failed or no data, trying GET with parameters');
        final getUrl = Uri.parse(
          'https://www.ego.gov.tr/tr/otobusnerede?durak_no=$durakNo&hat_no=$hatNo',
        );
        response = await http.get(getUrl, headers: headers);
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to load data: ${response.statusCode}');
      }

      debugPrint('Response body length: ${response.body.length}');
      debugPrint(
        'Contains Tahmini Varış: ${response.body.contains('Tahmini Varış')}',
      );

      final document = html_parser.parse(response.body);
      // The form submission returns the page with populated bus data in div.otobusnerede
      final otobusNeredeDiv = document.querySelector('div.otobusnerede');

      if (otobusNeredeDiv == null) {
        debugPrint('ERROR: div.otobusnerede not found');
        debugPrint('Body preview: ${response.body.substring(0, 500)}');
        throw Exception('Could not find bus location data');
      }

      debugPrint('Found otobusnerede div');
      final busList = <OtobusInfo>[];
      final table = otobusNeredeDiv.querySelector('table');

      if (table == null) {
        debugPrint('ERROR: table not found in div');
        debugPrint('Div text: ${otobusNeredeDiv.text}');
        throw Exception('Could not find table in bus location data');
      }

      final rows = table.querySelectorAll('tr');
      debugPrint('Found ${rows.length} rows in table');

      // Skip the header row (first row with th elements)
      // Process pairs of rows: first row has hatNo and hatAdi, second row has bus details
      for (int i = 1; i < rows.length; i += 2) {
        debugPrint('Processing row pair starting at index $i');
        if (i + 1 >= rows.length) {
          debugPrint('No matching detail row for index $i');
          break;
        }

        final infoRow = rows[i];
        final detailRow = rows[i + 1];

        // Extract hatNo and hatAdi from first row
        final infoCells = infoRow.querySelectorAll('td');
        debugPrint('Row $i has ${infoCells.length} td cells');

        if (infoCells.length < 2) {
          debugPrint('Skipping row $i - insufficient cells');
          continue;
        }

        final hatNoText = infoCells[0].text.trim();
        final hatAdiText = infoCells[1].text.trim();
        debugPrint('Extracted: hatNo=$hatNoText, hatAdi=$hatAdiText');

        // Extract details from second row
        final detailCell = detailRow.querySelector('td');
        if (detailCell == null) {
          debugPrint('No td cell in detail row ${i + 1}');
          continue;
        }

        final detailText = detailCell.text;
        debugPrint('Detail text: $detailText');

        // Parse the detail text using regex
        final tahminVarisMatch = RegExp(
          r'Tahmini Varış Süresi:\s*(.+?)\s*(?:Araç|$)',
        ).firstMatch(detailText);
        final aracNoMatch = RegExp(r'Araç No:\s*(\S+)').firstMatch(detailText);
        final plakaMatch = RegExp(
          r'Plaka:\s*(\d+\s+\w+\s+\d+)',
        ).firstMatch(detailText);
        final durakSirasiMatch = RegExp(
          r'Bulunduğu Durak Sırası:\s*(\d+/\d+)',
        ).firstMatch(detailText);

        // Extract features (last line after durakSirasi)
        final ozelliklerMatch = RegExp(
          r'Bulunduğu Durak Sırası:\s*\d+/\d+\s*(.+?)$',
          dotAll: true,
        ).firstMatch(detailText);

        final busInfo = OtobusInfo(
          hatNo: hatNoText,
          hatAdi: hatAdiText,
          durakAdi: durakAdi,
          tahminVarisSuresi: tahminVarisMatch?.group(1)?.trim() ?? '',
          aracNo: aracNoMatch?.group(1)?.trim() ?? '',
          plaka: plakaMatch?.group(1)?.trim() ?? '',
          durakSirasi: durakSirasiMatch?.group(1)?.trim() ?? '',
          ozellikler: ozelliklerMatch?.group(1)?.trim() ?? '',
        );

        debugPrint('Parsed BusInfo: $busInfo');
        busList.add(busInfo);
      }

      return busList;
    } catch (e) {
      debugPrint('Error fetching bus location: $e');
      throw Exception('Error fetching bus location: $e');
    }
  }
}
