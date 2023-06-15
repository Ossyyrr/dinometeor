import 'dart:ui';

import 'package:dinometeor/components/character.dart';
import 'package:dinometeor/components/meteor_component.dart';
import 'package:dinometeor/utils/crate_animation_by_limit.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerComponent extends Character {
  Vector2 mapSize;

  PlayerComponent({required this.mapSize}) : super() {
    debugMode = true; // Permite ver los hitBox
    anchor = const Anchor(0.33, 0.5);
  }

  int count = 0;

  @override
  Future<void> onLoad() async {
    final spriteImage = await Flame.images.load('dino.png');
    final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    idleAnimation = spriteSheet.createAnimationByLimit(xInit: 1, yInit: 2, step: 10, sizeX: 5, stepTime: 0.08);
    walkAnimation = spriteSheet.createAnimationByLimit(xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: 0.08);
    walkSlowAnimation = spriteSheet.createAnimationByLimit(xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: 0.2);
    runAnimation = spriteSheet.createAnimationByLimit(xInit: 5, yInit: 0, step: 8, sizeX: 5, stepTime: 0.08);
    jumpAnimation = spriteSheet.createAnimationByLimit(xInit: 3, yInit: 0, step: 12, sizeX: 5, stepTime: 0.08);
    deadAnimation = spriteSheet.createAnimationByLimit(xInit: 0, yInit: 0, step: 8, sizeX: 5, stepTime: 0.08);

    animation = idleAnimation;

    screenWidth = MediaQueryData.fromView(window).size.width;
    screenHeight = MediaQueryData.fromView(window).size.height;
    centerX = (screenWidth / 2) - (spriteSheetWidth / 8);
    centerY = (screenHeight / 2) - (spriteSheetHeight / 8);

    size = Vector2(spriteSheetWidth / 4, spriteSheetHeight / 4); // Tamaño
    position = Vector2(centerX, centerY);

    RectangleHitbox hitBox = RectangleHitbox(
      size: Vector2(spriteSheetWidth / 8 - 8, spriteSheetHeight / 4),
      position: Vector2(10, 8),
    );

    add(hitBox); // agregarle un hitbox
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.isEmpty) animation = idleAnimation;

    // CORRER DERECHA
    if ((keysPressed.contains(LogicalKeyboardKey.arrowRight) || keysPressed.contains(LogicalKeyboardKey.keyD)) &&
        (keysPressed.contains(LogicalKeyboardKey.shiftLeft))) {
      if (!isRight) {
        isRight = true;
        flipHorizontally();
      }
      playerSpeed = 1500;
      animation = runAnimation;
      if (!collisionXRight) posX++;
    }
    // ANDAR DERECHA
    else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) || keysPressed.contains(LogicalKeyboardKey.keyD)) {
      if (!isRight) {
        isRight = true;
        flipHorizontally();
      }
      playerSpeed = 500;
      animation = walkAnimation;
      if (!collisionXRight) posX++;
    }

    // CORRER IZQUIERDA
    if ((keysPressed.contains(LogicalKeyboardKey.arrowLeft) || keysPressed.contains(LogicalKeyboardKey.keyA)) &&
        (keysPressed.contains(LogicalKeyboardKey.shiftLeft))) {
      if (isRight) {
        isRight = false;
        flipHorizontally();
      }
      playerSpeed = 1500;
      animation = runAnimation;
      if (!collisionXLeft) posX--;
    }
    // ANDAR IZQUIERDA
    else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) || keysPressed.contains(LogicalKeyboardKey.keyA)) {
      if (isRight) {
        isRight = false;
        flipHorizontally();
      }
      playerSpeed = 500;
      animation = walkAnimation;
      if (!collisionXLeft) posX--;
    }

    // SALTAR ARRIBA
    if ((keysPressed.contains(LogicalKeyboardKey.arrowUp) || keysPressed.contains(LogicalKeyboardKey.keyW)) &&
        inGround) {
      animation = jumpAnimation;
      velocity.y = -jumpForce;
      position.y -= 15;
    }

    return true;
  }

  @override
  void update(double dt) {
    position.x += dt * posX * playerSpeed;
    position.y += dt * posY * playerSpeed;

    posX = 0;
    posY = 0;

    if (position.y < mapSize.y - size[1] / 2) {
      inGround = false;
      velocity.y += gravity;
      position.y += velocity.y * dt;
    } else {
      inGround = true;
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ScreenHitbox) {
      if (intersectionPoints.first[1] <= 0) {
        // top
      } else if (intersectionPoints.first[1] >= mapSize.y) {
        // bottom
      } else if (intersectionPoints.first[0] <= 0) {
        // left
        collisionXLeft = true;
      } else if (intersectionPoints.first[0] >= mapSize.x) {
        // right
        collisionXRight = true;
      }
    } else if (other is MeteorComponent) {
      count++;

      other.debugMode = true;
      other.hitBox.removeFromParent(); // una vez choca se elimina el hitBox para que no interactue más

      print('Meteorito: $count');
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    collisionXLeft = collisionXRight = false;
    super.onCollisionEnd(other);
  }
}
