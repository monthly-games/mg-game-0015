import 'package:flutter/material.dart';
import 'package:mg_common_game/core/ui/theme/app_colors.dart';
import 'package:mg_common_game/core/ui/theme/app_text_styles.dart';
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';
import 'achievement_manager.dart';
import 'achievement_models.dart';
import 'achievement_definitions.dart';

class AchievementOverlay extends StatefulWidget {
  final AchievementManager achievementManager;
  final VoidCallback onClose;

  const AchievementOverlay({
    super.key,
    required this.achievementManager,
    required this.onClose,
  });

  @override
  State<AchievementOverlay> createState() => _AchievementOverlayState();
}

class _AchievementOverlayState extends State<AchievementOverlay>
    with TickerProviderStateMixin {
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

  Color _getTierColor(AchievementTier tier) {
    switch (tier) {
      case AchievementTier.bronze:
        return const Color(0xFFCD7F32);
      case AchievementTier.silver:
        return const Color(0xFFC0C0C0);
      case AchievementTier.gold:
        return const Color(0xFFFFD700);
      case AchievementTier.platinum:
        return const Color(0xFFE5E4E2);
    }
  }

  String _getTierEmoji(AchievementTier tier) {
    switch (tier) {
      case AchievementTier.bronze:
        return '🥉';
      case AchievementTier.silver:
        return '🥈';
      case AchievementTier.gold:
        return '🥇';
      case AchievementTier.platinum:
        return '👑';
    }
  }

  Widget _buildAchievementCard(AchievementDefinition def, AchievementProgress progress) {
    final tierColor = _getTierColor(def.tier);
    final isUnlocked = progress.isUnlocked;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppColors.surface.withValues(alpha: 0.95)
            : AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? tierColor : AppColors.border,
          width: isUnlocked ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _getTierEmoji(def.tier),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      def.name,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? tierColor : AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      def.description,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isUnlocked)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: MGColors.success,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '✓',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          if (!isUnlocked) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress.progress,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(tierColor),
            ),
            const SizedBox(height: 4),
            Text(
              '${progress.currentValue.toInt()} / ${progress.targetValue.toInt()}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.monetization_on, size: 14, color: MGColors.success),
              const SizedBox(width: 4),
              Text(
                '+${def.reward.goldAmount}',
                style: AppTextStyles.caption.copyWith(
                  color: MGColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.stars, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                '+${def.reward.xpAmount} XP',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementList(bool showUnlocked) {
    final achievements = showUnlocked
        ? widget.achievementManager.unlockedAchievements
        : widget.achievementManager.lockedAchievements;

    if (achievements.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            showUnlocked
                ? 'No achievements unlocked yet. Keep building!'
                : 'All achievements unlocked! 🎉',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final progress = achievements[index];
        final def = widget.achievementManager.getDefinition(progress.achievementId);
        if (def == null) return const SizedBox.shrink();

        return _buildAchievementCard(def, progress);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.5),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Achievements',
                        style: AppTextStyles.header2,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: widget.onClose,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.emoji_events, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.achievementManager.unlockedCount} / ${widget.achievementManager.totalAchievements}',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Tabs
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'Unlocked'),
                Tab(text: 'Locked'),
              ],
            ),
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAchievementList(true),
                  _buildAchievementList(false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
