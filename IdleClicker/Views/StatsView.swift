import SwiftUI

struct StatsView: View {
    @EnvironmentObject var gameViewModel: GameViewModel

    var body: some View {
        NavigationStack {
            List {
                Section("Current Run") {
                    StatRow(label: "Total Coins", value: FormattingUtils.formatNumber(gameViewModel.gameState.coins))
                    StatRow(label: "Coins Earned", value: FormattingUtils.formatNumber(gameViewModel.gameState.totalCoinsEarned))
                    StatRow(label: "Total Clicks", value: "\(gameViewModel.gameState.totalClicks)")
                    StatRow(label: "Coins per Click", value: FormattingUtils.formatNumber(gameViewModel.effectiveCoinsPerClick))
                    StatRow(label: "Coins per Second", value: FormattingUtils.formatNumber(gameViewModel.gameState.coinsPerSecond))
                }

                Section("Multipliers") {
                    StatRow(label: "Click Multiplier", value: "\(FormattingUtils.formatNumber(gameViewModel.gameState.clickMultiplier))x")
                    StatRow(label: "Global Multiplier", value: "\(FormattingUtils.formatNumber(gameViewModel.gameState.globalMultiplier))x")
                    StatRow(label: "Prestige Multiplier", value: "\(FormattingUtils.formatNumber(gameViewModel.gameState.prestigeMultiplier))x")
                }

                Section("Generators Owned") {
                    ForEach(Generator.allGenerators) { generator in
                        let owned = gameViewModel.gameState.ownedGenerators[generator.id] ?? 0
                        if owned > 0 {
                            HStack {
                                Image(systemName: generator.icon)
                                    .foregroundColor(.orange)
                                    .frame(width: 24)
                                Text(generator.name)
                                Spacer()
                                Text("\(owned)")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    if gameViewModel.gameState.ownedGenerators.isEmpty ||
                       gameViewModel.gameState.ownedGenerators.values.allSatisfy({ $0 == 0 }) {
                        Text("No generators yet")
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }

                Section("Upgrades Purchased") {
                    let purchasedCount = gameViewModel.gameState.purchasedUpgrades.count
                    let totalCount = Upgrade.allUpgrades.count
                    StatRow(label: "Upgrades", value: "\(purchasedCount)/\(totalCount)")
                }

                Section("Prestige") {
                    StatRow(label: "Prestige Points", value: "\(gameViewModel.gameState.prestigePoints)")
                    StatRow(label: "Total Prestiges", value: "\(gameViewModel.gameState.totalPrestiges)")
                    StatRow(label: "Potential Points", value: "\(gameViewModel.potentialPrestigePoints)")

                    if gameViewModel.potentialPrestigePoints > 0 {
                        Button(action: {
                            gameViewModel.performPrestige()
                        }) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise.circle.fill")
                                Text("Prestige Now")
                                Spacer()
                                Text("+\(gameViewModel.potentialPrestigePoints) points")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .foregroundColor(.purple)
                    } else {
                        Text("Earn 1B coins to unlock prestige")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    Button(action: {
                        gameViewModel.saveGame()
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Save Game")
                        }
                    }
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    StatsView()
        .environmentObject(GameViewModel())
}
