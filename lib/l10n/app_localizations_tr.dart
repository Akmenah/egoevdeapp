// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'EgoEvde';

  @override
  String get homePage => 'Ana Sayfa';

  @override
  String get addRouteButton => 'Durak Çifti Ekle +';

  @override
  String get errorPrefix => 'Hata: ';

  @override
  String get lastUpdate => 'Son güncelleme: ';

  @override
  String get secondsAgo => 'saniye önce';

  @override
  String get minutesAgo => 'dakika önce';

  @override
  String get hoursAgo => 'saat önce';

  @override
  String get showStopInfo => 'Durak Bilgilerini Göster';

  @override
  String get addNewRouteTitle => 'Yeni Durak Çifti Ekle';

  @override
  String get routeNameLabel => 'Durak Çifti Adı';

  @override
  String get routeNameHint => 'Örn: Evden İşe';

  @override
  String get routeNameRequired => 'Durak çifti adı gerekli';

  @override
  String get firstStop => 'Birinci Durak';

  @override
  String get secondStop => 'İkinci Durak';

  @override
  String get stopNumberLabel => 'Durak No';

  @override
  String get stopNumberHint => 'Örn: 12345';

  @override
  String get stopNumberRequired => 'Durak numarası gerekli';

  @override
  String get lineNumberLabel => 'Hat No';

  @override
  String get lineNumberHint => 'Örn: 123';

  @override
  String get lineNumberRequired => 'Hat numarası gerekli';

  @override
  String get stopNameLabel => 'Durak Adı';

  @override
  String get stopNameHint => 'Örn: Ev/İş Yönü';

  @override
  String get saveRouteButton => 'Durak Çiftini Kaydet';

  @override
  String get routeAddedSuccess => 'Durak çifti başarıyla eklendi!';

  @override
  String get direction1 => '1. Yön';

  @override
  String get direction2 => '2. Yön';

  @override
  String get lineAbbr => 'Hat';

  @override
  String get estimatedArrival => 'Tahmini Varış';

  @override
  String get vehicleNumber => 'Araç No';

  @override
  String get plate => 'Plaka';

  @override
  String get stopOrder => 'Durak Sırası';

  @override
  String get features => 'Özellikler';

  @override
  String get noBusesFound => 'Seferde araç bulunamadı.';
}
