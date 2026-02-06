import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/game_view_model.dart';
import '../services/formatting_utils.dart';

class MainGameView extends StatefulWidget {
  const MainGameView({super.key});

  @override
  State<MainGameView> createState() => _MainGameViewState();
}

class _MainGameViewState extends State<MainGameView> with SingleTickerProviderStateMixin {
  final List<_FloatingNumberData> _floatingNumbers = [];
  int _nextId = 0;

  void _handleTrade(GameViewModel viewModel) {
    viewModel.manualTrade();

    final outcome = viewModel.lastTradeOutcome;
    if (outcome == null) return;

    final random = Random();
    final offsetX = random.nextDouble() * 80 - 40;
    final offsetY = random.nextDouble() * 30 - 15;

    setState(() {
      if (_floatingNumbers.length > 10) {
        _floatingNumbers.removeAt(0);
      }
      _floatingNumbers.add(_FloatingNumberData(
        id: _nextId++,
        text: outcome.isWin
            ? '+\$${FormattingUtils.formatNumber(outcome.amount)}'
            : '-\$${FormattingUtils.formatNumber(outcome.amount.abs())}',
        isPositive: outcome.isWin,
        position: Offset(
          MediaQuery.of(context).size.width / 2 + offsetX,
          MediaQuery.of(context).size.height * 0.35 + offsetY,
        ),
      ));
    });
  }

  void _handleWorkClick(GameViewModel viewModel) {
    if (!viewModel.isWorking) return;

    viewModel.clickWork();
    final earnings = viewModel.currentClickWage;

    final random = Random();
    final offsetX = random.nextDouble() * 80 - 40;
    final offsetY = random.nextDouble() * 30 - 15;

    setState(() {
      if (_floatingNumbers.length > 10) {
        _floatingNumbers.removeAt(0);
      }
      _floatingNumbers.add(_FloatingNumberData(
        id: _nextId++,
        text: '+\$${FormattingUtils.formatNumber(earnings)}',
        isPositive: true,
        position: Offset(
          MediaQuery.of(context).size.width / 2 + offsetX,
          MediaQuery.of(context).size.height * 0.35 + offsetY,
        ),
      ));
    });
  }

  void _handleDip(GameViewModel viewModel) {
    final outcome = viewModel.buyTheDip();

    final random = Random();
    final offsetX = random.nextDouble() * 80 - 40;
    final offsetY = random.nextDouble() * 30 - 15;

    String text;
    if (outcome.result == DipResult.wipe) {
      text = 'WIPED!';
    } else if (outcome.isWin) {
      text = '+\$${FormattingUtils.formatNumber(outcome.amount)}';
    } else {
      text = '-\$${FormattingUtils.formatNumber(outcome.amount.abs())}';
    }

    setState(() {
      if (_floatingNumbers.length > 10) {
        _floatingNumbers.removeAt(0);
      }
      _floatingNumbers.add(_FloatingNumberData(
        id: _nextId++,
        text: text,
        isPositive: outcome.isWin,
        isJackpot: outcome.result == DipResult.jackpot,
        position: Offset(
          MediaQuery.of(context).size.width / 2 + offsetX,
          MediaQuery.of(context).size.height * 0.5 + offsetY,
        ),
      ));
    });
  }

  void _removeFloatingNumber(int id) {
    setState(() {
      _floatingNumbers.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        final edge = viewModel.effectiveEdge;
        final edgePercent = (edge * 100).toStringAsFixed(1);
        final isPositiveEdge = edge >= 0;

        return Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Edge & Stats Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16213E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF0F3460)),
                    ),
                    child: Column(
                      children: [
                        // Current symbol
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              viewModel.activeSymbol.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              viewModel.activeSymbol.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Edge display
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              label: 'Edge',
                              value: '${isPositiveEdge ? '+' : ''}$edgePercent%',
                              valueColor: isPositiveEdge
                                  ? const Color(0xFF4ADE80)
                                  : const Color(0xFFE94560),
                            ),
                            _StatItem(
                              label: 'Win Rate',
                              value: '${(viewModel.winRate * 100).toStringAsFixed(1)}%',
                              valueColor: Colors.white,
                            ),
                            _StatItem(
                              label: 'Trades',
                              value: '${viewModel.gameState.totalTrades}',
                              valueColor: Colors.white,
                            ),
                          ],
                        ),
                        // ML Progress
                        if (viewModel.mlLevel > 0 || viewModel.mlProgress > 0) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Text('🧠 ML Level ${0}', style: TextStyle(fontSize: 12)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: viewModel.mlProgress,
                                    backgroundColor: const Color(0xFF0F3460),
                                    valueColor: const AlwaysStoppedAnimation(Color(0xFF4ADE80)),
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Trade Button (or Work Button when working)
                  if (!viewModel.isWorking)
                    // Normal Trade Button
                    GestureDetector(
                      onTap: () => _handleTrade(viewModel),
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF4ADE80), Color(0xFF22C55E)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4ADE80).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.show_chart, size: 48, color: Colors.white),
                            SizedBox(height: 4),
                            Text(
                              'TRADE',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    // Working - show Work button and optionally Trade button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Work Click Button
                        GestureDetector(
                          onTap: () => _handleWorkClick(viewModel),
                          child: Container(
                            width: viewModel.canTradeNow ? 120 : 160,
                            height: viewModel.canTradeNow ? 120 : 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFD700).withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.work, size: 36, color: Colors.white),
                                const SizedBox(height: 2),
                                Text(
                                  'WORK',
                                  style: TextStyle(
                                    fontSize: viewModel.canTradeNow ? 14 : 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${viewModel.workSecondsRemaining}s',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Trade button if allowed to trade at work
                        if (viewModel.canTradeNow) ...[
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () => _handleTrade(viewModel),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFF4ADE80), Color(0xFF22C55E)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF4ADE80).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.show_chart, size: 28, color: Colors.white),
                                  SizedBox(height: 2),
                                  Text(
                                    'TRADE',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                  const SizedBox(height: 20),

                  // Trade size info or work earnings
                  if (!viewModel.isWorking)
                    Text(
                      'Trade Size: \$${FormattingUtils.formatNumber(viewModel.effectiveTradeSize)}',
                      style: const TextStyle(color: Color(0xFF888888)),
                    )
                  else
                    Column(
                      children: [
                        Text(
                          '${viewModel.currentCareer.emoji} ${viewModel.currentCareer.title}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Click earnings: \$${FormattingUtils.formatNumber(viewModel.workClickEarnings)}',
                          style: const TextStyle(color: Color(0xFFFFD700)),
                        ),
                        Text(
                          '+\$${FormattingUtils.formatNumber(viewModel.currentWage)} completion bonus',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
                        ),
                        if (!viewModel.canTradeNow)
                          const Text(
                            'Trading locked at this career level',
                            style: TextStyle(fontSize: 10, color: Color(0xFFE94560)),
                          ),
                      ],
                    ),

                  const Spacer(),

                  // Go to Work Button (only when not working)
                  if (!viewModel.isWorking)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => viewModel.startWorking(),
                        icon: const Icon(Icons.work),
                        label: Column(
                          children: [
                            Text(
                              'Go to Work (+\$${FormattingUtils.formatNumber(viewModel.currentWage)})',
                            ),
                            Text(
                              '${viewModel.currentCareer.emoji} ${viewModel.currentCareer.title}',
                              style: const TextStyle(fontSize: 11, color: Color(0xFFAAAAAA)),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F3460),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Buy the Dip Button
                  _BuyTheDipButton(
                    viewModel: viewModel,
                    onDip: () => _handleDip(viewModel),
                  ),

                  const SizedBox(height: 12),

                  // Bot Status
                  if (viewModel.gameState.botEnabled)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16213E),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF4ADE80)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.smart_toy, color: Color(0xFF4ADE80)),
                          const SizedBox(width: 8),
                          Text(
                            'Bot: ${viewModel.gameState.botTradesPerSecond.toStringAsFixed(1)} trades/sec',
                            style: const TextStyle(color: Color(0xFF4ADE80)),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Floating numbers
            ..._floatingNumbers.map((data) => _FloatingNumber(
                  key: ValueKey(data.id),
                  text: data.text,
                  isPositive: data.isPositive,
                  position: data.position,
                  onComplete: () => _removeFloatingNumber(data.id),
                )),
          ],
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF888888),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _FloatingNumberData {
  final int id;
  final String text;
  final bool isPositive;
  final Offset position;
  final bool isJackpot;

  _FloatingNumberData({
    required this.id,
    required this.text,
    required this.isPositive,
    required this.position,
    this.isJackpot = false,
  });
}

class _FloatingNumber extends StatefulWidget {
  final String text;
  final bool isPositive;
  final Offset position;
  final VoidCallback onComplete;

  const _FloatingNumber({
    super.key,
    required this.text,
    required this.isPositive,
    required this.position,
    required this.onComplete,
  });

  @override
  State<_FloatingNumber> createState() => _FloatingNumberState();
}

class _FloatingNumberState extends State<_FloatingNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _translateY;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _translateY = Tween<double>(begin: 0, end: -60).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.position.dx - 50,
          top: widget.position.dy + _translateY.value,
          child: Opacity(
            opacity: _opacity.value,
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.isPositive
                    ? const Color(0xFF4ADE80)
                    : const Color(0xFFE94560),
                shadows: const [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black54,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BuyTheDipButton extends StatelessWidget {
  final GameViewModel viewModel;
  final VoidCallback onDip;

  const _BuyTheDipButton({
    required this.viewModel,
    required this.onDip,
  });

  @override
  Widget build(BuildContext context) {
    final isOnCooldown = viewModel.isDipOnCooldown;
    final cooldownSeconds = viewModel.dipCooldownSecondsRemaining;
    final streak = viewModel.dipStreak;
    final canDip = viewModel.gameState.balance > 0;

    // Determine risk level and colors
    Color buttonColor;
    Color borderColor;
    String riskLabel;

    if (!isOnCooldown) {
      buttonColor = const Color(0xFF0F3460);
      borderColor = const Color(0xFFFFD700);
      riskLabel = 'Safe Dip';
    } else if (streak == 1) {
      buttonColor = const Color(0xFF2D1B4E);
      borderColor = const Color(0xFFFF8C00);
      riskLabel = 'Risky! (${cooldownSeconds}s)';
    } else {
      buttonColor = const Color(0xFF4A1515);
      borderColor = const Color(0xFFE94560);
      riskLabel = 'DANGER! x$streak (${cooldownSeconds}s)';
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canDip ? onDip : null,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isOnCooldown ? '📉' : '📈',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BUY THE DIP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: canDip ? Colors.white : const Color(0xFF666666),
                      ),
                    ),
                    Text(
                      riskLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: isOnCooldown && streak > 1
                            ? const Color(0xFFE94560)
                            : isOnCooldown
                                ? const Color(0xFFFF8C00)
                                : const Color(0xFFFFD700),
                        fontWeight: isOnCooldown ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                if (isOnCooldown) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: streak > 1
                          ? const Color(0xFFE94560).withOpacity(0.3)
                          : const Color(0xFFFF8C00).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      streak > 1 ? 'WIPE RISK' : '10% WIPE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: streak > 1
                            ? const Color(0xFFE94560)
                            : const Color(0xFFFF8C00),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
