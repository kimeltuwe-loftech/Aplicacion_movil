import 'package:flutter/material.dart';
import '../../util/game_storage.dart';
import '../rounds_list.dart';

class SelectTeam extends StatefulWidget {
  final int amountOfTeams;
  final String sentence;

  const SelectTeam({
    super.key,
    required this.amountOfTeams,
    required this.sentence,
  });

  @override
  State<SelectTeam> createState() => _SelectTeamState();
}

class _SelectTeamState extends State<SelectTeam> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedTeamNumber;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) return;

    final selectedTeam = _selectedTeamNumber!;

    await Storage.setGameInfo(
      selectedTeam,
      widget.amountOfTeams,
      widget.sentence,
    );

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RoundsList(
          teamNumber: selectedTeam,
          amountOfTeams: widget.amountOfTeams,
          sentence: widget.sentence,
        ),
      ),
    );
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
            Text('Game', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFD0EAFF),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Seleccionar un equipo',
                      prefixIcon: Icon(Icons.group),
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                    items: List.generate(
                      widget.amountOfTeams,
                      (index) => DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text('Equipo ${index + 1}'),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedTeamNumber = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor seleccionar un equipo';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),
                  // Text('Sentence: ${widget.sentence}'),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onContinue,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Continuar', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_right_alt, size: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
