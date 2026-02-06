import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/game_view_model.dart';
import '../models/generator.dart';
import '../models/upgrade.dart';
import '../widgets/generator_row.dart';
import '../widgets/upgrade_row.dart';

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar
        Container(
          margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: const Color(0xFF0F3460),
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: const Color(0xFFFFD700),
            unselectedLabelColor: const Color(0xFF888888),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'Generators'),
              Tab(text: 'Upgrades'),
            ],
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _GeneratorsTab(),
              _UpgradesTab(),
            ],
          ),
        ),
      ],
    );
  }
}

class _GeneratorsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: Generator.allGenerators.length,
          itemBuilder: (context, index) {
            final generator = Generator.allGenerators[index];
            final owned = viewModel.gameState.ownedGenerators[generator.id] ?? 0;
            final price = generator.price(owned);
            final canAfford = viewModel.gameState.coins >= price;
            final multiplier =
                viewModel.generatorMultipliers[generator.id] ?? 1.0;
            final production = generator.production(owned, multiplier: multiplier) *
                viewModel.gameState.globalMultiplier *
                viewModel.gameState.prestigeMultiplier;

            return GeneratorRow(
              generator: generator,
              owned: owned,
              currentPrice: price,
              canAfford: canAfford,
              production: production,
              onBuy: () => viewModel.buyGenerator(generator),
            );
          },
        );
      },
    );
  }
}

class _UpgradesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        final available = viewModel.availableUpgrades;
        final purchased = viewModel.purchasedUpgrades;
        final allVisible = [...available, ...purchased];

        if (allVisible.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '🔒',
                  style: TextStyle(fontSize: 48),
                ),
                SizedBox(height: 16),
                Text(
                  'No upgrades available yet',
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Keep clicking and buying generators!',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: allVisible.length,
          itemBuilder: (context, index) {
            final upgrade = allVisible[index];
            final isPurchased =
                viewModel.gameState.purchasedUpgrades.contains(upgrade.id);
            final canAfford = viewModel.canAffordUpgrade(upgrade);

            return UpgradeRow(
              upgrade: upgrade,
              canAfford: canAfford,
              isPurchased: isPurchased,
              onBuy: () => viewModel.buyUpgrade(upgrade),
            );
          },
        );
      },
    );
  }
}
