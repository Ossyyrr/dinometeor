import 'dart:math';
import 'dart:ui';
import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import 'package:dinometeor/utils/crate_animation_by_limit.dart';
import 'package:flame/sprite.dart';

class MeteorComponent extends SpriteAnimationComponent with CollisionCallbacks {
  int counter = 0;

  static const int circleSpeed = 500;
  static const double circleWidth = 50, circleHeigth = 100;

  Random random = Random();

  late double screenWidth, screenHeight;
  final ShapeHitbox hitBox = CircleHitbox();

  final double spriteSheetWidth = 77.1, spriteSheetHeight = 120; // Valores de la imagen de un meteor

  @override
  void update(double dt) {
    position.y += circleSpeed * dt;
    if (position.y > screenHeight) {
      removeFromParent(); // Eliminar cuando sale de la pantalla
    }
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() async {
    screenWidth = MediaQueryData.fromView(window).size.width;
    screenHeight = MediaQueryData.fromView(window).size.height;

    position = Vector2(random.nextDouble() * screenWidth, -circleHeigth);
    size = Vector2(circleWidth, circleHeigth);

    hitBox.paint.color = BasicPalette.green.color;
    hitBox.renderShape = false; // RENDER CIRCLE

    final spriteImage = await Flame.images.load('meteor.png');
    final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));
    animation = spriteSheet.createAnimationByLimit(xInit: 0, yInit: 0, step: 6, sizeX: 5, stepTime: 0.08);

    add(hitBox);
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ScreenHitbox) {}
    if (other is MeteorComponent) {}

    hitBox.paint.color = ColorExtension.random();
    super.onCollision(intersectionPoints, other);
  }
}
