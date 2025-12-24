import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:get_it/get_it.dart';
import '../kingdom_game.dart';
import '../../core/audio/audio_manager.dart';

class InputHandlerComponent extends PositionComponent
    with TapCallbacks, HasGameReference<KingdomGame> {
  InputHandlerComponent() : super(priority: 100); // High priority to catch taps

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size; // Always cover full screen
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (game.selectedBuildingType != null) {
      // CONSTRUCTION MODE
      // We need to access KingdomGame's gridOrigin.
      // It's available via game.gridOrigin
      final screenPos =
          event.localPosition; // Local to this component (which is screen size)
      final localPos = screenPos - game.gridOrigin;
      final gridPoint = game.resourceManager.gridSystem.worldToGrid(localPos);

      // Attempt placement
      bool success = game.resourceManager.placeBuilding(
        game.selectedBuildingType!,
        gridPoint.x,
        gridPoint.y,
      );

      if (success) {
        game.selectedBuildingType = null; // Clear selection
        try {
          GetIt.I<AudioManager>().playSfx('sfx_build.wav');
        } catch (_) {}
      } else {
        try {
          GetIt.I<AudioManager>().playSfx('sfx_error.wav');
        } catch (_) {}
      }
    } else {
      // SELECTION MODE
      final screenPos = event.localPosition;
      final localPos = screenPos - game.gridOrigin;
      final gridPoint = game.resourceManager.gridSystem.worldToGrid(localPos);

      // Check if occupied
      if (game.resourceManager.gridSystem.isOccupied(
        gridPoint.x,
        gridPoint.y,
      )) {
        final id = game.resourceManager.gridSystem.getOccupantId(
          gridPoint.x,
          gridPoint.y,
        );
        if (id != null) {
          game.resourceManager.selectBuilding(id);
          try {
            GetIt.I<AudioManager>().playSfx('sfx_click.wav');
          } catch (_) {}
        } else {
          game.resourceManager.selectBuilding(null);
        }
      } else {
        game.resourceManager.selectBuilding(null); // Deselect
      }
    }
  }
}
