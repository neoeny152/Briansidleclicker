import Foundation
import SwiftUI
import Combine

@MainActor
class GameViewModel: ObservableObject {
    @Published var gameState: GameState
    @Published var availableUpgrades: [Upgrade] = []

    private var gameTimer: Timer?
    private var saveTimer: Timer?
    private let storageService = StorageService()

    init() {
        self.gameState = storageService.loadGameState() ?? GameState()
        calculateOfflineEarnings()
        startGameLoop()
        startAutoSave()
        updateAvailableUpgrades()
    }

    // MARK: - Game Loop

    private func startGameLoop() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }

    private func startAutoSave() {
        saveTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.saveGame()
            }
        }
    }

    private func tick() {
        let coinsEarned = gameState.coinsPerSecond * 0.1
        gameState.coins += coinsEarned
        gameState.totalCoinsEarned += coinsEarned
    }

    // MARK: - Player Actions

    func tap() {
        let earned = effectiveCoinsPerClick
        gameState.coins += earned
        gameState.totalCoinsEarned += earned
        gameState.totalClicks += 1
        updateAvailableUpgrades()
    }

    func buyGenerator(_ generator: Generator) {
        let owned = gameState.ownedGenerators[generator.id] ?? 0
        let price = generator.price(forQuantity: owned)

        guard gameState.coins >= price else { return }

        gameState.coins -= price
        gameState.ownedGenerators[generator.id] = owned + 1
        recalculateCoinsPerSecond()
        updateAvailableUpgrades()
    }

    func buyUpgrade(_ upgrade: Upgrade) {
        guard gameState.coins >= upgrade.price else { return }
        guard !gameState.purchasedUpgrades.contains(upgrade.id) else { return }

        gameState.coins -= upgrade.price
        gameState.purchasedUpgrades.insert(upgrade.id)

        applyUpgrade(upgrade)
        updateAvailableUpgrades()
    }

    func canAfford(generator: Generator) -> Bool {
        let owned = gameState.ownedGenerators[generator.id] ?? 0
        return gameState.coins >= generator.price(forQuantity: owned)
    }

    func canAfford(upgrade: Upgrade) -> Bool {
        return gameState.coins >= upgrade.price
    }

    // MARK: - Calculations

    var effectiveCoinsPerClick: Double {
        return gameState.coinsPerClick * gameState.clickMultiplier * gameState.globalMultiplier * gameState.prestigeMultiplier
    }

    private func applyUpgrade(_ upgrade: Upgrade) {
        switch upgrade.type {
        case .clickPower:
            gameState.clickMultiplier *= upgrade.multiplier
        case .generatorBoost:
            recalculateCoinsPerSecond()
        case .globalMultiplier:
            gameState.globalMultiplier *= upgrade.multiplier
        }
        recalculateCoinsPerSecond()
    }

    func recalculateCoinsPerSecond() {
        var total: Double = 0

        for generator in Generator.allGenerators {
            let owned = gameState.ownedGenerators[generator.id] ?? 0
            if owned > 0 {
                var production = generator.production(forQuantity: owned)

                // Apply generator-specific upgrades
                for upgrade in Upgrade.allUpgrades where gameState.purchasedUpgrades.contains(upgrade.id) {
                    if upgrade.type == .generatorBoost,
                       let req = upgrade.requirement,
                       req.generatorId == generator.id {
                        production *= upgrade.multiplier
                    }
                }

                total += production
            }
        }

        gameState.coinsPerSecond = total * gameState.globalMultiplier * gameState.prestigeMultiplier
    }

    private func updateAvailableUpgrades() {
        availableUpgrades = Upgrade.allUpgrades.filter { upgrade in
            !gameState.purchasedUpgrades.contains(upgrade.id) && upgrade.isUnlocked(state: gameState)
        }
    }

    // MARK: - Persistence

    func saveGame() {
        gameState.lastSaveTime = Date()
        storageService.saveGameState(gameState)
    }

    private func calculateOfflineEarnings() {
        let now = Date()
        let elapsed = now.timeIntervalSince(gameState.lastSaveTime)

        // Cap offline earnings at 8 hours
        let cappedElapsed = min(elapsed, 8 * 60 * 60)

        if cappedElapsed > 0 && gameState.coinsPerSecond > 0 {
            let offlineEarnings = gameState.coinsPerSecond * cappedElapsed
            gameState.coins += offlineEarnings
            gameState.totalCoinsEarned += offlineEarnings
        }
    }

    // MARK: - Prestige (Placeholder for future)

    var potentialPrestigePoints: Int {
        // Based on total coins earned this run
        return Int(sqrt(gameState.totalCoinsEarned / 1_000_000_000))
    }

    func performPrestige() {
        let points = potentialPrestigePoints
        guard points > 0 else { return }

        gameState.prestigePoints += points
        gameState.totalPrestiges += 1
        gameState.prestigeMultiplier = 1.0 + (Double(gameState.prestigePoints) * 0.01)

        // Reset progress
        gameState.coins = 0
        gameState.totalCoinsEarned = 0
        gameState.totalClicks = 0
        gameState.coinsPerClick = 1
        gameState.coinsPerSecond = 0
        gameState.ownedGenerators = [:]
        gameState.purchasedUpgrades = []
        gameState.clickMultiplier = 1.0
        gameState.globalMultiplier = 1.0

        saveGame()
        updateAvailableUpgrades()
    }

    deinit {
        gameTimer?.invalidate()
        saveTimer?.invalidate()
    }
}
