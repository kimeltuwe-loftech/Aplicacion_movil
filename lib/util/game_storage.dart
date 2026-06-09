import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static const String _selectedTeamKey = 'selected_team';
  static const String _amountOfTeamsKey = 'amount_of_teams';
  static const String _currentRoundKey = 'current_round';
  static const String _sentenceKey = 'sentence';

  /// Get both the selected team number and the amount of teams
  static Future<Map<String, dynamic>> getGameInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedTeam = prefs.getInt(_selectedTeamKey);
    final amountOfTeams = prefs.getInt(_amountOfTeamsKey);
    final sentence = prefs.getString(_sentenceKey);
    return {'selectedTeam': selectedTeam, 'amountOfTeams': amountOfTeams, 'sentence': sentence};
  }

  /// Set both the selected team number and the amount of teams
  static Future<void> setGameInfo(int teamNumber, int amount, String sentence) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedTeamKey, teamNumber);
    await prefs.setInt(_amountOfTeamsKey, amount);
    await prefs.setString(_sentenceKey, sentence);
  }

  /// Get the current round
  static Future<int> getCurrentRound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentRoundKey) ?? 0;
  }

  /// Set the current round
  static Future<void> setCurrentRound(int round) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentRoundKey, round);
  }
}
