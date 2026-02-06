class YouTubeLevel {
  final String id;
  final String title;
  final String emoji;
  final int subscribersRequired;
  final double unlockCost; // Equipment/setup cost
  final bool canMonetize;
  final bool canSellCourses;

  const YouTubeLevel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.subscribersRequired,
    required this.unlockCost,
    this.canMonetize = false,
    this.canSellCourses = false,
  });

  static const List<YouTubeLevel> allLevels = [
    YouTubeLevel(
      id: 'none',
      title: 'No Channel',
      emoji: '📵',
      subscribersRequired: 0,
      unlockCost: 0,
    ),
    YouTubeLevel(
      id: 'starter',
      title: 'Just Started',
      emoji: '📱',
      subscribersRequired: 0,
      unlockCost: 200, // Phone tripod, basic setup
    ),
    YouTubeLevel(
      id: 'small',
      title: 'Small Creator',
      emoji: '🎬',
      subscribersRequired: 100,
      unlockCost: 0,
      canMonetize: true, // Early monetization hook! (tiny revenue)
    ),
    YouTubeLevel(
      id: 'growing',
      title: 'Growing Channel',
      emoji: '📈',
      subscribersRequired: 1000,
      unlockCost: 0,
      canMonetize: true,
    ),
    YouTubeLevel(
      id: 'partner',
      title: 'YouTube Partner',
      emoji: '💵',
      subscribersRequired: 5000,
      unlockCost: 0,
      canMonetize: true,
    ),
    YouTubeLevel(
      id: 'fulltime',
      title: 'Full-Time Creator',
      emoji: '🎥',
      subscribersRequired: 25000,
      unlockCost: 0,
      canMonetize: true,
      canSellCourses: true, // Earlier course creation
    ),
    YouTubeLevel(
      id: 'influencer',
      title: 'Influencer',
      emoji: '⭐',
      subscribersRequired: 500000,
      unlockCost: 0,
      canMonetize: true,
      canSellCourses: true,
    ),
    YouTubeLevel(
      id: 'guru',
      title: 'Trading Guru',
      emoji: '👑',
      subscribersRequired: 1000000,
      unlockCost: 0,
      canMonetize: true,
      canSellCourses: true,
    ),
  ];

  static YouTubeLevel getLevel(int subscribers) {
    YouTubeLevel current = allLevels[0];
    for (final level in allLevels) {
      if (subscribers >= level.subscribersRequired) {
        current = level;
      } else {
        break;
      }
    }
    return current;
  }

  static YouTubeLevel? getById(String id) {
    try {
      return allLevels.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  static YouTubeLevel? getNextLevel(int subscribers) {
    for (final level in allLevels) {
      if (subscribers < level.subscribersRequired) {
        return level;
      }
    }
    return null; // Max level
  }
}

class CreatedCourse {
  final String id;
  final String name;
  final double price;
  final bool isScam;
  final int salesCount;
  final double totalRevenue;
  final DateTime createdAt;

  CreatedCourse({
    required this.id,
    required this.name,
    required this.price,
    required this.isScam,
    this.salesCount = 0,
    this.totalRevenue = 0,
    required this.createdAt,
  });

  CreatedCourse copyWith({
    int? salesCount,
    double? totalRevenue,
  }) {
    return CreatedCourse(
      id: id,
      name: name,
      price: price,
      isScam: isScam,
      salesCount: salesCount ?? this.salesCount,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'isScam': isScam,
    'salesCount': salesCount,
    'totalRevenue': totalRevenue,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CreatedCourse.fromJson(Map<String, dynamic> json) {
    return CreatedCourse(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      isScam: json['isScam'] as bool,
      salesCount: json['salesCount'] as int? ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
