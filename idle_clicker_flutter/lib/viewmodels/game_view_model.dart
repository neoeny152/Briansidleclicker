import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/game_state.dart';
import '../models/trading_symbol.dart';
import '../models/bot_upgrade.dart';
import '../services/storage_service.dart';

enum TradeResult { bigLoss, smallLoss, smallWin, goodWin, bigWin }

class TradeOutcome {
  final TradeResult result;
  final double amount;
  final bool isWin;

  TradeOutcome({required this.result, required this.amount, required this.isWin});
}

class GameViewModel extends ChangeNotifier {
  GameState gameState = GameState();
  final StorageService _storage = StorageService();
  final Random _random = Random();

  Timer? _gameTimer;
  Timer? _saveTimer;
  Timer? _workTimer;

  // Last trade result for UI feedback
  TradeOutcome? lastTradeOutcome;

  // Work state
  bool isWorking = false;
  int workSecondsRemaining = 0;

  GameViewModel() {
    _initGame();
  }

  Future<void> _initGame() async {
    final savedState = await _storage.loadGameState();
    if (savedState != null) {
      gameState = savedState;
    }
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
    // Bot trading
    if (gameState.botEnabled && gameState.botTradesPerSecond > 0) {
      // Calculate trades this tick (0.1 second)
      final tradesThisTick = gameState.botTradesPerSecond * 0.1;

      // Use probability for fractional trades
      final wholeTrades = tradesThisTick.floor();
      final fractional = tradesThisTick - wholeTrades;

      for (int i = 0; i < wholeTrades; i++) {
        _executeTrade(isBot: true);
      }

      if (_random.nextDouble() < fractional) {
        _executeTrade(isBot: true);
      }

      notifyListeners();
    }
  }

  // Get current symbol
  TradingSymbol get activeSymbol {
    return TradingSymbol.getById(gameState.activeSymbol) ?? TradingSymbol.allSymbols.first;
  }

  // Calculate effective edge including all bonuses
  double get effectiveEdge {
    double edge = gameState.baseEdge;

    // Add symbol-specific edge from ML training
    edge += gameState.symbolEdges[gameState.activeSymbol] ?? 0;

    // Add bot upgrade bonuses
    for (final upgrade in BotUpgrade.allUpgrades) {
      final level = gameState.botUpgrades[upgrade.id] ?? 0;
      edge += upgrade.edgePerLevel * level;
    }

    // Apply experience multiplier from crashes
    edge *= gameState.experienceMultiplier;

    return edge;
  }

  // Calculate trade size including bonuses
  double get effectiveTradeSize {
    double size = activeSymbol.baseTradeSize;

    // Add bot upgrade bonuses
    for (final upgrade in BotUpgrade.allUpgrades) {
      final level = gameState.botUpgrades[upgrade.id] ?? 0;
      size *= (1 + upgrade.tradeSizePerLevel * level);
    }

    return size;
  }

  // Execute a single trade
  TradeOutcome _executeTrade({bool isBot = false}) {
    final symbol = activeSymbol;
    final edge = effectiveEdge;
    final tradeSize = effectiveTradeSize;

    // Determine outcome based on edge
    // Base probabilities (adjusted by edge)
    // edge of 0 = slight negative EV
    // edge of 0.1 = slight positive EV
    final roll = _random.nextDouble();
    final adjustedRoll = roll - edge; // Edge shifts outcomes positive

    TradeResult result;
    double multiplier;

    if (adjustedRoll < 0.05) {
      // Big win (5% base)
      result = TradeResult.bigWin;
      multiplier = 1.0 + _random.nextDouble() * 0.5; // +100% to +150%
    } else if (adjustedRoll < 0.30) {
      // Good win (25% base)
      result = TradeResult.goodWin;
      multiplier = 0.2 + _random.nextDouble() * 0.15; // +20% to +35%
    } else if (adjustedRoll < 0.70) {
      // Small win (40% base)
      result = TradeResult.smallWin;
      multiplier = 0.05 + _random.nextDouble() * 0.1; // +5% to +15%
    } else if (adjustedRoll < 0.95) {
      // Small loss (25% base)
      result = TradeResult.smallLoss;
      multiplier = -(0.05 + _random.nextDouble() * 0.1); // -5% to -15%
    } else {
      // Big loss (5% base)
      result = TradeResult.bigLoss;
      multiplier = -(0.2 + _random.nextDouble() * 0.3); // -20% to -50%
    }

    // Apply volatility
    multiplier *= symbol.volatility;

    final amount = tradeSize * multiplier;
    final isWin = amount > 0;

    // Apply to balance
    gameState.balance += amount;
    if (gameState.balance < 0) gameState.balance = 0;

    // Update stats
    gameState.totalTrades++;
    if (isWin) {
      gameState.winningTrades++;
      gameState.totalEarned += amount;
    } else {
      gameState.losingTrades++;
      gameState.totalLost += amount.abs();
    }

    // Track lifetime earnings for prestige
    if (isWin) {
      gameState.totalLifetimeEarnings += amount;
    }

    // Increment symbol trade count (for ML training)
    gameState.symbolTradeCount[symbol.id] =
        (gameState.symbolTradeCount[symbol.id] ?? 0) + 1;

    // Check if we've earned edge from ML training
    _checkMLProgress(symbol);

    final outcome = TradeOutcome(result: result, amount: amount, isWin: isWin);

    if (!isBot) {
      lastTradeOutcome = outcome;
    }

    return outcome;
  }

  // Manual trade (clicking)
  void manualTrade() {
    _executeTrade(isBot: false);
    notifyListeners();
  }

  // Check ML training progress
  void _checkMLProgress(TradingSymbol symbol) {
    final trades = gameState.symbolTradeCount[symbol.id] ?? 0;
    final currentEdge = gameState.symbolEdges[symbol.id] ?? 0;
    final expectedEdge = (trades / symbol.mlTradesRequired).floor() * 0.01;

    if (expectedEdge > currentEdge) {
      gameState.symbolEdges[symbol.id] = expectedEdge;
    }
  }

  // Work for guaranteed income
  void startWorking() {
    if (isWorking) return;

    isWorking = true;
    workSecondsRemaining = 10; // 10 second work shift
    notifyListeners();

    _workTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      workSecondsRemaining--;

      if (workSecondsRemaining <= 0) {
        // Work complete - pay out
        final pay = 5.0 + (gameState.totalWorkSessions * 0.5); // Increases slightly over time
        gameState.balance += pay;
        gameState.totalWorkSessions++;
        gameState.totalWorkEarnings += pay;
        gameState.totalLifetimeEarnings += pay;

        isWorking = false;
        timer.cancel();
        _workTimer = null;
      }

      notifyListeners();
    });
  }

  // Buy upgrade
  bool canAffordUpgrade(BotUpgrade upgrade) {
    final currentLevel = gameState.botUpgrades[upgrade.id] ?? 0;
    if (currentLevel >= upgrade.maxLevel) return false;
    return gameState.balance >= upgrade.getPrice(currentLevel);
  }

  void buyUpgrade(BotUpgrade upgrade) {
    final currentLevel = gameState.botUpgrades[upgrade.id] ?? 0;
    if (currentLevel >= upgrade.maxLevel) return;

    final price = upgrade.getPrice(currentLevel);
    if (gameState.balance < price) return;

    gameState.balance -= price;
    gameState.botUpgrades[upgrade.id] = currentLevel + 1;

    // Apply immediate effects
    if (upgrade.id == 'basic_bot' && currentLevel == 0) {
      gameState.botEnabled = true;
    }
    gameState.botTradesPerSecond = _calculateBotSpeed();

    notifyListeners();
  }

  double _calculateBotSpeed() {
    double speed = 0;
    for (final upgrade in BotUpgrade.allUpgrades) {
      final level = gameState.botUpgrades[upgrade.id] ?? 0;
      speed += upgrade.speedPerLevel * level;
    }
    return speed;
  }

  // Unlock symbol
  bool canAffordSymbol(TradingSymbol symbol) {
    if (gameState.unlockedSymbols[symbol.id] == true) return false;
    return gameState.balance >= symbol.unlockPrice;
  }

  void unlockSymbol(TradingSymbol symbol) {
    if (gameState.unlockedSymbols[symbol.id] == true) return;
    if (gameState.balance < symbol.unlockPrice) return;

    gameState.balance -= symbol.unlockPrice;
    gameState.unlockedSymbols[symbol.id] = true;
    gameState.symbolEdges[symbol.id] = 0;
    gameState.symbolTradeCount[symbol.id] = 0;

    notifyListeners();
  }

  void selectSymbol(String symbolId) {
    if (gameState.unlockedSymbols[symbolId] != true) return;
    gameState.activeSymbol = symbolId;
    notifyListeners();
  }

  // Market Crash (Prestige)
  int get potentialCrashBonus {
    // Based on total lifetime earnings
    if (gameState.totalLifetimeEarnings < 10000) return 0;
    return (log(gameState.totalLifetimeEarnings / 10000) / log(2)).floor() + 1;
  }

  void marketCrash() {
    final bonus = potentialCrashBonus;
    if (bonus <= 0) return;

    // Save prestige data
    final newCrashCount = gameState.crashCount + 1;
    final newExpMultiplier = 1.0 + (gameState.crashCount + bonus) * 0.05;
    final lifetimeEarnings = gameState.totalLifetimeEarnings;

    // Reset to new game
    gameState = GameState(
      crashCount: newCrashCount,
      experienceMultiplier: newExpMultiplier,
      totalLifetimeEarnings: lifetimeEarnings,
    );

    saveGame();
    notifyListeners();
  }

  // Win rate
  double get winRate {
    if (gameState.totalTrades == 0) return 0;
    return gameState.winningTrades / gameState.totalTrades;
  }

  // ML Progress for current symbol (0.0 to 1.0 for next level)
  double get mlProgress {
    final symbol = activeSymbol;
    final trades = gameState.symbolTradeCount[symbol.id] ?? 0;
    final tradesInCurrentLevel = trades % symbol.mlTradesRequired;
    return tradesInCurrentLevel / symbol.mlTradesRequired;
  }

  int get mlLevel {
    final symbol = activeSymbol;
    final trades = gameState.symbolTradeCount[symbol.id] ?? 0;
    return trades ~/ symbol.mlTradesRequired;
  }

  Future<void> saveGame() async {
    gameState.lastSaveTime = DateTime.now();
    await _storage.saveGameState(gameState);
  }

  Future<void> resetGame() async {
    await _storage.resetGameState();
    gameState = GameState();
    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _saveTimer?.cancel();
    _workTimer?.cancel();
    saveGame();
    super.dispose();
  }
}
