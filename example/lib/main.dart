import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';

main() {
  final myGame = MyGame();
  runApp(
    GameWidget(
      game: myGame,
    ),
  );
}

class MyGame extends FlameGame {
  late SpriteAnimation walk;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final sprites = await fromJSONAtlas('spritesheet.png', 'spritesheet.json');
    walk = SpriteAnimation.spriteList(sprites, stepTime: 0.1);

    final map = await fromJSONAtlasAsMap('spritesheet.png', 'spritesheet.json');
    int i = 0;
    map.forEach((key, element) {
      add(TextComponent(text: key,)
        ..textRenderer = TextPaint(
            style: const TextStyle(fontSize: 10)
        )
        ..position = Vector2(i*60, 170)
        ..anchor = Anchor.centerLeft
      );
      add(SpriteComponent(
        sprite: element,
        position: Vector2(i*60, 180),
        size: Vector2(60, 60),
      ));
      i++;
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    walk.update(dt);
  }

  @override
  void render(Canvas c) {
    super.render(c);
    walk.getSprite().render(c);
  }
}
