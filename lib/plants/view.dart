import 'dart:io';
import 'package:flutter/material.dart';

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