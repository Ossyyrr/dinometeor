import 'package:dinometeor/components/background_image_component.dart';
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

  final world = World();
  late final CameraComponent cameraComponent;

  @override
  Future<void> onLoad() async {
    var background = BackgroundImageComponent();

    add(background);

    // Future
    background.loaded.then((value) {
      print(background.size);
      var player = PlayerComponent(mapSize: background.size);
      add(player);
      camera.followComponent(player, worldBounds: Rect.fromLTRB(0, 0, background.size.x, background.size.y));
    });

    add(ScreenHitbox()); // HitBox en los bordes de la pantalla

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

  @override
  Color backgroundColor() {
    super.backgroundColor();
    return Colors.purple;
  }
}

void main() {
  runApp(GameWidget(game: MyGame()));
}
