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
      baseWage: 5.0, // Gig work, odd jobs
      clickWage: 0.50,
      promotionCost: 0,
      workSessionsRequired: 0,
      canTradeAtWork: true, // You're your own boss (but poor)
    ),
    CareerLevel(
      id: 'intern',
      title: 'Intern',
      emoji: '📋',
      baseWage: 10.0,
      clickWage: 1.0,
      promotionCost: 25,
      workSessionsRequired: 2, // Very quick first promotion
      canTradeAtWork: false, // They're watching you
    ),
    CareerLevel(
      id: 'entry',
      title: 'Entry Level',
      emoji: '💼',
      baseWage: 20.0,
      clickWage: 2.0,
      promotionCost: 100,
      workSessionsRequired: 4,
      canTradeAtWork: false, // Still being monitored
    ),
    CareerLevel(
      id: 'associate',
      title: 'Associate',
      emoji: '👔',
      baseWage: 40.0,
      clickWage: 4.0,
      promotionCost: 400,
      workSessionsRequired: 6,
      canTradeAtWork: false, // Open office, no privacy
    ),
    CareerLevel(
      id: 'senior',
      title: 'Senior Associate',
      emoji: '📊',
      baseWage: 80.0,
      clickWage: 8.0,
      promotionCost: 1500,
      workSessionsRequired: 10,
      canTradeAtWork: true, // You have your own desk now
    ),
    CareerLevel(
      id: 'manager',
      title: 'Manager',
      emoji: '👨‍💼',
      baseWage: 150.0,
      clickWage: 15.0,
      promotionCost: 5000,
      workSessionsRequired: 15,
      canTradeAtWork: true, // Private office
    ),
    CareerLevel(
      id: 'director',
      title: 'Director',
      emoji: '🎯',
      baseWage: 300.0,
      clickWage: 30.0,
      promotionCost: 25000,
      workSessionsRequired: 25,
      canTradeAtWork: true, // Nobody questions you
    ),
    CareerLevel(
      id: 'vp',
      title: 'Vice President',
      emoji: '🏆',
      baseWage: 600.0,
      clickWage: 60.0,
      promotionCost: 100000,
      workSessionsRequired: 40,
      canTradeAtWork: true, // You ARE the boss
    ),
    CareerLevel(
      id: 'executive',
      title: 'Executive',
      emoji: '👑',
      baseWage: 1200.0,
      clickWage: 120.0,
      promotionCost: 500000,
      workSessionsRequired: 60,
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
