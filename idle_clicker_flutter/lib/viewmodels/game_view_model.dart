import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/game_state.dart';
import '../models/generator.dart';
import '../models/upgrade.dart';
import '../services/storage_service.dart';

class GameViewModel extends ChangeNotifier {
  GameState gameState = GameState();
  final StorageService _storage = StorageService();

  Timer? _gameTimer;
  Timer? _saveTimer;

  Map<String, double> generatorMultipliers = {};

  GameViewModel() {
    _initGame();
  }

  Future<void> _initGame() async {
    final savedState = await _storage.loadGameState();
    if (savedState != null) {
      gameState = savedState;
      _calculateOfflineEarnings();
    }
    _recalculateCoinsPerSecond();
    _updateAvailableUpgrades();
    _startGameLoop();
    _startAutoSave();
    notifyListeners();
  }

  void _startGameLoop() {
    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
  }

  void _startAutoSave() {
    _saveTimer = Timer.periodic(const Duration(seconds: 30), (_) => saveGame());
  }

  void _tick() {
    if (gameState.coinsPerSecond > 0) {
      final coinsEarned = gameState.coinsPerSecond * 0.1;
      gameState.coins += coinsEarned;
      gameState.totalCoinsEarned += coinsEarned;
      notifyListeners();
    }
  }

  void _calculateOfflineEarnings() {
    final now = DateTime.now();
    final elapsed = now.difference(gameState.lastSaveTime);
    final cappedSeconds = min(elapsed.inSeconds, 8 * 60 * 60); // Cap at 8 hours

    if (cappedSeconds > 0 && gameState.coinsPerSecond > 0) {
      final offlineEarnings = gameState.coinsPerSecond * cappedSeconds;
      gameState.coins += offlineEarnings;
      gameState.totalCoinsEarned += offlineEarnings;
    }
  }

  double get effectiveCoinsPerClick {
    return gameState.coinsPerClick *
        gameState.clickMultiplier *
        gameState.globalMultiplier *
        gameState.prestigeMultiplier;
  }

  void tap() {
    final earned = effectiveCoinsPerClick;
    gameState.coins += earned;
    gameState.totalCoinsEarned += earned;
    gameState.totalClicks++;
    _updateAvailableUpgrades();
    notifyListeners();
  }

  bool canAffordGenerator(Generator generator) {
    final owned = gameState.ownedGenerators[generator.id] ?? 0;
    return gameState.coins >= generator.price(owned);
  }

  void buyGenerator(Generator generator) {
    final owned = gameState.ownedGenerators[generator.id] ?? 0;
    final cost = generator.price(owned);

    if (gameState.coins >= cost) {
      gameState.coins -= cost;
      gameState.ownedGenerators[generator.id] = owned + 1;
      _recalculateCoinsPerSecond();
      _updateAvailableUpgrades();
      notifyListeners();
    }
  }

  bool canAffordUpgrade(Upgrade upgrade) {
    return gameState.coins >= upgrade.price &&
        !gameState.purchasedUpgrades.contains(upgrade.id);
  }

  void buyUpgrade(Upgrade upgrade) {
    if (!canAffordUpgrade(upgrade)) return;
    if (!upgrade.isUnlocked(gameState)) return;

    gameState.coins -= upgrade.price;
    gameState.purchasedUpgrades.add(upgrade.id);

    switch (upgrade.type) {
      case UpgradeType.clickPower:
        gameState.clickMultiplier *= upgrade.multiplier;
        break;
      case UpgradeType.generatorBoost:
        if (upgrade.targetGenerator != null) {
          generatorMultipliers[upgrade.targetGenerator!] =
              (generatorMultipliers[upgrade.targetGenerator!] ?? 1.0) *
                  upgrade.multiplier;
        }
        break;
      case UpgradeType.globalMultiplier:
        gameState.globalMultiplier *= upgrade.multiplier;
        break;
    }

    _recalculateCoinsPerSecond();
    _updateAvailableUpgrades();
    notifyListeners();
  }

  void _recalculateCoinsPerSecond() {
    double total = 0;

    for (final generator in Generator.allGenerators) {
      final owned = gameState.ownedGenerators[generator.id] ?? 0;
      if (owned > 0) {
        final multiplier = generatorMultipliers[generator.id] ?? 1.0;
        total += generator.production(owned, multiplier: multiplier);
      }
    }

    gameState.coinsPerSecond =
        total * gameState.globalMultiplier * gameState.prestigeMultiplier;
  }

  List<Upgrade> get availableUpgrades {
    return Upgrade.allUpgrades
        .where((u) =>
            !gameState.purchasedUpgrades.contains(u.id) &&
            u.isUnlocked(gameState))
        .toList();
  }

  List<Upgrade> get purchasedUpgrades {
    return Upgrade.allUpgrades
        .where((u) => gameState.purchasedUpgrades.contains(u.id))
        .toList();
  }

  void _updateAvailableUpgrades() {
    // Triggers UI refresh for upgrade visibility
  }

  // Prestige system
  int get potentialPrestigePoints {
    if (gameState.totalCoinsEarned < 1e9) return 0;
    return sqrt(gameState.totalCoinsEarned / 1e9).floor();
  }

  void performPrestige() {
    final points = potentialPrestigePoints;
    if (points <= 0) return;

    gameState.prestigePoints += points;
    gameState.totalPrestiges++;
    gameState.prestigeMultiplier = 1.0 + (gameState.prestigePoints * 0.01);

    // Reset game state but keep prestige
    gameState.coins = 0;
    gameState.totalCoinsEarned = 0;
    gameState.totalClicks = 0;
    gameState.coinsPerClick = 1;
    gameState.coinsPerSecond = 0;
    gameState.ownedGenerators = {};
    gameState.purchasedUpgrades = {};
    gameState.clickMultiplier = 1.0;
    gameState.globalMultiplier = 1.0;
    generatorMultipliers = {};

    saveGame();
    notifyListeners();
  }

  Future<void> saveGame() async {
    gameState.lastSaveTime = DateTime.now();
    await _storage.saveGameState(gameState);
  }

  Future<void> resetGame() async {
    await _storage.resetGameState();
    gameState = GameState();
    generatorMultipliers = {};
    _recalculateCoinsPerSecond();
    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _saveTimer?.cancel();
    saveGame();
    super.dispose();
  }
}
