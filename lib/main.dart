import 'package:dinometeor/components/meteor_component.dart';
import 'package:dinometeor/components/player_component.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  // Habilitar los que se usan en cada componente tras el
  // HasTappables permite manejar los eventos de toque mediante componentes
  // HasKeyboardHandlerComponents manejar los eventos de teclado mediante componentes

  @override
  Future<void> onLoad() async {
    add(ScreenHitbox()); // HitBox en los bordes de la pantalla
    add(PlayerComponent());

    return super.onLoad();
  }

  double elapsedTime = 0.0;

  @override
  void update(double dt) {
    elapsedTime += dt;
    if (elapsedTime >= 1) {
      add(MeteorComponent());
      elapsedTime = 0.0;
    }

    super.update(dt);
  }
}

void main() {
  runApp(GameWidget(game: MyGame()));
}
