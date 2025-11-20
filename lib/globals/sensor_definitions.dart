import 'package:flutter/material.dart';

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

const Map<SensorType, SensorInfo> sensorInfo = {
  SensorType.temperaturaAmbiente: SensorInfo(
    label: 'Temperatura ambiente',
    color: Color.fromARGB(255, 244, 168, 54),
    icon: Icons.thermostat,
    limites: [0, 40],
    unidad: '°C',
  ),
  SensorType.humedadAmbiente: SensorInfo(
    label: 'Humedad ambiente',
    color: Colors.blue,
    icon: Icons.water_drop,
    limites: [0, 100],
    unidad: '%HR',
  ),
  SensorType.materialParticulado: SensorInfo(
    label: 'Material particulado',
    color: Colors.green,
    icon: Icons.nature,
    limites: [0, 1500],
    unidad: 'ppm',
  ),
  SensorType.luminosidad: SensorInfo(
    label: 'Luminosidad',
    color: Color.fromARGB(255, 248, 245, 75),
    icon: Icons.light_mode_outlined,
    limites: [0, 5000],
    unidad: 'lux',
  ),
  SensorType.humedadSuelo: SensorInfo(
    label: 'Humedad suelo',
    color: Colors.deepPurpleAccent,
    icon: Icons.water_damage_outlined,
    limites: [0, 100],
    unidad: '%H',
  ),
  SensorType.lluvia: SensorInfo(
    label: 'Lluvia',
    color: Colors.pink,
    icon: Icons.water_drop,
    limites: [0, 100],
    unidad: '%Lluvia',
  ),
};