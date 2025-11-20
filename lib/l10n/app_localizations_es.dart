// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get sensors => 'Sensores';

  @override
  String get plantsInformation => 'Fichas de Plantas';

  @override
  String get sensorAmbientTemperature => 'Temperatura ambiente';

  @override
  String get sensorAmbientHumidity => 'Humedad ambiente';

  @override
  String get sensorParticulateMatter => 'Material particulado';

  @override
  String get sensorLuminosity => 'Luminosidad';

  @override
  String get sensorSoilHumidity => 'Humedad suelo';

  @override
  String get sensorRain => 'Lluvia';
}
