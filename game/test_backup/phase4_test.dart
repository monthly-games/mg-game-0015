import 'package:flutter_test/flutter_test.dart';
import 'package:game/features/buildings/building_definition.dart';
import 'package:game/features/resources/resource_manager.dart';
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
      expect(resourceManager.tutorialCompleted, isFalse);
      await resourceManager.completeTutorial();
      expect(resourceManager.tutorialCompleted, isTrue);

      final newManager = ResourceManager();
      await newManager.load();
      expect(newManager.tutorialCompleted, isTrue);
    });

    test('Building Removal Logic', () {
      resourceManager.gold = 1000;
      resourceManager.wood = 1000;
      resourceManager.stone = 1000;

      resourceManager.placeBuilding(
        BuildingType.house,
        0,
        0,
        free: true,
      );

      final building = resourceManager.buildings.first;
      building.finishConstruction();

      expect(resourceManager.buildings.length, 1);
      expect(resourceManager.gridSystem.isOccupied(0, 0), isTrue);

      resourceManager.selectBuilding(building.id);
      expect(resourceManager.selectedBuildingId, building.id);

      resourceManager.removeBuilding(building.id);

      expect(resourceManager.buildings.length, 0);
      expect(resourceManager.gridSystem.isOccupied(0, 0), isFalse);
    });
  });
}
