import 'package:flutter/material.dart';
import '../../globals/game_rounds.dart';
import '../util/sentence_input.dart';

class NewLetter extends StatelessWidget {
  final VoidCallback onBackToHomeScreen;
  final SensorRound sensorRound;
  final List<Letter> letters;

  const NewLetter({
    super.key,
    required this.onBackToHomeScreen,
    required this.sensorRound,
    required this.letters,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '🎉 ¡Felicitaciones, has encontrado nuevas letras! 🎉',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: [
              ...letters.map((Letter letter) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        letter.key,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (letter.value + 1).toString(),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }),
            ],
          ),

          SizedBox(height: 30),
          ElevatedButton(
            onPressed: onBackToHomeScreen,
            child: Text('De vuelta a Home'),
          ),
        ],
      ),
    );
  }
}
