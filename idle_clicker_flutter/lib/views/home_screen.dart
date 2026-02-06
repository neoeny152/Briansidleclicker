import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/game_view_model.dart';
import '../services/formatting_utils.dart';
import 'main_game_view.dart';
import 'shop_view.dart';
import 'stats_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    MainGameView(),
    ShopView(),
    StatsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            _Header(),

            // Main content
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),

            // Bottom navigation
            SafeArea(
              top: false,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF16213E),
                  border: Border(
                    top: BorderSide(color: Color(0xFF0F3460)),
                  ),
                ),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) => setState(() => _currentIndex = index),
                  backgroundColor: Colors.transparent,
                  selectedItemColor: const Color(0xFF4ADE80),
                  unselectedItemColor: const Color(0xFF888888),
                  elevation: 0,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.show_chart),
                      label: 'Trade',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart),
                      label: 'Upgrades',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart),
                      label: 'Stats',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: const BoxDecoration(
            color: Color(0xFF16213E),
            border: Border(
              bottom: BorderSide(color: Color(0xFF0F3460)),
            ),
          ),
          child: Column(
            children: [
              // Balance display
              Text(
                '\$${FormattingUtils.formatNumber(viewModel.gameState.balance)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4ADE80),
                ),
              ),
              const SizedBox(height: 5),
              // P&L display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '↑ \$${FormattingUtils.formatNumber(viewModel.gameState.totalEarned)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4ADE80),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '↓ \$${FormattingUtils.formatNumber(viewModel.gameState.totalLost)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFE94560),
                    ),
                  ),
                  if (viewModel.gameState.botEnabled) ...[
                    const SizedBox(width: 16),
                    const Icon(Icons.smart_toy, size: 14, color: Color(0xFF4ADE80)),
                    const SizedBox(width: 4),
                    Text(
                      '${viewModel.gameState.botTradesPerSecond.toStringAsFixed(1)}/s',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4ADE80),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
