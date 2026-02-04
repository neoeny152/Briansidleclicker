import Foundation

struct GameState: Codable {
    var coins: Double = 0
    var totalCoinsEarned: Double = 0
    var totalClicks: Int = 0
    var coinsPerClick: Double = 1
    var coinsPerSecond: Double = 0

    var ownedGenerators: [String: Int] = [:]
    var purchasedUpgrades: Set<String> = []

    var lastSaveTime: Date = Date()

    var clickMultiplier: Double = 1.0
    var globalMultiplier: Double = 1.0

    // For future prestige system
    var prestigePoints: Int = 0
    var prestigeMultiplier: Double = 1.0
    var totalPrestiges: Int = 0
}
