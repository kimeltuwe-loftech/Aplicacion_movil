import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'globals/mapuche_facts.dart';
import 'sensor_graph.dart';
import 'globals/sensor_definitions.dart';
import 'connecting_help.dart';
import 'package:provider/provider.dart';
import 'util/udp.dart';
import 'loading_icon.dart';

class Sensores extends StatefulWidget {
  const Sensores({super.key});

  @override
  State<Sensores> createState() => _SensoresState();
}

class _SensoresState extends State<Sensores> {
  @override
  Widget build(BuildContext context) {
    final prototypeConnection = context.watch<PrototypeConnection>();
    final loading = prototypeConnection.isStale;
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
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinningLoaderIcon(assetName: 'assets/mapuche_symbol_loading.png', size: 64),
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
          : GridView.count(
              // shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
              physics: ScrollPhysics(),
              crossAxisSpacing: 10,
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 20,
                bottom: 100,
              ),
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
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              prototypeConnection.isSensorConnected(sensorType)
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                              color:
                                  prototypeConnection.isSensorConnected(
                                    sensorType,
                                  )
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text(
                              prototypeConnection.isSensorConnected(sensorType)
                                  ? 'Conectado'
                                  : 'Desconectado',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
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
    );
  }
}
