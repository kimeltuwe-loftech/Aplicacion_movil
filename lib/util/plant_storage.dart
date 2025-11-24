import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PlantStorage {
  static const String _key = 'fichas_plantas';

  /// Load all plants
  static Future<List<Map<String, dynamic>>> loadPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data == null) return [];

    return (json.decode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  /// Save entire list
  static Future<void> savePlants(List<Map<String, dynamic>> plants) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(plants));
  }

  /// Add a new plant
  static Future<void> addPlant(Map<String, dynamic> plant) async {
    final plants = await loadPlants();
    plants.add(plant);
    await savePlants(plants);
  }

  /// Delete a plant by index
  static Future<void> deletePlant(int index) async {
    final plants = await loadPlants();
    if (index < plants.length) {
      plants.removeAt(index);
      await savePlants(plants);
    }
  }
}
