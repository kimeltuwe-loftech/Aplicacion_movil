import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'util/udp.dart';
import 'globals/sensor_definitions.dart';

class SensorGraph extends StatefulWidget {
  final SensorType sensorType;
  SensorGraph({
    super.key,
    required this.sensorType,
  });

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
  Widget build(BuildContext context) {
    final PrototypeConnection conn = context.watch<PrototypeConnection>();
    final samples = conn.getSensorValues(widget.sensorType);

    // Convert samples (with DateTime) to FlSpot using seconds since first sample
    List<FlSpot> spots;
    DateTime? baseTime;

    if (samples.isEmpty) {
      spots = [const FlSpot(0, 0)];
      baseTime = null;
    } else {
      baseTime = samples.first.timestamp;
      spots = samples.map((s) {
        final seconds =
            s.timestamp.difference(baseTime!).inMilliseconds / 1000.0;
        return FlSpot(seconds, s.value);
      }).toList();
    }

    final sensorInfo = getSensorInfo(context);
    final info = sensorInfo[widget.sensorType]!;

    final double maxX =
        spots.isNotEmpty ? (spots.last.x > 0 ? spots.last.x : 59) : 59;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(info.icon, color: info.color, size: 40),
            const SizedBox(width: 20),
            Text(info.label, style: const TextStyle(fontWeight: FontWeight.bold)),
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
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: maxX,
                minY: info.limites[0],
                maxY: info.limites[1],
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    preventCurveOverShooting: true,
                    color: info.color,
                    barWidth: 2,
                    dotData: FlDotData(show: true),
                  ),
                ],
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
                      reservedSize: 40,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        if (baseTime == null) {
                          return const SizedBox.shrink();
                        }
                        final dt = baseTime!.add(
                          Duration(seconds: value.toInt()),
                        );
                        final hh =
                            dt.hour.toString().padLeft(2, '0');
                        final mm =
                            dt.minute.toString().padLeft(2, '0');
                        final ss =
                            dt.second.toString().padLeft(2, '0');
                        return Text(
                          '$hh:$mm:$ss',
                          style: const TextStyle(
                            color: Color(0xFF009900),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        );
                      },
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
                      const FlLine(color: Colors.lightBlueAccent, strokeWidth: 1),
                  getDrawingVerticalLine: (value) =>
                      const FlLine(color: Colors.lightBlueAccent, strokeWidth: 1),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 16, height: 16, color: info.color),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
