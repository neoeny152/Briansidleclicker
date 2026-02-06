class CareerLevel {
  final String id;
  final String title;
  final String emoji;
  final double baseWage; // Per work session completion
  final double clickWage; // Per click during work
  final double promotionCost; // Cost to reach this level
  final int workSessionsRequired; // Min sessions at previous level
  final bool canTradeAtWork; // Can trade during work session

  const CareerLevel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.baseWage,
    required this.clickWage,
    required this.promotionCost,
    required this.workSessionsRequired,
    this.canTradeAtWork = false,
  });

  static const List<CareerLevel> allLevels = [
    CareerLevel(
      id: 'unemployed',
      title: 'Unemployed',
      emoji: '😔',
      baseWage: 3.0, // Gig work, odd jobs
      clickWage: 0.15,
      promotionCost: 0,
      workSessionsRequired: 0,
      canTradeAtWork: true, // You're your own boss (but poor)
    ),
    CareerLevel(
      id: 'intern',
      title: 'Intern',
      emoji: '📋',
      baseWage: 5.0,
      clickWage: 0.25,
      promotionCost: 25, // Faster early game!
      workSessionsRequired: 3, // Quick first promotion
      canTradeAtWork: false, // They're watching you
    ),
    CareerLevel(
      id: 'entry',
      title: 'Entry Level',
      emoji: '💼',
      baseWage: 8.0,
      clickWage: 0.40,
      promotionCost: 100, // Was 200
      workSessionsRequired: 8, // Was 15
      canTradeAtWork: false, // Still being monitored
    ),
    CareerLevel(
      id: 'associate',
      title: 'Associate',
      emoji: '👔',
      baseWage: 15.0,
      clickWage: 0.75,
      promotionCost: 400, // Was 800
      workSessionsRequired: 20, // Was 30
      canTradeAtWork: false, // Open office, no privacy
    ),
    CareerLevel(
      id: 'senior',
      title: 'Senior Associate',
      emoji: '📊',
      baseWage: 25.0,
      clickWage: 1.25,
      promotionCost: 2000, // Was 3000
      workSessionsRequired: 40, // Was 60
      canTradeAtWork: true, // You have your own desk now
    ),
    CareerLevel(
      id: 'manager',
      title: 'Manager',
      emoji: '👨‍💼',
      baseWage: 45.0,
      clickWage: 2.25,
      promotionCost: 10000, // Was 12000
      workSessionsRequired: 80, // Was 100
      canTradeAtWork: true, // Private office
    ),
    CareerLevel(
      id: 'director',
      title: 'Director',
      emoji: '🎯',
      baseWage: 80.0,
      clickWage: 4.0,
      promotionCost: 50000,
      workSessionsRequired: 200,
      canTradeAtWork: true, // Nobody questions you
    ),
    CareerLevel(
      id: 'vp',
      title: 'Vice President',
      emoji: '🏆',
      baseWage: 150.0,
      clickWage: 7.5,
      promotionCost: 200000,
      workSessionsRequired: 400,
      canTradeAtWork: true, // You ARE the boss
    ),
    CareerLevel(
      id: 'executive',
      title: 'Executive',
      emoji: '👑',
      baseWage: 300.0,
      clickWage: 15.0,
      promotionCost: 1000000,
      workSessionsRequired: 800,
      canTradeAtWork: true, // You make the rules
    ),
  ];

  static CareerLevel getLevel(int index) {
    if (index < 0) return allLevels[0];
    if (index >= allLevels.length) return allLevels.last;
    return allLevels[index];
  }

  static CareerLevel? getById(String id) {
    try {
      return allLevels.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }
}
