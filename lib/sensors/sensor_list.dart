import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'sensor_graph.dart';
import '../globals/sensor_definitions.dart';
import 'package:provider/provider.dart';
import '../util/udp.dart';
import '../connection_gate.dart';

// Importamos las pantallas a las que vamos a navegar
import '../configuracion.dart'; 
import '../ayudar.dart';

class Sensores extends StatefulWidget {
  const Sensores({super.key});

  @override
  State<Sensores> createState() => _SensoresState();
}

class _SensoresState extends State<Sensores> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final prototypeConnection = context.watch<UdpSensorReceiver>();
    final sensorInfo = getSensorInfo(context);
    final loc = AppLocalizations.of(context);

    // Filtrar los sensores por la barra de búsqueda
    final filteredSensors = SensorType.values.where((sensor) {
      final info = sensorInfo[sensor];
      if (info == null) return false;
      return info.label.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFD0EAFF), 
      
      // BARRA SUPERIOR
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0EAFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black54, size: 35),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54, size: 35),
            onPressed: () {
              // NAVEGACIÓN A CONFIGURACIÓN
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Configuracion()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // LÍNEA SEPARADORA NEGRA (Justo debajo de la barra superior)
          const Divider(
            color: Colors.black87, // Color de la línea
            thickness: 1.5,        // Grosor de la línea
            height: 0,             // Altura 0 para que quede pegada a la barra
          ),

          // TÍTULO SECUNDARIO Y FLECHA DE RETROCESO
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 15),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    loc?.sensors.toUpperCase() ?? 'SENSORES',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Espacio en blanco para centrar el texto
              ],
            ),
          ),

          // BARRA DE BÚSQUEDA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                prefixIcon: const Icon(Icons.search, color: Colors.green, size: 28),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // GRID DE TARJETAS DE SENSORES
          Expanded(
            child: ConnectionGate(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.85,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 80),
                children: filteredSensors.map((sensorType) {
                  final info = sensorInfo[sensorType]!;
                  bool isConnected = prototypeConnection.isSensorConnected(sensorType);
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SensorGraph(sensorType: sensorType)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9BD4FF), 
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(color: Colors.black12),
                      ),
                      elevation: 2,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(info.icon, size: 60, color: info.color),
                        const SizedBox(height: 12),
                        Text(
                          info.label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isConnected ? Icons.circle : Icons.circle_outlined,
                              color: isConnected ? Colors.green[700] : Colors.red[700],
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isConnected ? 'Conectado' : 'Desconectado',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isConnected ? Colors.green[800] : Colors.red[800],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      
      // BOTÓN FLOTANTE DE AYUDA (Rediseñado y con navegación)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // NAVEGACIÓN A AYUDA
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Ayudar()), // <- Asegúrate de que la clase se llame Ayudar()
          );
        },
        backgroundColor: Colors.transparent, // Fondo transparente para que solo se vea el ícono
        elevation: 0,                        // Sin sombra cuadrada
        child: const Icon(
          Icons.help, // Este es el círculo gris con el "?" blanco adentro
          size: 60,
          color: Color(0xFF6E6E6E), // Un gris oscuro como el de la ficha de plantas
        ),
      ),
    );
  }
}
