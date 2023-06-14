import 'dart:math';
import 'dart:ui';
import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class MeteorComponent extends PositionComponent with CollisionCallbacks {
  MeteorComponent({this.isCountActive = false});
  bool isCountActive;
  int counter = 0;

  static const int circleSpeed = 250;
  static const double circleWidth = 100, circleHeigth = 100;
  late int circleDirectionX;
  late int circleDirectionY;

  Random random = Random();

  late double screenWidth, screenHeight;
  final ShapeHitbox hitBox = CircleHitbox();

  @override
  void update(double dt) {
    position.x += circleDirectionX * circleSpeed * dt;
    position.y += circleDirectionY * circleSpeed * dt;
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() {
    screenWidth = MediaQueryData.fromView(window).size.width;
    screenHeight = MediaQueryData.fromView(window).size.height;

    circleDirectionX = random.nextInt(2) == 0 ? -1 : 1;
    circleDirectionY = random.nextInt(2) == 0 ? -1 : 1;

    position =
        Vector2(random.nextDouble() * (screenWidth - circleWidth), random.nextDouble() * (screenHeight - circleHeigth));
    size = Vector2(circleWidth, circleHeigth);

    hitBox.paint.color = BasicPalette.green.color;
    hitBox.renderShape = true;

    add(hitBox);
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ScreenHitbox) {
      if (intersectionPoints.first[1] <= 0) {
        // top
        circleDirectionX = random.nextInt(2) == 0 ? -1 : 1;
        circleDirectionY = 1;
      } else if (intersectionPoints.first[1] >= screenHeight) {
        // bottom
        circleDirectionX = random.nextInt(2) == 0 ? -1 : 1;
        circleDirectionY = -1;
      } else if (intersectionPoints.first[0] <= 0) {
        // left
        circleDirectionX = 1;
        circleDirectionY = random.nextInt(2) == 0 ? -1 : 1;
      } else if (intersectionPoints.first[0] >= screenWidth) {
        // right
        circleDirectionX = -1;
        circleDirectionY = random.nextInt(2) == 0 ? -1 : 1;
      }
    }
    if (other is MeteorComponent) {
      circleDirectionX *= -1;
      circleDirectionY *= -1;
    }

    if (isCountActive) {
      counter++;
      print(counter);
    }

    hitBox.paint.color = ColorExtension.random();
    super.onCollision(intersectionPoints, other);
  }
}
