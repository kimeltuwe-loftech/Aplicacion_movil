import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:udp/udp.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'l10n/app_localizations.dart';
import 'globals/mapuche_facts.dart';
// import 'loading_icon.dart';

import 'sensor_graph.dart';
import 'globals/sensor_definitions.dart';
import 'connecting_help.dart';

class Sensores extends StatefulWidget {
  const Sensores({super.key});

  @override
  State<Sensores> createState() => _SensoresState();
}

class _SensoresState extends State<Sensores> {
  Map<String, List<FlSpot>> _valoresPorSensor = {};
  final loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset('assets/sensores_principal.png', width: 40, height: 40),
            SizedBox(width: 20),
            Text(
              AppLocalizations.of(context)!.sensors,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFD0EAFF),
      body: loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SpinningSvgLoader(),
                  SpinKitCubeGrid(color: const Color(0xFF009900), size: 50.0),
                  SizedBox(height: 10),
                  Text(
                    'Sabias que ...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(getRandomMapucheFact(), textAlign: TextAlign.center),
                  SizedBox(height: 30),
                  Builder(
                    builder: (context) => ElevatedButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnectingHelp(),
                          ),
                        ),
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.question_mark_rounded),
                          Text('No se puede conectar?'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              children: [
                const SizedBox(height: 30),
                Center(
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    children: SensorType.values.map((sensorType) {
                      final sensorInfo = getSensorInfo(context);
                      final info = sensorInfo[sensorType];
                      if (info == null) return SizedBox();
                      return Builder(
                        builder: (BuildContext context) => ElevatedButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SensorGraph(sensorType: sensorType),
                              ),
                            ),
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(info.icon, size: 100, color: info.color),
                              const SizedBox(height: 8),
                              Text(
                                info.label,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.circle, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text(
                                    'Conectado',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
    );
  }
}
