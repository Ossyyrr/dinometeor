import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Character extends SpriteAnimationComponent with KeyboardHandler, CollisionCallbacks {
  // Tappable para los eventos de toque
  // KeyboardHandler necesita el HasKeyboardHandlerComponents en el main
  late double screenWidth, screenHeight, centerX, centerY;
  final double spriteSheetWidth = 680, spriteSheetHeight = 472; // Valores de la imagen  

  int posX = 0, posY = 0;
  double playerSpeed = 500;

  int animationIndex = 0;

  bool inGround = true, isRight = true, collisionXRight = false, collisionXLeft = false;

  double gravity = 5;
  Vector2 velocity = Vector2(0, 0);

  final double jumpForce = 200;

  late SpriteAnimation deadAnimation, idleAnimation, jumpAnimation, runAnimation, walkAnimation, walkSlowAnimation;
}
