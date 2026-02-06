import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/game_view_model.dart';
import '../services/formatting_utils.dart';

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // Trading Stats
              _StatsCard(
                title: 'Trading Stats',
                stats: [
                  _StatItem(
                    'Balance',
                    '\$${FormattingUtils.formatNumber(viewModel.gameState.balance)}',
                  ),
                  _StatItem(
                    'Total Earned',
                    '\$${FormattingUtils.formatNumber(viewModel.gameState.totalEarned)}',
                  ),
                  _StatItem(
                    'Total Lost',
                    '\$${FormattingUtils.formatNumber(viewModel.gameState.totalLost)}',
                  ),
                  _StatItem(
                    'Total Trades',
                    '${viewModel.gameState.totalTrades}',
                  ),
                  _StatItem(
                    'Win Rate',
                    '${(viewModel.winRate * 100).toStringAsFixed(1)}%',
                  ),
                  _StatItem(
                    'Current Edge',
                    '${(viewModel.effectiveEdge * 100).toStringAsFixed(1)}%',
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Work Stats
              _StatsCard(
                title: 'Work Stats',
                stats: [
                  _StatItem(
                    'Work Sessions',
                    '${viewModel.gameState.totalWorkSessions}',
                  ),
                  _StatItem(
                    'Work Earnings',
                    '\$${FormattingUtils.formatNumber(viewModel.gameState.totalWorkEarnings)}',
                  ),
                  _StatItem(
                    'Career',
                    '${viewModel.currentCareer.emoji} ${viewModel.currentCareer.title}',
                  ),
                  _StatItem(
                    'Current Wage',
                    '\$${FormattingUtils.formatNumber(viewModel.currentWage)}',
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Dip Stats
              if (viewModel.gameState.totalDips > 0)
                _StatsCard(
                  title: 'Buy the Dip Stats',
                  stats: [
                    _StatItem(
                      'Total Dips',
                      '${viewModel.gameState.totalDips}',
                    ),
                    _StatItem(
                      'Dip Winnings',
                      '\$${FormattingUtils.formatNumber(viewModel.gameState.totalDipWinnings)}',
                    ),
                    _StatItem(
                      'Dip Losses',
                      '\$${FormattingUtils.formatNumber(viewModel.gameState.totalDipLosses)}',
                    ),
                    _StatItem(
                      'Net Dip P/L',
                      '\$${FormattingUtils.formatNumber(viewModel.gameState.totalDipWinnings - viewModel.gameState.totalDipLosses)}',
                    ),
                  ],
                ),

              if (viewModel.gameState.totalDips > 0) const SizedBox(height: 15),

              // Education Stats
              if (viewModel.gameState.purchasedCourses.isNotEmpty)
                _StatsCard(
                  title: 'Education',
                  stats: [
                    _StatItem(
                      'Courses Taken',
                      '${viewModel.gameState.purchasedCourses.length}',
                    ),
                    _StatItem(
                      'Course Edge Bonus',
                      '+${(viewModel.gameState.courseEdgeBonus * 100).toStringAsFixed(1)}%',
                    ),
                  ],
                ),

              if (viewModel.gameState.purchasedCourses.isNotEmpty) const SizedBox(height: 15),

              // YouTube Stats
              if (viewModel.gameState.hasYouTubeChannel)
                _StatsCard(
                  title: 'YouTube Channel',
                  stats: [
                    _StatItem(
                      'Level',
                      '${viewModel.youtubeLevel.emoji} ${viewModel.youtubeLevel.title}',
                    ),
                    _StatItem(
                      'Subscribers',
                      FormattingUtils.formatNumber(viewModel.gameState.subscribers.toDouble()),
                    ),
                    _StatItem(
                      'Videos',
                      '${viewModel.gameState.totalVideosPosted}',
                    ),
                    _StatItem(
                      'Credibility',
                      '${viewModel.gameState.credibility.toInt()}%',
                    ),
                    _StatItem(
                      'Ad Revenue',
                      '\$${FormattingUtils.formatNumber(viewModel.gameState.youtubeRevenue)}',
                    ),
                    if (viewModel.gameState.totalCourseRevenue > 0)
                      _StatItem(
                        'Course Sales',
                        '\$${FormattingUtils.formatNumber(viewModel.gameState.totalCourseRevenue)}',
                      ),
                  ],
                ),

              if (viewModel.gameState.hasYouTubeChannel) const SizedBox(height: 15),

              // Bot Stats
              if (viewModel.gameState.botEnabled)
                _StatsCard(
                  title: 'Bot Stats',
                  stats: [
                    _StatItem(
                      'Status',
                      'Active',
                    ),
                    _StatItem(
                      'Speed',
                      '${viewModel.gameState.botTradesPerSecond.toStringAsFixed(1)} trades/sec',
                    ),
                    _StatItem(
                      'Trade Size',
                      '\$${FormattingUtils.formatNumber(viewModel.effectiveTradeSize)}',
                    ),
                  ],
                ),

              if (viewModel.gameState.botEnabled) const SizedBox(height: 15),

              // Market Crash (Prestige) Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF16213E),
                      const Color(0xFF1A1A2E).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: viewModel.potentialCrashBonus > 0
                        ? const Color(0xFFE94560)
                        : const Color(0xFF0F3460),
                  ),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '📉',
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Market Crash',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE94560),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _PrestigeStat(
                          'Crashes',
                          '${viewModel.gameState.crashCount}',
                        ),
                        _PrestigeStat(
                          'Experience',
                          '${((viewModel.gameState.experienceMultiplier - 1) * 100).toStringAsFixed(0)}%',
                        ),
                        _PrestigeStat(
                          'Potential',
                          '+${viewModel.potentialCrashBonus}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Lifetime Earnings: \$${FormattingUtils.formatNumber(viewModel.gameState.totalLifetimeEarnings)}',
                      style: const TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (viewModel.potentialCrashBonus > 0)
                      ElevatedButton(
                        onPressed: () => _confirmCrash(context, viewModel),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE94560),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Trigger Crash (+${viewModel.potentialCrashBonus} experience)',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    else
                      const Column(
                        children: [
                          Text(
                            'Earn \$10,000 lifetime to unlock',
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Experience gives permanent edge bonus',
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => viewModel.saveGame(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F3460),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save Game'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _confirmReset(context, viewModel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F3460),
                        foregroundColor: const Color(0xFFE94560),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Reset All'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmCrash(BuildContext context, GameViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Row(
          children: [
            Text('📉 ', style: TextStyle(fontSize: 24)),
            Text(
              'Market Crash?',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You will gain +${viewModel.potentialCrashBonus} experience points (+${viewModel.potentialCrashBonus * 5}% permanent edge bonus)',
              style: const TextStyle(color: Color(0xFF4ADE80)),
            ),
            const SizedBox(height: 12),
            const Text(
              'You will lose:',
              style: TextStyle(color: Color(0xFFE94560)),
            ),
            const Text(
              '• All your balance\n• All bot upgrades\n• All unlocked markets\n• All ML training progress',
              style: TextStyle(color: Color(0xFF888888)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.marketCrash();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE94560),
            ),
            child: const Text('Crash Market'),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, GameViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text(
          'Reset Game?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will delete ALL progress including experience from crashes. Are you sure?',
          style: TextStyle(color: Color(0xFF888888)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.resetGame();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE94560),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final List<_StatItem> stats;

  const _StatsCard({required this.title, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0F3460)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ...stats.map((stat) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      stat.label,
                      style: const TextStyle(color: Color(0xFF888888)),
                    ),
                    Text(
                      stat.value,
                      style: const TextStyle(
                        color: Color(0xFF4ADE80),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;

  _StatItem(this.label, this.value);
}

class _PrestigeStat extends StatelessWidget {
  final String label;
  final String value;

  const _PrestigeStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE94560),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF888888),
          ),
        ),
      ],
    );
  }
}
