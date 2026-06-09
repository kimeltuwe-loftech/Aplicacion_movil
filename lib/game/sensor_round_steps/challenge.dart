import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals/game_rounds.dart';
import '../components/sensor_value_display.dart';
import '../../util/udp.dart';

class Challenge extends StatefulWidget {
  final VoidCallback onNext;
  final SensorRound sensorRound;
  final double? capturedValue;

  const Challenge({
    super.key,
    required this.onNext,
    required this.sensorRound,
    required this.capturedValue,
  });

  @override
  State<Challenge> createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  bool _reached = false;

  @override
  Widget build(BuildContext context) {
    final receiver = context.watch<UdpSensorReceiver>();

    final double capturedValue = widget.capturedValue ?? 0.0;
    final double targetValue =
        capturedValue *
        (1 + widget.sensorRound.challengePercentageChange / 100);

    final double? currentValue = receiver.latestValueOf(
      widget.sensorRound.sensorType,
    );

    if (!_reached && currentValue != null) {
      final bool justReached = targetValue >= capturedValue
          ? currentValue >= targetValue
          : currentValue <= targetValue;
      if (justReached) {
        _reached = true; // 🔒 latch
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text(
              _reached ? '✅ Desafío completado ✅' : '⭐ Desafío ⭐',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(
              'Valor actual: ${capturedValue.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Valor objectivo: ${targetValue.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            SensorValueDisplay(sensorType: widget.sensorRound.sensorType),
            // if (_reached)
            ElevatedButton(onPressed: widget.onNext, child: const Text('Continuar')),
          ],
        ),
      ),
    );
  }
}
