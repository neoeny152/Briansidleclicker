import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

class StorageService {
  static const String _gameStateKey = 'com.idleclicker.gamestate';

  Future<void> saveGameState(GameState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_gameStateKey, state.toJsonString());
  }

  Future<GameState?> loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_gameStateKey);
    if (jsonString == null) return null;
    try {
      return GameState.fromJsonString(jsonString);
    } catch (e) {
      print('Error loading game state: $e');
      return null;
    }
  }

  Future<void> resetGameState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_gameStateKey);
  }
}
