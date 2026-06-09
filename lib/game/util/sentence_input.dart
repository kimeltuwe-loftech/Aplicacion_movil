import 'dart:math';

class Letter {
  final String key;
  final int value;
  Letter(this.key, this.value);

  @override
  String toString() => 'Letter(character: $key, indexInSentence: $value)';
}

class RoundLetters {
  final int roundIndex;
  final List<Letter> letters;
  RoundLetters(this.roundIndex, this.letters);

  @override
  String toString() => 'TeamRound(roundIndex: $roundIndex, letters: $letters)';
}

class TeamLetters {
  final int teamIndex;
  final List<RoundLetters> teamRounds;
  TeamLetters(this.teamIndex, this.teamRounds);

  @override
  String toString() => 'Team(teamIndex: $teamIndex, teamRounds: $teamRounds)';
}

List<TeamLetters> getLettersToGuess(
  String sentence,
  int numberOfRounds,
  int amountOfTeams,
) {
  final filtered = sentence.replaceAll(' ', '');

  // Keep original indices, then shuffle them (so "value" can be original position)
  final indices = List<int>.generate(filtered.length, (i) => i);
  final random = Random(10293);
  indices.shuffle(random);

  final totalSlots = amountOfTeams * numberOfRounds;
  final lettersPerSlot = (filtered.length / totalSlots).ceil();

  int cursor = 0;
  final teams = <TeamLetters>[];

  for (int teamIndex = 0; teamIndex < amountOfTeams; teamIndex++) {
    final rounds = <RoundLetters>[];

    for (int roundIndex = 0; roundIndex < numberOfRounds; roundIndex++) {
      final letters = <Letter>[];

      for (int i = 0; i < lettersPerSlot && cursor < indices.length; i++) {
        final originalIndex = indices[cursor++];
        final ch = filtered[originalIndex];
        letters.add(Letter(ch, originalIndex));
      }

      rounds.add(RoundLetters(roundIndex, letters));
    }

    teams.add(TeamLetters(teamIndex, rounds));
  }

  return teams;
}
