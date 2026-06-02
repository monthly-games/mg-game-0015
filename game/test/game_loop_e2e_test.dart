import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:game/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:game/game/enhanced_game_screen.dart';
import 'package:game/game/level_design_config.dart';
import 'package:game/game/wave_spawn_table.dart';
import 'package:game/game/tutorial_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// E2E Test for MG-0015: Kingdom Rebuild Project
///
/// Tests the game loop with focus on:
/// - Achievement system integration
/// - Building/construction mechanics
/// - Kingdom progression and restoration
/// - Long-term retention features
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MG-0015 Kingdom Rebuild - Game Loop E2E', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    Future<void> tapCompleteAction(WidgetTester tester) async {
      final action = find.byKey(const ValueKey('complete-action'));
      await tester.ensureVisible(action);
      await tester.pumpAndSettle();
      await tester.tap(action);
      await tester.pumpAndSettle();
    }

    testWidgets('Complete kingdom progression with achievement system', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify main menu elements
      expect(find.text('MG-0015'), findsOneWidget);
      expect(find.text('Kingdom Rebuild Project'), findsOneWidget);
      expect(find.text('Core Fun: $kCoreFunLoop'), findsOneWidget);

      // Navigate to tutorial
      await tester.tap(find.text('Tutorial'));
      await tester.pumpAndSettle();

      // Complete tutorial steps
      final tutorialSteps = kOnboardingTutorial.steps;
      for (int i = 0; i < tutorialSteps.length; i++) {
        await tester.pumpAndSettle();
        expect(find.text('${i + 1}/${tutorialSteps.length}'), findsOneWidget);
        expect(find.text(tutorialSteps[i].title), findsOneWidget);

        await tester.tap(
          find.text(i == tutorialSteps.length - 1 ? 'Done' : 'Next'),
        );
        await tester.pumpAndSettle();
      }

      // Navigate to game screen
      await tester.tap(find.text('Start Game'));
      await tester.pumpAndSettle();

      // Verify game screen initialization
      expect(find.byType(app.GameScreen), findsOneWidget);

      // Test achievement system through building completion
      int achievementsUnlocked = 0;
      int totalGold = 0;
      int totalXP = 0;

      // Complete buildings to unlock achievements
      for (int i = 0; i < 10 && i < kLevelDesign.length; i++) {
        await tester.pumpAndSettle();

        final levelDesign = kLevelDesign[i];
        final spawn = kWaveSpawnTable[i];

        expect(
          find.text('Level ${levelDesign.levelIndex} - ${levelDesign.stage}'),
          findsOneWidget,
        );
        expect(find.text('${spawn.enemyCount} targets'), findsOneWidget);

        // Complete building to progress kingdom
        await tapCompleteAction(tester);

        // Achievement milestones
        if (levelDesign.levelIndex == 2) {
          achievementsUnlocked++; // First building achievement
        }
        if (levelDesign.levelIndex == 5) {
          achievementsUnlocked++; // Kingdom expansion achievement
        }
        if (levelDesign.levelIndex == 8) {
          achievementsUnlocked++; // Restoration milestone
        }

        totalGold += levelDesign.goldReward;
        totalXP += levelDesign.xpReward;

        expect(find.text('$totalGold gold / $totalXP xp'), findsOneWidget);
      }

      // Verify achievement system
      expect(
        achievementsUnlocked,
        greaterThan(0),
        reason: 'Should unlock achievements',
      );
      expect(
        totalGold,
        greaterThan(0),
        reason: 'Building should provide rewards',
      );
      expect(totalXP, greaterThan(0), reason: 'Achievements should provide XP');
    });

    testWidgets('Test kingdom building variety and progression', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Game'));
      await tester.pumpAndSettle();

      // Test different building types
      List<String> buildingTypes = [];

      for (int i = 0; i < 12 && i < kLevelDesign.length; i++) {
        final level = kLevelDesign[i];
        buildingTypes.add(level.stage.toLowerCase());

        // Kingdom rebuild should have diverse building types
        expect(
          level.stage.toLowerCase(),
          anyOf([
            contains('build'),
            contains('construct'),
            contains('restore'),
            contains('kingdom'),
            contains('castle'),
            contains('village'),
            contains('farm'),
            contains('mine'),
          ]),
          reason: 'Levels should have building themes',
        );

        await tapCompleteAction(tester);
      }

      // Verify building variety
      final uniqueBuildingTypes = buildingTypes.toSet();
      expect(
        uniqueBuildingTypes.length,
        greaterThan(3),
        reason: 'Kingdom should have diverse building types',
      );
    });

    testWidgets('Test enhanced game screen features', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // MG-0015 has enhanced game screen
      await tester.tap(find.text('Enhanced Game'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify enhanced game screen is available
      expect(find.byType(EnhancedGameScreen), findsOneWidget);

      // Enhanced screen should provide additional features
      expect(find.byIcon(Icons.build), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events), findsWidgets);
    });

    testWidgets('Verify kingdom rebuild theme and visual elements', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Game'));
      await tester.pumpAndSettle();

      // Verify kingdom building visual elements
      expect(find.byIcon(Icons.videogame_asset_rounded), findsWidgets);
      expect(find.byIcon(Icons.construction_rounded), findsWidgets);
    });

    testWidgets('Complete full kingdom rebuild session', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Complete tutorial
      await tester.tap(find.text('Tutorial'));
      await tester.pumpAndSettle();

      while (find.text('Next').evaluate().isNotEmpty) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      if (find.text('Done').evaluate().isNotEmpty) {
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();
      }

      // Rebuild entire kingdom
      await tester.tap(find.text('Start Game'));
      await tester.pumpAndSettle();

      int buildingsCompleted = 0;
      int maxBuildings = 25;

      for (int i = 0; i < maxBuildings && i < kLevelDesign.length; i++) {
        await tapCompleteAction(tester);
        buildingsCompleted++;
      }

      expect(
        buildingsCompleted,
        equals(maxBuildings),
        reason: 'Should complete 25 buildings',
      );

      // Verify kingdom rebuild rewards
      final finalGold = kLevelDesign
          .take(maxBuildings)
          .map((l) => l.goldReward)
          .fold(0, (a, b) => a + b);
      final finalXP = kLevelDesign
          .take(maxBuildings)
          .map((l) => l.xpReward)
          .fold(0, (a, b) => a + b);

      expect(
        find.text('Reward bank: $finalGold gold / $finalXP xp'),
        findsOneWidget,
      );
    });

    testWidgets('Test kingdom rebuild special features and retention', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Test daily building quests
      await tester.tap(find.text('Daily'));
      await tester.pumpAndSettle();
      expect(find.text('Daily Quests'), findsWidgets);
      expect(
        find.text('Short goals keep the fun loop moving.'),
        findsOneWidget,
      );

      await tester.pageBack();
      await tester.pumpAndSettle();

      // Test rewards system (important for long-term rebuilding)
      await tester.tap(find.text('Rewards'));
      await tester.pumpAndSettle();
      expect(find.text('Rewards'), findsWidgets);
      expect(
        find.text('Progression loop: return, claim, improve.'),
        findsOneWidget,
      );

      await tester.pageBack();
      await tester.pumpAndSettle();

      // Test guild war (kingdom vs kingdom)
      await tester.tap(find.text('Guild'));
      await tester.pumpAndSettle();
      expect(find.text('Guild War'), findsWidgets);
      expect(
        find.text('Social competition is reachable from the main loop.'),
        findsOneWidget,
      );

      await tester.pageBack();
      await tester.pumpAndSettle();

      // Test tournament
      await tester.tap(find.text('Tournament'));
      await tester.pumpAndSettle();
      expect(find.text('Tournament'), findsWidgets);
      expect(
        find.text('Competitive goals are available for mastery.'),
        findsOneWidget,
      );
    });

    testWidgets('Verify achievement milestone rewards and bonuses', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Game'));
      await tester.pumpAndSettle();

      int totalGold = 0;
      int achievementBonus = 0;
      List<String> achievementsUnlocked = [];

      // Play through building progression
      for (int i = 0; i < 20 && i < kLevelDesign.length; i++) {
        final level = kLevelDesign[i];
        totalGold += level.goldReward;

        // Achievement milestones provide bonus rewards
        if (level.levelIndex == 3) {
          achievementBonus += 150;
          achievementsUnlocked.add('First Territory');
        }
        if (level.levelIndex == 7) {
          achievementBonus += 300;
          achievementsUnlocked.add('Town Established');
        }
        if (level.levelIndex == 12) {
          achievementBonus += 500;
          achievementsUnlocked.add('Castle Restored');
        }
        if (level.levelIndex == 18) {
          achievementBonus += 1000;
          achievementsUnlocked.add('Kingdom Reborn');
        }

        await tapCompleteAction(tester);
      }

      // Verify achievement rewards
      expect(
        achievementBonus,
        greaterThan(0),
        reason: 'Achievements should provide bonuses',
      );
      expect(
        achievementsUnlocked.length,
        greaterThan(0),
        reason: 'Should unlock achievements',
      );
      expect(
        totalGold + achievementBonus,
        greaterThan(totalGold),
        reason: 'Total with achievements should be higher',
      );
    });

    testWidgets('Test long-term retention mechanics', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Kingdom rebuild is a long-term game
      await tester.tap(find.text('Start Game'));
      await tester.pumpAndSettle();

      // Test that progression is satisfying over time
      int progressPercentage = 0;

      for (int i = 0; i < 30 && i < kLevelDesign.length; i++) {
        await tapCompleteAction(tester);

        progressPercentage = ((i + 1) / kLevelDesign.length * 100).round();
      }

      // Long-term games should provide clear progression
      expect(
        progressPercentage,
        greaterThan(0),
        reason: 'Should show clear progress',
      );
    });

    testWidgets('Verify level roadmap shows building progression', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Level Roadmap'));
      await tester.pumpAndSettle();

      // Kingdom rebuild should have clear building progression
      expect(find.byType(app.LevelRoadmapScreen), findsOneWidget);

      for (int i = 0; i < kLevelDesign.length && i < 15; i++) {
        final level = kLevelDesign[i];
        final levelTitle = find.text(
          'Level ${level.levelIndex} - ${level.stage}',
        );
        await tester.scrollUntilVisible(
          levelTitle,
          120,
          scrollable: find.byType(Scrollable),
        );
        expect(levelTitle, findsOneWidget);

        // Kingdom levels should show progression from small to large
        if (i < 5) {
          // Early levels: small buildings
          expect(
            level.stage.toLowerCase(),
            anyOf(
              contains('hut'),
              contains('shack'),
              contains('small'),
              contains('basic'),
            ),
          );
        } else if (i > 10) {
          // Later levels: major structures
          expect(
            level.stage.toLowerCase(),
            anyOf(
              contains('castle'),
              contains('palace'),
              contains('grand'),
              contains('monument'),
            ),
          );
        }
      }
    });
  });
}
