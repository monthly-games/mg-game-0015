// Circular dependency for type enum if needed, or just keep enum here?
// Better to move Enum to a shared file or keep in definition.

enum BuildingType { castle, lumberMill, stoneQuarry, house }

class BuildingDefinition {
  final BuildingType type;
  final String name;
  final String description;
  final double baseCost;
  final double baseProduction;
  final double costMultiplier;
  final int width;
  final int height;
  final int maxWorkersBase;
  final int populationBonus;
  final double storageBonus;

  const BuildingDefinition({
    required this.type,
    required this.name,
    required this.description,
    required this.baseCost,
    required this.baseProduction,
    this.costMultiplier = 1.5,
    this.width = 1,
    this.height = 1,
    this.maxWorkersBase = 0,
    this.populationBonus = 0,
    this.storageBonus = 0.0,
  });
}
