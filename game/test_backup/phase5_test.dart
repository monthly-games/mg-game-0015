import 'package:flutter_test/flutter_test.dart';
import 'package:game/features/resources/resource_manager.dart';
import 'package:game/features/buildings/building_definition.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ResourceManager resourceManager;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    resourceManager = ResourceManager();
    await resourceManager.init();
  });

  test('House Increases Population and Storage', () {
    // Initial state (Castle + Mill + Quarry)
    // Castle: Pop +5, Storage +100
    // Others: Pop +0, Storage +0
    // Total Pop: 5. Storage: 100.

    // Check initial values via getters if exposed, or calculate manually via internal logic
    // ResourceManager exposes totalWorkers (pop) and maxGold/maxWood (storage)

    // Initial check (Castle is level 1 by default in init spawn)
    expect(resourceManager.totalWorkers, 5);
    expect(resourceManager.maxGold, 100);

    // Build a House
    resourceManager.placeBuilding(BuildingType.house, 0, 0, free: true);

    // House: Pop +5, Storage +10
    // New Totals: Pop 10, Storage 110
    expect(resourceManager.totalWorkers, 10);
    expect(resourceManager.maxGold, 110);
  });

  test('Castle Upgrade Cost Logic', () {
    // Spawn initial (Castle Level 1)
    final castle = resourceManager.buildings.firstWhere(
      (b) => b.type == BuildingType.castle,
    );
    expect(castle.level, 1);

    // Base Cost 500. Logic: base * 1.5 ^ level
    // Level 1 -> 2 Cost: 500 * (1 + 1 * 1.5) = 1250
    expect(castle.currentCost, 1250);
  });

  test('Resource accumulation with Caps', () {
    // Max Storage 100 initially.
    resourceManager.gold = 90;
    resourceManager.maxGold; // 100

    // Tick: Castle produces 1.0/s
    resourceManager.tick(1.0); // 1 sec
    expect(resourceManager.gold, 91); // 90 + 1

    // Tick: Overflow test
    resourceManager.gold = 99.5;
    resourceManager.tick(1.0); // +1 -> 100.5 -> capped at 100
    expect(resourceManager.gold, 100);
  });
}
