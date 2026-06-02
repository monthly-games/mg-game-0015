import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:get_it/get_it.dart';
import '../features/resources/resource_manager.dart';
import '../features/achievements/achievement_manager.dart';
import '../features/achievements/achievement_models.dart';
import '../features/achievements/achievement_overlay.dart';
import '../features/achievements/achievement_notification.dart';
import '../features/ui/construction_overlay.dart';
import '../game/kingdom_game.dart';
import 'package:mg_common_game/core/ui/theme/app_colors.dart';
import 'package:mg_common_game/core/ui/theme/app_text_styles.dart';

class EnhancedGameScreen extends StatefulWidget {
  const EnhancedGameScreen({super.key});

  @override
  State<EnhancedGameScreen> createState() => _EnhancedGameScreenState();
}

class _EnhancedGameScreenState extends State<EnhancedGameScreen> {
  late final KingdomGame _game;
  late final ResourceManager _resourceManager;
  late final AchievementManager _achievementManager;

  bool _showConstruction = false;
  bool _showAchievements = false;
  AchievementUnlockEvent? _pendingNotification;

  @override
  void initState() {
    super.initState();
    _resourceManager = ResourceManager();
    _achievementManager = _resourceManager.achievementManager;
    _game = KingdomGame(resourceManager: _resourceManager);

    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await _resourceManager.init();
    _listenToAchievements();
  }

  void _listenToAchievements() {
    _achievementManager.unlockEvents.listen((event) {
      setState(() {
        _pendingNotification = event;
      });
    });
  }

  void _dismissNotification() {
    setState(() {
      _pendingNotification = null;
    });
  }

  @override
  void dispose() {
    _game.onRemove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game Layer
          GameWidget(game: _game),

          // Achievement Notification
          if (_pendingNotification != null)
            AchievementNotification(
              event: _pendingNotification!,
              onDismiss: _dismissNotification,
            ),

          // Top Bar - Resources and Stats
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _ResourceBar(
              resourceManager: _resourceManager,
              achievementManager: _achievementManager,
            ),
          ),

          // Achievement Button
          Positioned(
            top: 80,
            right: 16,
            child: _AchievementButton(
              unlockedCount: _achievementManager.unlockedCount,
              totalCount: _achievementManager.totalAchievements,
              onTap: () => setState(() => _showAchievements = true),
            ),
          ),

          // Construction Button
          Positioned(
            bottom: 16,
            left: 16,
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _showConstruction = true),
              icon: const Icon(Icons.build),
              label: const Text('Build'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // Construction Overlay
          if (_showConstruction)
            ConstructionOverlay(
              game: _game,
              resourceManager: _resourceManager,
              onClose: () => setState(() => _showConstruction = false),
            ),

          // Achievements Overlay
          if (_showAchievements)
            AchievementOverlay(
              achievementManager: _achievementManager,
              onClose: () => setState(() => _showAchievements = false),
            ),
        ],
      ),
    );
  }
}

class _ResourceBar extends StatelessWidget {
  final ResourceManager resourceManager;
  final AchievementManager achievementManager;

  const _ResourceBar({
    required this.resourceManager,
    required this.achievementManager,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            _ResourceItem(
              icon: Icons.monetization_on,
              label: 'Gold',
              value: resourceManager.gold.toInt(),
              maxValue: resourceManager.maxGold.toInt(),
              color: Colors.amber,
            ),
            const SizedBox(width: 16),
            _ResourceItem(
              icon: Icons.forest,
              label: 'Wood',
              value: resourceManager.wood.toInt(),
              maxValue: resourceManager.maxWood.toInt(),
              color: Colors.brown,
            ),
            const SizedBox(width: 16),
            _ResourceItem(
              icon: Icons.landscape,
              label: 'Stone',
              value: resourceManager.stone.toInt(),
              maxValue: resourceManager.maxStone.toInt(),
              color: Colors.grey,
            ),
            const Spacer(),
            _ResourceItem(
              icon: Icons.people,
              label: 'Pop',
              value: resourceManager.totalWorkers,
              maxValue:
                  resourceManager.totalWorkers +
                  resourceManager.availableWorkers,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final int maxValue;
  final Color color;

  const _ResourceItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
            Text(
              '$value/$maxValue',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AchievementButton extends StatelessWidget {
  final int unlockedCount;
  final int totalCount;
  final VoidCallback onTap;

  const _AchievementButton({
    required this.unlockedCount,
    required this.totalCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Achievements',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                Text(
                  '$unlockedCount/$totalCount',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
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
