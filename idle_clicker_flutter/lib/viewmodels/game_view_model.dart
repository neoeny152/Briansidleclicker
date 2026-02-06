import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/game_state.dart';
import '../models/trading_symbol.dart';
import '../models/bot_upgrade.dart';
import '../models/career.dart';
import '../models/online_course.dart';
import '../models/youtube_career.dart';
import '../services/storage_service.dart';

enum TradeResult { bigLoss, smallLoss, smallWin, goodWin, bigWin }

class TradeOutcome {
  final TradeResult result;
  final double amount;
  final bool isWin;

  TradeOutcome({required this.result, required this.amount, required this.isWin});
}

enum DipResult { wipe, bigLoss, smallLoss, smallWin, bigWin, jackpot }

class DipOutcome {
  final DipResult result;
  final double amount;
  final bool isWin;
  final int streakUsed; // What streak level was used

  DipOutcome({
    required this.result,
    required this.amount,
    required this.isWin,
    required this.streakUsed,
  });
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

  // Last dip result for UI feedback
  DipOutcome? lastDipOutcome;

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
    bool changed = false;

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

      changed = true;
    }

    // YouTube ad revenue (passive income, collected every tick)
    if (youtubeLevel.canMonetize) {
      final adRev = pendingAdRevenue;
      if (adRev > 0) {
        gameState.balance += adRev;
        gameState.youtubeRevenue += adRev;
        gameState.totalLifetimeEarnings += adRev;
        changed = true;
      }
    }

    // Affiliate income (credibility bonus)
    final affIncome = affiliateIncome * 0.1; // Per tick (10 ticks/sec)
    if (affIncome > 0) {
      gameState.balance += affIncome;
      gameState.totalLifetimeEarnings += affIncome;
      changed = true;
    }

    if (changed) {
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

    // Add course edge bonus
    edge += gameState.courseEdgeBonus;

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

  // Career getters
  CareerLevel get currentCareer => CareerLevel.getLevel(gameState.careerLevel);
  CareerLevel? get nextCareer {
    if (gameState.careerLevel >= CareerLevel.allLevels.length - 1) return null;
    return CareerLevel.getLevel(gameState.careerLevel + 1);
  }

  double get currentWage {
    final career = currentCareer;
    // Tiny bonus per work session at current level (+$0.01 per session)
    return career.baseWage + (gameState.workSessionsAtCurrentLevel * 0.01);
  }

  bool get canPromote {
    final next = nextCareer;
    if (next == null) return false;
    return gameState.balance >= next.promotionCost &&
        gameState.workSessionsAtCurrentLevel >= next.workSessionsRequired;
  }

  int get workSessionsForPromotion {
    final next = nextCareer;
    if (next == null) return 0;
    return next.workSessionsRequired;
  }

  void promote() {
    final next = nextCareer;
    if (next == null) return;
    if (!canPromote) return;

    gameState.balance -= next.promotionCost;
    gameState.careerLevel++;
    gameState.workSessionsAtCurrentLevel = 0;
    notifyListeners();
  }

  // Work for guaranteed income
  void startWorking() {
    if (isWorking) return;

    isWorking = true;
    workSecondsRemaining = 15; // 15 second work shift (longer grind)
    notifyListeners();

    _workTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      workSecondsRemaining--;

      if (workSecondsRemaining <= 0) {
        // Work complete - pay out based on career level
        final pay = currentWage;
        gameState.balance += pay;
        gameState.totalWorkSessions++;
        gameState.workSessionsAtCurrentLevel++;
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

  // Online Courses
  bool hasPurchasedCourse(String courseId) {
    return gameState.purchasedCourses.contains(courseId);
  }

  bool canAffordCourse(OnlineCourse course) {
    if (hasPurchasedCourse(course.id)) return false;
    return gameState.balance >= course.price;
  }

  // Returns true if course was legit, false if scam
  bool purchaseCourse(OnlineCourse course) {
    if (hasPurchasedCourse(course.id)) return false;
    if (gameState.balance < course.price) return false;

    gameState.balance -= course.price;
    gameState.purchasedCourses.add(course.id);

    if (!course.isScam) {
      // Legit course - add edge bonus
      gameState.courseEdgeBonus += course.edgeBonus;
    }
    // Scam courses do nothing but take your money

    notifyListeners();
    return !course.isScam;
  }

  // YouTube Career
  YouTubeLevel get youtubeLevel => YouTubeLevel.getLevel(gameState.subscribers);
  YouTubeLevel? get nextYoutubeLevel => YouTubeLevel.getNextLevel(gameState.subscribers);

  bool get canStartChannel {
    if (gameState.hasYouTubeChannel) return false;
    final starterLevel = YouTubeLevel.allLevels[1]; // "Just Started"
    return gameState.balance >= starterLevel.unlockCost;
  }

  void startYouTubeChannel() {
    if (gameState.hasYouTubeChannel) return;
    final starterLevel = YouTubeLevel.allLevels[1];
    if (gameState.balance < starterLevel.unlockCost) return;

    gameState.balance -= starterLevel.unlockCost;
    gameState.hasYouTubeChannel = true;
    gameState.subscribers = 0;
    notifyListeners();
  }

  bool get canPostVideo {
    if (!gameState.hasYouTubeChannel) return false;
    if (gameState.lastVideoPostTime == null) return true;
    // 30 second cooldown between videos
    return DateTime.now().difference(gameState.lastVideoPostTime!).inSeconds >= 30;
  }

  int get videoPostCooldownSeconds {
    if (gameState.lastVideoPostTime == null) return 0;
    final elapsed = DateTime.now().difference(gameState.lastVideoPostTime!).inSeconds;
    return (30 - elapsed).clamp(0, 30);
  }

  // Post a video - gains subscribers based on edge and hype
  void postVideo() {
    if (!canPostVideo) return;

    gameState.totalVideosPosted++;
    gameState.lastVideoPostTime = DateTime.now();

    // Base subscriber gain
    int baseGain = 5 + (gameState.totalVideosPosted ~/ 5); // Grows slowly

    // HYPE FACTOR: Bad edge = more exciting content = more growth!
    // Good traders are "boring" - bad traders show huge wins/losses
    double hypeFactor = 1.0;
    if (effectiveEdge < 0) {
      // Negative edge = more volatile = more exciting content
      hypeFactor = 1.0 + (effectiveEdge.abs() * 5); // -20% edge = 2x hype
    } else if (effectiveEdge > 0.1) {
      // Good edge = boring consistent gains = less exciting
      hypeFactor = 0.5; // Half the growth
    }

    // Credibility factor (slight boost for credible creators)
    double credFactor = 1.0 + (gameState.credibility - 50) / 200; // 0.75x to 1.25x

    // Calculate final subscriber gain
    int gain = (baseGain * hypeFactor * credFactor).round();
    gain = gain.clamp(1, 10000); // Min 1, max 10000 per video

    gameState.subscribers += gain;

    // Update credibility based on edge
    _updateCredibility();

    notifyListeners();
  }

  void _updateCredibility() {
    // Credibility moves toward 0 if bad edge, toward 100 if good edge
    if (effectiveEdge >= 0.05) {
      // Good edge - build credibility
      gameState.credibility = (gameState.credibility + 1).clamp(0, 100);
    } else if (effectiveEdge < -0.05) {
      // Bad edge - lose credibility
      gameState.credibility = (gameState.credibility - 0.5).clamp(0, 100);
    }
  }

  // Collect ad revenue (passive income based on subscribers)
  double get pendingAdRevenue {
    if (!youtubeLevel.canMonetize) return 0;
    // $0.001 per subscriber per collection (can collect every tick)
    return gameState.subscribers * 0.0001;
  }

  void collectAdRevenue() {
    if (!youtubeLevel.canMonetize) return;
    final revenue = pendingAdRevenue;
    if (revenue <= 0) return;

    gameState.balance += revenue;
    gameState.youtubeRevenue += revenue;
    gameState.totalLifetimeEarnings += revenue;
    notifyListeners();
  }

  // Course creation
  bool get canCreateCourse => youtubeLevel.canSellCourses;

  // Returns course revenue per sale
  double getCourseRevenuePerSale(bool isScamCourse) {
    // Base price based on subscriber count
    double basePrice = 50 + (gameState.subscribers / 1000);

    if (isScamCourse) {
      // Scam courses sell for MORE (hype pricing)
      return basePrice * 2;
    } else {
      // Legit courses sell for less but you need good edge
      return basePrice;
    }
  }

  // Calculate expected sales when creating a course
  int getExpectedCourseSales(bool isScamCourse) {
    // Base sales = 0.1% of subscribers
    int baseSales = (gameState.subscribers * 0.001).round();

    if (isScamCourse) {
      // Scam courses sell more (FOMO marketing)
      // But credibility affects repeat sales
      double credPenalty = (100 - gameState.credibility) / 100; // 0 to 1
      return (baseSales * (1.5 + credPenalty)).round();
    } else {
      // Legit courses sell based on credibility
      double credBonus = gameState.credibility / 100; // 0 to 1
      return (baseSales * (0.5 + credBonus)).round();
    }
  }

  // Create and sell a course (one-time revenue event)
  double createAndSellCourse(String courseName, bool isScamCourse) {
    if (!canCreateCourse) return 0;

    final pricePerSale = getCourseRevenuePerSale(isScamCourse);
    final sales = getExpectedCourseSales(isScamCourse);
    final totalRevenue = pricePerSale * sales;

    // Record the course
    gameState.createdCourses.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': courseName,
      'price': pricePerSale,
      'isScam': isScamCourse,
      'salesCount': sales,
      'totalRevenue': totalRevenue,
      'createdAt': DateTime.now().toIso8601String(),
    });

    // Add revenue
    gameState.balance += totalRevenue;
    gameState.totalCourseRevenue += totalRevenue;
    gameState.totalLifetimeEarnings += totalRevenue;

    // Credibility impact
    if (isScamCourse) {
      // Selling scam courses tanks credibility
      gameState.credibility = (gameState.credibility - 10).clamp(0, 100);
    } else {
      // Selling legit courses builds credibility
      gameState.credibility = (gameState.credibility + 5).clamp(0, 100);
    }

    notifyListeners();
    return totalRevenue;
  }

  // Credibility bonus: passive income from affiliate deals
  double get affiliateIncome {
    if (!gameState.hasYouTubeChannel) return 0;
    if (gameState.credibility < 60) return 0; // Need decent credibility
    // $0.10 per credibility point above 60, per 10K subscribers
    return ((gameState.credibility - 60) * 0.10) * (gameState.subscribers / 10000);
  }

  // Buy the Dip
  bool get isDipOnCooldown {
    if (gameState.dipCooldownEndTime == null) return false;
    return DateTime.now().isBefore(gameState.dipCooldownEndTime!);
  }

  int get dipCooldownSecondsRemaining {
    if (gameState.dipCooldownEndTime == null) return 0;
    final remaining = gameState.dipCooldownEndTime!.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  int get dipStreak => gameState.dipStreak;

  DipOutcome buyTheDip() {
    if (gameState.balance <= 0) {
      // Can't dip with no money
      return DipOutcome(
        result: DipResult.smallLoss,
        amount: 0,
        isWin: false,
        streakUsed: 0,
      );
    }

    final currentStreak = isDipOnCooldown ? gameState.dipStreak : 0;
    final roll = _random.nextDouble();

    DipResult result;
    double multiplier;

    if (currentStreak == 0) {
      // Safe dip (not on cooldown)
      // 35% lose 20-40%, 30% win 30-60%, 25% win 60-120%, 10% win 150-250%
      if (roll < 0.35) {
        result = DipResult.smallLoss;
        multiplier = -(0.2 + _random.nextDouble() * 0.2);
      } else if (roll < 0.65) {
        result = DipResult.smallWin;
        multiplier = 0.3 + _random.nextDouble() * 0.3;
      } else if (roll < 0.90) {
        result = DipResult.bigWin;
        multiplier = 0.6 + _random.nextDouble() * 0.6;
      } else {
        result = DipResult.jackpot;
        multiplier = 1.5 + _random.nextDouble() * 1.0;
      }
    } else if (currentStreak == 1) {
      // Risky dip (first during cooldown)
      // 10% wipe, 30% lose 40-70%, 25% win 50-100%, 25% win 100-200%, 10% jackpot 250-400%
      if (roll < 0.10) {
        result = DipResult.wipe;
        multiplier = -1.0; // Lose everything
      } else if (roll < 0.40) {
        result = DipResult.bigLoss;
        multiplier = -(0.4 + _random.nextDouble() * 0.3);
      } else if (roll < 0.65) {
        result = DipResult.smallWin;
        multiplier = 0.5 + _random.nextDouble() * 0.5;
      } else if (roll < 0.90) {
        result = DipResult.bigWin;
        multiplier = 1.0 + _random.nextDouble() * 1.0;
      } else {
        result = DipResult.jackpot;
        multiplier = 2.5 + _random.nextDouble() * 1.5;
      }
    } else {
      // Dangerous dip (2+ during cooldown)
      // 25% wipe, 30% lose 60-90%, 15% win 100-200%, 20% win 200-400%, 10% jackpot 500-1000%
      if (roll < 0.25) {
        result = DipResult.wipe;
        multiplier = -1.0;
      } else if (roll < 0.55) {
        result = DipResult.bigLoss;
        multiplier = -(0.6 + _random.nextDouble() * 0.3);
      } else if (roll < 0.70) {
        result = DipResult.smallWin;
        multiplier = 1.0 + _random.nextDouble() * 1.0;
      } else if (roll < 0.90) {
        result = DipResult.bigWin;
        multiplier = 2.0 + _random.nextDouble() * 2.0;
      } else {
        result = DipResult.jackpot;
        multiplier = 5.0 + _random.nextDouble() * 5.0;
      }
    }

    final amount = gameState.balance * multiplier;
    final isWin = amount > 0;

    // Apply to balance
    gameState.balance += amount;
    if (gameState.balance < 0) gameState.balance = 0;

    // Update stats
    gameState.totalDips++;
    if (isWin) {
      gameState.totalDipWinnings += amount;
      gameState.totalLifetimeEarnings += amount;
      gameState.totalEarned += amount;
    } else {
      gameState.totalDipLosses += amount.abs();
      gameState.totalLost += amount.abs();
    }

    // Update cooldown and streak
    if (isDipOnCooldown) {
      // Increase streak
      gameState.dipStreak++;
    } else {
      // Start new cooldown
      gameState.dipStreak = 1;
    }
    // Reset/extend cooldown timer (30 seconds)
    gameState.dipCooldownEndTime = DateTime.now().add(const Duration(seconds: 30));

    lastDipOutcome = DipOutcome(
      result: result,
      amount: amount,
      isWin: isWin,
      streakUsed: currentStreak,
    );

    notifyListeners();
    return lastDipOutcome!;
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

    // Save prestige data (career, courses, and YouTube persist!)
    final newCrashCount = gameState.crashCount + 1;
    final newExpMultiplier = 1.0 + (gameState.crashCount + bonus) * 0.05;
    final lifetimeEarnings = gameState.totalLifetimeEarnings;
    final savedCareerLevel = gameState.careerLevel;
    final savedWorkSessions = gameState.workSessionsAtCurrentLevel;
    final savedCourses = List<String>.from(gameState.purchasedCourses);
    final savedCourseEdge = gameState.courseEdgeBonus;
    // YouTube persists
    final savedHasChannel = gameState.hasYouTubeChannel;
    final savedSubscribers = gameState.subscribers;
    final savedVideos = gameState.totalVideosPosted;
    final savedYTRevenue = gameState.youtubeRevenue;
    final savedCredibility = gameState.credibility;
    final savedCreatedCourses = List<Map<String, dynamic>>.from(gameState.createdCourses);
    final savedCourseRev = gameState.totalCourseRevenue;

    // Reset to new game (but keep career, courses, and YouTube)
    gameState = GameState(
      crashCount: newCrashCount,
      experienceMultiplier: newExpMultiplier,
      totalLifetimeEarnings: lifetimeEarnings,
      careerLevel: savedCareerLevel,
      workSessionsAtCurrentLevel: savedWorkSessions,
      purchasedCourses: savedCourses,
      courseEdgeBonus: savedCourseEdge,
      hasYouTubeChannel: savedHasChannel,
      subscribers: savedSubscribers,
      totalVideosPosted: savedVideos,
      youtubeRevenue: savedYTRevenue,
      credibility: savedCredibility,
      createdCourses: savedCreatedCourses,
      totalCourseRevenue: savedCourseRev,
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
