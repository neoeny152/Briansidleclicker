import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/game_view_model.dart';
import '../models/trading_symbol.dart';
import '../models/bot_upgrade.dart';
import '../models/career.dart';
import '../models/online_course.dart';
import '../models/youtube_career.dart';
import '../services/formatting_utils.dart';

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar
        Container(
          margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: const Color(0xFF0F3460),
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: const Color(0xFF4ADE80),
            unselectedLabelColor: const Color(0xFF888888),
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
            labelPadding: EdgeInsets.zero,
            tabs: const [
              Tab(text: 'Career'),
              Tab(text: 'YT'),
              Tab(text: 'Course'),
              Tab(text: 'Passive'),
              Tab(text: 'Bot'),
              Tab(text: 'Rsrch'),
              Tab(text: 'Mkts'),
            ],
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _CareerTab(),
              _YouTubeTab(),
              _CoursesTab(),
              _PassiveIncomeTab(),
              _BotUpgradesTab(),
              _ResearchTab(),
              _MarketsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

class _CareerTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        final currentCareer = viewModel.currentCareer;
        final nextCareer = viewModel.nextCareer;

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            // Current position card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF16213E),
                    const Color(0xFF0F3460).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF4ADE80), width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    currentCareer.emoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentCareer.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Wage: \$${FormattingUtils.formatNumber(viewModel.currentWage)} per shift',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4ADE80),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Progress to next level
                  if (nextCareer != null) ...[
                    Text(
                      'Sessions at current level: ${viewModel.gameState.workSessionsAtCurrentLevel}/${nextCareer.workSessionsRequired}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF888888),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(
                        value: viewModel.gameState.workSessionsAtCurrentLevel /
                            nextCareer.workSessionsRequired,
                        backgroundColor: const Color(0xFF0F3460),
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF4ADE80)),
                        minHeight: 8,
                      ),
                    ),
                  ] else
                    const Text(
                      'MAX CAREER LEVEL',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Promotion card
            if (nextCareer != null)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: viewModel.canPromote
                        ? const Color(0xFFFFD700)
                        : const Color(0xFF0F3460),
                    width: viewModel.canPromote ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          nextCareer.emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Next Promotion:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF888888),
                                ),
                              ),
                              Text(
                                nextCareer.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Wage: \$${FormattingUtils.formatNumber(nextCareer.baseWage)}/shift',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF4ADE80),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Training Cost: \$${FormattingUtils.formatNumber(nextCareer.promotionCost)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: viewModel.gameState.balance >= nextCareer.promotionCost
                                    ? const Color(0xFF4ADE80)
                                    : const Color(0xFFE94560),
                              ),
                            ),
                            Text(
                              'Requires: ${nextCareer.workSessionsRequired} sessions',
                              style: TextStyle(
                                fontSize: 12,
                                color: viewModel.gameState.workSessionsAtCurrentLevel >=
                                        nextCareer.workSessionsRequired
                                    ? const Color(0xFF4ADE80)
                                    : const Color(0xFF888888),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: viewModel.canPromote
                              ? () => viewModel.promote()
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: viewModel.canPromote
                                ? const Color(0xFFFFD700)
                                : const Color(0xFF0F3460),
                            foregroundColor: viewModel.canPromote
                                ? Colors.black
                                : const Color(0xFF888888),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'PROMOTE',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Career persists info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF0F3460)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF888888), size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Career progress persists through Market Crashes!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF888888),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _YouTubeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.gameState.hasYouTubeChannel) {
          // Show start channel option
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📺', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 20),
                  const Text(
                    'Start a YouTube Channel',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Share your trading journey!\nBad traders make exciting content...',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF888888)),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: viewModel.canStartChannel
                        ? () => viewModel.startYouTubeChannel()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: viewModel.canStartChannel
                          ? const Color(0xFFFF0000)
                          : const Color(0xFF0F3460),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Start Channel (\$200)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Show YouTube channel management
        final level = viewModel.youtubeLevel;
        final nextLevel = viewModel.nextYoutubeLevel;

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            // Channel Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF16213E),
                    const Color(0xFFFF0000).withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFFF0000), width: 2),
              ),
              child: Column(
                children: [
                  Text(level.emoji, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 10),
                  Text(
                    level.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatBox(
                        label: 'Subscribers',
                        value: FormattingUtils.formatNumber(viewModel.gameState.subscribers.toDouble()),
                        color: const Color(0xFFFF0000),
                      ),
                      _StatBox(
                        label: 'Videos',
                        value: '${viewModel.gameState.totalVideosPosted}',
                        color: const Color(0xFF4ADE80),
                      ),
                      _StatBox(
                        label: 'Credibility',
                        value: '${viewModel.gameState.credibility.toInt()}%',
                        color: viewModel.gameState.credibility > 60
                            ? const Color(0xFF4ADE80)
                            : viewModel.gameState.credibility < 40
                                ? const Color(0xFFE94560)
                                : const Color(0xFFFFD700),
                      ),
                    ],
                  ),
                  if (nextLevel != null) ...[
                    const SizedBox(height: 15),
                    Text(
                      'Next: ${nextLevel.title} at ${FormattingUtils.formatNumber(nextLevel.subscribersRequired.toDouble())} subs',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(
                        value: viewModel.gameState.subscribers / nextLevel.subscribersRequired,
                        backgroundColor: const Color(0xFF0F3460),
                        valueColor: const AlwaysStoppedAnimation(Color(0xFFFF0000)),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Post Video Button
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: viewModel.canPostVideo
                      ? const Color(0xFFFF0000)
                      : const Color(0xFF0F3460),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: viewModel.canPostVideo ? () => viewModel.postVideo() : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.upload,
                          size: 40,
                          color: viewModel.canPostVideo
                              ? const Color(0xFFFF0000)
                              : const Color(0xFF888888),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Post Video',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: viewModel.canPostVideo
                                      ? Colors.white
                                      : const Color(0xFF888888),
                                ),
                              ),
                              Text(
                                viewModel.canPostVideo
                                    ? 'Gain subscribers!'
                                    : 'Cooldown: ${viewModel.videoPostCooldownSeconds}s',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Revenue Info
            if (level.canMonetize)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Revenue Streams',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _RevenueRow(
                      icon: Icons.play_circle,
                      label: 'Ad Revenue',
                      value: '\$${FormattingUtils.formatNumber(viewModel.pendingAdRevenue * 10)}/sec',
                    ),
                    if (viewModel.affiliateIncome > 0)
                      _RevenueRow(
                        icon: Icons.handshake,
                        label: 'Affiliate Deals',
                        value: '\$${FormattingUtils.formatNumber(viewModel.affiliateIncome)}/sec',
                      ),
                    const Divider(color: Color(0xFF0F3460)),
                    _RevenueRow(
                      icon: Icons.account_balance_wallet,
                      label: 'Total YT Revenue',
                      value: '\$${FormattingUtils.formatNumber(viewModel.gameState.youtubeRevenue)}',
                      isBold: true,
                    ),
                  ],
                ),
              ),

            if (level.canSellCourses) ...[
              const SizedBox(height: 15),

              // Create Course Section
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFD700)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('🎓', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 10),
                        Text(
                          'Create & Sell Course',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Scam Course Option
                    _CourseCreationOption(
                      title: 'Hype Course',
                      subtitle: '"10x Your Portfolio!"',
                      isScam: true,
                      viewModel: viewModel,
                      expectedSales: viewModel.getExpectedCourseSales(true),
                      pricePerSale: viewModel.getCourseRevenuePerSale(true),
                    ),

                    const SizedBox(height: 10),

                    // Legit Course Option
                    _CourseCreationOption(
                      title: 'Educational Course',
                      subtitle: 'Actually useful content',
                      isScam: false,
                      viewModel: viewModel,
                      expectedSales: viewModel.getExpectedCourseSales(false),
                      pricePerSale: viewModel.getCourseRevenuePerSale(false),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      viewModel.effectiveEdge >= 0
                          ? 'Your positive edge makes legit courses credible!'
                          : 'Warning: Selling hype courses will tank your credibility',
                      style: TextStyle(
                        fontSize: 11,
                        color: viewModel.effectiveEdge >= 0
                            ? const Color(0xFF4ADE80)
                            : const Color(0xFFE94560),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 15),

            // Info box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF0F3460)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF888888), size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'YouTube progress persists through Market Crashes!\nBad traders = exciting content = more subs!',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF888888),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
        ),
      ],
    );
  }
}

class _RevenueRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isBold;

  const _RevenueRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF888888)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Color(0xFF888888))),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF4ADE80),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCreationOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isScam;
  final GameViewModel viewModel;
  final int expectedSales;
  final double pricePerSale;

  const _CourseCreationOption({
    required this.title,
    required this.subtitle,
    required this.isScam,
    required this.viewModel,
    required this.expectedSales,
    required this.pricePerSale,
  });

  @override
  Widget build(BuildContext context) {
    final expectedRevenue = expectedSales * pricePerSale;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isScam ? const Color(0xFFE94560) : const Color(0xFF4ADE80),
        ),
      ),
      child: Row(
        children: [
          Text(isScam ? '🎰' : '📚', style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isScam ? const Color(0xFFE94560) : const Color(0xFF4ADE80),
                  ),
                ),
                Text(
                  '~${expectedSales} sales @ \$${pricePerSale.toInt()} = \$${FormattingUtils.formatNumber(expectedRevenue)}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final revenue = viewModel.createAndSellCourse(
                isScam ? 'Hype Trading Secrets' : 'Trading Fundamentals',
                isScam,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Course sold! +\$${FormattingUtils.formatNumber(revenue)}',
                  ),
                  backgroundColor: const Color(0xFF4ADE80),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isScam ? const Color(0xFFE94560) : const Color(0xFF4ADE80),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text('Sell', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _CoursesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        // Shuffle courses but keep order deterministic per session
        final courses = List<OnlineCourse>.from(OnlineCourse.allCourses);

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: courses.length + 1, // +1 for header
          itemBuilder: (context, index) {
            if (index == 0) {
              // Header with course edge bonus
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Course Edge Bonus:',
                      style: TextStyle(color: Color(0xFF888888)),
                    ),
                    Text(
                      '+${(viewModel.gameState.courseEdgeBonus * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4ADE80),
                      ),
                    ),
                  ],
                ),
              );
            }

            final course = courses[index - 1];
            return _CourseCard(course: course, viewModel: viewModel);
          },
        );
      },
    );
  }
}

class _CourseCard extends StatelessWidget {
  final OnlineCourse course;
  final GameViewModel viewModel;

  const _CourseCard({required this.course, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final isPurchased = viewModel.hasPurchasedCourse(course.id);
    final canAfford = viewModel.gameState.balance >= course.price && !isPurchased;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPurchased
              ? (course.isScam ? const Color(0xFFE94560) : const Color(0xFF4ADE80))
              : canAfford
                  ? const Color(0xFFFFD700)
                  : const Color(0xFF0F3460),
          width: isPurchased ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  course.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isPurchased ? course.revealedDescription : course.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isPurchased
                              ? (course.isScam
                                  ? const Color(0xFFE94560)
                                  : const Color(0xFF4ADE80))
                              : const Color(0xFF888888),
                          fontStyle: isPurchased ? FontStyle.italic : FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isPurchased)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: course.isScam
                          ? const Color(0xFFE94560).withOpacity(0.2)
                          : const Color(0xFF4ADE80).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      course.isScam ? 'SCAM!' : '+${(course.edgeBonus * 100).toStringAsFixed(1)}% Edge',
                      style: TextStyle(
                        color: course.isScam
                            ? const Color(0xFFE94560)
                            : const Color(0xFF4ADE80),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                else
                  Text(
                    '\$${FormattingUtils.formatNumber(course.price)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: canAfford
                          ? const Color(0xFFFFD700)
                          : const Color(0xFFE94560),
                    ),
                  ),
                if (!isPurchased)
                  ElevatedButton(
                    onPressed: canAfford
                        ? () {
                            final wasLegit = viewModel.purchaseCourse(course);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  wasLegit
                                      ? 'Great course! +${(course.edgeBonus * 100).toStringAsFixed(1)}% edge'
                                      : 'This was a SCAM! Money wasted...',
                                ),
                                backgroundColor: wasLegit
                                    ? const Color(0xFF4ADE80)
                                    : const Color(0xFFE94560),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canAfford
                          ? const Color(0xFFFFD700)
                          : const Color(0xFF0F3460),
                      foregroundColor:
                          canAfford ? Colors.black : const Color(0xFF888888),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Enroll',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PassiveIncomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final upgrades = BotUpgrade.allUpgrades
        .where((u) => u.category == UpgradeCategory.passive)
        .toList();

    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            // Passive income summary card
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF16213E),
                    const Color(0xFF4ADE80).withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF4ADE80), width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    '💤 Passive Income',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${FormattingUtils.formatNumber(viewModel.passiveIncome)}/sec',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4ADE80),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Money while you sleep!',
                    style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
                  ),
                ],
              ),
            ),
            // Upgrade list
            ...upgrades.map((upgrade) => _UpgradeCard(
                  upgrade: upgrade,
                  viewModel: viewModel,
                )),
          ],
        );
      },
    );
  }
}

class _BotUpgradesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final upgrades = BotUpgrade.allUpgrades
        .where((u) =>
            u.category == UpgradeCategory.bot ||
            u.category == UpgradeCategory.infrastructure)
        .toList();

    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: upgrades.length,
          itemBuilder: (context, index) {
            final upgrade = upgrades[index];
            return _UpgradeCard(upgrade: upgrade, viewModel: viewModel);
          },
        );
      },
    );
  }
}

class _ResearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final upgrades = BotUpgrade.allUpgrades
        .where((u) => u.category == UpgradeCategory.research)
        .toList();

    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: upgrades.length,
          itemBuilder: (context, index) {
            final upgrade = upgrades[index];
            return _UpgradeCard(upgrade: upgrade, viewModel: viewModel);
          },
        );
      },
    );
  }
}

class _MarketsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: TradingSymbol.allSymbols.length,
          itemBuilder: (context, index) {
            final symbol = TradingSymbol.allSymbols[index];
            return _SymbolCard(symbol: symbol, viewModel: viewModel);
          },
        );
      },
    );
  }
}

class _UpgradeCard extends StatelessWidget {
  final BotUpgrade upgrade;
  final GameViewModel viewModel;

  const _UpgradeCard({required this.upgrade, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final currentLevel = viewModel.gameState.botUpgrades[upgrade.id] ?? 0;
    final isMaxed = currentLevel >= upgrade.maxLevel;
    final price = upgrade.getPrice(currentLevel);
    final canAfford = viewModel.gameState.balance >= price && !isMaxed;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: canAfford
              ? const Color(0xFF4ADE80)
              : isMaxed
                  ? const Color(0xFF4ADE80)
                  : const Color(0xFF0F3460),
          width: canAfford || isMaxed ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  upgrade.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        upgrade.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F3460),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$currentLevel/${upgrade.maxLevel}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    upgrade.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),

            // Price & Buy
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMaxed)
                  Text(
                    '\$${FormattingUtils.formatNumber(price)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: canAfford
                          ? const Color(0xFF4ADE80)
                          : const Color(0xFFE94560),
                    ),
                  ),
                const SizedBox(height: 5),
                if (isMaxed)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ADE80),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'MAXED',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: canAfford
                        ? () => viewModel.buyUpgrade(upgrade)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canAfford
                          ? const Color(0xFF4ADE80)
                          : const Color(0xFF0F3460),
                      foregroundColor:
                          canAfford ? Colors.black : const Color(0xFF888888),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Buy',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SymbolCard extends StatelessWidget {
  final TradingSymbol symbol;
  final GameViewModel viewModel;

  const _SymbolCard({required this.symbol, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = viewModel.gameState.unlockedSymbols[symbol.id] == true;
    final isActive = viewModel.gameState.activeSymbol == symbol.id;
    final canAfford = viewModel.gameState.balance >= symbol.unlockPrice;
    final symbolEdge = viewModel.gameState.symbolEdges[symbol.id] ?? 0;
    final trades = viewModel.gameState.symbolTradeCount[symbol.id] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? const Color(0xFF4ADE80)
              : isUnlocked
                  ? const Color(0xFF0F3460)
                  : canAfford
                      ? const Color(0xFFFFD700)
                      : const Color(0xFF0F3460),
          width: isActive ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  symbol.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symbol.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  if (isUnlocked) ...[
                    Text(
                      'ML Edge: +${(symbolEdge * 100).toStringAsFixed(0)}%  •  ${trades} trades',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4ADE80),
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    'Volatility: ${symbol.volatility}x  •  \$${symbol.baseTradeSize.toInt()}/trade',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),

            // Action
            if (isUnlocked)
              ElevatedButton(
                onPressed: isActive ? null : () => viewModel.selectSymbol(symbol.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive
                      ? const Color(0xFF4ADE80)
                      : const Color(0xFF0F3460),
                  foregroundColor:
                      isActive ? Colors.black : const Color(0xFFFFFFFF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  isActive ? 'Active' : 'Select',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${FormattingUtils.formatNumber(symbol.unlockPrice)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: canAfford
                          ? const Color(0xFFFFD700)
                          : const Color(0xFFE94560),
                    ),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed:
                        canAfford ? () => viewModel.unlockSymbol(symbol) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canAfford
                          ? const Color(0xFFFFD700)
                          : const Color(0xFF0F3460),
                      foregroundColor:
                          canAfford ? Colors.black : const Color(0xFF888888),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Unlock',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
