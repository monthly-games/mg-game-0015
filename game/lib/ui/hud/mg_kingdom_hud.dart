import 'package:flutter/material.dart';
import 'package:mg_common_game/core/ui/theme/mg_colors.dart';
import 'package:mg_common_game/core/ui/layout/mg_spacing.dart';
import 'package:mg_common_game/core/ui/typography/mg_text_styles.dart';
import 'package:mg_common_game/core/ui/widgets/buttons/mg_icon_button.dart';
import 'package:mg_common_game/core/ui/widgets/progress/mg_linear_progress.dart';
import 'package:mg_common_game/core/ui/widgets/indicators/mg_resource_bar.dart';

/// MG-0015 Kingdom Rebuild HUD
/// 왕국 재건 시뮬레이션 게임용 HUD - 자원, 인구, 행복도 표시
class MGKingdomHud extends StatelessWidget {
  final int gold;
  final int wood;
  final int stone;
  final int food;
  final int population;
  final int maxPopulation;
  final int happiness;
  final int kingdomLevel;
  final VoidCallback? onPause;
  final VoidCallback? onBuildMenu;
  final VoidCallback? onInventory;

  const MGKingdomHud({
    super.key,
    required this.gold,
    required this.wood,
    required this.stone,
    required this.food,
    required this.population,
    required this.maxPopulation,
    required this.happiness,
    required this.kingdomLevel,
    this.onPause,
    this.onBuildMenu,
    this.onInventory,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(MGSpacing.sm),
        child: Column(
          children: [
            // 상단 HUD
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 왼쪽: 왕국 레벨
                _buildKingdomLevel(),
                SizedBox(width: MGSpacing.sm),
                // 중앙: 자원 표시
                Expanded(child: _buildResourcePanel()),
                SizedBox(width: MGSpacing.sm),
                // 오른쪽: 버튼들
                _buildActionButtons(),
              ],
            ),
            SizedBox(height: MGSpacing.xs),
            // 인구 & 행복도
            _buildPopulationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildKingdomLevel() {
    return Container(
      padding: EdgeInsets.all(MGSpacing.sm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.8),
            Colors.orange.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(MGSpacing.sm),
        border: Border.all(color: Colors.amber, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.castle, color: Colors.white, size: 28),
          SizedBox(height: MGSpacing.xxs),
          Text(
            'Lv.$kingdomLevel',
            style: MGTextStyles.buttonMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcePanel() {
    return Container(
      padding: EdgeInsets.all(MGSpacing.xs),
      decoration: BoxDecoration(
        color: MGColors.surface.withOpacity(0.85),
        borderRadius: BorderRadius.circular(MGSpacing.sm),
        border: Border.all(color: MGColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1행: 골드, 나무
          Row(
            children: [
              Expanded(child: _buildResourceItem(Icons.monetization_on, gold, Colors.amber)),
              Expanded(child: _buildResourceItem(Icons.park, wood, Colors.brown)),
            ],
          ),
          SizedBox(height: MGSpacing.xxs),
          // 2행: 돌, 음식
          Row(
            children: [
              Expanded(child: _buildResourceItem(Icons.terrain, stone, Colors.grey)),
              Expanded(child: _buildResourceItem(Icons.restaurant, food, Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(IconData icon, int value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        SizedBox(width: MGSpacing.xxs),
        Text(
          _formatNumber(value),
          style: MGTextStyles.caption.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onBuildMenu != null)
          MGIconButton(
            icon: Icons.construction,
            onPressed: onBuildMenu!,
            size: MGIconButtonSize.small,
          ),
        if (onInventory != null)
          MGIconButton(
            icon: Icons.inventory_2,
            onPressed: onInventory!,
            size: MGIconButtonSize.small,
          ),
        if (onPause != null)
          MGIconButton(
            icon: Icons.pause,
            onPressed: onPause!,
            size: MGIconButtonSize.small,
          ),
      ],
    );
  }

  Widget _buildPopulationBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MGSpacing.sm,
        vertical: MGSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: MGColors.surface.withOpacity(0.85),
        borderRadius: BorderRadius.circular(MGSpacing.xs),
        border: Border.all(color: MGColors.border),
      ),
      child: Row(
        children: [
          // 인구
          Icon(Icons.people, color: Colors.blue, size: 16),
          SizedBox(width: MGSpacing.xxs),
          Text(
            '$population/$maxPopulation',
            style: MGTextStyles.caption.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(width: MGSpacing.sm),
          Expanded(
            child: MGLinearProgress(
              value: population / maxPopulation,
              height: 8,
              backgroundColor: Colors.blue.withOpacity(0.3),
              progressColor: Colors.blue,
            ),
          ),
          SizedBox(width: MGSpacing.md),
          // 행복도
          Icon(
            _getHappinessIcon(),
            color: _getHappinessColor(),
            size: 16,
          ),
          SizedBox(width: MGSpacing.xxs),
          Text(
            '$happiness%',
            style: MGTextStyles.caption.copyWith(
              color: _getHappinessColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getHappinessIcon() {
    if (happiness >= 80) return Icons.sentiment_very_satisfied;
    if (happiness >= 60) return Icons.sentiment_satisfied;
    if (happiness >= 40) return Icons.sentiment_neutral;
    if (happiness >= 20) return Icons.sentiment_dissatisfied;
    return Icons.sentiment_very_dissatisfied;
  }

  Color _getHappinessColor() {
    if (happiness >= 80) return Colors.green;
    if (happiness >= 60) return Colors.lightGreen;
    if (happiness >= 40) return Colors.yellow;
    if (happiness >= 20) return Colors.orange;
    return Colors.red;
  }

  String _formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}
