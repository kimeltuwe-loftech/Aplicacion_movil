import 'package:udp/udp.dart';
import 'dart:async';
import 'dart:convert';
import '../globals/sensor_definitions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

class PrototypeConnection extends ChangeNotifier {
  UDP? _receiver;
  final Map<SensorType, List<FlSpot>> _valuesPerSensor = {};

  // GLOBAL last measurement (for overall loading screen)
  DateTime? _lastMeasurementTime;

  // PER-SENSOR last measurement
  final Map<SensorType, DateTime> _lastMeasurementPerSensor = {};

  Timer? _staleTimer;
  bool _isStale = true; // start as "loading" until the first value comes in

  bool get isStale => _isStale;

  /// Per-sensor connection status: true if this sensor had data in last 3 seconds
  bool isSensorConnected(SensorType sensorType) {
    final last = _lastMeasurementPerSensor[sensorType];
    if (last == null) return false;
    return DateTime.now().difference(last) <= const Duration(seconds: 3);
  }

  PrototypeConnection() {
    // Check once per second for global and per-sensor "staleness"
    _staleTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final last = _lastMeasurementTime;
      final now = DateTime.now();
      final shouldBeStale =
          last == null || now.difference(last) > const Duration(seconds: 3);

      if (shouldBeStale != _isStale) {
        _isStale = shouldBeStale;
        notifyListeners();
      }
    });
  }

  List<FlSpot> getSensorValues(SensorType sensorType) {
    return _valuesPerSensor[sensorType] ?? [FlSpot(0, 0)];
  }

  void startListeningUDP() async {
    _receiver = await UDP.bind(Endpoint.any(port: Port(12345)));
    _receiver!.asStream().listen((datagram) {
      if (datagram == null) return;
      final dataString = utf8.decode(datagram.data);
      final sensorData = json.decode(dataString) as List<dynamic>;

      for (var measurement in sensorData) {
        final sensorTypeString = measurement["type"];
        final sensorTypeEnum = sensorTypeFromUdpLabel(sensorTypeString);
        if (sensorTypeEnum == null) return;

        var rawValue = measurement["value"];

        double? value;
        if (rawValue is num) {
          value = rawValue.toDouble();
        } else if (rawValue is String) {
          value = double.tryParse(rawValue);
        }

        if (value != null) {
          final now = DateTime.now();

          // Update global last measurement
          _lastMeasurementTime = now;

          // Update per-sensor last measurement
          _lastMeasurementPerSensor[sensorTypeEnum] = now;

          _valuesPerSensor.putIfAbsent(sensorTypeEnum, () => []);
          _valuesPerSensor[sensorTypeEnum]!.add(
            FlSpot(now.second.toDouble(), value),
          );
          if (_valuesPerSensor[sensorTypeEnum]!.length > 20) {
            _valuesPerSensor[sensorTypeEnum]!.removeAt(0);
          }
        }
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _receiver?.close();
    _staleTimer?.cancel();
    super.dispose();
  }
}
