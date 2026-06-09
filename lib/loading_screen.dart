import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'connecting_help.dart';
import 'sensors/loading_icon.dart';
import 'globals/spanish_facts.dart';
import 'globals/aymara_facts.dart';
import 'globals/mapuche_facts.dart';
import 'util/settings_service.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    final languageCode = settings.languageCode;

    final String assetName;
    final String factText;

    switch (languageCode) {
      case 'ay':
        assetName = 'assets/aymara_symbol_loading.png';
        factText = getRandomAymaraFact();
        break;
      case 'map':
        assetName = 'assets/mapuche_symbol_loading.png';
        factText = getRandomMapucheFact();
        break;
      default:
        assetName = 'assets/symbol_loading.png';
        factText = getRandomSpanishFact();
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinningLoaderIcon(
              assetName: assetName,
              size: 64,
            ),
            const SizedBox(height: 10),
            Text(
              'Sabías que ...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 6),
            Text(factText, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Image.asset('assets/mascotte.png', width: 80),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ConnectingHelp()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.question_mark_rounded),
                  SizedBox(width: 6),
                  Text('¿No se puede conectar?'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
