import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals/game_rounds.dart';
import '../../util/udp.dart';
import '../../globals/sensor_definitions.dart';

class RiddleStep extends StatefulWidget {
  final void Function(double? capturedValue) onNext;
  final SensorRound sensorRound;

  const RiddleStep({
    super.key,
    required this.onNext,
    required this.sensorRound,
  });

  @override
  State<RiddleStep> createState() => _RiddleStepState();
}

class _RiddleStepState extends State<RiddleStep> {
  bool _isConnected = false;

  @override
  Widget build(BuildContext context) {
    final receiver = context.read<UdpSensorReceiver>();
    final SensorType sensorType = widget.sensorRound.sensorType;

    return ChangeNotifierProvider<SensorConnectionNotifier>(
      create: (_) => SensorConnectionNotifier(receiver, sensorType: sensorType),
      child: Consumer<SensorConnectionNotifier>(
        builder: (context, conn, _) {
          final double? capturedValue = receiver.latestValueOf(sensorType);

          // 🔒 Latch connection once true
          if (conn.isConnected && !_isConnected) {
            _isConnected = true;
          }

          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text('Acertijo:', style: TextStyle(fontSize: 25)),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    widget.sensorRound.riddle,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _isConnected ? 'Sensor contectado ✅' : 'Esperando el sensor...',
                ),
                const SizedBox(height: 20),

                // if (_isConnected)
                ElevatedButton(
                  onPressed: () => widget.onNext(capturedValue),
                  child: const Text('Continuar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
