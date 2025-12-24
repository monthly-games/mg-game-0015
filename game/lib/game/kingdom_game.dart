import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_common_game/core/audio/audio_manager.dart';
import 'package:mg_common_game/core/ui/theme/app_colors.dart';
import '../features/resources/resource_manager.dart';

import '../features/buildings/building_definition.dart';
import '../features/buildings/building_component.dart';
import '../features/grid/iso_grid_component.dart';
import '../features/grid/grid_system.dart';
import 'components/floating_text.dart';
import 'components/input_handler.dart';

class KingdomGame extends FlameGame {
  final ResourceManager resourceManager;

  BuildingType? selectedBuildingType; // State for construction mode
  late final Vector2 gridOrigin;

  KingdomGame({required this.resourceManager});

  @override
  Color backgroundColor() => const Color(0xFF87CEEB); // Sky Blue - Keep as is for sky effect

  @override
  Future<void> onLoad() async {
    // Define World Origin (Top Center of screen usually good for Iso)
    // For specific resolution support we might need to adjust, but center screen top is safe.
    gridOrigin = Vector2(size.x / 2, 120);

    // Add Input Handler (full screen)
    add(InputHandlerComponent());

    // Add Grid Component
    add(
      IsoGridComponent(gridSystem: resourceManager.gridSystem)
        ..position = gridOrigin,
    );

    _spawnBuildings();

    // Listen for events
    resourceManager.events.listen((event) {
      if (event.type == ResourceType.gold) {
        add(
          FloatingTextComponent(
            text: "+${event.amount.toInt()}",
            position: Vector2(size.x / 2, size.y / 2 + 50),
            color: AppColors.secondary,
          ),
        );
        try {
          GetIt.I<AudioManager>().playSfx('sfx_coin.wav');
        } catch (_) {}
      }
    });

    // Listen for building changes (re-spawn on new building)
    resourceManager.addListener(_onResourceManagerUpdate);
  }

  void _onResourceManagerUpdate() {
    // Very crude, full rebuild on any change. Optimize later if needed.
    _spawnBuildings();
  }

  void _spawnBuildings() {
    // Clear existing buildings if any (re-spawn logic)
    children.whereType<BuildingComponent>().forEach(
      (c) => c.removeFromParent(),
    );

    for (final instance in resourceManager.buildings) {
      // Use GridSystem for positioning
      final pos = resourceManager.gridSystem.gridToWorld(
        instance.gridX,
        instance.gridY,
      );

      add(
        BuildingComponent(
          data: instance,
          position: gridOrigin + pos + Vector2(0, GridSystem.tileHeight / 2),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    resourceManager.tick(dt);
  }

  @override
  void onRemove() {
    resourceManager.removeListener(_onResourceManagerUpdate);
    super.onRemove();
  }
}
