import 'dart:math';
import 'dart:ui';
import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class MeteorComponent extends PositionComponent with CollisionCallbacks {
  int counter = 0;

  static const int circleSpeed = 500;
  static const double circleWidth = 100, circleHeigth = 100;

  Random random = Random();

  late double screenWidth, screenHeight;
  final ShapeHitbox hitBox = CircleHitbox();

  @override
  void update(double dt) {
    position.y += circleSpeed * dt;

    if (position.y > screenHeight) {
      removeFromParent(); // Eliminar cuando sale de la pantalla
    }

    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() {
    screenWidth = MediaQueryData.fromView(window).size.width;
    screenHeight = MediaQueryData.fromView(window).size.height;

    position = Vector2(random.nextDouble() * screenWidth, -circleHeigth);
    size = Vector2(circleWidth, circleHeigth);

    hitBox.paint.color = BasicPalette.green.color;
    hitBox.renderShape = true;

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
