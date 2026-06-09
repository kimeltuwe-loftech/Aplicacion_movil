import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'util/settings_service.dart';
import 'main.dart';
import 'ayudar.dart';

class Configuracion extends StatefulWidget {
  const Configuracion({super.key});

  @override
  State<Configuracion> createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion> {
  @override
  Widget build(BuildContext context) {
    // Obtenemos el servicio
    final settings = Provider.of<SettingsService>(context);
    
    // Colores
    const backgroundColor = Color(0xFFD0EAFF);
    const selectedColor = Color(0xFFD0EAFF);
    const unselectedColor = Colors.white;
    const greyIconColor = Color(0xFF5F6368);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          child: Stack(
            children: [
              Column(
                children: [
                  // 1. HEADER SUPERIOR
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD0EAFF),
                      border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.home, size: 40, color: greyIconColor),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const MyApp()),
                              (route) => false,
                            );
                          },
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),

                  // 2. TÍTULO "CONFIGURACIONES"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 30, color: greyIconColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            "CONFIGURACIONES",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              // Hacemos que el título sea un poco más grande que el texto base (+2)
                              fontSize: settings.fontSize + 2,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),

                  // 3. OPCIONES
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          // --- SECCIÓN: TAMAÑO DE LETRA ---
                          Text(
                            "TAMAÑO DE LETRA",
                            style: TextStyle(
                              fontSize: settings.fontSize, // ¡Tamaño dinámico!
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // CAMBIO: Opciones 16, 18, 20, 22
                              _buildCircleOption(16, settings, selectedColor, unselectedColor),
                              _buildCircleOption(18, settings, selectedColor, unselectedColor),
                              _buildCircleOption(20, settings, selectedColor, unselectedColor),
                              _buildCircleOption(22, settings, selectedColor, unselectedColor),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // --- SECCIÓN: IDIOMA ---
                          Text(
                            "LENGUAJE",
                            style: TextStyle(
                              fontSize: settings.fontSize, // ¡Tamaño dinámico!
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildPillOptionLanguage("Mapuzungun", "map", settings, selectedColor, unselectedColor),
                              const SizedBox(width: 10),
                              _buildPillOptionLanguage("Aymara", "ay", settings, selectedColor, unselectedColor),
                              const SizedBox(width: 10),
                              _buildPillOptionLanguage("Español", "es", settings, selectedColor, unselectedColor),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ICONO AYUDA
              Positioned(
                bottom: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.help),
                  iconSize: 50,
                  color: greyIconColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Ayudar()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  // Botón Circular (16, 18, 20, 22)
  Widget _buildCircleOption(int value, SettingsService settings, Color selectedColor, Color unselectedColor) {
    final isSelected = settings.fontSize == value.toDouble();
    
    return GestureDetector(
      onTap: () {
        settings.setFontSize(value.toDouble());
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? selectedColor : unselectedColor,
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        child: Center(
          child: Text(
            value.toString(),
            // El número dentro del círculo también cambia de tamaño
            style: TextStyle(
              fontSize: settings.fontSize * 0.9, // Un pelín más chico para que quepa en el círculo
              fontWeight: FontWeight.bold, 
              color: Colors.black
            ),
          ),
        ),
      ),
    );
  }

  // Botón Píldora (Idioma)
  Widget _buildPillOptionLanguage(
    String label, 
    String value, 
    SettingsService settings, 
    Color selectedColor, 
    Color unselectedColor
  ) {
    final isSelected = settings.languageCode == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          settings.setLanguage(value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : unselectedColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              // El texto del idioma cambia según la configuración
              style: TextStyle(
                fontSize: settings.fontSize * 0.8, // Factor 0.8 para evitar que se salga del botón si la letra es muy grande
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
