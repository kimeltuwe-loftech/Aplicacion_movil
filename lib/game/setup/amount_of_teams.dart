import 'package:flutter/material.dart';
import 'select_team.dart';

class AmountOfTeams extends StatefulWidget {
  const AmountOfTeams({super.key});

  @override
  State<AmountOfTeams> createState() => _AmountOfTeamsState();
}

class _AmountOfTeamsState extends State<AmountOfTeams> {
  final _formKey = GlobalKey<FormState>();
  int? _amountOfTeams;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) return;

    final amountOfTeams = _amountOfTeams!;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectTeam(
          amountOfTeams: amountOfTeams,
          sentence: 'Aymara is cool',
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
                      labelText: 'Cantidad de equipos',
                      prefixIcon: Icon(Icons.group),
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                    items: List.generate(
                      6,
                      (index) => DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text('${index + 1}'),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _amountOfTeams = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor seleccionar una cantidad de equipos';
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
