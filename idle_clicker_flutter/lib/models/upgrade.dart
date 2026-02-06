import 'package:flutter/material.dart';
import 'game_state.dart';

enum UpgradeType { clickPower, generatorBoost, globalMultiplier }

class UpgradeRequirement {
  final String? generatorId;
  final int? generatorCount;
  final int? totalClicks;
  final double? totalCoins;

  const UpgradeRequirement({
    this.generatorId,
    this.generatorCount,
    this.totalClicks,
    this.totalCoins,
  });
}

class Upgrade {
  final String id;
  final String name;
  final String description;
  final double price;
  final UpgradeType type;
  final String? targetGenerator;
  final double multiplier;
  final UpgradeRequirement? requirement;
  final IconData icon;
  final String emoji;

  const Upgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    this.targetGenerator,
    required this.multiplier,
    this.requirement,
    required this.icon,
    required this.emoji,
  });

  bool isUnlocked(GameState state) {
    if (requirement == null) return true;

    final req = requirement!;

    if (req.generatorId != null && req.generatorCount != null) {
      final owned = state.ownedGenerators[req.generatorId] ?? 0;
      if (owned < req.generatorCount!) return false;
    }

    if (req.totalClicks != null) {
      if (state.totalClicks < req.totalClicks!) return false;
    }

    if (req.totalCoins != null) {
      if (state.totalCoinsEarned < req.totalCoins!) return false;
    }

    return true;
  }

  static const List<Upgrade> allUpgrades = [
    // Click upgrades
    Upgrade(
      id: 'click1',
      name: 'Reinforced Finger',
      description: 'Double your clicking power',
      price: 100,
      type: UpgradeType.clickPower,
      multiplier: 2.0,
      requirement: UpgradeRequirement(totalClicks: 100),
      icon: Icons.touch_app,
      emoji: '👆',
    ),
    Upgrade(
      id: 'click2',
      name: 'Carpal Tunnel Prevention',
      description: 'Triple your clicking power',
      price: 500,
      type: UpgradeType.clickPower,
      multiplier: 3.0,
      requirement: UpgradeRequirement(totalClicks: 500),
      icon: Icons.pan_tool,
      emoji: '🖐️',
    ),
    Upgrade(
      id: 'click3',
      name: 'Ambidextrous',
      description: '5x clicking power',
      price: 10000,
      type: UpgradeType.clickPower,
      multiplier: 5.0,
      requirement: UpgradeRequirement(totalClicks: 2000),
      icon: Icons.sign_language,
      emoji: '👏',
    ),

    // Auto Clicker upgrades
    Upgrade(
      id: 'cursor1',
      name: 'Faster Cursors',
      description: 'Auto Clickers are twice as efficient',
      price: 100,
      type: UpgradeType.generatorBoost,
      targetGenerator: 'cursor',
      multiplier: 2.0,
      requirement: UpgradeRequirement(generatorId: 'cursor', generatorCount: 1),
      icon: Icons.mouse,
      emoji: '🖱️',
    ),
    Upgrade(
      id: 'cursor2',
      name: 'Quantum Cursors',
      description: 'Auto Clickers are twice as efficient again',
      price: 500,
      type: UpgradeType.generatorBoost,
      targetGenerator: 'cursor',
      multiplier: 2.0,
      requirement: UpgradeRequirement(generatorId: 'cursor', generatorCount: 10),
      icon: Icons.science,
      emoji: '⚛️',
    ),

    // Grandma upgrades
    Upgrade(
      id: 'grandma1',
      name: "Grandma's Secret Recipe",
      description: 'Grandmas are twice as efficient',
      price: 1000,
      type: UpgradeType.generatorBoost,
      targetGenerator: 'grandma',
      multiplier: 2.0,
      requirement: UpgradeRequirement(generatorId: 'grandma', generatorCount: 1),
      icon: Icons.cookie,
      emoji: '🍪',
    ),
    Upgrade(
      id: 'grandma2',
      name: 'Grandma Army',
      description: 'Grandmas are twice as efficient again',
      price: 5000,
      type: UpgradeType.generatorBoost,
      targetGenerator: 'grandma',
      multiplier: 2.0,
      requirement: UpgradeRequirement(generatorId: 'grandma', generatorCount: 10),
      icon: Icons.groups,
      emoji: '👵👵',
    ),

    // Farm upgrades
    Upgrade(
      id: 'farm1',
      name: 'Fertilizer',
      description: 'Coin Farms are twice as efficient',
      price: 11000,
      type: UpgradeType.generatorBoost,
      targetGenerator: 'farm',
      multiplier: 2.0,
      requirement: UpgradeRequirement(generatorId: 'farm', generatorCount: 1),
      icon: Icons.water_drop,
      emoji: '💧',
    ),
    Upgrade(
      id: 'farm2',
      name: 'Irrigation',
      description: 'Coin Farms are twice as efficient again',
      price: 55000,
      type: UpgradeType.generatorBoost,
      targetGenerator: 'farm',
      multiplier: 2.0,
      requirement: UpgradeRequirement(generatorId: 'farm', generatorCount: 10),
      icon: Icons.shower,
      emoji: '🚿',
    ),

    // Global upgrades
    Upgrade(
      id: 'global1',
      name: 'Lucky Coin',
      description: 'All production increased by 10%',
      price: 77777,
      type: UpgradeType.globalMultiplier,
      multiplier: 1.1,
      requirement: UpgradeRequirement(totalCoins: 50000),
      icon: Icons.star,
      emoji: '🍀',
    ),
    Upgrade(
      id: 'global2',
      name: 'Golden Touch',
      description: 'All production increased by 25%',
      price: 777777,
      type: UpgradeType.globalMultiplier,
      multiplier: 1.25,
      requirement: UpgradeRequirement(totalCoins: 500000),
      icon: Icons.auto_awesome,
      emoji: '✨',
    ),
  ];
}
