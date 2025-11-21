import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'agregar_ficha.dart';

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

  Future<void> _guardarFichas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fichas_plantas', json.encode(_fichas));
  }

  void _eliminarFicha(int index) {
    setState(() {
      _fichas.removeAt(index);
    });
    _guardarFichas();
  }

  void _editarFicha(int index) {
    // setState(() {
    //   _editIndex = index;
    //   _nombreController.text = _fichas[index]['nombre'];
    //   _descripcionController.text = _fichas[index]['descripcion'];
    //   _usosController.text = _fichas[index]['usos'];
    //   _imagePath = _fichas[index]['imagen'];
    // });
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AgregarFicha()),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Fichas guardadas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _fichas.length,
              itemBuilder: (context, i) {
                final ficha = _fichas[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    onTap: () => _verFichaDetalle(ficha),
                    leading: ficha['imagen'] != null
                        ? Image.file(
                            File(ficha['imagen']),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.local_florist),
                    title: Text(ficha['nombre']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Descripción: ${ficha['descripcion']}'),
                        Text('Usos: ${ficha['usos']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editarFicha(i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _eliminarFicha(i),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Nueva pantalla para ver la ficha en grande
class FichaDetalle extends StatelessWidget {
  final Map<String, dynamic> ficha;
  const FichaDetalle({super.key, required this.ficha});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ficha['nombre'] ?? 'Detalle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ficha['imagen'] != null
                ? Image.file(
                    File(ficha['imagen']),
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.local_florist, size: 100),
            const SizedBox(height: 20),
            Text(
              'Nombre: ${ficha['nombre']}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Descripción: ${ficha['descripcion']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Usos: ${ficha['usos']}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
