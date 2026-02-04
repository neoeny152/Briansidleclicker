import SwiftUI

struct UpgradeRowView: View {
    let upgrade: Upgrade
    let canAfford: Bool
    let onBuy: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(canAfford ? Color.purple.opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: 50, height: 50)

                Image(systemName: upgrade.icon)
                    .font(.title2)
                    .foregroundColor(canAfford ? .purple : .gray)
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(upgrade.name)
                    .font(.headline)

                Text(upgrade.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                HStack {
                    Image(systemName: multiplierIcon)
                        .font(.caption)
                        .foregroundColor(.purple)
                    Text(multiplierText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            // Buy button
            Button(action: onBuy) {
                VStack(spacing: 2) {
                    Text(FormattingUtils.formatNumber(upgrade.price))
                        .font(.subheadline.bold())
                    Text("coins")
                        .font(.caption2)
                }
                .foregroundColor(canAfford ? .white : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(canAfford ? Color.purple : Color.gray.opacity(0.3))
                .cornerRadius(10)
            }
            .disabled(!canAfford)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }

    private var multiplierIcon: String {
        switch upgrade.type {
        case .clickPower:
            return "hand.tap.fill"
        case .generatorBoost:
            return "bolt.fill"
        case .globalMultiplier:
            return "star.fill"
        }
    }

    private var multiplierText: String {
        switch upgrade.type {
        case .clickPower:
            return "\(Int(upgrade.multiplier))x click power"
        case .generatorBoost:
            return "\(Int(upgrade.multiplier))x generator boost"
        case .globalMultiplier:
            return "+\(Int((upgrade.multiplier - 1) * 100))% all production"
        }
    }
}

#Preview {
    VStack {
        UpgradeRowView(
            upgrade: Upgrade.allUpgrades[0],
            canAfford: true,
            onBuy: {}
        )
        UpgradeRowView(
            upgrade: Upgrade.allUpgrades[3],
            canAfford: false,
            onBuy: {}
        )
    }
    .padding()
}
