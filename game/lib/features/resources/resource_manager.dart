import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../buildings/building_definition.dart';
import '../buildings/building_instance.dart';
import '../grid/grid_system.dart';

enum ResourceType { gold, wood, stone }

class ResourceEvent {
  final ResourceType type;
  final double amount;
  ResourceEvent({required this.type, required this.amount});
}

class ResourceManager extends ChangeNotifier {
  // Resources
  double gold = 0;
  double wood = 0;
  double stone = 0;
  bool tutorialCompleted = false;

  final GridSystem gridSystem = GridSystem();

  // Definitions
  late final Map<BuildingType, BuildingDefinition> definitions;

  // Instances
  List<BuildingInstance> buildings = [];
  String? selectedBuildingId; // UI State

  // Workers
  int _assignedWorkers = 0;

  double _autoSaveTimer = 0;

  int get totalWorkers {
    int bonus = 0;
    for (final b in buildings) {
      // Only counting completed buildings for simplicity, or level > 0
      if (b.level > 0 && !b.isUnderConstruction) {
        bonus += b.definition.populationBonus;
      }
    }
    return bonus; // Castle also gives bonus via definition now
  }

  int get availableWorkers => totalWorkers - _assignedWorkers;

  double get maxGold => _calculateStorage();
  double get maxWood => _calculateStorage();
  double get maxStone => _calculateStorage();

  double _calculateStorage() {
    double total = 0;
    for (final b in buildings) {
      if (b.level > 0 && !b.isUnderConstruction) {
        total += b.definition.storageBonus;
      }
    }
    return total;
  }

  ResourceManager() {
    _initDefinitions();
    // Default buildings if load fails or first run
    // load() will overwrite if save exists
  }

  void _initDefinitions() {
    definitions = {
      BuildingType.castle: const BuildingDefinition(
        type: BuildingType.castle,
        name: "Castle",
        description: "Your main base. Produces Gold.",
        baseCost: 500, // Balanced from 0
        baseProduction: 1.0,
        maxWorkersBase: 2,
        width: 2,
        height: 2,
        storageBonus: 100.0,
        populationBonus: 5,
      ),
      BuildingType.lumberMill: const BuildingDefinition(
        type: BuildingType.lumberMill,
        name: "Lumber Mill",
        description: "Produces Wood.",
        baseCost: 50,
        baseProduction: 2.0,
        maxWorkersBase: 3,
        width: 1,
        height: 1,
      ),
      BuildingType.stoneQuarry: const BuildingDefinition(
        type: BuildingType.stoneQuarry,
        name: "Stone Quarry",
        description: "Produces Stone.",
        baseCost: 100,
        baseProduction: 1.0,
        maxWorkersBase: 3,
        width: 1,
        height: 1,
      ),
      BuildingType.house: const BuildingDefinition(
        type: BuildingType.house,
        name: "House",
        description: "Increases population.",
        baseCost: 50,
        baseProduction: 0.0,
        maxWorkersBase: 0,
        width: 1,
        height: 1,
        populationBonus: 5,
        storageBonus: 10.0, // Added storage bonus
      ),
    };
  }

  Future<void> init() async {
    await load();
    if (buildings.isEmpty) {
      // Initial State
      _spawnInitialBuildings();
    }
  }

  void _spawnInitialBuildings() {
    // Place Castle at center (0,0 concept, but let's use positive grid 10x10)
    // Grid 0-9. Center 4,4
    placeBuilding(BuildingType.castle, 4, 4, free: true);
    placeBuilding(BuildingType.lumberMill, 2, 4, free: true); // Left
    placeBuilding(BuildingType.stoneQuarry, 6, 4, free: true); // Right
    notifyListeners();
  }

  void tick(double dt) {
    _assignedWorkers = 0;

    for (final b in buildings) {
      _assignedWorkers += b.workers;

      // Handle Construction
      if (b.isUnderConstruction) {
        if (b.constructionEndTime!.isBefore(DateTime.now())) {
          b.finishConstruction();
          notifyListeners();
        }
      }

      // Handle Production
      if (b.level > 0 && !b.isUnderConstruction) {
        double production = b.currentProduction * dt;
        switch (b.type) {
          case BuildingType.castle:
            gold = min(gold + production, maxGold);
            break;
          case BuildingType.lumberMill:
            wood = min(wood + production, maxWood);
            break;
          case BuildingType.stoneQuarry:
            stone = min(stone + production, maxStone);
            break;
          default:
            break;
        }
      }
    }

    // Auto Save
    _autoSaveTimer += dt;
    if (_autoSaveTimer >= 10.0) {
      _autoSaveTimer = 0;
      save();
    }

    notifyListeners();
  }

  bool canAfford(double cost) {
    return gold >= cost;
  }

  // Placement
  bool placeBuilding(BuildingType type, int x, int y, {bool free = false}) {
    final def = definitions[type]!;

    // Check Grid Occupancy
    if (gridSystem.isOccupied(x, y, width: def.width, height: def.height)) {
      return false;
    }

    double cost = def.baseCost; // Level 0 cost

    if (!free) {
      if (!canAfford(cost)) return false;
      gold -= cost;
    }

    final instance = BuildingInstance(
      definition: def,
      gridX: x,
      gridY: y,
      level: free ? 1 : 0, // Free buildings start built (for now)
    );

    // Mark Occupancy
    gridSystem.markOccupied(x, y, def.width, def.height, instance.id);

    if (!free && cost > 0) {
      // Construction time for new building?
      // Implementation Plan says "Click a grid slot... Verify House appears and Construction starts."
      // So yes, level 0 -> level 1 takes time.
      instance.startConstruction(const Duration(seconds: 10)); // Default 10s
    }

    buildings.add(instance);
    if (!free) {
      save();
      notifyListeners();
    }
    return true;
  }

  void upgradeBuilding(String instanceId) {
    final b = buildings.firstWhere((e) => e.id == instanceId);

    if (b.isUnderConstruction) return;

    double cost = b.currentCost;

    if (gold >= cost) {
      gold -= cost;
      // Linear scaling: 5s, 10s, 15s...
      int seconds = 5 * (b.level + 1);
      b.startConstruction(Duration(seconds: seconds));

      save();
      notifyListeners();
    }
  }

  void removeBuilding(String instanceId) {
    final index = buildings.indexWhere((e) => e.id == instanceId);
    if (index == -1) return;

    final b = buildings[index];

    // Free grid
    gridSystem.unmarkOccupied(
      b.gridX,
      b.gridY,
      b.definition.width,
      b.definition.height,
    );

    buildings.removeAt(index);

    // Refund? Maybe 50% base cost.
    gold += b.definition.baseCost * 0.5;

    save();
    notifyListeners();
  }

  void selectBuilding(String? id) {
    selectedBuildingId = id;
    notifyListeners();
  }

  Future<void> completeTutorial() async {
    tutorialCompleted = true;
    await save();
    notifyListeners();
  }

  void assignWorker(String instanceId) {
    if (availableWorkers <= 0) return;
    final b = buildings.firstWhere((e) => e.id == instanceId);
    if (b.level > 0 && b.workers < b.maxWorkers) {
      b.workers++;
      notifyListeners();
    }
  }

  void removeWorker(String instanceId) {
    final b = buildings.firstWhere((e) => e.id == instanceId);
    if (b.workers > 0) {
      b.workers--;
      notifyListeners();
    }
  }

  // Events
  final _eventController = StreamController<ResourceEvent>.broadcast();
  Stream<ResourceEvent> get events => _eventController.stream;

  // Active Click
  void click() {
    // Find Castle level
    int castleLevel = 1;
    try {
      final castle = buildings.firstWhere((b) => b.type == BuildingType.castle);
      castleLevel = castle.level;
    } catch (_) {}

    double amount = 1 + (castleLevel * 0.5);
    gold += amount;
    _eventController.add(
      ResourceEvent(type: ResourceType.gold, amount: amount),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _eventController.close();
    super.dispose();
  }

  // Persistence
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('gold', gold);
    await prefs.setDouble('wood', wood);
    await prefs.setDouble('stone', stone);

    // Save Instance List count
    await prefs.setInt('building_count', buildings.length);

    for (int i = 0; i < buildings.length; i++) {
      final b = buildings[i];
      await prefs.setString('b_${i}_id', b.id);
      await prefs.setInt('b_${i}_type', b.type.index);
      await prefs.setInt('b_${i}_x', b.gridX);
      await prefs.setInt('b_${i}_y', b.gridY);
      await prefs.setInt('b_${i}_level', b.level);
      await prefs.setInt('b_${i}_workers', b.workers);
      if (b.constructionEndTime != null) {
        await prefs.setString(
          'b_${i}_construct',
          b.constructionEndTime!.toIso8601String(),
        );
      } else {
        await prefs.remove('b_${i}_construct');
      }
    }
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    gold = prefs.getDouble('gold') ?? 0;
    wood = prefs.getDouble('wood') ?? 0;
    stone = prefs.getDouble('stone') ?? 0;

    int count = prefs.getInt('building_count') ?? 0;
    buildings.clear();

    if (count == 0) return; // Will trigger init spawn in init()

    for (int i = 0; i < count; i++) {
      int typeIndex = prefs.getInt('b_${i}_type') ?? 0;
      BuildingType type = BuildingType.values[typeIndex];

      // Skip if definition missing (safety)
      if (!definitions.containsKey(type)) continue;

      final instance = BuildingInstance(
        id: prefs.getString('b_${i}_id'),
        definition: definitions[type]!,
        gridX: prefs.getInt('b_${i}_x') ?? 0,
        gridY: prefs.getInt('b_${i}_y') ?? 0,
        level: prefs.getInt('b_${i}_level') ?? 0,
        workers: prefs.getInt('b_${i}_workers') ?? 0,
      );

      final constructStr = prefs.getString('b_${i}_construct');
      if (constructStr != null) {
        instance.constructionEndTime = DateTime.parse(constructStr);
      }

      buildings.add(instance);
      gridSystem.markOccupied(
        instance.gridX,
        instance.gridY,
        instance.definition.width,
        instance.definition.height,
        instance.id,
      );
    }
    notifyListeners();
  }
}
