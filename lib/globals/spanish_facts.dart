import 'dart:math';

// Lista combinada de curiosidades (Mapuche + Aymara)
final List<String> _spanishFacts = [
  // --- Mapuche ---
  "El Mapudüngun es la lengua de la tierra.",
  "El cultrún representa la cosmovisión mapuche y sus cuatro puntos cardinales.",
  "La ruca es la vivienda tradicional mapuche, hecha de materiales naturales.",
  "El We Tripantu es la celebración del año nuevo mapuche en el solsticio de invierno.",
  "El canelo (Foye) es el árbol sagrado del pueblo mapuche.",
  "La platería mapuche (Rütrafe) tiene un profundo significado espiritual y social.",
  "El Palin es un deporte ancestral mapuche similar al hockey.",
  
  // --- Aymara ---
  "El saludo tradicional aymara es 'Kamisaraki' (¿Cómo estás?)",
  "La Wiphala es el símbolo de los pueblos andinos; sus 7 colores representan la igualdad y la armonía.",
  "Los aymaras se encuentran en Bolivia, Perú y el norte grande de Chile.",
  "El Año Nuevo Aymara se celebra cada 21 de junio.",
  "Los aymaras rinden culto a deidades como al sol, la lluvia, al viento, a al tierra y espiritus de los cerros.",
];

// Función para obtener una frase al azar de la lista mixta
String getRandomSpanishFact() {
  return _spanishFacts[Random().nextInt(_spanishFacts.length)];
}
