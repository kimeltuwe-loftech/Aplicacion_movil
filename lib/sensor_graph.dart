import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:udp/udp.dart';

import 'globals/sensor_definitions.dart';

class SensorGraph extends StatefulWidget {
  final SensorType sensorType;
  SensorGraph({super.key, required this.sensorType});

  @override
  State<SensorGraph> createState() => _SensorGraphState();
}

class _SensorGraphState extends State<SensorGraph> {
  final List<FlSpot> _valores = [];
  UDP? _receiver;
  // Toggle to true to use generated example data instead of UDP.
  final bool _useMock = true;
  Timer? _mockTimer;
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();
    _startMockData();
    // if (_useMock) {
    // }
    // } else {
    //   _escucharUDP();
    // }
  }

  void _startMockData() {
    final sensorInfo = getSensorInfo(context);
    final info = sensorInfo[widget.sensorType]!;
    final limits = info.limites;
    _mockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final min = limits[0];
      final max = limits[1];
      final value = min + _rand.nextDouble() * (max - min);

      setState(() {
        _valores.add(
          FlSpot(now.second.toDouble(), double.parse(value.toStringAsFixed(2))),
        );
        if (_valores.length > 20) _valores.removeAt(0);
      });
    });
  }

  // void _escucharUDP() async {
  //   _receiver = await UDP.bind(Endpoint.any(port: Port(12345)));
  //   _receiver!.asStream().listen((datagram) {
  //     if (datagram == null) return;
  //     final dataString = utf8.decode(datagram.data);
  //     final sensorData = json.decode(dataString) as List<dynamic>;
  //     _processSensorData(sensorData, DateTime.now());
  //   });
  // }

  // void _processSensorData(List<dynamic> sensorData, DateTime timestamp) {
  //   final tipo = widget.sensorName;
  //   for (var measurement in sensorData) {
  //     if (measurement is Map && measurement['type'] == tipo) {
  //       var rawValue = measurement['value'];
  //       double? value;
  //       if (rawValue is num)
  //         value = rawValue.toDouble();
  //       else if (rawValue is String)
  //         value = double.tryParse(rawValue);
  //       if (value != null) {
  //         setState(() {
  //           _valores.add(FlSpot(timestamp.second.toDouble(), value));
  //           if (_valores.length > 20) _valores.removeAt(0);
  //         });
  //       }
  //       break; // only one sensor tracked
  //     }
  //   }
  // }

  @override
  void dispose() {
    _receiver?.close();
    _mockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sensorInfo = getSensorInfo(context);
    final info = sensorInfo[widget.sensorType]!;
    final limits = info.limites;
    final unidad = info.unidad;
    final color = info.color;
    final spots = _valores.isNotEmpty ? _valores : [FlSpot(0, limits[0])];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(info.icon, color: info.color, size: 40),
            const SizedBox(width: 20),
            Text(info.label, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 30),
          SizedBox(
            height: 400,
            width: 500,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 59,
                minY: limits[0],
                maxY: limits[1],
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    preventCurveOverShooting: true,
                    color: color,
                    barWidth: 2,
                    dotData: FlDotData(show: true),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(
                      unidad,
                      style: const TextStyle(
                        color: Color(0xFF009900),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    axisNameSize: 28,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: const TextStyle(
                          color: Color(0xFF009900),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text(
                      "Tiempo",
                      style: TextStyle(
                        color: Color(0xFF009900),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    axisNameSize: 28,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 5,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: const TextStyle(
                          color: Color(0xFF009900),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    width: 2,
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  verticalInterval: 5,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.lightBlueAccent, strokeWidth: 1),
                  getDrawingVerticalLine: (value) =>
                      FlLine(color: Colors.lightBlueAccent, strokeWidth: 1),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 16, height: 16, color: color),
              const SizedBox(width: 8),
              // Text(tipo[0].toUpperCase() + tipo.substring(1)),
            ],
          ),
        ],
      ),
    );
  }
}
