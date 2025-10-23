import 'package:flutter/material.dart';
import 'sensores.dart';
import 'ficha.dart';
void main() =>  runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        backgroundColor: const Color(0xFFD0EAFF),
        body: ListView(
          children: [
            Center ( child: 
                  Container(
                    width: 240,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(250),
                        bottomRight: Radius.circular(250),
                      )
                    ),
                    child: Center(
                      child: Image.asset(
                    'assets/logo_principal.png', 
                    width: 120, 
                    height: 120,
                  ),
                      )
                  ),
                  ),          
            const SizedBox(height: 50), 
            Builder(
                builder: (context) => Row(
                mainAxisAlignment: MainAxisAlignment.center,    
                children: [
                ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Sensores()),
                  );
                },                
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009900), 
                  foregroundColor: Colors.white,
                  padding:const EdgeInsets.symmetric(horizontal: 75, vertical: 20),
                  textStyle:const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text('Sensores'),
                ),
                ],
                ),
                ),
                const SizedBox(height: 30), // <-- Espacio de 10 píxeles entre los botones
                Image.asset(
                  'assets/sensores_principal.png', 
                  width: 150, 
                  height: 150,
                ),
                const SizedBox(height: 30),
                 Builder(
                  builder: (context) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: null,
                        // onPressed: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => const FichasPlantas()),
                        //   );
                        // },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF009900),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          
                        ),
                        child: const Text('Fichas de Plantas'),
                        
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Image.asset(
                  'assets/ficha.png', 
                  width: 120, 
                  height: 120,
                ),
          ],
        ),
      ),
    );
  }
}
