import 'package:flutter/material.dart';

enum UpgradeCategory { bot, infrastructure, research, passive }

class BotUpgrade {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final IconData icon;
  final UpgradeCategory category;
  final double basePrice;
  final double priceMultiplier; // Price increases per level
  final int maxLevel;

  // Effects per level
  final double edgePerLevel; // +edge bonus
  final double speedPerLevel; // +trades/sec for bot
  final double tradeSizePerLevel; // +% trade size
  final double passiveIncomePerLevel; // $/sec passive income

  const BotUpgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.icon,
    required this.category,
    required this.basePrice,
    this.priceMultiplier = 1.5,
    this.maxLevel = 10,
    this.edgePerLevel = 0,
    this.speedPerLevel = 0,
    this.tradeSizePerLevel = 0,
    this.passiveIncomePerLevel = 0,
  });

  double getPrice(int currentLevel) {
    return basePrice * (priceMultiplier * currentLevel + 1);
  }

  static const List<BotUpgrade> allUpgrades = [
    // Bot Tier - Unlocks and improves automated trading
    BotUpgrade(
      id: 'basic_bot',
      name: 'Basic Trading Bot',
      description: 'Automates trades at 0.1/sec',
      emoji: '🤖',
      icon: Icons.smart_toy,
      category: UpgradeCategory.bot,
      basePrice: 5000, // Was 500 - need to grind for this!
      maxLevel: 1,
      speedPerLevel: 0.1,
    ),
    BotUpgrade(
      id: 'bot_speed',
      name: 'Faster Execution',
      description: '+0.1 trades/sec per level',
      emoji: '⚡',
      icon: Icons.speed,
      category: UpgradeCategory.bot,
      basePrice: 8000, // Was 1000
      priceMultiplier: 2.5,
      maxLevel: 20,
      speedPerLevel: 0.1,
    ),
    BotUpgrade(
      id: 'bot_size',
      name: 'Larger Positions',
      description: '+10% trade size per level',
      emoji: '📦',
      icon: Icons.expand,
      category: UpgradeCategory.bot,
      basePrice: 15000, // Was 2000
      priceMultiplier: 2.0,
      maxLevel: 15,
      tradeSizePerLevel: 0.1,
    ),

    // Infrastructure Tier - General improvements
    BotUpgrade(
      id: 'data_feed',
      name: 'Premium Data Feed',
      description: '+0.5% edge per level',
      emoji: '📡',
      icon: Icons.cell_tower,
      category: UpgradeCategory.infrastructure,
      basePrice: 20000, // Was 2500
      priceMultiplier: 2.5,
      maxLevel: 10,
      edgePerLevel: 0.005,
    ),
    BotUpgrade(
      id: 'servers',
      name: 'Dedicated Servers',
      description: '+0.05 trades/sec per level',
      emoji: '🖥️',
      icon: Icons.dns,
      category: UpgradeCategory.infrastructure,
      basePrice: 35000, // Was 5000
      priceMultiplier: 3.0,
      maxLevel: 10,
      speedPerLevel: 0.05,
    ),
    BotUpgrade(
      id: 'colocation',
      name: 'Exchange Colocation',
      description: '+1% edge per level (proximity advantage)',
      emoji: '🏢',
      icon: Icons.domain,
      category: UpgradeCategory.infrastructure,
      basePrice: 250000, // Was 50000
      priceMultiplier: 3.5,
      maxLevel: 5,
      edgePerLevel: 0.01,
    ),

    // Research Tier - ML and analysis improvements
    BotUpgrade(
      id: 'basic_ml',
      name: 'Basic ML Model',
      description: '+1% edge per level',
      emoji: '🧠',
      icon: Icons.psychology,
      category: UpgradeCategory.research,
      basePrice: 40000, // Was 5000
      priceMultiplier: 2.5,
      maxLevel: 10,
      edgePerLevel: 0.01,
    ),
    BotUpgrade(
      id: 'neural_net',
      name: 'Neural Network',
      description: '+2% edge per level',
      emoji: '🕸️',
      icon: Icons.hub,
      category: UpgradeCategory.research,
      basePrice: 150000, // Was 25000
      priceMultiplier: 3.0,
      maxLevel: 10,
      edgePerLevel: 0.02,
    ),
    BotUpgrade(
      id: 'sentiment',
      name: 'Sentiment Analysis',
      description: '+1.5% edge per level',
      emoji: '📰',
      icon: Icons.article,
      category: UpgradeCategory.research,
      basePrice: 80000, // Was 15000
      priceMultiplier: 2.5,
      maxLevel: 10,
      edgePerLevel: 0.015,
    ),
    BotUpgrade(
      id: 'quant_team',
      name: 'Quant Researchers',
      description: '+3% edge per level',
      emoji: '👨‍🔬',
      icon: Icons.science,
      category: UpgradeCategory.research,
      basePrice: 500000, // Was 100000
      priceMultiplier: 4.0,
      maxLevel: 5,
      edgePerLevel: 0.03,
    ),

    // Passive Income Tier - Money without clicking!
    BotUpgrade(
      id: 'side_hustle',
      name: 'Side Hustle',
      emoji: '🛒',
      description: '+\$0.05/sec per level (dropshipping)',
      icon: Icons.shopping_bag,
      category: UpgradeCategory.passive,
      basePrice: 500, // Cheap early unlock
      priceMultiplier: 2.0,
      maxLevel: 10,
      passiveIncomePerLevel: 0.05,
    ),
    BotUpgrade(
      id: 'vending_machines',
      name: 'Vending Machines',
      emoji: '🥤',
      description: '+\$0.15/sec per level',
      icon: Icons.local_drink,
      category: UpgradeCategory.passive,
      basePrice: 2000,
      priceMultiplier: 2.2,
      maxLevel: 10,
      passiveIncomePerLevel: 0.15,
    ),
    BotUpgrade(
      id: 'rental_property',
      name: 'Rental Property',
      emoji: '🏠',
      description: '+\$0.50/sec per level',
      icon: Icons.home,
      category: UpgradeCategory.passive,
      basePrice: 15000,
      priceMultiplier: 2.5,
      maxLevel: 5,
      passiveIncomePerLevel: 0.50,
    ),
    BotUpgrade(
      id: 'dividend_portfolio',
      name: 'Dividend Portfolio',
      emoji: '💰',
      description: '+\$1.00/sec per level',
      icon: Icons.account_balance,
      category: UpgradeCategory.passive,
      basePrice: 50000,
      priceMultiplier: 3.0,
      maxLevel: 5,
      passiveIncomePerLevel: 1.0,
    ),
    BotUpgrade(
      id: 'laundromat',
      name: 'Laundromat Chain',
      emoji: '🧺',
      description: '+\$2.50/sec per level',
      icon: Icons.local_laundry_service,
      category: UpgradeCategory.passive,
      basePrice: 200000,
      priceMultiplier: 3.5,
      maxLevel: 5,
      passiveIncomePerLevel: 2.5,
    ),
    BotUpgrade(
      id: 'business_empire',
      name: 'Business Empire',
      emoji: '🏰',
      description: '+\$10/sec per level (end game)',
      icon: Icons.castle,
      category: UpgradeCategory.passive,
      basePrice: 1000000,
      priceMultiplier: 4.0,
      maxLevel: 10,
      passiveIncomePerLevel: 10.0,
    ),
  ];

  static BotUpgrade? getById(String id) {
    try {
      return allUpgrades.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }
}
