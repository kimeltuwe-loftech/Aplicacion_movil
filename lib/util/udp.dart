import 'package:udp/udp.dart';
import 'dart:async'; // <--- ADD THIS
import 'dart:convert';
import '../globals/sensor_definitions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

class PrototypeConnection extends ChangeNotifier {
  UDP? _receiver;
  final Map<SensorType, List<FlSpot>> _valuesPerSensor = {};

  DateTime? _lastMeasurementTime;
  Timer? _staleTimer;
  bool _isStale = true; // start as "loading" until the first value comes in

  bool get isStale => _isStale;

  PrototypeConnection() {
    // Check once per second if data has become "stale"
    _staleTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final last = _lastMeasurementTime;
      final now = DateTime.now();
      final shouldBeStale =
          last == null || now.difference(last) > const Duration(seconds: 3);

      if (shouldBeStale != _isStale) {
        _isStale = shouldBeStale;
        print(_isStale);
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

          _lastMeasurementTime = now; // <-- update last measurement time
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
