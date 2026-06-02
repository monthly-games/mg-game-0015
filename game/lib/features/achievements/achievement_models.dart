/// Achievement system for Kingdom Rebuild
/// Provides progression goals and rewards to enhance the core game loop

enum AchievementCategory {
  progress,
  economy,
  construction,
  population,
  production,
}

enum AchievementTier {
  bronze,
  silver,
  gold,
  platinum,
}

class AchievementReward {
  final int goldAmount;
  final int xpAmount;
  final String? unlockBuildingType;

  const AchievementReward({
    this.goldAmount = 0,
    this.xpAmount = 0,
    this.unlockBuildingType,
  });
}

class AchievementDefinition {
  final String id;
  final String name;
  final String description;
  final AchievementCategory category;
  final AchievementTier tier;
  final AchievementReward reward;
  final String iconPath;

  const AchievementDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.tier,
    required this.reward,
    this.iconPath = 'assets/icons/achievement_default.png',
  });
}

class AchievementProgress {
  final String achievementId;
  double currentValue;
  double targetValue;
  bool isUnlocked;
  DateTime? unlockedAt;

  AchievementProgress({
    required this.achievementId,
    this.currentValue = 0,
    required this.targetValue,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  double get progress => isUnlocked ? 1.0 : (currentValue / targetValue).clamp(0.0, 1.0);

  AchievementProgress copyWith({
    double? currentValue,
    double? targetValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return AchievementProgress(
      achievementId: achievementId,
      currentValue: currentValue ?? this.currentValue,
      targetValue: targetValue ?? this.targetValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'achievementId': achievementId,
      'currentValue': currentValue,
      'targetValue': targetValue,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  factory AchievementProgress.fromJson(Map<String, dynamic> json) {
    return AchievementProgress(
      achievementId: json['achievementId'] as String,
      currentValue: (json['currentValue'] as num).toDouble(),
      targetValue: (json['targetValue'] as num).toDouble(),
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }
}

class AchievementUnlockEvent {
  final String achievementId;
  final String name;
  final AchievementTier tier;
  final int goldReward;

  AchievementUnlockEvent({
    required this.achievementId,
    required this.name,
    required this.tier,
    required this.goldReward,
  });
}
