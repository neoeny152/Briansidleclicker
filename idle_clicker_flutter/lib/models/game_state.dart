import 'dart:convert';

class GameState {
  double coins;
  double totalCoinsEarned;
  int totalClicks;
  double coinsPerClick;
  double coinsPerSecond;
  Map<String, int> ownedGenerators;
  Set<String> purchasedUpgrades;
  DateTime lastSaveTime;
  double clickMultiplier;
  double globalMultiplier;
  int prestigePoints;
  double prestigeMultiplier;
  int totalPrestiges;

  GameState({
    this.coins = 0,
    this.totalCoinsEarned = 0,
    this.totalClicks = 0,
    this.coinsPerClick = 1,
    this.coinsPerSecond = 0,
    Map<String, int>? ownedGenerators,
    Set<String>? purchasedUpgrades,
    DateTime? lastSaveTime,
    this.clickMultiplier = 1.0,
    this.globalMultiplier = 1.0,
    this.prestigePoints = 0,
    this.prestigeMultiplier = 1.0,
    this.totalPrestiges = 0,
  })  : ownedGenerators = ownedGenerators ?? {},
        purchasedUpgrades = purchasedUpgrades ?? {},
        lastSaveTime = lastSaveTime ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'coins': coins,
        'totalCoinsEarned': totalCoinsEarned,
        'totalClicks': totalClicks,
        'coinsPerClick': coinsPerClick,
        'coinsPerSecond': coinsPerSecond,
        'ownedGenerators': ownedGenerators,
        'purchasedUpgrades': purchasedUpgrades.toList(),
        'lastSaveTime': lastSaveTime.toIso8601String(),
        'clickMultiplier': clickMultiplier,
        'globalMultiplier': globalMultiplier,
        'prestigePoints': prestigePoints,
        'prestigeMultiplier': prestigeMultiplier,
        'totalPrestiges': totalPrestiges,
      };

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      coins: (json['coins'] as num?)?.toDouble() ?? 0,
      totalCoinsEarned: (json['totalCoinsEarned'] as num?)?.toDouble() ?? 0,
      totalClicks: (json['totalClicks'] as int?) ?? 0,
      coinsPerClick: (json['coinsPerClick'] as num?)?.toDouble() ?? 1,
      coinsPerSecond: (json['coinsPerSecond'] as num?)?.toDouble() ?? 0,
      ownedGenerators: (json['ownedGenerators'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as int)) ??
          {},
      purchasedUpgrades:
          (json['purchasedUpgrades'] as List<dynamic>?)?.cast<String>().toSet() ??
              {},
      lastSaveTime: json['lastSaveTime'] != null
          ? DateTime.parse(json['lastSaveTime'] as String)
          : DateTime.now(),
      clickMultiplier: (json['clickMultiplier'] as num?)?.toDouble() ?? 1.0,
      globalMultiplier: (json['globalMultiplier'] as num?)?.toDouble() ?? 1.0,
      prestigePoints: (json['prestigePoints'] as int?) ?? 0,
      prestigeMultiplier:
          (json['prestigeMultiplier'] as num?)?.toDouble() ?? 1.0,
      totalPrestiges: (json['totalPrestiges'] as int?) ?? 0,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory GameState.fromJsonString(String jsonString) {
    return GameState.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }
}
