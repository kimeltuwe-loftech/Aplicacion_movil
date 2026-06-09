import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:udp/udp.dart';

import '../globals/sensor_definitions.dart';

class SensorSample {
  final DateTime timestamp;
  final double value;

  SensorSample({required this.timestamp, required this.value});
}

/// Receives UDP packets and stores ONLY the latest value per sensor.
class UdpSensorReceiver extends ChangeNotifier {
  UDP? _udp;

  final Map<SensorType, double> _latestValue = {};
  final Map<SensorType, DateTime> _lastSeen = {};

  // Store recent history per sensor (keep last 10)
  final Map<SensorType, List<SensorSample>> _historyPerSensor = {};

  /// Latest value for a sensor (null if never received).
  double? latestValueOf(SensorType sensorType) => _latestValue[sensorType];

  /// When we last received data for a sensor (null if never received).
  DateTime? lastSeenOf(SensorType sensorType) => _lastSeen[sensorType];

  /// History of values for a sensor (empty if never received).
  List<SensorSample> getSensorValues(SensorType sensorType) {
    return _historyPerSensor[sensorType] ?? [];
  }

  /// True if we got data for this sensor within [timeout].
  bool isSensorConnected(
    SensorType sensorType, {
    Duration timeout = const Duration(seconds: 3),
  }) {
    final last = _lastSeen[sensorType];
    if (last == null) return false;
    return DateTime.now().difference(last) <= timeout;
  }

  /// True if ANY sensor is connected within [timeout].
  bool isAnySensorConnected({Duration timeout = const Duration(seconds: 3)}) {
    final now = DateTime.now();
    for (final t in _lastSeen.values) {
      if (now.difference(t) <= timeout) return true;
    }
    return false;
  }

  /// Start listening on UDP.
  Future<void> start({int port = 12345}) async {
    _udp = await UDP.bind(Endpoint.any(port: Port(port)));

    _udp!.asStream().listen((datagram) {
      if (datagram == null) return;

      final dataString = utf8.decode(datagram.data);
      final decoded = json.decode(dataString);

      if (decoded is! List) return;

      var didUpdate = false;
      final now = DateTime.now();

      for (final item in decoded) {
        if (item is! Map) continue;

        final typeLabel = item['type'];
        final sensorType = sensorTypeFromUdpLabel(typeLabel);
        if (sensorType == null) continue;

        final rawValue = item['value'];
        final value = _toDouble(rawValue);
        if (value == null) continue;

        _latestValue[sensorType] = value;
        _lastSeen[sensorType] = now;

        // Store history (keep last 10)
        final list = _historyPerSensor.putIfAbsent(sensorType, () => []);
        list.add(SensorSample(timestamp: now, value: value));
        if (list.length > 10) list.removeAt(0);

        didUpdate = true;
      }

      if (didUpdate) notifyListeners();
    });
  }

  void stop() {
    _udp?.close();
    _udp = null;
  }

  double? _toDouble(dynamic rawValue) {
    if (rawValue is num) return rawValue.toDouble();
    if (rawValue is String) return double.tryParse(rawValue);
    return null;
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}

/// Notifies when the "ANY sensor connected" status flips between connected/stale.
class AnySensorConnectionNotifier extends ChangeNotifier {
  final UdpSensorReceiver receiver;
  final Duration timeout;
  final Duration checkInterval;

  Timer? _timer;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  AnySensorConnectionNotifier(
    this.receiver, {
    this.timeout = const Duration(seconds: 3),
    this.checkInterval = const Duration(seconds: 1),
  }) {
    receiver.addListener(_recompute);
    _timer = Timer.periodic(checkInterval, (_) => _recompute());
    _recompute();
  }

  void _recompute() {
    final next = receiver.isAnySensorConnected(timeout: timeout);
    if (next != _isConnected) {
      _isConnected = next;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    receiver.removeListener(_recompute);
    _timer?.cancel();
    super.dispose();
  }
}

/// Notifies when a SPECIFIC sensor's connected/stale status flips.
class SensorConnectionNotifier extends ChangeNotifier {
  final UdpSensorReceiver receiver;
  final SensorType sensorType;
  final Duration timeout;
  final Duration checkInterval;

  Timer? _timer;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  SensorConnectionNotifier(
    this.receiver, {
    required this.sensorType,
    this.timeout = const Duration(seconds: 3),
    this.checkInterval = const Duration(seconds: 1),
  }) {
    receiver.addListener(_recompute);
    _timer = Timer.periodic(checkInterval, (_) => _recompute());
    _recompute();
  }

  void _recompute() {
    final next = receiver.isSensorConnected(sensorType, timeout: timeout);
    if (next != _isConnected) {
      _isConnected = next;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    receiver.removeListener(_recompute);
    _timer?.cancel();
    super.dispose();
  }
}