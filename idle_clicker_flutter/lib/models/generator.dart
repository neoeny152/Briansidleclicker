import 'dart:math';
import 'package:flutter/material.dart';

class Generator {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final double baseProduction;
  final double priceMultiplier;
  final IconData icon;
  final String emoji;

  const Generator({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.baseProduction,
    this.priceMultiplier = 1.15,
    required this.icon,
    required this.emoji,
  });

  double price(int owned) => basePrice * pow(priceMultiplier, owned);

  double production(int owned, {double multiplier = 1.0}) =>
      baseProduction * owned * multiplier;

  static const List<Generator> allGenerators = [
    Generator(
      id: 'cursor',
      name: 'Auto Clicker',
      description: 'Clicks for you automatically',
      basePrice: 15,
      baseProduction: 0.1,
      icon: Icons.mouse,
      emoji: '👆',
    ),
    Generator(
      id: 'grandma',
      name: 'Grandma',
      description: 'A nice grandma to help click',
      basePrice: 100,
      baseProduction: 1,
      icon: Icons.person,
      emoji: '👵',
    ),
    Generator(
      id: 'farm',
      name: 'Coin Farm',
      description: 'Grows coins organically',
      basePrice: 1100,
      baseProduction: 8,
      icon: Icons.eco,
      emoji: '🌾',
    ),
    Generator(
      id: 'mine',
      name: 'Coin Mine',
      description: 'Digs deep for precious coins',
      basePrice: 12000,
      baseProduction: 47,
      icon: Icons.hardware,
      emoji: '⛏️',
    ),
    Generator(
      id: 'factory',
      name: 'Coin Factory',
      description: 'Mass produces coins',
      basePrice: 130000,
      baseProduction: 260,
      icon: Icons.factory,
      emoji: '🏭',
    ),
    Generator(
      id: 'bank',
      name: 'Coin Bank',
      description: 'Generates interest on coins',
      basePrice: 1400000,
      baseProduction: 1400,
      icon: Icons.account_balance,
      emoji: '🏦',
    ),
    Generator(
      id: 'temple',
      name: 'Coin Temple',
      description: 'Prays for coin prosperity',
      basePrice: 20000000,
      baseProduction: 7800,
      icon: Icons.temple_buddhist,
      emoji: '🛕',
    ),
    Generator(
      id: 'wizard',
      name: 'Wizard Tower',
      description: 'Conjures coins from thin air',
      basePrice: 330000000,
      baseProduction: 44000,
      icon: Icons.auto_awesome,
      emoji: '🧙',
    ),
    Generator(
      id: 'portal',
      name: 'Coin Portal',
      description: 'Imports coins from another dimension',
      basePrice: 5100000000,
      baseProduction: 260000,
      icon: Icons.blur_circular,
      emoji: '🌀',
    ),
    Generator(
      id: 'timemachine',
      name: 'Time Machine',
      description: 'Brings coins from the future',
      basePrice: 75000000000,
      baseProduction: 1600000,
      icon: Icons.history,
      emoji: '⏰',
    ),
  ];
}
