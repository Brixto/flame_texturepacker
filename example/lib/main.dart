import 'dart:ui';
import 'package:flame/animation.dart' as anim;
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyGame().widget);

class MyGame extends Game {
  List<Sprite> sprites = List();
  anim.Animation walk = anim.Animation.empty();

  MyGame() {
    TexturepackerLoader.fromJSONAtlas('spritesheet.png', 'spritesheet.json')
        .then((sprites) {
      this.sprites = sprites;
      walk = anim.Animation.spriteList(
        sprites,
        stepTime: 0.1,
        loop: true,
      );
    });
  }

  @override
  void render(Canvas canvas) {
    if (walk.loaded()) {
      walk.getSprite().render(canvas);
    }
  }

  @override
  void update(double t) {
    if (walk.loaded()) {
      this.walk.update(t);
    }
  }
}
