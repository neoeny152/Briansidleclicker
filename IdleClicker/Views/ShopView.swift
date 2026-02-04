import SwiftUI

struct ShopView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @State private var selectedSection = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Coin balance header
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                    Text(FormattingUtils.formatNumber(gameViewModel.gameState.coins))
                        .font(.title2.bold())
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))

                // Section picker
                Picker("Shop Section", selection: $selectedSection) {
                    Text("Generators").tag(0)
                    Text("Upgrades").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()

                // Content
                if selectedSection == 0 {
                    generatorsSection
                } else {
                    upgradesSection
                }
            }
            .navigationTitle("Shop")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var generatorsSection: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Generator.allGenerators) { generator in
                    GeneratorRowView(
                        generator: generator,
                        owned: gameViewModel.gameState.ownedGenerators[generator.id] ?? 0,
                        canAfford: gameViewModel.canAfford(generator: generator),
                        onBuy: { gameViewModel.buyGenerator(generator) }
                    )
                }
            }
            .padding()
        }
    }

    private var upgradesSection: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if gameViewModel.availableUpgrades.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No upgrades available")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Keep clicking and buying generators\nto unlock more upgrades!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 60)
                } else {
                    ForEach(gameViewModel.availableUpgrades) { upgrade in
                        UpgradeRowView(
                            upgrade: upgrade,
                            canAfford: gameViewModel.canAfford(upgrade: upgrade),
                            onBuy: { gameViewModel.buyUpgrade(upgrade) }
                        )
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ShopView()
        .environmentObject(GameViewModel())
}
