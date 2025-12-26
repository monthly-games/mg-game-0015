import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// VFX Manager for Kingdom Rebuild Project (MG-0015)
/// City Building + Idle + Story 게임 전용 이펙트 관리자
class VfxManager extends Component with HasGameRef {
  VfxManager();
  final Random _random = Random();

  // Building Effects
  void showBuildingConstruct(Vector2 position) {
    gameRef.add(_createSparkleEffect(position: position, color: Colors.amber, count: 15));
    gameRef.add(_createGroundCircle(position: position, color: Colors.green));
    gameRef.add(_createRisingEffect(position: position, color: Colors.lightBlue, count: 8, speed: 50));
  }

  void showBuildingUpgrade(Vector2 position, int newLevel) {
    gameRef.add(_createExplosionEffect(position: position, color: Colors.amber, count: 30, radius: 60));
    gameRef.add(_createSparkleEffect(position: position, color: Colors.yellow, count: 18));
    gameRef.add(_LevelUpText(position: position, level: newLevel));
  }

  void showKingdomExpansion(Vector2 position) {
    for (int i = 0; i < 4; i++) {
      Future.delayed(Duration(milliseconds: i * 120), () {
        if (!isMounted) return;
        final offset = Vector2((_random.nextDouble() - 0.5) * 120, (_random.nextDouble() - 0.5) * 80);
        gameRef.add(_createExplosionEffect(position: position + offset, color: [Colors.amber, Colors.green, Colors.blue][i % 3], count: 20, radius: 50));
      });
    }
    gameRef.add(_ExpansionText(position: position));
  }

  void showCitizenAssign(Vector2 position) {
    gameRef.add(_createSparkleEffect(position: position, color: Colors.lightBlue, count: 10));
    gameRef.add(_createRisingEffect(position: position, color: Colors.cyan, count: 6, speed: 40));
  }

  void showResourceCollect(Vector2 position, String resourceType) {
    Color color;
    switch (resourceType) {
      case 'gold': color = Colors.amber; break;
      case 'wood': color = Colors.brown; break;
      case 'stone': color = Colors.grey; break;
      case 'food': color = Colors.green; break;
      default: color = Colors.white;
    }
    gameRef.add(_createBurstEffect(position: position, color: color, count: 12, speed: 60, lifespan: 0.5));
    showNumberPopup(position, '+1', color: color);
  }

  // Story Effects
  void showStoryUnlock(Vector2 position) {
    gameRef.add(_createExplosionEffect(position: position, color: Colors.purple, count: 25, radius: 55));
    gameRef.add(_createSparkleEffect(position: position, color: Colors.white, count: 15));
    gameRef.add(_StoryText(position: position));
  }

  void showQuestComplete(Vector2 position) {
    gameRef.add(_createSparkleEffect(position: position, color: Colors.amber, count: 20));
    gameRef.add(_createCoinEffect(position: position, count: 10));
    showNumberPopup(position, 'COMPLETE!', color: Colors.amber);
  }

  void showNumberPopup(Vector2 position, String text, {Color color = Colors.white}) {
    gameRef.add(_NumberPopup(position: position, text: text, color: color));
  }

  // Private generators
  ParticleSystemComponent _createBurstEffect({required Vector2 position, required Color color, required int count, required double speed, required double lifespan}) {
    return ParticleSystemComponent(particle: Particle.generate(count: count, lifespan: lifespan, generator: (i) {
      final angle = (i / count) * 2 * pi;
      return AcceleratedParticle(position: position.clone(), speed: Vector2(cos(angle), sin(angle)) * (speed * (0.5 + _random.nextDouble() * 0.5)), acceleration: Vector2(0, 120), child: ComputedParticle(renderer: (canvas, particle) {
        final opacity = (1.0 - particle.progress).clamp(0.0, 1.0);
        canvas.drawCircle(Offset.zero, 4 * (1.0 - particle.progress * 0.5), Paint()..color = color.withOpacity(opacity));
      }));
    }));
  }

  ParticleSystemComponent _createExplosionEffect({required Vector2 position, required Color color, required int count, required double radius}) {
    return ParticleSystemComponent(particle: Particle.generate(count: count, lifespan: 0.7, generator: (i) {
      final angle = _random.nextDouble() * 2 * pi; final speed = radius * (0.4 + _random.nextDouble() * 0.6);
      return AcceleratedParticle(position: position.clone(), speed: Vector2(cos(angle), sin(angle)) * speed, acceleration: Vector2(0, 80), child: ComputedParticle(renderer: (canvas, particle) {
        final opacity = (1.0 - particle.progress).clamp(0.0, 1.0);
        canvas.drawCircle(Offset.zero, 4 * (1.0 - particle.progress * 0.3), Paint()..color = color.withOpacity(opacity));
      }));
    }));
  }

  ParticleSystemComponent _createSparkleEffect({required Vector2 position, required Color color, required int count}) {
    return ParticleSystemComponent(particle: Particle.generate(count: count, lifespan: 0.6, generator: (i) {
      final angle = _random.nextDouble() * 2 * pi; final speed = 45 + _random.nextDouble() * 35;
      return AcceleratedParticle(position: position.clone(), speed: Vector2(cos(angle), sin(angle)) * speed, acceleration: Vector2(0, 35), child: ComputedParticle(renderer: (canvas, particle) {
        final opacity = (1.0 - particle.progress).clamp(0.0, 1.0); final size = 3 * (1.0 - particle.progress * 0.5);
        final path = Path(); for (int j = 0; j < 4; j++) { final a = (j * pi / 2); if (j == 0) {
          path.moveTo(cos(a) * size, sin(a) * size);
        } else {
          path.lineTo(cos(a) * size, sin(a) * size);
        } } path.close();
        canvas.drawPath(path, Paint()..color = color.withOpacity(opacity));
      }));
    }));
  }

  ParticleSystemComponent _createRisingEffect({required Vector2 position, required Color color, required int count, required double speed}) {
    return ParticleSystemComponent(particle: Particle.generate(count: count, lifespan: 0.9, generator: (i) {
      final spreadX = (_random.nextDouble() - 0.5) * 30;
      return AcceleratedParticle(position: position.clone() + Vector2(spreadX, 0), speed: Vector2(0, -speed), acceleration: Vector2(0, -15), child: ComputedParticle(renderer: (canvas, particle) {
        final opacity = (1.0 - particle.progress).clamp(0.0, 1.0);
        canvas.drawCircle(Offset.zero, 3, Paint()..color = color.withOpacity(opacity));
      }));
    }));
  }

  ParticleSystemComponent _createGroundCircle({required Vector2 position, required Color color}) {
    return ParticleSystemComponent(particle: Particle.generate(count: 1, lifespan: 0.7, generator: (i) {
      return ComputedParticle(renderer: (canvas, particle) {
        final progress = particle.progress; final opacity = (1.0 - progress).clamp(0.0, 1.0);
        canvas.drawCircle(Offset(position.x, position.y), 15 + progress * 35, Paint()..color = color.withOpacity(opacity * 0.35)..style = PaintingStyle.stroke..strokeWidth = 2);
      });
    }));
  }

  ParticleSystemComponent _createCoinEffect({required Vector2 position, required int count}) {
    return ParticleSystemComponent(particle: Particle.generate(count: count, lifespan: 0.7, generator: (i) {
      final angle = -pi / 2 + (_random.nextDouble() - 0.5) * pi / 4; final speed = 120 + _random.nextDouble() * 70;
      return AcceleratedParticle(position: position.clone(), speed: Vector2(cos(angle), sin(angle)) * speed, acceleration: Vector2(0, 320), child: ComputedParticle(renderer: (canvas, particle) {
        final opacity = (1.0 - particle.progress * 0.2).clamp(0.0, 1.0);
        canvas.save(); canvas.rotate(particle.progress * 3 * pi);
        canvas.drawOval(const Rect.fromLTWH(-3, -2, 6, 4), Paint()..color = Colors.amber.withOpacity(opacity));
        canvas.restore();
      }));
    }));
  }
}

class _LevelUpText extends TextComponent {
  _LevelUpText({required Vector2 position, required int level}) : super(text: 'LV.$level', position: position + Vector2(0, -35), anchor: Anchor.center, textRenderer: TextPaint(style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber, shadows: [Shadow(color: Colors.orange, blurRadius: 8)])));
  @override Future<void> onLoad() async { await super.onLoad(); scale = Vector2.all(0.5); add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.3, curve: Curves.elasticOut))); add(MoveByEffect(Vector2(0, -20), EffectController(duration: 1.0, curve: Curves.easeOut))); add(OpacityEffect.fadeOut(EffectController(duration: 1.0, startDelay: 0.5))); add(RemoveEffect(delay: 1.5)); }
}

class _ExpansionText extends TextComponent {
  _ExpansionText({required Vector2 position}) : super(text: 'EXPANSION!', position: position, anchor: Anchor.center, textRenderer: TextPaint(style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green, letterSpacing: 2, shadows: [Shadow(color: Colors.green, blurRadius: 12)])));
  @override Future<void> onLoad() async { await super.onLoad(); scale = Vector2.all(0.3); add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.4, curve: Curves.elasticOut))); add(OpacityEffect.fadeOut(EffectController(duration: 2.0, startDelay: 1.0))); add(RemoveEffect(delay: 3.0)); }
}

class _StoryText extends TextComponent {
  _StoryText({required Vector2 position}) : super(text: 'NEW STORY!', position: position + Vector2(0, -40), anchor: Anchor.center, textRenderer: TextPaint(style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purple, shadows: [Shadow(color: Colors.purple, blurRadius: 10)])));
  @override Future<void> onLoad() async { await super.onLoad(); scale = Vector2.all(0.5); add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.3, curve: Curves.elasticOut))); add(MoveByEffect(Vector2(0, -15), EffectController(duration: 1.0, curve: Curves.easeOut))); add(OpacityEffect.fadeOut(EffectController(duration: 1.0, startDelay: 0.5))); add(RemoveEffect(delay: 1.5)); }
}

class _NumberPopup extends TextComponent {
  _NumberPopup({required Vector2 position, required String text, required Color color}) : super(text: text, position: position, anchor: Anchor.center, textRenderer: TextPaint(style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color, shadows: const [Shadow(color: Colors.black, blurRadius: 4, offset: Offset(1, 1))])));
  @override Future<void> onLoad() async { await super.onLoad(); add(MoveByEffect(Vector2(0, -25), EffectController(duration: 0.6, curve: Curves.easeOut))); add(OpacityEffect.fadeOut(EffectController(duration: 0.6, startDelay: 0.2))); add(RemoveEffect(delay: 0.8)); }
}
