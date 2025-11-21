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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        children: [
          SizedBox(height: 20),
          Text('Option 1: Connecting via QR code (easiest)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('1. Open the camera app'),
          Text('2. Attach the battery to the prototype'),
          Text('3. Scan the QR code with the phone, to connect to WiFi network'),
          Text('4. Go back to the app, and you are done!'),
          SizedBox(height: 20),
          Text('Option 2: Connecting manually', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('1. Connect the battery to the prototype'),
          Text('2. On the prototype display, look at the WiFi network name and password'),
          Text('3. On the phone, open WiFi settings and connect to the network'),
        ]
      )
    );
  }
}
