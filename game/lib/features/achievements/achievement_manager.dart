import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'achievement_models.dart';
import 'achievement_definitions.dart';
import '../buildings/building_definition.dart';

class AchievementManager extends ChangeNotifier {
  final Map<String, AchievementProgress> _progress = {};
  final Set<String> _unlockedAchievements = {};

  final _unlockController = StreamController<AchievementUnlockEvent>.broadcast();
  Stream<AchievementUnlockEvent> get unlockEvents => _unlockController.stream;

  AchievementManager() {
    _initializeProgress();
  }

  void _initializeProgress() {
    for (final def in kAchievementDefinitions) {
      _progress.putIfAbsent(
        def.id,
        () => AchievementProgress(
          achievementId: def.id,
          targetValue: _getTargetValue(def.id),
        ),
      );
    }
  }

  double _getTargetValue(String achievementId) {
    switch (achievementId) {
      case 'first_steps':
        return 1;
      case 'kingdom_builder':
        return 10;
      case 'metropolis':
        return 25;
      case 'hoarder':
        return 1000;
      case 'wealthy':
        return 5000;
      case 'tycoon':
        return 15000;
      case 'lumberjack':
      case 'stone_mason':
        return 500;
      case 'resource_master':
        return 2000;
      case 'settler':
        return 10;
      case 'community':
        return 25;
      case 'kingdom_populus':
        return 50;
      case 'improver':
        return 2;
      case 'master_builder':
        return 5;
      default:
        return 1;
    }
  }

  List<AchievementProgress> get allProgress => _progress.values.toList();

  List<AchievementProgress> get unlockedAchievements =>
      _progress.values.where((p) => p.isUnlocked).toList();

  List<AchievementProgress> get lockedAchievements =>
      _progress.values.where((p) => !p.isUnlocked).toList();

  AchievementDefinition? getDefinition(String id) {
    try {
      return kAchievementDefinitions.firstWhere((def) => def.id == id);
    } catch (_) {
      return null;
    }
  }

  AchievementProgress? getProgress(String id) {
    return _progress[id];
  }

  void updateBuildingCount(int count) {
    _updateProgress('first_steps', count.toDouble());
    _updateProgress('kingdom_builder', count.toDouble());
    _updateProgress('metropolis', count.toDouble());
  }

  void updateGoldAmount(double amount) {
    _updateProgress('hoarder', amount);
    _updateProgress('wealthy', amount);
    _updateProgress('tycoon', amount);
  }

  void updateResourceAmount(String resourceType, double amount) {
    if (resourceType == 'wood') {
      _updateProgress('lumberjack', amount);
    }
    if (resourceType == 'stone') {
      _updateProgress('stone_mason', amount);
    }
  }

  void updateCombinedResources(double wood, double stone) {
    if (wood >= 2000 && stone >= 2000) {
      _updateProgress('resource_master', 2000);
    }
  }

  void updatePopulation(int population) {
    _updateProgress('settler', population.toDouble());
    _updateProgress('community', population.toDouble());
    _updateProgress('kingdom_populus', population.toDouble());
  }

  void updateBuildingLevel(String buildingId, int level) {
    if (level >= 2) {
      _updateProgress('improver', 2);
    }
  }

  void updateHighLevelBuildings(int count) {
    _updateProgress('master_builder', count.toDouble());
  }

  void _updateProgress(String achievementId, double value) {
    if (_unlockedAchievements.contains(achievementId)) return;

    final progress = _progress[achievementId];
    if (progress == null) return;

    final updated = progress.copyWith(currentValue: value);
    _progress[achievementId] = updated;

    if (value >= progress.targetValue && !progress.isUnlocked) {
      _unlockAchievement(achievementId);
    }

    notifyListeners();
  }

  void _unlockAchievement(String achievementId) {
    if (_unlockedAchievements.contains(achievementId)) return;

    _unlockedAchievements.add(achievementId);
    final progress = _progress[achievementId];
    final def = getDefinition(achievementId);

    if (progress != null && def != null) {
      final updated = progress.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      _progress[achievementId] = updated;

      _unlockController.add(AchievementUnlockEvent(
        achievementId: achievementId,
        name: def.name,
        tier: def.tier,
        goldReward: def.reward.goldAmount,
      ));

      save();
    }
  }

  bool isAchievementUnlocked(String id) {
    return _unlockedAchievements.contains(id);
  }

  int get unlockedCount => _unlockedAchievements.length;
  int get totalAchievements => kAchievementDefinitions.length;

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('unlocked_achievements', _unlockedAchievements.toList());

    for (final entry in _progress.entries) {
      final key = 'achievement_${entry.key}';
      await prefs.setString(key, entry.value.toJson().toString());
    }
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final unlockedList = prefs.getStringList('unlocked_achievements');
    if (unlockedList != null) {
      _unlockedAchievements.addAll(unlockedList);
    }

    for (final def in kAchievementDefinitions) {
      final key = 'achievement_${def.id}';
      final jsonStr = prefs.getString(key);
      if (jsonStr != null) {
        try {
          // Simple parse for now - in production use proper JSON
          final progress = AchievementProgress(
            achievementId: def.id,
            targetValue: _getTargetValue(def.id),
          );
          _progress[def.id] = progress;
        } catch (_) {
          // Use default if parsing fails
        }
      }

      if (_unlockedAchievements.contains(def.id)) {
        final current = _progress[def.id];
        if (current != null && !current.isUnlocked) {
          _progress[def.id] = current.copyWith(
            isUnlocked: true,
            currentValue: _getTargetValue(def.id),
          );
        }
      }
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _unlockController.close();
    super.dispose();
  }
}
