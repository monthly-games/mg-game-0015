import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'building_definition.dart';
import 'building_instance.dart';

class BuildingComponent extends PositionComponent with HasGameRef {
  final BuildingInstance data;
  Sprite? _sprite;

  BuildingComponent({required this.data, required Vector2 position})
    : super(position: position, size: Vector2(100, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    String spriteName;
    switch (data.type) {
      case BuildingType.castle:
        spriteName = 'building_castle.png';
        break;
      case BuildingType.lumberMill:
        spriteName = 'building_lumber_mill.png';
        break;
      case BuildingType.stoneQuarry:
        spriteName = 'building_stone_quarry.png';
        break;
      default:
        spriteName = 'building_house.png';
        break;
    }

    try {
      _sprite = await gameRef.loadSprite(spriteName);
    } catch (e) {
      print('Failed to load sprite $spriteName: $e');
    }
  }

  @override
  void render(Canvas canvas) {
    if (data.level == 0) {
      // Construction site look
      _drawConstructionSite(canvas);
      return;
    }

    if (_sprite != null) {
      _sprite!.render(canvas, size: size);
    } else {
      // Fallback
      switch (data.type) {
        case BuildingType.castle:
          _drawCastle(canvas);
          break;
        case BuildingType.lumberMill:
          _drawLumberMill(canvas);
          break;
        case BuildingType.stoneQuarry:
          _drawQuarry(canvas);
          break;
        default:
          _drawHouse(canvas);
          break;
      }
    }
  }

  void _drawConstructionSite(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.brown.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(10, height - 10, width - 20, 10), paint);
    canvas.drawRect(Rect.fromLTWH(20, height - 40, 10, 30), paint);
    canvas.drawRect(Rect.fromLTWH(width - 30, height - 40, 10, 30), paint);

    // Crane
    canvas.drawLine(Offset(width / 2, height), Offset(width / 2, 20), paint);
    canvas.drawLine(Offset(width / 2, 20), Offset(width - 20, 40), paint);
  }

  void _drawCastle(Canvas canvas) {
    // Walls
    final wallPaint = Paint()..color = Colors.grey[700]!;
    canvas.drawRect(Rect.fromLTWH(10, 40, width - 20, height - 40), wallPaint);

    // Battlements
    canvas.drawRect(const Rect.fromLTWH(10, 30, 15, 10), wallPaint);
    canvas.drawRect(const Rect.fromLTWH(35, 30, 15, 10), wallPaint);
    canvas.drawRect(const Rect.fromLTWH(60, 30, 15, 10), wallPaint);
    canvas.drawRect(const Rect.fromLTWH(85, 30, 15, 10), wallPaint);

    // Gate
    canvas.drawArc(
      const Rect.fromLTWH(35, 60, 30, 40),
      3.14,
      3.14,
      true,
      Paint()..color = Colors.brown[900]!,
    );

    // Flag
    final polePaint = Paint()..color = Colors.brown;
    canvas.drawLine(
      Offset(width / 2, 30),
      Offset(width / 2, 0),
      polePaint..strokeWidth = 3,
    );
    canvas.drawPath(
      Path()
        ..moveTo(width / 2, 0)
        ..lineTo(width / 2 + 20, 10)
        ..lineTo(width / 2, 20),
      Paint()..color = Colors.red,
    );
  }

  void _drawLumberMill(Canvas canvas) {
    // Building
    canvas.drawRect(
      Rect.fromLTWH(20, 40, width - 40, height - 40),
      Paint()..color = Colors.brown[400]!,
    );

    // Roof
    canvas.drawPath(
      Path()
        ..moveTo(10, 40)
        ..lineTo(width / 2, 10)
        ..lineTo(width - 10, 40),
      Paint()..color = Colors.brown[800]!,
    );

    // Logs
    final logPaint = Paint()..color = Colors.brown[300]!;
    canvas.drawCircle(Offset(30, height - 10), 8, logPaint);
    canvas.drawCircle(Offset(50, height - 10), 8, logPaint);
    canvas.drawCircle(Offset(40, height - 20), 8, logPaint);
  }

  void _drawQuarry(Canvas canvas) {
    // Pit
    canvas.drawRect(
      Rect.fromLTWH(10, 50, width - 20, height - 50),
      Paint()..color = Colors.grey[400]!,
    );

    // Rocks
    final rockPaint = Paint()..color = Colors.grey[600]!;
    canvas.drawCircle(const Offset(30, 70), 10, rockPaint);
    canvas.drawCircle(const Offset(60, 80), 15, rockPaint);
    canvas.drawCircle(const Offset(80, 60), 8, rockPaint);

    // Crane
    final cranePaint = Paint()
      ..color = Colors.orange[800]!
      ..strokeWidth = 4;
    canvas.drawLine(
      Offset(width - 20, height),
      Offset(width - 20, 20),
      cranePaint,
    );
    canvas.drawLine(Offset(width - 20, 20), const Offset(20, 40), cranePaint);
  }

  void _drawHouse(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(20, 40, width - 40, height - 40),
      Paint()..color = Colors.blueGrey,
    );
    canvas.drawPath(
      Path()
        ..moveTo(10, 40)
        ..lineTo(width / 2, 10)
        ..lineTo(width - 10, 40),
      Paint()..color = Colors.black54,
    );
  }
}
