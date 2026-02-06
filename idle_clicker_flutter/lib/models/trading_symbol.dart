import 'package:flutter/material.dart';

class TradingSymbol {
  final String id;
  final String name;
  final String emoji;
  final IconData icon;
  final double unlockPrice;
  final double volatility; // Higher = bigger swings
  final double baseTradeSize; // Base $ per trade
  final int mlTradesRequired; // Trades needed for +1% edge

  const TradingSymbol({
    required this.id,
    required this.name,
    required this.emoji,
    required this.icon,
    required this.unlockPrice,
    required this.volatility,
    required this.baseTradeSize,
    required this.mlTradesRequired,
  });

  static const List<TradingSymbol> allSymbols = [
    TradingSymbol(
      id: 'stocks',
      name: 'Stocks',
      emoji: '📈',
      icon: Icons.show_chart,
      unlockPrice: 0, // Free, starting symbol
      volatility: 1.0,
      baseTradeSize: 10,
      mlTradesRequired: 100,
    ),
    TradingSymbol(
      id: 'crypto',
      name: 'Crypto',
      emoji: '₿',
      icon: Icons.currency_bitcoin,
      unlockPrice: 1000,
      volatility: 2.5, // Very volatile
      baseTradeSize: 25,
      mlTradesRequired: 150,
    ),
    TradingSymbol(
      id: 'forex',
      name: 'Forex',
      emoji: '💱',
      icon: Icons.currency_exchange,
      unlockPrice: 5000,
      volatility: 0.5, // Less volatile
      baseTradeSize: 50,
      mlTradesRequired: 200,
    ),
    TradingSymbol(
      id: 'options',
      name: 'Options',
      emoji: '📊',
      icon: Icons.candlestick_chart,
      unlockPrice: 25000,
      volatility: 3.0, // Very risky
      baseTradeSize: 100,
      mlTradesRequired: 300,
    ),
    TradingSymbol(
      id: 'futures',
      name: 'Futures',
      emoji: '🛢️',
      icon: Icons.oil_barrel,
      unlockPrice: 100000,
      volatility: 1.5,
      baseTradeSize: 250,
      mlTradesRequired: 400,
    ),
    TradingSymbol(
      id: 'commodities',
      name: 'Commodities',
      emoji: '🥇',
      icon: Icons.diamond,
      unlockPrice: 500000,
      volatility: 1.2,
      baseTradeSize: 500,
      mlTradesRequired: 500,
    ),
  ];

  static TradingSymbol? getById(String id) {
    try {
      return allSymbols.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
