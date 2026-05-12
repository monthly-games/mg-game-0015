import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FloatingTextComponent extends TextComponent {
  final double lifeTime;
  double _timer = 0;

  FloatingTextComponent({
    required String text,
    required Vector2 position,
    this.lifeTime = 1.0,
    Color color = Colors.amber,
  }) : super(
         text: text,
         position: position,
         textRenderer: TextPaint(
           style: TextStyle(
             color: color,
             fontSize: 24,
             fontWeight: FontWeight.bold,
             shadows: const [
               Shadow(
                 blurRadius: 2,
                 color: Colors.black,
                 offset: Offset(1, 1),
               ),
             ],
           ),
         ),
         anchor: Anchor.center,
       );

  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;

    // Move up
    position.y -= 50 * dt;

    // Fade (requires recreating TextPaint or using opacity wrapper, simlified: remove at end)
    if (_timer >= lifeTime) {
      removeFromParent();
    }
  }
}
