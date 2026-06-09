import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PlantStorage {
  static const String _key = 'plants_data';

  // Cargar todas las plantas
  static Future<List<Map<String, dynamic>>> loadPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final String? plantsString = prefs.getString(_key);

    if (plantsString != null) {
      final List<dynamic> decodedList = jsonDecode(plantsString);
      return decodedList.map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  // Guardar la lista completa (Método privado auxiliar)
  static Future<void> _saveList(List<Map<String, dynamic>> plants) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(plants);
    await prefs.setString(_key, encodedList);
  }

  // Agregar una nueva planta
  static Future<void> addPlant(Map<String, dynamic> newPlant) async {
    final plants = await loadPlants();
    plants.add(newPlant);
    await _saveList(plants);
  }

  // Eliminar una planta por índice
  static Future<void> deletePlant(int index) async {
    final plants = await loadPlants();
    if (index >= 0 && index < plants.length) {
      plants.removeAt(index);
      await _saveList(plants);
    }
  }


  // Actualizar una planta existente
  static Future<void> updatePlant(int index, Map<String, dynamic> updatedPlant) async {
    final plants = await loadPlants();
    if (index >= 0 && index < plants.length) {
      plants[index] = updatedPlant; // Reemplazamos la ficha antigua por la nueva
      await _saveList(plants);
    }
  }
}
