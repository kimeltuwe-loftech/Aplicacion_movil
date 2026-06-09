import 'package:flutter/material.dart';
import '../globals/game_rounds.dart';
import 'sensor_round_steps/riddle.dart';
import 'sensor_round_steps/video.dart';
import 'sensor_round_steps/challenge.dart';
import 'sensor_round_steps/new_letter.dart';
import 'sensor_round_steps/quiz.dart';
import '../util/game_storage.dart';
import '../connection_gate.dart';
import 'util/sentence_input.dart';

class SensorRoundWidget extends StatefulWidget {
  final SensorRound sensorRound;
  final List<Letter> letters;
  final int roundIndex;

  const SensorRoundWidget({
    super.key,
    required this.sensorRound,
    required this.letters,
    required this.roundIndex,
  });

  @override
  State<SensorRoundWidget> createState() => _SensorRoundState();
}

class _SensorRoundState extends State<SensorRoundWidget> {
  int currentStep = 0;
  double? riddleCapturedValue;

  void next([double? value]) {
    if (value != null) riddleCapturedValue = value;
    setState(() => currentStep++);
  }

  void back() => setState(() => currentStep--);

  Future<void> backToHomeScreen() async {
    final currentRound = await Storage.getCurrentRound();
    await Storage.setCurrentRound(currentRound + 1);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      RiddleStep(onNext: next, sensorRound: widget.sensorRound),
      VideoScreen(onNext: next, sensorRound: widget.sensorRound),
      Challenge(
        onNext: next,
        sensorRound: widget.sensorRound,
        capturedValue: riddleCapturedValue,
      ),
      MultipleChoiceStep(
        onNext: next,
        question: '¿Qué mide un sensor de luz?',
        options: [
          'A. Qué tan caliente está el aire',
          'B. Cuánta luz llega al sensor',
          'C. Qué tan fuerte sopla el viento',
          'D. Qué tan húmedo está el suelo',
        ],
        correctIndex: 1,
      ),
      NewLetter(
        letters: widget.letters,
        onBackToHomeScreen: backToHomeScreen,
        sensorRound: widget.sensorRound,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: ConnectionGate(child: steps[currentStep]),
    );
  }
}
