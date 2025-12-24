import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../game/kingdom_game.dart';
import 'grid_system.dart';

class IsoGridComponent extends PositionComponent
    with HasGameReference<KingdomGame> {
  final GridSystem gridSystem;

  IsoGridComponent({required this.gridSystem})
    : super(priority: -1); // Render behind buildings

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // We need to offset the whole grid to center it, similar to buildings.
    // KingdomGame needs a unified "World Origin".
    // For now let's assume 0,0 world is 0,0 screen, but we might want to center the grid.

    // Draw cells
    for (int x = 0; x < GridSystem.gridWidth; x++) {
      for (int y = 0; y < GridSystem.gridHeight; y++) {
        _drawTile(canvas, x, y, paint);
      }
    }
  }

  void _drawTile(Canvas canvas, int x, int y, Paint paint) {
    // Top
    Vector2 top = gridSystem.gridToWorld(x, y);
    // Right
    Vector2 right = gridSystem.gridToWorld(x + 1, y);
    // Bottom
    Vector2 bottom = gridSystem.gridToWorld(x + 1, y + 1);
    // Left
    Vector2 left = gridSystem.gridToWorld(x, y + 1);

    // Apply offset (centered on screen logic needs to count here too if we do it in component)
    // Or we use a CameraComponent.
    // For Phase 2 simple implementation, let's assume usage of a global offset wrapper or just raw coordinates.
    // Since BuildingComponent uses raw coordinates + offset in KingdomGame, we should probably stick to that.

    // BUT! KingdomGame currently does:
    // double originX = 100;
    // double originY = 100;
    // add(BuildingComponent(position: Vector2(originX + instance.gridX * 120.0, ...)))
    // That was CARTESIAN logic in previous step!
    // GridSystem uses ISOMETRIC logic!

    // I NEED TO UPDATE KINGDOM GAME TO USE GRIDSYSTEM FOR PLACEMENT FIRST to match this visual.

    final path = Path()
      ..moveTo(top.x, top.y)
      ..lineTo(right.x, right.y)
      ..lineTo(bottom.x, bottom.y)
      ..lineTo(left.x, left.y)
      ..close();

    canvas.drawPath(path, paint);
  }
}
