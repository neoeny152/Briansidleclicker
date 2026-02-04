import Foundation

enum UpgradeType: String, Codable {
    case clickPower
    case generatorBoost
    case globalMultiplier
}

struct Upgrade: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let type: UpgradeType
    let multiplier: Double
    let requirement: UpgradeRequirement?
    let icon: String

    struct UpgradeRequirement: Codable {
        let generatorId: String?
        let generatorCount: Int?
        let totalClicks: Int?
        let totalCoins: Double?
    }

    func isUnlocked(state: GameState) -> Bool {
        guard let req = requirement else { return true }

        if let genId = req.generatorId, let count = req.generatorCount {
            let owned = state.ownedGenerators[genId] ?? 0
            if owned < count { return false }
        }

        if let clicks = req.totalClicks {
            if state.totalClicks < clicks { return false }
        }

        if let coins = req.totalCoins {
            if state.totalCoinsEarned < coins { return false }
        }

        return true
    }

    static let allUpgrades: [Upgrade] = [
        // Click upgrades
        Upgrade(
            id: "click1",
            name: "Reinforced Finger",
            description: "Double your clicking power",
            price: 100,
            type: .clickPower,
            multiplier: 2.0,
            requirement: UpgradeRequirement(generatorId: nil, generatorCount: nil, totalClicks: 100, totalCoins: nil),
            icon: "hand.point.up.fill"
        ),
        Upgrade(
            id: "click2",
            name: "Carpal Tunnel Prevention",
            description: "Triple your clicking power",
            price: 500,
            type: .clickPower,
            multiplier: 3.0,
            requirement: UpgradeRequirement(generatorId: nil, generatorCount: nil, totalClicks: 500, totalCoins: nil),
            icon: "hand.raised.fill"
        ),
        Upgrade(
            id: "click3",
            name: "Ambidextrous",
            description: "5x clicking power",
            price: 10_000,
            type: .clickPower,
            multiplier: 5.0,
            requirement: UpgradeRequirement(generatorId: nil, generatorCount: nil, totalClicks: 2000, totalCoins: nil),
            icon: "hands.clap.fill"
        ),

        // Auto Clicker upgrades
        Upgrade(
            id: "cursor1",
            name: "Faster Cursors",
            description: "Auto Clickers are twice as efficient",
            price: 100,
            type: .generatorBoost,
            multiplier: 2.0,
            requirement: UpgradeRequirement(generatorId: "cursor", generatorCount: 1, totalClicks: nil, totalCoins: nil),
            icon: "cursorarrow.click.2"
        ),
        Upgrade(
            id: "cursor2",
            name: "Quantum Cursors",
            description: "Auto Clickers are twice as efficient again",
            price: 500,
            type: .generatorBoost,
            multiplier: 2.0,
            requirement: UpgradeRequirement(generatorId: "cursor", generatorCount: 10, totalClicks: nil, totalCoins: nil),
            icon: "cursorarrow.motionlines"
        ),

        // Grandma upgrades
        Upgrade(
            id: "grandma1",
            name: "Grandma's Secret Recipe",
            description: "Grandmas are twice as efficient",
            price: 1_000,
            type: .generatorBoost,
            multiplier: 2.0,
            requirement: UpgradeRequirement(generatorId: "grandma", generatorCount: 1, totalClicks: nil, totalCoins: nil),
            icon: "cup.and.saucer.fill"
        ),
        Upgrade(
            id: "grandma2",
            name: "Grandma Army",
            description: "Grandmas are twice as efficient again",
            price: 5_000,
            type: .generatorBoost,
            multiplier: 2.0,
            requirement: UpgradeRequirement(generatorId: "grandma", generatorCount: 10, totalClicks: nil, totalCoins: nil),
            icon: "person.3.fill"
        ),

        // Farm upgrades
        Upgrade(
            id: "farm1",
            name: "Fertilizer",
            description: "Coin Farms are twice as efficient",
            price: 11_000,
            type: .generatorBoost,
            multiplier: 2.0,
            requirement: UpgradeRequirement(generatorId: "farm", generatorCount: 1, totalClicks: nil, totalCoins: nil),
            icon: "drop.fill"
        ),
        Upgrade(
            id: "farm2",
            name: "Irrigation",
            description: "Coin Farms are twice as efficient again",
            price: 55_000,
            type: .generatorBoost,
            multiplier: 2.0,
            requirement: UpgradeRequirement(generatorId: "farm", generatorCount: 10, totalClicks: nil, totalCoins: nil),
            icon: "humidity.fill"
        ),

        // Global upgrades
        Upgrade(
            id: "global1",
            name: "Lucky Coin",
            description: "All production increased by 10%",
            price: 77_777,
            type: .globalMultiplier,
            multiplier: 1.1,
            requirement: UpgradeRequirement(generatorId: nil, generatorCount: nil, totalClicks: nil, totalCoins: 50_000),
            icon: "star.fill"
        ),
        Upgrade(
            id: "global2",
            name: "Golden Touch",
            description: "All production increased by 25%",
            price: 777_777,
            type: .globalMultiplier,
            multiplier: 1.25,
            requirement: UpgradeRequirement(generatorId: nil, generatorCount: nil, totalClicks: nil, totalCoins: 500_000),
            icon: "sparkle"
        )
    ]
}
