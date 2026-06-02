import 'achievement_models.dart';

/// Achievement definitions for Kingdom Rebuild
/// Designed to align with the core game loop and level design
const List<AchievementDefinition> kAchievementDefinitions = [
  // Progress Achievements
  AchievementDefinition(
    id: 'first_steps',
    name: 'First Steps',
    description: 'Complete your first building construction',
    category: AchievementCategory.progress,
    tier: AchievementTier.bronze,
    reward: AchievementReward(goldAmount: 50, xpAmount: 10),
  ),
  AchievementDefinition(
    id: 'kingdom_builder',
    name: 'Kingdom Builder',
    description: 'Construct 10 buildings',
    category: AchievementCategory.construction,
    tier: AchievementTier.silver,
    reward: AchievementReward(goldAmount: 200, xpAmount: 50),
  ),
  AchievementDefinition(
    id: 'metropolis',
    name: 'Metropolis',
    description: 'Construct 25 buildings',
    category: AchievementCategory.construction,
    tier: AchievementTier.gold,
    reward: AchievementReward(goldAmount: 500, xpAmount: 150),
  ),

  // Economy Achievements
  AchievementDefinition(
    id: 'hoarder',
    name: 'Hoarder',
    description: 'Accumulate 1000 gold',
    category: AchievementCategory.economy,
    tier: AchievementTier.bronze,
    reward: AchievementReward(goldAmount: 100, xpAmount: 25),
  ),
  AchievementDefinition(
    id: 'wealthy',
    name: 'Wealthy',
    description: 'Accumulate 5000 gold',
    category: AchievementCategory.economy,
    tier: AchievementTier.silver,
    reward: AchievementReward(goldAmount: 300, xpAmount: 75),
  ),
  AchievementDefinition(
    id: 'tycoon',
    name: 'Tycoon',
    description: 'Accumulate 15000 gold',
    category: AchievementCategory.economy,
    tier: AchievementTier.gold,
    reward: AchievementReward(goldAmount: 1000, xpAmount: 250),
  ),

  // Production Achievements
  AchievementDefinition(
    id: 'lumberjack',
    name: 'Lumberjack',
    description: 'Produce 500 wood',
    category: AchievementCategory.production,
    tier: AchievementTier.bronze,
    reward: AchievementReward(goldAmount: 75, xpAmount: 20),
  ),
  AchievementDefinition(
    id: 'stone_mason',
    name: 'Stone Mason',
    description: 'Produce 500 stone',
    category: AchievementCategory.production,
    tier: AchievementTier.bronze,
    reward: AchievementReward(goldAmount: 75, xpAmount: 20),
  ),
  AchievementDefinition(
    id: 'resource_master',
    name: 'Resource Master',
    description: 'Produce 2000 wood and 2000 stone',
    category: AchievementCategory.production,
    tier: AchievementTier.silver,
    reward: AchievementReward(goldAmount: 400, xpAmount: 100),
  ),

  // Population Achievements
  AchievementDefinition(
    id: 'settler',
    name: 'Settler',
    description: 'Reach 10 population',
    category: AchievementCategory.population,
    tier: AchievementTier.bronze,
    reward: AchievementReward(goldAmount: 80, xpAmount: 30),
  ),
  AchievementDefinition(
    id: 'community',
    name: 'Community',
    description: 'Reach 25 population',
    category: AchievementCategory.population,
    tier: AchievementTier.silver,
    reward: AchievementReward(goldAmount: 250, xpAmount: 80),
  ),
  AchievementDefinition(
    id: 'kingdom_populus',
    name: 'Kingdom Populus',
    description: 'Reach 50 population',
    category: AchievementCategory.population,
    tier: AchievementTier.gold,
    reward: AchievementReward(goldAmount: 600, xpAmount: 200),
  ),

  // Upgrade Achievements
  AchievementDefinition(
    id: 'improver',
    name: 'Improver',
    description: 'Upgrade a building to level 2',
    category: AchievementCategory.progress,
    tier: AchievementTier.bronze,
    reward: AchievementReward(goldAmount: 60, xpAmount: 15),
  ),
  AchievementDefinition(
    id: 'master_builder',
    name: 'Master Builder',
    description: 'Have 5 buildings at level 3 or higher',
    category: AchievementCategory.progress,
    tier: AchievementTier.silver,
    reward: AchievementReward(goldAmount: 350, xpAmount: 90),
  ),

  // Platinum Achievements (End-game)
  AchievementDefinition(
    id: 'kingdom_legend',
    name: 'Kingdom Legend',
    description: 'Unlock all other achievements',
    category: AchievementCategory.progress,
    tier: AchievementTier.platinum,
    reward: AchievementReward(goldAmount: 5000, xpAmount: 1000),
  ),
];
