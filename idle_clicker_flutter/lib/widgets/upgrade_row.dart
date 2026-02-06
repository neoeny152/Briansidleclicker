import 'package:flutter/material.dart';
import '../models/upgrade.dart';
import '../services/formatting_utils.dart';

class UpgradeRow extends StatelessWidget {
  final Upgrade upgrade;
  final bool canAfford;
  final bool isPurchased;
  final VoidCallback onBuy;

  const UpgradeRow({
    super.key,
    required this.upgrade,
    required this.canAfford,
    required this.isPurchased,
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
          color: isPurchased
              ? const Color(0xFF4ADE80)
              : canAfford
                  ? const Color(0xFF4ADE80)
                  : const Color(0xFF0F3460),
          width: (isPurchased || canAfford) ? 2 : 1,
        ),
      ),
      child: Opacity(
        opacity: isPurchased ? 0.6 : 1.0,
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
                    Text(
                      upgrade.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
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
                  if (!isPurchased)
                    Text(
                      FormattingUtils.formatNumber(upgrade.price),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: canAfford
                            ? const Color(0xFFFFD700)
                            : const Color(0xFFE94560),
                      ),
                    ),
                  const SizedBox(height: 5),
                  if (isPurchased)
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
                        'Owned',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: canAfford ? onBuy : null,
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
      ),
    );
  }
}
