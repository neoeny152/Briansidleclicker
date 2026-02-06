// Generators - matches iOS version exactly
const GENERATORS = [
    {
        id: "cursor",
        name: "Auto Clicker",
        description: "Clicks for you automatically",
        basePrice: 15,
        baseProduction: 0.1,
        priceMultiplier: 1.15,
        icon: "👆"
    },
    {
        id: "grandma",
        name: "Grandma",
        description: "A nice grandma to help click",
        basePrice: 100,
        baseProduction: 1,
        priceMultiplier: 1.15,
        icon: "👵"
    },
    {
        id: "farm",
        name: "Coin Farm",
        description: "Grows coins organically",
        basePrice: 1100,
        baseProduction: 8,
        priceMultiplier: 1.15,
        icon: "🌾"
    },
    {
        id: "mine",
        name: "Coin Mine",
        description: "Digs deep for precious coins",
        basePrice: 12000,
        baseProduction: 47,
        priceMultiplier: 1.15,
        icon: "⛏️"
    },
    {
        id: "factory",
        name: "Coin Factory",
        description: "Mass produces coins",
        basePrice: 130000,
        baseProduction: 260,
        priceMultiplier: 1.15,
        icon: "🏭"
    },
    {
        id: "bank",
        name: "Coin Bank",
        description: "Generates interest on coins",
        basePrice: 1400000,
        baseProduction: 1400,
        priceMultiplier: 1.15,
        icon: "🏦"
    },
    {
        id: "temple",
        name: "Coin Temple",
        description: "Prays for coin prosperity",
        basePrice: 20000000,
        baseProduction: 7800,
        priceMultiplier: 1.15,
        icon: "🛕"
    },
    {
        id: "wizard",
        name: "Wizard Tower",
        description: "Conjures coins from thin air",
        basePrice: 330000000,
        baseProduction: 44000,
        priceMultiplier: 1.15,
        icon: "🧙"
    },
    {
        id: "portal",
        name: "Coin Portal",
        description: "Imports coins from another dimension",
        basePrice: 5100000000,
        baseProduction: 260000,
        priceMultiplier: 1.15,
        icon: "🌀"
    },
    {
        id: "timemachine",
        name: "Time Machine",
        description: "Brings coins from the future",
        basePrice: 75000000000,
        baseProduction: 1600000,
        priceMultiplier: 1.15,
        icon: "⏰"
    }
];

// Upgrades - matches iOS version exactly
const UPGRADES = [
    // Click upgrades
    {
        id: "click1",
        name: "Reinforced Finger",
        description: "Double your clicking power",
        price: 100,
        type: "clickPower",
        multiplier: 2.0,
        requirement: { totalClicks: 100 },
        icon: "👆"
    },
    {
        id: "click2",
        name: "Carpal Tunnel Prevention",
        description: "Triple your clicking power",
        price: 500,
        type: "clickPower",
        multiplier: 3.0,
        requirement: { totalClicks: 500 },
        icon: "🖐️"
    },
    {
        id: "click3",
        name: "Ambidextrous",
        description: "5x clicking power",
        price: 10000,
        type: "clickPower",
        multiplier: 5.0,
        requirement: { totalClicks: 2000 },
        icon: "👏"
    },

    // Auto Clicker upgrades
    {
        id: "cursor1",
        name: "Faster Cursors",
        description: "Auto Clickers are twice as efficient",
        price: 100,
        type: "generatorBoost",
        targetGenerator: "cursor",
        multiplier: 2.0,
        requirement: { generatorId: "cursor", generatorCount: 1 },
        icon: "🖱️"
    },
    {
        id: "cursor2",
        name: "Quantum Cursors",
        description: "Auto Clickers are twice as efficient again",
        price: 500,
        type: "generatorBoost",
        targetGenerator: "cursor",
        multiplier: 2.0,
        requirement: { generatorId: "cursor", generatorCount: 10 },
        icon: "⚛️"
    },

    // Grandma upgrades
    {
        id: "grandma1",
        name: "Grandma's Secret Recipe",
        description: "Grandmas are twice as efficient",
        price: 1000,
        type: "generatorBoost",
        targetGenerator: "grandma",
        multiplier: 2.0,
        requirement: { generatorId: "grandma", generatorCount: 1 },
        icon: "🍪"
    },
    {
        id: "grandma2",
        name: "Grandma Army",
        description: "Grandmas are twice as efficient again",
        price: 5000,
        type: "generatorBoost",
        targetGenerator: "grandma",
        multiplier: 2.0,
        requirement: { generatorId: "grandma", generatorCount: 10 },
        icon: "👵👵"
    },

    // Farm upgrades
    {
        id: "farm1",
        name: "Fertilizer",
        description: "Coin Farms are twice as efficient",
        price: 11000,
        type: "generatorBoost",
        targetGenerator: "farm",
        multiplier: 2.0,
        requirement: { generatorId: "farm", generatorCount: 1 },
        icon: "💧"
    },
    {
        id: "farm2",
        name: "Irrigation",
        description: "Coin Farms are twice as efficient again",
        price: 55000,
        type: "generatorBoost",
        targetGenerator: "farm",
        multiplier: 2.0,
        requirement: { generatorId: "farm", generatorCount: 10 },
        icon: "🚿"
    },

    // Global upgrades
    {
        id: "global1",
        name: "Lucky Coin",
        description: "All production increased by 10%",
        price: 77777,
        type: "globalMultiplier",
        multiplier: 1.1,
        requirement: { totalCoins: 50000 },
        icon: "🍀"
    },
    {
        id: "global2",
        name: "Golden Touch",
        description: "All production increased by 25%",
        price: 777777,
        type: "globalMultiplier",
        multiplier: 1.25,
        requirement: { totalCoins: 500000 },
        icon: "✨"
    }
];
