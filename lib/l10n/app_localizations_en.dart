// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get sensors => 'Küpalfe';

  @override
  String get plantsInformation => 'Xayen ñi kimün';

  @override
  String get sensorAmbientTemperature => 'Temperatura ñi mapu';

  @override
  String get sensorAmbientHumidity => 'Mañumtun ñi mapu';

  @override
  String get sensorParticulateMatter => 'Küzaw püle rüpü';

  @override
  String get sensorLuminosity => 'Lihuen';

  @override
  String get sensorSoilHumidity => 'Mañumtun ñi mapu lladkü';

  @override
  String get sensorRain => 'Mawün';
}
