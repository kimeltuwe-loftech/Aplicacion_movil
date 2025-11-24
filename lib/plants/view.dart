import 'dart:io';
import 'package:flutter/material.dart';
import '../util/plant_storage.dart';

class FichaDetalle extends StatelessWidget {
  final Map<String, dynamic> ficha;
  final int index;
  const FichaDetalle({super.key, required this.ficha, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ficha['nombre'] ?? 'Detalle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 30),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Eliminar planta'),
                  content: const Text(
                    '¿Seguro que quieres eliminar esta planta?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await PlantStorage.deletePlant(index);
                if (!context.mounted) return;
                Navigator.of(context).pop(true);
              }
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(File(ficha['imagen']), fit: BoxFit.cover),
                ),
              ),
            ),
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
