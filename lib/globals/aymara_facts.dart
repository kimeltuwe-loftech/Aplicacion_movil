import 'dart:math';

// Lista de curiosidades Aymara
final List<String> _aymaraFacts = [
  "El saludo tradicional aymara es 'Kamisaraki' (¿Cómo estás?)",
  "La Wiphala es el símbolo de los pueblos andinos; sus 7 colores representan la igualdad y la armonía.",
  "Los aymaras se encuentran en Bolivia, Perú y el norte grande de Chile.",
  "El Año Nuevo Aymara se celebra cada 21 de junio.",
  "Los aymaras rinden culto a deidades como al sol, la lluvia, al viento, a al tierra y espiritus de los cerros.",
];

// Función pública para obtener una frase al azar
String getRandomAymaraFact() {
  return _aymaraFacts[Random().nextInt(_aymaraFacts.length)];
}
