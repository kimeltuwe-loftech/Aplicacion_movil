import 'package:flutter/material.dart';
import 'add.dart';
import 'view.dart';
import '../util/plant_storage.dart';

class FichasPlantas extends StatefulWidget {
  const FichasPlantas({super.key});

  @override
  State<FichasPlantas> createState() => _FichasPlantasState();
}

class _FichasPlantasState extends State<FichasPlantas> {
  List<Map<String, dynamic>> _fichas = [];

  @override
  void initState() {
    super.initState();
    _cargarFichas();
  }

  Future<void> _cargarFichas() async {
    final plants = await PlantStorage.loadPlants();
    setState(() {
      _fichas = plants;
    });
  }

  Future<void> _verFichaDetalle(Map<String, dynamic> ficha, int index) async {
    final deleted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FichaDetalle(ficha: ficha, index: index),
      ),
    );

    if (deleted == true) {
      _cargarFichas(); // reload list from storage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset('assets/ficha.png', width: 40, height: 40),
            SizedBox(width: 20),
            Text(
              'Fichas de Plantas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFD0EAFF),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () async {
            final added = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AgregarFicha()),
            );

            if (added == true) {
              _cargarFichas(); // reload from SharedPreferences
            }
          },
          child: Icon(Icons.add),
        ),
      ),
      body: ListView(
        physics: ScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 20,
          bottom: 100,
        ),
        children: _fichas.asMap().entries.map((entry) {
          final index = entry.key;
          final ficha = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 15), // spacing between items
            child: ElevatedButton(
              onPressed: () => _verFichaDetalle(ficha, index),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/plant_example.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover, // important
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ficha['nombre'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        ficha['descripcion'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        ficha['usos'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
