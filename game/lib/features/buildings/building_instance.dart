import 'package:uuid/uuid.dart';
import 'building_definition.dart';

class BuildingInstance {
  final String id;
  final BuildingDefinition definition;
  int gridX;
  int gridY;
  int level;
  int workers;

  DateTime? constructionEndTime;

  BuildingInstance({
    String? id,
    required this.definition,
    required this.gridX,
    required this.gridY,
    this.level = 0,
    this.workers = 0,
    this.constructionEndTime,
  }) : id = id ?? const Uuid().v4();

  // Delegation getters
  BuildingType get type => definition.type;
  String get name => definition.name;

  double get currentCost =>
      definition.baseCost * (1 + (level * definition.costMultiplier));

  int get maxWorkers {
    if (level == 0) return 0;
    // Base + Level scaling
    return definition.maxWorkersBase + (level - 1);
  }

  double get currentProduction {
    if (level == 0) return 0;
    double levelBonus = 1 + (level - 1) * 0.1;
    double workerBonus = 1 + (workers * 0.05);
    return definition.baseProduction * levelBonus * workerBonus;
  }

  bool get isUnderConstruction =>
      constructionEndTime != null &&
      constructionEndTime!.isAfter(DateTime.now());

  void startConstruction(Duration duration) {
    constructionEndTime = DateTime.now().add(duration);
  }

  void finishConstruction() {
    constructionEndTime = null;
    level++;
  }
}
