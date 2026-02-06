import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/game_view_model.dart';
import '../services/formatting_utils.dart';
import '../widgets/clicker_button.dart';
import '../widgets/floating_number.dart';

class MainGameView extends StatefulWidget {
  const MainGameView({super.key});

  @override
  State<MainGameView> createState() => _MainGameViewState();
}

class _MainGameViewState extends State<MainGameView> {
  final List<_FloatingNumberData> _floatingNumbers = [];
  int _nextId = 0;

  void _handleTap(GameViewModel viewModel) {
    final random = Random();
    final offsetX = random.nextDouble() * 100 - 50;
    final offsetY = random.nextDouble() * 40 - 20;

    setState(() {
      if (_floatingNumbers.length > 15) {
        _floatingNumbers.removeAt(0);
      }
      _floatingNumbers.add(_FloatingNumberData(
        id: _nextId++,
        text: '+${FormattingUtils.formatNumber(viewModel.effectiveCoinsPerClick)}',
        position: Offset(
          MediaQuery.of(context).size.width / 2 + offsetX,
          MediaQuery.of(context).size.height * 0.35 + offsetY,
        ),
      ));
    });

    viewModel.tap();
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
        return Stack(
          children: [
            // Main content
            Column(
              children: [
                const Spacer(flex: 1),
                // Clicker button
                ClickerButton(
                  size: MediaQuery.of(context).size.width * 0.45,
                  onTap: () => _handleTap(viewModel),
                ),
                const Spacer(flex: 2),
              ],
            ),

            // Floating numbers
            ..._floatingNumbers.map((data) => FloatingNumber(
                  key: ValueKey(data.id),
                  text: data.text,
                  position: data.position,
                  onComplete: () => _removeFloatingNumber(data.id),
                )),
          ],
        );
      },
    );
  }
}

class _FloatingNumberData {
  final int id;
  final String text;
  final Offset position;

  _FloatingNumberData({
    required this.id,
    required this.text,
    required this.position,
  });
}
