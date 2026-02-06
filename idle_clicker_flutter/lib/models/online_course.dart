class OnlineCourse {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final double price;
  final bool isScam;
  final double edgeBonus; // Only applies if not a scam
  final String revealedDescription; // Shown after purchase

  const OnlineCourse({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.price,
    required this.isScam,
    this.edgeBonus = 0,
    required this.revealedDescription,
  });

  static const List<OnlineCourse> allCourses = [
    // SCAM COURSES - Tempting but worthless
    OnlineCourse(
      id: 'forex_guru',
      name: 'Forex Guru Secrets',
      emoji: '🌟',
      description: 'Learn the SECRET patterns that banks don\'t want you to know!',
      price: 150,
      isScam: true,
      revealedDescription: 'Just a PDF of basic candlestick patterns you can find free online. Total scam.',
    ),
    OnlineCourse(
      id: 'crypto_millionaire',
      name: 'Crypto Millionaire Blueprint',
      emoji: '🚀',
      description: '10x your money with this ONE WEIRD TRICK!',
      price: 300,
      isScam: true,
      revealedDescription: 'It\'s just "buy low, sell high" repeated 50 times. You got played.',
    ),
    OnlineCourse(
      id: 'options_mastery',
      name: 'Options Mastery Pro',
      emoji: '💰',
      description: 'Turn \$100 into \$10,000 with weekly options!',
      price: 500,
      isScam: true,
      revealedDescription: 'The only strategy was "buy calls before earnings." Your money is gone.',
    ),
    OnlineCourse(
      id: 'ai_trading',
      name: 'AI Trading Secrets',
      emoji: '🤖',
      description: 'ChatGPT-powered trading signals! 95% win rate!',
      price: 750,
      isScam: true,
      revealedDescription: 'It\'s literally just asking ChatGPT "should I buy?" Complete garbage.',
    ),
    OnlineCourse(
      id: 'whale_alerts',
      name: 'Whale Wallet Tracker VIP',
      emoji: '🐋',
      description: 'Follow smart money! Copy what billionaires buy!',
      price: 400,
      isScam: true,
      revealedDescription: 'The data is 3 days delayed. By the time you see it, it\'s too late.',
    ),
    OnlineCourse(
      id: 'lambo_lifestyle',
      name: 'Lambo Lifestyle Trading',
      emoji: '🏎️',
      description: 'Quit your job! Trade from the beach! (Lambo pics included)',
      price: 999,
      isScam: true,
      revealedDescription: 'It\'s motivational quotes and rented Lambo photos. Pure scam.',
    ),

    // EXPENSIVE SCAMS - Look legit, still worthless
    OnlineCourse(
      id: 'hedge_fund_secrets',
      name: 'Hedge Fund Insider Strategies',
      emoji: '🏦',
      description: 'Former Goldman Sachs VP reveals institutional trading secrets.',
      price: 4500,
      isScam: true,
      revealedDescription: 'The "VP" was an intern for 2 months. Just generic trading advice.',
    ),
    OnlineCourse(
      id: 'algo_masterclass',
      name: 'Algorithmic Trading Masterclass',
      emoji: '🔬',
      description: 'Build your own HFT system! Taught by ex-Citadel quant.',
      price: 7500,
      isScam: true,
      revealedDescription: 'Copy-pasted Wikipedia articles and a broken Python script. Fraud.',
    ),
    OnlineCourse(
      id: 'inner_circle',
      name: 'Elite Traders Inner Circle',
      emoji: '💎',
      description: 'Join the top 1% of traders. Private Discord + daily signals.',
      price: 5000,
      isScam: true,
      revealedDescription: 'The Discord is just the instructor shilling his bags. Classic pump & dump.',
    ),

    // LEGITIMATE COURSES - Expensive but actually help
    OnlineCourse(
      id: 'tech_analysis',
      name: 'Technical Analysis Fundamentals',
      emoji: '📈',
      description: 'University-level course on chart patterns and indicators.',
      price: 2000,
      isScam: false,
      edgeBonus: 0.02,
      revealedDescription: 'Solid foundation in support/resistance, trends, and volume analysis. +2% edge.',
    ),
    OnlineCourse(
      id: 'market_structure',
      name: 'Market Microstructure 101',
      emoji: '🏛️',
      description: 'Understand how markets actually work at the order book level.',
      price: 5000,
      isScam: false,
      edgeBonus: 0.03,
      revealedDescription: 'Deep dive into market makers, order flow, and liquidity. +3% edge.',
    ),
    OnlineCourse(
      id: 'risk_management',
      name: 'Professional Risk Management',
      emoji: '🛡️',
      description: 'Learn position sizing and portfolio management from hedge fund managers.',
      price: 3500,
      isScam: false,
      edgeBonus: 0.025,
      revealedDescription: 'Kelly criterion, drawdown management, correlation. +2.5% edge.',
    ),
    OnlineCourse(
      id: 'quant_intro',
      name: 'Introduction to Quantitative Trading',
      emoji: '🔢',
      description: 'Statistical approaches to finding market inefficiencies.',
      price: 8000,
      isScam: false,
      edgeBonus: 0.04,
      revealedDescription: 'Mean reversion, momentum factors, statistical arbitrage basics. +4% edge.',
    ),
    OnlineCourse(
      id: 'behavioral_finance',
      name: 'Behavioral Finance & Psychology',
      emoji: '🧠',
      description: 'Why traders fail and how to avoid common psychological traps.',
      price: 1500,
      isScam: false,
      edgeBonus: 0.015,
      revealedDescription: 'Understanding FOMO, loss aversion, and emotional discipline. +1.5% edge.',
    ),
    OnlineCourse(
      id: 'options_greeks',
      name: 'Options Greeks Masterclass',
      emoji: '🇬🇷',
      description: 'Deep understanding of delta, gamma, theta, and vega.',
      price: 4000,
      isScam: false,
      edgeBonus: 0.03,
      revealedDescription: 'Proper options pricing and hedging strategies. +3% edge.',
    ),
  ];

  static OnlineCourse? getById(String id) {
    try {
      return allCourses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<OnlineCourse> get scamCourses =>
      allCourses.where((c) => c.isScam).toList();

  static List<OnlineCourse> get legitCourses =>
      allCourses.where((c) => !c.isScam).toList();
}
