library flame_texturepacker;

import 'dart:convert';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

extension TexturepackerLoader on Game {
  Future<List<Sprite>> fromJSONAtlas(
      String imagePath, String dataPath) async {
    final String content = await Flame.assets.readFile(dataPath);
    final Map<String, dynamic> json = jsonDecode(content);

    final Map<String, dynamic> jsonFrames = json['frames'];
    final image = await Flame.images.load(imagePath);

    final sprites = jsonFrames.values.map((value) {
      final frameData = value['frame'];
      final int x = frameData['x'];
      final int y = frameData['y'];
      final int width = frameData['w'];
      final int height = frameData['h'];

      final Sprite sprite = Sprite(image,
          srcPosition: Vector2(x.toDouble(), y.toDouble()),
          srcSize: Vector2(width.toDouble(), height.toDouble()));
      return sprite;
    });
    return sprites.toList();
  }
}
