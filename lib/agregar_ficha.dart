import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class AgregarFicha extends StatefulWidget {
  const AgregarFicha({super.key});

  @override
  State<AgregarFicha> createState() => _AgregarFichaState();
}

class _AgregarFichaState extends State<AgregarFicha> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _usosController = TextEditingController();
  List<Map<String, dynamic>> _fichas = [];
  String? _imagePath;

  void _agregarFicha() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _fichas.add({
          'nombre': _nombreController.text,
          'descripcion': _descripcionController.text,
          'usos': _usosController.text,
          // 'imagen': _imagePath,
        });
        _nombreController.clear();
        _descripcionController.clear();
        _usosController.clear();
        // _imagePath = null;
      });
      // _guardarFichas();
    }
  }

  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0EAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(width: 20),
            Text(
              'Agregar ficha',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de la planta',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.6),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese un nombre' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    prefixIcon: Icon(Icons.edit_document),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.6),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese una descripción' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _usosController,
                  decoration: InputDecoration(
                    labelText: 'Usos',
                    prefixIcon: Icon(Icons.construction),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.6),
                  ),
                  maxLines: 4,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingrese los usos' : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _tomarFoto,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color(0xFF009900),
                        foregroundColor: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add_a_photo),
                          SizedBox(width: 5),
                          Text('Tomar foto'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    _imagePath != null
                        ? Image.file(File(_imagePath!), width: 50, height: 50)
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _agregarFicha,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color(0xFF009900),
                      foregroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 24),
                        SizedBox(width: 5),
                        Text('Agregar Ficha', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
