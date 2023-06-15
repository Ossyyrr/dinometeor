import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BackgroundImageComponent extends SpriteComponent {
  late double screenWidth, screenHeight;

  @override
  FutureOr<void> onLoad() async {
    screenWidth = MediaQueryData.fromView(window).size.width;
    screenHeight = MediaQueryData.fromView(window).size.height;

    position = Vector2(0, 0);
    sprite = await Sprite.load('background.jpg');
    // size = Vector2(screenWidth, screenHeight);
    size = sprite!.originalSize;

    return super.onLoad();
  } 
}
