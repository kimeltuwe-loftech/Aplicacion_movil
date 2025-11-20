import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

enum SensorType {
  temperaturaAmbiente,
  humedadAmbiente,
  materialParticulado,
  luminosidad,
  humedadSuelo,
  lluvia,
}

class SensorInfo {
  final String label;
  final Color color;
  final IconData? icon;
  final List<double> limites;
  final String unidad;

  const SensorInfo({
    required this.label,
    required this.color,
    this.icon,
    required this.limites,
    required this.unidad,
  });
}

/// Build sensor info with localized labels
Map<SensorType, SensorInfo> getSensorInfo(BuildContext context) {
  final t = AppLocalizations.of(context)!;

  return {
    SensorType.temperaturaAmbiente: SensorInfo(
      label: t.sensorAmbientTemperature,
      color: const Color.fromARGB(255, 244, 168, 54),
      icon: Icons.thermostat,
      limites: [0, 40],
      unidad: '°C',
    ),

    SensorType.humedadAmbiente: SensorInfo(
      label: t.sensorAmbientHumidity,
      color: Colors.blue,
      icon: Icons.water_drop,
      limites: [0, 100],
      unidad: '%HR',
    ),

    SensorType.materialParticulado: SensorInfo(
      label: t.sensorParticulateMatter,
      color: Colors.green,
      icon: Icons.nature,
      limites: [0, 1500],
      unidad: 'ppm',
    ),

    SensorType.luminosidad: SensorInfo(
      label: t.sensorLuminosity,
      color: const Color.fromARGB(255, 248, 245, 75),
      icon: Icons.light_mode_outlined,
      limites: [0, 5000],
      unidad: 'lux',
    ),

    SensorType.humedadSuelo: SensorInfo(
      label: t.sensorSoilHumidity,
      color: Colors.deepPurpleAccent,
      icon: Icons.water_damage_outlined,
      limites: [0, 100],
      unidad: '%H',
    ),

    SensorType.lluvia: SensorInfo(
      label: t.sensorRain,
      color: Colors.pink,
      icon: Icons.water_drop,
      limites: [0, 100],
      unidad: '%Lluvia',
    ),
  };
}
