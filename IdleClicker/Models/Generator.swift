import Foundation

struct Generator: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let basePrice: Double
    let baseProduction: Double
    let priceMultiplier: Double
    let icon: String

    func price(forQuantity owned: Int) -> Double {
        return basePrice * pow(priceMultiplier, Double(owned))
    }

    func production(forQuantity owned: Int, multiplier: Double = 1.0) -> Double {
        return baseProduction * Double(owned) * multiplier
    }

    static let allGenerators: [Generator] = [
        Generator(
            id: "cursor",
            name: "Auto Clicker",
            description: "Clicks for you automatically",
            basePrice: 15,
            baseProduction: 0.1,
            priceMultiplier: 1.15,
            icon: "cursorarrow.click"
        ),
        Generator(
            id: "grandma",
            name: "Grandma",
            description: "A nice grandma to help click",
            basePrice: 100,
            baseProduction: 1,
            priceMultiplier: 1.15,
            icon: "figure.stand"
        ),
        Generator(
            id: "farm",
            name: "Coin Farm",
            description: "Grows coins organically",
            basePrice: 1_100,
            baseProduction: 8,
            priceMultiplier: 1.15,
            icon: "leaf.fill"
        ),
        Generator(
            id: "mine",
            name: "Coin Mine",
            description: "Digs deep for precious coins",
            basePrice: 12_000,
            baseProduction: 47,
            priceMultiplier: 1.15,
            icon: "hammer.fill"
        ),
        Generator(
            id: "factory",
            name: "Coin Factory",
            description: "Mass produces coins",
            basePrice: 130_000,
            baseProduction: 260,
            priceMultiplier: 1.15,
            icon: "building.2.fill"
        ),
        Generator(
            id: "bank",
            name: "Coin Bank",
            description: "Generates interest on coins",
            basePrice: 1_400_000,
            baseProduction: 1_400,
            priceMultiplier: 1.15,
            icon: "banknote.fill"
        ),
        Generator(
            id: "temple",
            name: "Coin Temple",
            description: "Prays for coin prosperity",
            basePrice: 20_000_000,
            baseProduction: 7_800,
            priceMultiplier: 1.15,
            icon: "building.columns.fill"
        ),
        Generator(
            id: "wizard",
            name: "Wizard Tower",
            description: "Conjures coins from thin air",
            basePrice: 330_000_000,
            baseProduction: 44_000,
            priceMultiplier: 1.15,
            icon: "sparkles"
        ),
        Generator(
            id: "portal",
            name: "Coin Portal",
            description: "Imports coins from another dimension",
            basePrice: 5_100_000_000,
            baseProduction: 260_000,
            priceMultiplier: 1.15,
            icon: "circle.hexagongrid.fill"
        ),
        Generator(
            id: "timemachine",
            name: "Time Machine",
            description: "Brings coins from the future",
            basePrice: 75_000_000_000,
            baseProduction: 1_600_000,
            priceMultiplier: 1.15,
            icon: "clock.arrow.circlepath"
        )
    ]
}
