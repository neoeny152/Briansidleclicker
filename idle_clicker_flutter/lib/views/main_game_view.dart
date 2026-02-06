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

                  // Trade Button
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
                  ),

                  const SizedBox(height: 20),

                  // Trade size info
                  Text(
                    'Trade Size: \$${FormattingUtils.formatNumber(viewModel.effectiveTradeSize)}',
                    style: const TextStyle(color: Color(0xFF888888)),
                  ),

                  const Spacer(),

                  // Work Button
                  if (!viewModel.isWorking)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => viewModel.startWorking(),
                        icon: const Icon(Icons.work),
                        label: Text(
                          'Go to Work (+\$${FormattingUtils.formatNumber(5.0 + viewModel.gameState.totalWorkSessions * 0.5)})',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F3460),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16213E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF0F3460)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Working...',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${viewModel.workSecondsRemaining}s remaining',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFD700),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

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

  _FloatingNumberData({
    required this.id,
    required this.text,
    required this.isPositive,
    required this.position,
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
