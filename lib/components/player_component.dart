import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerComponent extends SpriteAnimationComponent with Tappable, KeyboardHandler, CollisionCallbacks {
  // Tappable para los eventos de toque
  // KeyboardHandler necesita el HasKeyboardHandlerComponents en el main
  late double screenWidth, screenHeight, centerX, centerY;
  final double spriteSheetWidth = 680, spriteSheetHeight = 472; // Valores de la imagen de un dino

  int posX = 0, posY = 0;
  double playerSpeed = 500;

  int animationIndex = 0;
  bool isRight = true;

  late SpriteAnimation dinoDeadAnimation, dinoIdleAnimation, dinoJumpAnimation, dinoRunAnimation, dinoWalkAnimation;

  @override
  Future<void> onLoad() async {
    anchor = const Anchor(0.33, 0.5);

    final spriteImage = await Flame.images.load('dino.png');
    final spriteSheet = SpriteSheet(image: spriteImage, srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    dinoDeadAnimation = spriteSheet.createAnimationByLimit(xInit: 0, yInit: 0, step: 8, sizeX: 5, stepTime: 0.1);
    dinoIdleAnimation = spriteSheet.createAnimationByLimit(xInit: 1, yInit: 2, step: 10, sizeX: 5, stepTime: 0.1);
    dinoJumpAnimation = spriteSheet.createAnimationByLimit(xInit: 3, yInit: 0, step: 12, sizeX: 5, stepTime: 0.1);
    dinoRunAnimation = spriteSheet.createAnimationByLimit(xInit: 5, yInit: 0, step: 8, sizeX: 5, stepTime: 0.1);
    dinoWalkAnimation = spriteSheet.createAnimationByLimit(xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: 0.1);

    animation = dinoWalkAnimation;

    screenWidth = MediaQueryData.fromView(window).size.width;
    screenHeight = MediaQueryData.fromView(window).size.height;
    centerX = (screenWidth / 2) - (spriteSheetWidth / 8);
    centerY = (screenHeight / 2) - (spriteSheetHeight / 8);

    size = Vector2(spriteSheetWidth / 4, spriteSheetHeight / 4); // Tamaño dino
    position = Vector2(centerX, centerY);

    debugMode = true; // Permite ver los hitBox

    RectangleHitbox dinoHitBox = RectangleHitbox(
      size: Vector2(spriteSheetWidth / 8 - 8, spriteSheetHeight / 4 - 20),
      position: Vector2(10, 8),
    );

    add(dinoHitBox); // agregarle un hitbox
  }

  @override
  bool onTapDown(TapDownInfo info) {
    print(info);
    // animationIndex++;

    // if (animationIndex > 4) animationIndex = 0;

    // switch (animationIndex) {
    //   case 0:
    //     animation = dinoDeadAnimation;
    //     break;
    //   case 1:
    //     animation = dinoIdleAnimation;
    //     break;
    //   case 2:
    //     animation = dinoJumpAnimation;
    //     break;
    //   case 3:
    //     animation = dinoRunAnimation;
    //     break;
    //   case 4:
    //     animation = dinoWalkAnimation;
    //     break;
    //   default:
    //     animation = dinoIdleAnimation;
    // }

    super.onTapDown(info);
    return true;
  }

  // @override
  // bool onTapUp(TapUpInfo info) {
  //   print(info);
  //   super.onTapUp(info);
  //   return true;
  // }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.isEmpty) animation = dinoIdleAnimation;

    // CORRER DERECHA
    if ((keysPressed.contains(LogicalKeyboardKey.arrowRight) || keysPressed.contains(LogicalKeyboardKey.keyD)) &&
        (keysPressed.contains(LogicalKeyboardKey.shiftLeft))) {
      if (!isRight) {
        isRight = true;
        flipHorizontally();
      }
      playerSpeed = 1500;
      animation = dinoRunAnimation;
      posX++;
    }
    // ANDAR DERECHA
    else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) || keysPressed.contains(LogicalKeyboardKey.keyD)) {
      if (!isRight) {
        isRight = true;
        flipHorizontally();
      }
      playerSpeed = 500;
      animation = dinoWalkAnimation;
      posX++;
    }

    // CORRER IZQUIERDA
    if ((keysPressed.contains(LogicalKeyboardKey.arrowLeft) || keysPressed.contains(LogicalKeyboardKey.keyA)) &&
        (keysPressed.contains(LogicalKeyboardKey.shiftLeft))) {
      if (isRight) {
        playerSpeed = 1500;
        isRight = false;
        flipHorizontally();
      }
      animation = dinoRunAnimation;
      posX--;
    }
    // ANDAR IZQUIERDA
    else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) || keysPressed.contains(LogicalKeyboardKey.keyA)) {
      if (isRight) {
        isRight = false;
        flipHorizontally();
      }
      playerSpeed = 500;
      animation = dinoWalkAnimation;
      posX--;
    }

    // ANDAR ARRIBA
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) || keysPressed.contains(LogicalKeyboardKey.keyW)) {
      animation = dinoWalkAnimation;
      playerSpeed = 500;
      posY--;
    }

    // ANDAR ABAJO
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown) || keysPressed.contains(LogicalKeyboardKey.keyS)) {
      animation = dinoWalkAnimation;
      playerSpeed = 500;
      posY++;
    }

    return true;
  }

  @override
  void update(double dt) {
    position.x += dt * posX * playerSpeed;
    position.y += dt * posY * playerSpeed;

    posX = 0;
    posY = 0;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    print('COLLISION DINO');
  }
}

extension CreateAnimationByLimit on SpriteSheet {
  SpriteAnimation createAnimationByLimit({
    // Función para coger sprites de la imagen matriz de sprites
    required int xInit,
    required int yInit,
    required int step,
    required int sizeX,
    required double stepTime,
    bool loop = true,
  }) {
    final List<Sprite> spriteList = [];
    int x = xInit;
    int y = yInit - 1;

    for (var i = 0; i < step; i++) {
      if (y >= sizeX) {
        y = 0;
        x++;
      } else {
        y++;
      }
      spriteList.add(getSprite(x, y));
      // print('x: $x, y: $y');
    }
    return SpriteAnimation.spriteList(spriteList, stepTime: stepTime, loop: loop);
  }
}
