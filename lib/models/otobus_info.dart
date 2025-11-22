/// Model representing a single bus's real-time information.
///
/// Contains all details about a bus including its route, arrival time,
/// vehicle identification, and position in the route.
library;

/// Represents real-time information about a specific bus.
class OtobusInfo {
  /// Bus line number (e.g., "590")
  final String hatNo;

  /// Bus line name/description (e.g., "Yaşamkent - Kızılay")
  final String hatAdi;

  /// Stop name where this bus information applies, optional
  final String? durakAdi;

  /// Estimated arrival time as a string (e.g., "3 dk", "5 dakika")
  final String tahminVarisSuresi;

  /// Vehicle number assigned to this bus
  final String aracNo;

  /// License plate number of the bus
  final String plaka;

  /// Current position in the route as "current/total" (e.g., "5/12")
  final String durakSirasi;

  /// Special features of the bus (e.g., "Engelli Erişimi", "Klimalı")
  final String ozellikler;

  /// Creates a new OtobusInfo instance.
  ///
  /// All fields except [durakAdi] are required.
  OtobusInfo({
    required this.hatNo,
    required this.hatAdi,
    this.durakAdi,
    required this.tahminVarisSuresi,
    required this.aracNo,
    required this.plaka,
    required this.durakSirasi,
    required this.ozellikler,
  });

  /// Returns a string representation of this bus info for debugging.
  @override
  String toString() {
    return 'BusInfo(hatNo: $hatNo, hatAdi: $hatAdi, tahminVarisSuresi: $tahminVarisSuresi, '
        'aracNo: $aracNo, plaka: $plaka, durakSirasi: $durakSirasi, ozellikler: $ozellikler)';
  }
}
