import 'package:flutter/material.dart';
import '../models/generator.dart';
import '../services/formatting_utils.dart';

class GeneratorRow extends StatelessWidget {
  final Generator generator;
  final int owned;
  final double currentPrice;
  final bool canAfford;
  final double production;
  final VoidCallback onBuy;

  const GeneratorRow({
    super.key,
    required this.generator,
    required this.owned,
    required this.currentPrice,
    required this.canAfford,
    required this.production,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: canAfford ? const Color(0xFF4ADE80) : const Color(0xFF0F3460),
          width: canAfford ? 2 : 1,
        ),
        boxShadow: canAfford
            ? [
                BoxShadow(
                  color: const Color(0xFF4ADE80).withOpacity(0.2),
                  blurRadius: 10,
                )
              ]
            : null,
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
                  generator.emoji,
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
                        generator.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      if (owned > 0) ...[
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
                            '$owned',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    generator.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                    ),
                  ),
                  if (owned > 0) ...[
                    const SizedBox(height: 3),
                    Text(
                      '+${FormattingUtils.formatNumber(production)}/sec',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4ADE80),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Price & Buy
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  FormattingUtils.formatNumber(currentPrice),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: canAfford
                        ? const Color(0xFFFFD700)
                        : const Color(0xFFE94560),
                  ),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: canAfford ? onBuy : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        canAfford ? const Color(0xFF4ADE80) : const Color(0xFF0F3460),
                    foregroundColor: canAfford ? Colors.black : const Color(0xFF888888),
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
