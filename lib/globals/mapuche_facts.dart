import 'dart:math';

final List<String> datosCuriososMapuche = [
  "Los Mapuche son el grupo indígena más numeroso de Chile y también viven en el suroeste de Argentina.",
  "Mapuche significa 'gente de la tierra' (mapu = tierra, che = gente).",
  "Su lengua tradicional es el mapudungun, aún hablada por muchas personas.",
  "Los Mapuche resistieron con éxito al Imperio Inca en el siglo XV.",
  "También resistieron la conquista española durante más de 300 años.",
  "Los colores de la bandera mapuche tienen significados simbólicos: verde para la tierra, azul para el universo y rojo para la fuerza.",
  "El kultrún, su tambor ceremonial, representa el universo dividido en cuatro partes.",
  "Los líderes tradicionales se llaman lonko, elegidos por su sabiduría y capacidad de mediación.",
  "Una machi es una líder espiritual y curandera en la comunidad.",
  "El año nuevo mapuche, We Tripantu, coincide con el solsticio de invierno en junio.",
  "La platería mapuche es muy valorada y simboliza protección e identidad.",
  "Sus viviendas tradicionales, llamadas rucas, se construyen con madera y paja.",
  "Los Mapuche desarrollaron una estrategia defensiva muy efectiva llamada 'malón', un ataque rápido a caballo.",
  "El caballo se volvió central en la cultura mapuche después de la llegada de los europeos.",
  "El mate es una bebida tradicional que suele compartirse en reuniones mapuche.",
  "El tejido mapuche es reconocido por sus complejos patrones geométricos.",
  "Tradicionalmente, la tierra no se veía como propiedad, sino como un espacio vivo compartido.",
  "La música mapuche incorpora instrumentos como la trutruka y la pifilka.",
  "Muchos apellidos mapuche tienen significados relacionados con la naturaleza, como 'Antilef' (flecha del sol).",
  "La cosmovisión mapuche incluye a los ngen, espíritus protectores de elementos naturales como ríos y bosques."
];

final Random _random = Random();

String getRandomMapucheFact() {
  return datosCuriososMapuche[_random.nextInt(datosCuriososMapuche.length)];
}