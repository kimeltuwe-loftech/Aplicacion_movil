import 'package:flutter/material.dart';

class ConnectingHelp extends StatelessWidget {
  const ConnectingHelp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.question_mark_rounded, size: 25),
            SizedBox(width: 10),
            Text('Connection help', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Text('test'),
    );
  }
}
