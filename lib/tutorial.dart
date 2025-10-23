import 'package:flutter/material.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0EAFF),
      body: ListView(
        children: [
          const Text("...."),
          const SizedBox(height: 50),
          Builder(builder: (context) => Row (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Tutorial()),
                  );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009900), 
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 20),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('NADA'),
            ),
          ],)          
          )
          ],
      ),
    );
  }
}