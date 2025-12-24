import 'package:flutter_test/flutter_test.dart';
import 'package:game/features/resources/resource_manager.dart';
import 'package:game/features/buildings/building_definition.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Phase 4 Verification', () {
    late ResourceManager resourceManager;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      resourceManager = ResourceManager();
    });

    test('Building Selection Logic', () {
      expect(resourceManager.selectedBuildingId, isNull);
      resourceManager.selectBuilding('test_id');
      expect(resourceManager.selectedBuildingId, 'test_id');
      resourceManager.selectBuilding(null);
      expect(resourceManager.selectedBuildingId, isNull);
    });

    test('Tutorial Flag Persistence', () async {
      expect(resourceManager.tutorialCompleted, false);
      await resourceManager.completeTutorial();
      expect(resourceManager.tutorialCompleted, true);

      // Simulate reload
      final newManager = ResourceManager();
      await newManager.load();
      // Mock prefs might not persist across instances easily without re-init,
      // but SharedPreferences.setMockInitialValues persists in memory for the test session usually?
      // Actually standard SharedPreferences mock persists within the same test run if not reset.

      // Let's check if load picks it up.
      // ResourceManager.load calls SharedPreferences.getInstance()
      // We need to ensure the value was written.
      // resourceManager.completeTutorial() calls save() which writes to prefs.

      // Verify persistence via load
      final newManager = ResourceManager();
      await newManager.load();
      expect(newManager.tutorialCompleted, true);

    test('Building Removal Logic', () {
      // Mock building
      resourceManager.gold = 1000;
      resourceManager.wood = 1000;
      resourceManager.stone = 1000;

      // Add a building directly for testing (bypassing grid logic which is hard to mock here without more setup)
      // Actually removeBuilding interacts with gridSystem.
      // ResourceManager initializes GridSystem internally.

      // Place a building
      resourceManager.placeBuilding(
        BuildingType.house,
        0,
        0,
        free: true,
      ); // 2x2
      final b = resourceManager.buildings.first;
      b.finishConstruction(); // Level 1

      expect(resourceManager.buildings.length, 1);
      expect(resourceManager.gridSystem.isOccupied(0, 0), true);

      // Select it
      resourceManager.selectBuilding(b.id);
      expect(resourceManager.selectedBuildingId, b.id);

      // Remove it
      resourceManager.removeBuilding(b.id);

      expect(resourceManager.buildings.length, 0);
      expect(resourceManager.gridSystem.isOccupied(0, 0), false);
      // Logic doesn't auto-deselect in manager, UI does it upon click.
      // But removeBuilding implementation invalidates the instance.
    });
  });
}
