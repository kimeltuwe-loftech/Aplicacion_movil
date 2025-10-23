import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:udp/udp.dart';


class Sensores extends StatefulWidget {
  const Sensores({super.key});

  @override
  State<Sensores> createState() => _SensoresState();
}

class _SensoresState extends State<Sensores> {
  Map<String, List<FlSpot>> _valoresPorSensor = {};
  final Map<String, Color> _colores = {
    'Temperatura ambiente': const Color.fromARGB(255, 244, 168, 54),
    'Humedad ambiente': Colors.blue,
    'Material particulado': Colors.green,
    'Luminosidad': const Color.fromARGB(255, 248, 245, 75),
    'Humedad suelo': Colors.deepPurpleAccent,
    'Lluvia': Colors.pink
  };
  final Map<String, List<double>> _limites = {
    'Temperatura ambiente': [0, 40],
    'Humedad ambiente': [0, 100],
    'Material particulado': [0, 1500],
    'Luminosidad': [0, 5000],
    'Humedad suelo': [0, 100],
    'Lluvia': [0, 100]
  };

  final Map<String, String> _unidades = {
    'Temperatura ambiente': "°C",
    'Humedad ambiente': "%HR",
    'Material particulado': "ppm",
    'Luminosidad': "lux",
    'Humedad suelo': "%H",
    'Lluvia': "%Lluvia" 
  };
  
  Set<String> _sensoresRecibidos = {};
  UDP? _receiver;

  @override
  void initState() {
    super.initState();
    _escucharUDP();
  }

  void _escucharUDP() async {
    _receiver = await UDP.bind(Endpoint.any(port: Port(12345)));
    _receiver!.asStream().listen((datagram) {
      if (datagram == null) return;

      final dataString = utf8.decode(datagram.data);
      final sensorData = json.decode(dataString) as List<dynamic>;

      for (var measurement in sensorData) {
        var type = measurement["type"];
        var rawValue = measurement["value"];
        
        double? value; 
        if (rawValue is num) {
          value = rawValue.toDouble(); 
        } else if (rawValue is String) {
          value = double.tryParse(rawValue); // Handle string representations like "25.5"
        }

        if (value != null) {
          setState(() {
            _sensoresRecibidos.add(type);
            _valoresPorSensor.putIfAbsent(type, () => []);
            _valoresPorSensor[type]!.add(FlSpot(DateTime.now().second.toDouble(), value!));
            if (_valoresPorSensor[type]!.length > 20) {
              _valoresPorSensor[type]!.removeAt(0);
            }
          });
        }
      }
      
    });
  }

  @override
  void dispose() {
    _receiver?.close();
    super.dispose();
  }

  // Método para mostrar todos los sensores y sus valores actuales
  String getSensoresActuales() {
    if (_valoresPorSensor.isEmpty) return 'Esperando datos...';
    return "Datos recibidos";
    // return _valoresPorSensor.entries
    //     .where((e) => e.value.isNotEmpty)
    //     .map((e) =>
    //         '${e.key[0].toUpperCase()}${e.key.substring(1)}: ${e.value.last.toStringAsFixed(2)}')
    //     .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sensores'), backgroundColor: const Color(0xFFD0EAFF)),
      backgroundColor: const Color(0xFFD0EAFF),
      body: ListView(
        children: [
          const SizedBox(height: 30),
          Text(
            getSensoresActuales(),
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 30),
          Center(
            child: Column(
              spacing: 10,
              children: _sensoresRecibidos.map(
                (tipo) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Gráfico de $tipo",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            width: 500,
                            child: LineChart(
                              LineChartData(
                                minX: 0,
                                maxX: 59,
                                // maxX: DateTime.now().second.toDouble(),
                                minY: _limites[tipo]![0],
                                maxY: _limites[tipo]![1],
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _valoresPorSensor[tipo]!,

                                        // .asMap()
                                        // .entries
                                        // .map((e) => FlSpot(e.key.toDouble(), e.value))
                                        // .toList(),
                                    isCurved: true,
                                    preventCurveOverShooting: true,
                                    color: _colores[tipo] ?? Colors.black,
                                    barWidth: 2,
                                    dotData: FlDotData(show: true),
                                  )
                                ],
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    axisNameWidget: Text(
                                      _unidades[tipo]!,
                                      style: const TextStyle(
                                          color: Color(0xFF009900),
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                    axisNameSize: 28,
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      // interval: 10,
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
                                    axisNameWidget: Text(
                                      "Tiempo",
                                      style: const TextStyle(
                                          color: Color(0xFF009900),
                                          fontWeight: FontWeight.bold,
                                        )
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
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 2),
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  // horizontalInterval: 10,
                                  verticalInterval: 5,
                                  drawVerticalLine: true,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: Colors.lightBlueAccent,
                                    strokeWidth: 1,
                                  ),
                                  getDrawingVerticalLine: (value) => FlLine(
                                    color: Colors.lightBlueAccent,
                                    strokeWidth: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Leyenda dinámica según sensores recibidos
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(width: 16, height: 16, color: _colores[tipo] ?? Colors.black),
                                    const SizedBox(width: 4),
                                    Text(tipo[0].toUpperCase() + tipo.substring(1)),
                                    const SizedBox(width: 16),
                                  ],
                                )
                              ]
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ).toList()
            ) 
            
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}