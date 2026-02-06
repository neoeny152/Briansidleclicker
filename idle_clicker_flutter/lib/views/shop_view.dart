import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/game_view_model.dart';
import '../models/trading_symbol.dart';
import '../models/bot_upgrade.dart';
import '../models/online_course.dart';
import '../services/formatting_utils.dart';

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
    _tabController = TabController(length: 5, vsync: this);
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
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: const Color(0xFF4ADE80),
              unselectedLabelColor: const Color(0xFF888888),
              dividerColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              tabs: const [
                Tab(text: 'Courses'),
                Tab(text: 'Passive'),
                Tab(text: 'Bot'),
                Tab(text: 'Research'),
                Tab(text: 'Markets'),
              ],
            ),
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _CoursesTab(),
              _PassiveIncomeTab(),
              _BotUpgradesTab(),
              _ResearchTab(),
              _MarketsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// _CareerTab and _YouTubeTab moved to career_view.dart

class _CoursesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        // Shuffle courses but keep order deterministic per session
        final courses = List<OnlineCourse>.from(OnlineCourse.allCourses);

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: courses.length + 1, // +1 for header
          itemBuilder: (context, index) {
            if (index == 0) {
              // Header with course edge bonus
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Course Edge Bonus:',
                      style: TextStyle(color: Color(0xFF888888)),
                    ),
                    Text(
                      '+${(viewModel.gameState.courseEdgeBonus * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4ADE80),
                      ),
                    ),
                  ],
                ),
              );
            }

            final course = courses[index - 1];
            return _CourseCard(course: course, viewModel: viewModel);
          },
        );
      },
    );
  }
}

class _CourseCard extends StatelessWidget {
  final OnlineCourse course;
  final GameViewModel viewModel;

  const _CourseCard({required this.course, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final isPurchased = viewModel.hasPurchasedCourse(course.id);
    final canAfford = viewModel.gameState.balance >= course.price && !isPurchased;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPurchased
              ? (course.isScam ? const Color(0xFFE94560) : const Color(0xFF4ADE80))
              : canAfford
                  ? const Color(0xFFFFD700)
                  : const Color(0xFF0F3460),
          width: isPurchased ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  course.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isPurchased ? course.revealedDescription : course.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isPurchased
                              ? (course.isScam
                                  ? const Color(0xFFE94560)
                                  : const Color(0xFF4ADE80))
                              : const Color(0xFF888888),
                          fontStyle: isPurchased ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isPurchased)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: course.isScam
                          ? const Color(0xFFE94560).withOpacity(0.2)
                          : const Color(0xFF4ADE80).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      course.isScam ? 'SCAM!' : '+${(course.edgeBonus * 100).toStringAsFixed(1)}% Edge',
                      style: TextStyle(
                        color: course.isScam
                            ? const Color(0xFFE94560)
                            : const Color(0xFF4ADE80),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                else
                  Text(
                    '\$${FormattingUtils.formatNumber(course.price)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: canAfford
                          ? const Color(0xFFFFD700)
                          : const Color(0xFFE94560),
                    ),
                  ),
                if (!isPurchased)
                  ElevatedButton(
                    onPressed: canAfford
                        ? () {
                            final wasLegit = viewModel.purchaseCourse(course);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  wasLegit
                                      ? 'Great course! +${(course.edgeBonus * 100).toStringAsFixed(1)}% edge'
                                      : 'This was a SCAM! Money wasted...',
                                ),
                                backgroundColor: wasLegit
                                    ? const Color(0xFF4ADE80)
                                    : const Color(0xFFE94560),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canAfford
                          ? const Color(0xFFFFD700)
                          : const Color(0xFF0F3460),
                      foregroundColor:
                          canAfford ? Colors.black : const Color(0xFF888888),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Enroll',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PassiveIncomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final upgrades = BotUpgrade.allUpgrades
        .where((u) => u.category == UpgradeCategory.passive)
        .toList();

    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            // Passive income summary card
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF16213E),
                    const Color(0xFF4ADE80).withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF4ADE80), width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    '💤 Passive Income',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${FormattingUtils.formatNumber(viewModel.passiveIncome)}/sec',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4ADE80),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Money while you sleep!',
                    style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
                  ),
                ],
              ),
            ),
            // Upgrade list
            ...upgrades.map((upgrade) => _UpgradeCard(
                  upgrade: upgrade,
                  viewModel: viewModel,
                )),
          ],
        );
      },
    );
  }
}

class _BotUpgradesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final upgrades = BotUpgrade.allUpgrades
        .where((u) =>
            u.category == UpgradeCategory.bot ||
            u.category == UpgradeCategory.infrastructure)
        .toList();

    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: upgrades.length,
          itemBuilder: (context, index) {
            final upgrade = upgrades[index];
            return _UpgradeCard(upgrade: upgrade, viewModel: viewModel);
          },
        );
      },
    );
  }
}

class _ResearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final upgrades = BotUpgrade.allUpgrades
        .where((u) => u.category == UpgradeCategory.research)
        .toList();

    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: upgrades.length,
          itemBuilder: (context, index) {
            final upgrade = upgrades[index];
            return _UpgradeCard(upgrade: upgrade, viewModel: viewModel);
          },
        );
      },
    );
  }
}

class _MarketsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: TradingSymbol.allSymbols.length,
          itemBuilder: (context, index) {
            final symbol = TradingSymbol.allSymbols[index];
            return _SymbolCard(symbol: symbol, viewModel: viewModel);
          },
        );
      },
    );
  }
}

class _UpgradeCard extends StatelessWidget {
  final BotUpgrade upgrade;
  final GameViewModel viewModel;

  const _UpgradeCard({required this.upgrade, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final currentLevel = viewModel.gameState.botUpgrades[upgrade.id] ?? 0;
    final isMaxed = currentLevel >= upgrade.maxLevel;
    final price = upgrade.getPrice(currentLevel);
    final canAfford = viewModel.gameState.balance >= price && !isMaxed;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: canAfford
              ? const Color(0xFF4ADE80)
              : isMaxed
                  ? const Color(0xFF4ADE80)
                  : const Color(0xFF0F3460),
          width: canAfford || isMaxed ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  upgrade.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        upgrade.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F3460),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$currentLevel/${upgrade.maxLevel}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    upgrade.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),

            // Price & Buy
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMaxed)
                  Text(
                    '\$${FormattingUtils.formatNumber(price)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: canAfford
                          ? const Color(0xFF4ADE80)
                          : const Color(0xFFE94560),
                    ),
                  ),
                const SizedBox(height: 5),
                if (isMaxed)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ADE80),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'MAXED',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: canAfford
                        ? () => viewModel.buyUpgrade(upgrade)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canAfford
                          ? const Color(0xFF4ADE80)
                          : const Color(0xFF0F3460),
                      foregroundColor:
                          canAfford ? Colors.black : const Color(0xFF888888),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Buy',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SymbolCard extends StatelessWidget {
  final TradingSymbol symbol;
  final GameViewModel viewModel;

  const _SymbolCard({required this.symbol, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = viewModel.gameState.unlockedSymbols[symbol.id] == true;
    final isActive = viewModel.gameState.activeSymbol == symbol.id;
    final canAfford = viewModel.gameState.balance >= symbol.unlockPrice;
    final symbolEdge = viewModel.gameState.symbolEdges[symbol.id] ?? 0;
    final trades = viewModel.gameState.symbolTradeCount[symbol.id] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? const Color(0xFF4ADE80)
              : isUnlocked
                  ? const Color(0xFF0F3460)
                  : canAfford
                      ? const Color(0xFFFFD700)
                      : const Color(0xFF0F3460),
          width: isActive ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  symbol.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symbol.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  if (isUnlocked) ...[
                    Text(
                      'ML Edge: +${(symbolEdge * 100).toStringAsFixed(0)}%  •  ${trades} trades',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4ADE80),
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    'Volatility: ${symbol.volatility}x  •  \$${symbol.baseTradeSize.toInt()}/trade',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),

            // Action
            if (isUnlocked)
              ElevatedButton(
                onPressed: isActive ? null : () => viewModel.selectSymbol(symbol.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive
                      ? const Color(0xFF4ADE80)
                      : const Color(0xFF0F3460),
                  foregroundColor:
                      isActive ? Colors.black : const Color(0xFFFFFFFF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  isActive ? 'Active' : 'Select',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${FormattingUtils.formatNumber(symbol.unlockPrice)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: canAfford
                          ? const Color(0xFFFFD700)
                          : const Color(0xFFE94560),
                    ),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed:
                        canAfford ? () => viewModel.unlockSymbol(symbol) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canAfford
                          ? const Color(0xFFFFD700)
                          : const Color(0xFF0F3460),
                      foregroundColor:
                          canAfford ? Colors.black : const Color(0xFF888888),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Unlock',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
