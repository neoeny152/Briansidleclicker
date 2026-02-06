import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/game_view_model.dart';
import '../models/career.dart';
import '../models/youtube_career.dart';
import '../services/formatting_utils.dart';

class CareerView extends StatefulWidget {
  const CareerView({super.key});

  @override
  State<CareerView> createState() => _CareerViewState();
}

class _CareerViewState extends State<CareerView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
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
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
              labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              tabs: const [
                Tab(text: 'Day Job'),
                Tab(text: 'YouTube'),
              ],
            ),
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _JobTab(),
              _YouTubeTab(),
            ],
          ),
        ),
      ],
    );
  }
}

class _JobTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        final currentCareer = viewModel.currentCareer;
        final nextCareer = viewModel.nextCareer;

        return ListView(
          physics: const ClampingScrollPhysics(),
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
                  const SizedBox(height: 4),
                  Text(
                    '+ \$${FormattingUtils.formatNumber(viewModel.currentClickWage)} per click during work',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFFFD700),
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
                                'Wage: \$${FormattingUtils.formatNumber(nextCareer.baseWage)}/shift + \$${FormattingUtils.formatNumber(nextCareer.clickWage)}/click',
                                style: const TextStyle(
                                  fontSize: 12,
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
                                fontSize: 13,
                                color: viewModel.gameState.balance >= nextCareer.promotionCost
                                    ? const Color(0xFF4ADE80)
                                    : const Color(0xFFE94560),
                              ),
                            ),
                            Text(
                              'Requires: ${nextCareer.workSessionsRequired} sessions',
                              style: TextStyle(
                                fontSize: 12,
                                color: viewModel.gameState.workSessionsAtCurrentLevel >= nextCareer.workSessionsRequired
                                    ? const Color(0xFF4ADE80)
                                    : const Color(0xFF888888),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: viewModel.canPromote ? () => viewModel.promote() : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700),
                            foregroundColor: Colors.black,
                            disabledBackgroundColor: const Color(0xFF0F3460),
                            disabledForegroundColor: const Color(0xFF888888),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          child: const Text('PROMOTE'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Info card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E).withOpacity(0.5),
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
                      style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
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
        final hasChannel = viewModel.gameState.hasYouTubeChannel;
        final level = viewModel.youtubeLevel;
        final nextLevel = YouTubeLevel.getNextLevel(viewModel.gameState.subscribers);

        if (!hasChannel) {
          // Show start channel prompt
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📺', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 20),
                  const Text(
                    'Start a YouTube Channel',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Share your trading journey!\nBad traders make exciting content...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: viewModel.gameState.balance >= 200
                        ? () => viewModel.startYouTubeChannel()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0000),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text('Start Channel (\$200)'),
                  ),
                ],
              ),
            ),
          );
        }

        // Has channel - show stats
        return ListView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            // Channel stats card
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
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatColumn(
                        label: 'Subscribers',
                        value: FormattingUtils.formatNumber(viewModel.gameState.subscribers.toDouble()),
                        color: const Color(0xFFFF0000),
                      ),
                      _StatColumn(
                        label: 'Videos',
                        value: '${viewModel.gameState.totalVideosPosted}',
                        color: Colors.white,
                      ),
                      _StatColumn(
                        label: 'Credibility',
                        value: '${viewModel.gameState.credibility.toInt()}%',
                        color: viewModel.gameState.credibility >= 60
                            ? const Color(0xFF4ADE80)
                            : const Color(0xFFE94560),
                      ),
                    ],
                  ),
                  if (nextLevel != null) ...[
                    const SizedBox(height: 15),
                    Text(
                      'Next: ${nextLevel.title} (${FormattingUtils.formatNumber(nextLevel.subscribersRequired.toDouble())} subs)',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(
                        value: viewModel.gameState.subscribers / nextLevel.subscribersRequired,
                        backgroundColor: const Color(0xFF0F3460),
                        valueColor: const AlwaysStoppedAnimation(Color(0xFFFF0000)),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Passive Income Summary
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF4ADE80)),
              ),
              child: Column(
                children: [
                  const Text(
                    '💰 YouTube Income',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (level.canMonetize) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ad Revenue:', style: TextStyle(color: Color(0xFF888888))),
                        Text(
                          '+\$${FormattingUtils.formatNumber(viewModel.pendingAdRevenue * 10)}/sec',
                          style: const TextStyle(
                            color: Color(0xFF4ADE80),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (viewModel.affiliateIncome > 0) ...[
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Affiliate Income:', style: TextStyle(color: Color(0xFF888888))),
                          Text(
                            '+\$${FormattingUtils.formatNumber(viewModel.affiliateIncome)}/sec',
                            style: const TextStyle(
                              color: Color(0xFF4ADE80),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const Divider(color: Color(0xFF0F3460)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Earned:', style: TextStyle(color: Color(0xFF888888))),
                        Text(
                          '\$${FormattingUtils.formatNumber(viewModel.gameState.youtubeRevenue)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ] else
                    const Text(
                      'Reach 100 subscribers to start earning!',
                      style: TextStyle(color: Color(0xFF888888)),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Post video button
            ElevatedButton.icon(
              onPressed: viewModel.canPostVideo ? () => viewModel.postVideo() : null,
              icon: const Icon(Icons.videocam),
              label: Text(
                viewModel.canPostVideo
                    ? 'Post Video'
                    : 'Cooldown: ${viewModel.videoPostCooldownSeconds}s',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF0000),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF0F3460),
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
            ),

            const SizedBox(height: 10),

            // Edge indicator for content
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E).withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    viewModel.effectiveEdge < 0 ? Icons.trending_up : Icons.trending_down,
                    color: viewModel.effectiveEdge < 0
                        ? const Color(0xFF4ADE80)
                        : const Color(0xFFE94560),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      viewModel.effectiveEdge < 0
                          ? 'Bad edge = Exciting content = More subs!'
                          : 'Good edge = Boring content = Slower growth',
                      style: TextStyle(
                        fontSize: 11,
                        color: viewModel.effectiveEdge < 0
                            ? const Color(0xFF4ADE80)
                            : const Color(0xFF888888),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Course creation (if unlocked)
            if (level.canSellCourses) ...[
              const Text(
                'Create & Sell Courses',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final revenue = viewModel.createAndSellCourse('Trading Secrets', true);
                        if (revenue > 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sold scam course for \$${revenue.toStringAsFixed(0)}!'),
                              backgroundColor: const Color(0xFFE94560),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE94560),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Column(
                        children: [
                          Text('Scam Course'),
                          Text('(More \$\$\$)', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: viewModel.effectiveEdge > 0
                          ? () {
                              final revenue = viewModel.createAndSellCourse('Real Trading', false);
                              if (revenue > 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Sold legit course for \$${revenue.toStringAsFixed(0)}!'),
                                    backgroundColor: const Color(0xFF4ADE80),
                                  ),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4ADE80),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFF0F3460),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Column(
                        children: [
                          Text('Legit Course'),
                          Text('(Need + edge)', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20),

            // Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E).withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF0F3460)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF888888), size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'YouTube progress persists through Market Crashes!',
                      style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
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

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.color,
  });

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
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF888888),
          ),
        ),
      ],
    );
  }
}
