import 'dart:convert';

class GameState {
  // Core currency
  double balance;
  double totalEarned;
  double totalLost;

  // Trading stats
  int totalTrades;
  int winningTrades;
  int losingTrades;

  // Work stats
  int totalWorkSessions;
  double totalWorkEarnings;

  // Bot & Edge
  double baseEdge; // Starts very negative (-0.20 = -20% expected value)
  Map<String, int> botUpgrades; // upgrade_id -> level
  Map<String, double> symbolEdges; // symbol_id -> additional edge for that symbol
  Map<String, bool> unlockedSymbols; // symbol_id -> unlocked
  Map<String, int> symbolTradeCount; // symbol_id -> trades made (for ML training)

  // Career (persists through crash)
  int careerLevel; // Index into CareerLevel.allLevels
  int workSessionsAtCurrentLevel; // Progress toward next promotion

  // Courses (persists through crash)
  List<String> purchasedCourses; // List of course IDs
  double courseEdgeBonus; // Total edge from legit courses

  // YouTube Career (persists through crash)
  bool hasYouTubeChannel;
  int subscribers;
  int totalVideosPosted;
  double youtubeRevenue; // Total ad revenue earned
  double credibility; // 0-100, builds if good edge, decays if bad edge
  List<Map<String, dynamic>> createdCourses; // Courses you've created to sell
  double totalCourseRevenue; // Revenue from courses you created
  DateTime? lastVideoPostTime; // Cooldown for posting videos

  // Bot automation
  bool botEnabled;
  double botTradesPerSecond;

  // Current selected symbol
  String activeSymbol;

  // Prestige (Market Crash)
  int crashCount;
  double experienceMultiplier; // Permanent edge bonus from crashes
  double totalLifetimeEarnings; // Tracks all-time for crash rewards

  // Buy the Dip
  DateTime? dipCooldownEndTime; // When cooldown expires (null = ready)
  int dipStreak; // Times bought dip during current cooldown (increases risk)
  int totalDips; // All-time dip attempts
  double totalDipWinnings;
  double totalDipLosses;

  // Market Tips (Golden Cookie equivalent)
  DateTime? frenzyEndTime; // When 2x frenzy ends

  // Meta
  DateTime lastSaveTime;

  GameState({
    this.balance = 100, // Start with $100
    this.totalEarned = 0,
    this.totalLost = 0,
    this.totalTrades = 0,
    this.winningTrades = 0,
    this.losingTrades = 0,
    this.totalWorkSessions = 0,
    this.totalWorkEarnings = 0,
    this.baseEdge = -0.20, // -20% edge to start (day trading loses money!)
    Map<String, int>? botUpgrades,
    Map<String, double>? symbolEdges,
    Map<String, bool>? unlockedSymbols,
    Map<String, int>? symbolTradeCount,
    this.careerLevel = 0, // Start unemployed
    this.workSessionsAtCurrentLevel = 0,
    List<String>? purchasedCourses,
    this.courseEdgeBonus = 0,
    this.hasYouTubeChannel = false,
    this.subscribers = 0,
    this.totalVideosPosted = 0,
    this.youtubeRevenue = 0,
    this.credibility = 50, // Start neutral
    List<Map<String, dynamic>>? createdCourses,
    this.totalCourseRevenue = 0,
    this.lastVideoPostTime,
    this.botEnabled = false,
    this.botTradesPerSecond = 0,
    this.activeSymbol = 'stocks',
    this.crashCount = 0,
    this.experienceMultiplier = 1.0,
    this.totalLifetimeEarnings = 0,
    this.dipCooldownEndTime,
    this.dipStreak = 0,
    this.totalDips = 0,
    this.totalDipWinnings = 0,
    this.totalDipLosses = 0,
    this.frenzyEndTime,
    DateTime? lastSaveTime,
  })  : botUpgrades = botUpgrades ?? {},
        symbolEdges = symbolEdges ?? {'stocks': 0},
        unlockedSymbols = unlockedSymbols ?? {'stocks': true},
        symbolTradeCount = symbolTradeCount ?? {'stocks': 0},
        purchasedCourses = purchasedCourses ?? [],
        createdCourses = createdCourses ?? [],
        lastSaveTime = lastSaveTime ?? DateTime.now();

  // Calculate effective edge for a symbol
  double getEffectiveEdge(String symbolId) {
    final symbolEdge = symbolEdges[symbolId] ?? 0;
    return (baseEdge + symbolEdge) * experienceMultiplier;
  }

  Map<String, dynamic> toJson() => {
        'balance': balance,
        'totalEarned': totalEarned,
        'totalLost': totalLost,
        'totalTrades': totalTrades,
        'winningTrades': winningTrades,
        'losingTrades': losingTrades,
        'totalWorkSessions': totalWorkSessions,
        'totalWorkEarnings': totalWorkEarnings,
        'baseEdge': baseEdge,
        'botUpgrades': botUpgrades,
        'symbolEdges': symbolEdges,
        'unlockedSymbols': unlockedSymbols,
        'symbolTradeCount': symbolTradeCount,
        'careerLevel': careerLevel,
        'workSessionsAtCurrentLevel': workSessionsAtCurrentLevel,
        'purchasedCourses': purchasedCourses,
        'courseEdgeBonus': courseEdgeBonus,
        'hasYouTubeChannel': hasYouTubeChannel,
        'subscribers': subscribers,
        'totalVideosPosted': totalVideosPosted,
        'youtubeRevenue': youtubeRevenue,
        'credibility': credibility,
        'createdCourses': createdCourses,
        'totalCourseRevenue': totalCourseRevenue,
        'lastVideoPostTime': lastVideoPostTime?.toIso8601String(),
        'botEnabled': botEnabled,
        'botTradesPerSecond': botTradesPerSecond,
        'activeSymbol': activeSymbol,
        'crashCount': crashCount,
        'experienceMultiplier': experienceMultiplier,
        'totalLifetimeEarnings': totalLifetimeEarnings,
        'dipCooldownEndTime': dipCooldownEndTime?.toIso8601String(),
        'dipStreak': dipStreak,
        'totalDips': totalDips,
        'totalDipWinnings': totalDipWinnings,
        'totalDipLosses': totalDipLosses,
        'frenzyEndTime': frenzyEndTime?.toIso8601String(),
        'lastSaveTime': lastSaveTime.toIso8601String(),
      };

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      balance: (json['balance'] as num?)?.toDouble() ?? 100,
      totalEarned: (json['totalEarned'] as num?)?.toDouble() ?? 0,
      totalLost: (json['totalLost'] as num?)?.toDouble() ?? 0,
      totalTrades: (json['totalTrades'] as int?) ?? 0,
      winningTrades: (json['winningTrades'] as int?) ?? 0,
      losingTrades: (json['losingTrades'] as int?) ?? 0,
      totalWorkSessions: (json['totalWorkSessions'] as int?) ?? 0,
      totalWorkEarnings: (json['totalWorkEarnings'] as num?)?.toDouble() ?? 0,
      baseEdge: (json['baseEdge'] as num?)?.toDouble() ?? -0.20,
      botUpgrades: (json['botUpgrades'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as int)) ?? {},
      symbolEdges: (json['symbolEdges'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ?? {'stocks': 0},
      unlockedSymbols: (json['unlockedSymbols'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as bool)) ?? {'stocks': true},
      symbolTradeCount: (json['symbolTradeCount'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as int)) ?? {'stocks': 0},
      careerLevel: (json['careerLevel'] as int?) ?? 0,
      workSessionsAtCurrentLevel: (json['workSessionsAtCurrentLevel'] as int?) ?? 0,
      purchasedCourses: (json['purchasedCourses'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ?? [],
      courseEdgeBonus: (json['courseEdgeBonus'] as num?)?.toDouble() ?? 0,
      hasYouTubeChannel: (json['hasYouTubeChannel'] as bool?) ?? false,
      subscribers: (json['subscribers'] as int?) ?? 0,
      totalVideosPosted: (json['totalVideosPosted'] as int?) ?? 0,
      youtubeRevenue: (json['youtubeRevenue'] as num?)?.toDouble() ?? 0,
      credibility: (json['credibility'] as num?)?.toDouble() ?? 50,
      createdCourses: (json['createdCourses'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>).toList() ?? [],
      totalCourseRevenue: (json['totalCourseRevenue'] as num?)?.toDouble() ?? 0,
      lastVideoPostTime: json['lastVideoPostTime'] != null
          ? DateTime.parse(json['lastVideoPostTime'] as String)
          : null,
      botEnabled: (json['botEnabled'] as bool?) ?? false,
      botTradesPerSecond: (json['botTradesPerSecond'] as num?)?.toDouble() ?? 0,
      activeSymbol: (json['activeSymbol'] as String?) ?? 'stocks',
      crashCount: (json['crashCount'] as int?) ?? 0,
      experienceMultiplier: (json['experienceMultiplier'] as num?)?.toDouble() ?? 1.0,
      totalLifetimeEarnings: (json['totalLifetimeEarnings'] as num?)?.toDouble() ?? 0,
      dipCooldownEndTime: json['dipCooldownEndTime'] != null
          ? DateTime.parse(json['dipCooldownEndTime'] as String)
          : null,
      dipStreak: (json['dipStreak'] as int?) ?? 0,
      totalDips: (json['totalDips'] as int?) ?? 0,
      totalDipWinnings: (json['totalDipWinnings'] as num?)?.toDouble() ?? 0,
      totalDipLosses: (json['totalDipLosses'] as num?)?.toDouble() ?? 0,
      frenzyEndTime: json['frenzyEndTime'] != null
          ? DateTime.parse(json['frenzyEndTime'] as String)
          : null,
      lastSaveTime: json['lastSaveTime'] != null
          ? DateTime.parse(json['lastSaveTime'] as String)
          : DateTime.now(),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory GameState.fromJsonString(String jsonString) {
    return GameState.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }
}
