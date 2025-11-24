import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add.dart';
import 'view.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('fichas_plantas');
    if (data != null) {
      setState(() {
        _fichas = (json.decode(data) as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      });
    }
  }

  void _eliminarFicha(int index) {
    setState(() {
      _fichas.removeAt(index);
    });
  }

  void _verFichaDetalle(Map<String, dynamic> ficha) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FichaDetalle(ficha: ficha)),
    );
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
        children: _fichas.map((ficha) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15), // spacing between items
            child: ElevatedButton(
              onPressed: () => _verFichaDetalle(ficha),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.all(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/plant_example.jpg', width: 80),
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
