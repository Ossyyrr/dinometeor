import 'package:flame/sprite.dart';

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
