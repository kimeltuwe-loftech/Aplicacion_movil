import 'sensor_definitions.dart';

const int amountOfRounds = 3;

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class SensorRound {
  final String title;
  final String riddle;
  final String videoUrl;
  final SensorType sensorType;
  final String challengeDescription;
  final int challengePercentageChange;

  const SensorRound({
    required this.title,
    required this.riddle,
    required this.videoUrl,
    required this.sensorType,
    required this.challengeDescription,
    required this.challengePercentageChange,
  });
}

const List<SensorRound> sensorRounds = [
  SensorRound(
    title: 'Luz',
    riddle: 'Aumento mi valor cuando hay luz',
    videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    sensorType: SensorType.luminosidad,
    challengeDescription: 'Busca un lugar donde la luz sea alta',
    challengePercentageChange: 10,
  ),
  SensorRound(
    title: 'Humedad del suelo',
    riddle: 'Aumento mi valor cuando llueve',
    videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    sensorType: SensorType.humedadSuelo,
    challengeDescription: 'Busca un lugar donde la humedad sea mayor al 50%',
    challengePercentageChange: 10,
  ),
  SensorRound(
    title: 'Temperatura',
    riddle: 'Aumento mi valor cuando hace calor',
    videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    sensorType: SensorType.temperaturaAmbiente,
    challengeDescription:
        'Busca un lugar donde la temperatura sea mayor a 30 grados Celsius',
    challengePercentageChange: 10,
  ),
];
