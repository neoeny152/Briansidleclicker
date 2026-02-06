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
              // Stats Grid
              _StatsCard(
                title: 'Current Run',
                stats: [
                  _StatItem(
                    'Total Coins',
                    FormattingUtils.formatNumber(viewModel.gameState.coins),
                  ),
                  _StatItem(
                    'Coins Earned',
                    FormattingUtils.formatNumber(viewModel.gameState.totalCoinsEarned),
                  ),
                  _StatItem(
                    'Total Clicks',
                    '${viewModel.gameState.totalClicks}',
                  ),
                  _StatItem(
                    'Coins per Click',
                    FormattingUtils.formatNumber(viewModel.effectiveCoinsPerClick),
                  ),
                  _StatItem(
                    'Coins per Second',
                    FormattingUtils.formatNumber(viewModel.gameState.coinsPerSecond),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Multipliers
              _StatsCard(
                title: 'Multipliers',
                stats: [
                  _StatItem(
                    'Click Multiplier',
                    '${FormattingUtils.formatNumber(viewModel.gameState.clickMultiplier)}x',
                  ),
                  _StatItem(
                    'Global Multiplier',
                    '${FormattingUtils.formatNumber(viewModel.gameState.globalMultiplier)}x',
                  ),
                  _StatItem(
                    'Prestige Multiplier',
                    '${FormattingUtils.formatNumber(viewModel.gameState.prestigeMultiplier)}x',
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Prestige Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF0F3460)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Prestige',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _PrestigeStat(
                          'Points',
                          '${viewModel.gameState.prestigePoints}',
                        ),
                        _PrestigeStat(
                          'Prestiges',
                          '${viewModel.gameState.totalPrestiges}',
                        ),
                        _PrestigeStat(
                          'Potential',
                          '+${viewModel.potentialPrestigePoints}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    if (viewModel.potentialPrestigePoints > 0)
                      ElevatedButton(
                        onPressed: () => _confirmPrestige(context, viewModel),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9333EA),
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
                          'Prestige (+${viewModel.potentialPrestigePoints} points)',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    else
                      const Text(
                        'Earn 1 billion coins to unlock prestige',
                        style: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 14,
                        ),
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
                      child: const Text('Reset Game'),
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

  void _confirmPrestige(BuildContext context, GameViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text(
          'Prestige?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'You will gain ${viewModel.potentialPrestigePoints} prestige points but lose all coins, generators, and upgrades.',
          style: const TextStyle(color: Color(0xFF888888)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.performPrestige();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9333EA),
            ),
            child: const Text('Prestige'),
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
          'This will delete ALL progress including prestige points. Are you sure?',
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
                        color: Color(0xFFFFD700),
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
            color: Color(0xFF9333EA),
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
