import 'package:flutter/material.dart';

class SettingsService extends ChangeNotifier {
  // 1. Variables de estado
  double _fontSize = 18.0;
  bool _isDarkMode = false; // Nuevo: por defecto es modo claro

  // 2. Getters (para leer los datos)
  double get fontSize => _fontSize;
  bool get isDarkMode => _isDarkMode;

  // Agregamos manejo de idioma
  String _languageCode = 'es'; // idioma por defecto
  String get languageCode => _languageCode;

  // 3. Setters (para cambiar los datos)
  void setFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners(); // Aviso a toda la app para cambiar el tema
  }

  void setLanguage(String code) {
    _languageCode = code;
    notifyListeners(); // Aviso a la app para actualizar la localización
  }
}
