import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals/game_rounds.dart';
import '../util/game_storage.dart';
import '../connection_gate.dart';
import 'components/round_button.dart';
import 'util/sentence_input.dart';

class RoundsList extends StatefulWidget {
  final int teamNumber;
  final int amountOfTeams;
  final String sentence;

  const RoundsList({
    super.key,
    required this.teamNumber,
    required this.amountOfTeams,
    required this.sentence,
  });

  @override
  State<RoundsList> createState() => _RoundsListState();
}

class _RoundsListState extends State<RoundsList> {
  late Future<int> _currentRoundFuture;
  late List<RoundLetters> roundsLetters;

  @override
  void initState() {
    super.initState();
    _currentRoundFuture = Storage.getCurrentRound();
    final List<TeamLetters> teamLetters = getLettersToGuess(
      widget.sentence,
      3,
      widget.amountOfTeams,
    );
    roundsLetters = teamLetters[widget.teamNumber - 1].teamRounds;
  }

  Future<void> _clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.popUntil(context, (route) => route.isFirst);
  }

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
              'Game',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFD0EAFF),
      body: ConnectionGate(
        child: FutureBuilder<int>(
          future: () async {
            final currentRound = await _currentRoundFuture;
            return currentRound;
          }(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('No data'));
            }

            final currentRound = snapshot.data ?? 0;

            return ListView(
              children: [
                const SizedBox(height: 35),
                Center(
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      spacing: 15,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 15),
                        ...sensorRounds.asMap().entries.map((entry) {
                          final index = entry.key;
                          final round = entry.value;
                          return RoundButton(
                            round: round,
                            letters: roundsLetters[index].letters,
                            index: index,
                            currentRound: currentRound,
                            onRoundCompleted: () {
                              setState(() {
                                _currentRoundFuture = Storage.getCurrentRound();
                              });
                            },
                          );
                        }),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: _clearPreferences,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout),
                              SizedBox(width: 10),
                              Text('Cerrar sesión'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'Equipo ${widget.teamNumber} de ${widget.amountOfTeams}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
