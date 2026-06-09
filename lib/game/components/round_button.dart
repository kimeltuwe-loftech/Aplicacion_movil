import 'package:flutter/material.dart';
import '../../globals/game_rounds.dart';
import '../sensor_round.dart';
import '../util/sentence_input.dart';

class RoundButton extends StatelessWidget {
  final SensorRound round;
  final List<Letter> letters;
  final int index;
  final int currentRound;
  final VoidCallback onRoundCompleted;

  const RoundButton({
    super.key,
    required this.round,
    required this.letters,
    required this.index,
    required this.currentRound,
    required this.onRoundCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDone = currentRound > index;
    final bool isNext = currentRound == index;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ElevatedButton(
          onPressed: (isDone || isNext)
              ? () async {
                  final updated = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SensorRoundWidget(
                        sensorRound: round,
                        letters: letters,
                        roundIndex: index,
                      ),
                    ),
                  );

                  if (updated == true) {
                    onRoundCompleted(); // 🔁 notify parent
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDone || isNext ? Colors.white : Colors.grey,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(
                color: Colors.green,
                width: isDone ? 2 : 0,
              ),
            ),
          ),
          child: Center(
            child: Text(
              isDone
                  ? round.title
                  : isNext
                      ? 'Descrubrir siguiente nivel 🔓'
                      : '???',
            ),
          ),
        ),

        // ✅ Green check on edge when DONE
        if (isDone)
          const Positioned(
            right: -6,
            bottom: -6,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.green,
              child: Icon(Icons.check, size: 18, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
