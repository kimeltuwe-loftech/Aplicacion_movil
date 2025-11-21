import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'util/udp.dart';
import 'globals/sensor_definitions.dart';

class SensorGraph extends StatefulWidget {
  final SensorType sensorType;
  SensorGraph({super.key, required this.sensorType});

  @override
  State<SensorGraph> createState() => _SensorGraphState();
}

class _SensorGraphState extends State<SensorGraph> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final PrototypeConnection conn = context.watch<PrototypeConnection>();
    final samples = conn.getSensorValues(widget.sensorType);

    final sensorInfo = getSensorInfo(context);
    final info = sensorInfo[widget.sensorType]!;

    if (samples.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(info.icon, color: info.color, size: 40),
              const SizedBox(width: 20),
              Text(
                info.label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: const Center(child: Text("No data yet")),
      );
    }

    // ----- Build FL spots from samples -----
    final DateTime baseTime = samples.first.timestamp;

    final barGroups = samples.asMap().entries.map((entry) {
      final i = entry.key;
      final sample = entry.value;

      // x-axis = seconds since first sample
      final x = sample.timestamp.difference(baseTime).inSeconds.toDouble();

      return BarChartGroupData(
        x: x.toInt(),
        barRods: [
          BarChartRodData(
            toY: sample.value,
            color: info.color,
            width: 12,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    double maxX = barGroups.last.x.toDouble();
    double maxY = info.limites[1];
    double minY = info.limites[0];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(info.icon, color: info.color, size: 40),
            const SizedBox(width: 20),
            Text(
              info.label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 30),
          SizedBox(
            height: 400,
            width: 500,
            child: BarChart(
              BarChartData(
                minY: minY,
                maxY: maxY,
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(
                      info.unidad,
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
                      interval: 5,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final dt = baseTime.add(
                          Duration(seconds: value.toInt()),
                        );
                        final ss = dt.second.toString().padLeft(2, '0');

                        return Text(
                          '$ss',
                          style: const TextStyle(
                            color: Color(0xFF009900),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),

                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),

                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black, width: 2),
                ),

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: Colors.lightBlueAccent,
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => const FlLine(
                    color: Colors.lightBlueAccent,
                    strokeWidth: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
