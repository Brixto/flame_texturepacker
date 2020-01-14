library flame_texturepacker;

import 'dart:convert';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class TexturepackerLoader {
  static Future<List<Sprite>> fromJSONAtlas(
      String imagePath, String dataPath) async {
    final String content = await Flame.assets.readFile(dataPath);
    final Map<String, dynamic> json = jsonDecode(content);

    final Map<String, dynamic> jsonFrames = json['frames'];

    final sprites = jsonFrames.values.map((value) {
      final frameData = value['frame'];
      final int x = frameData['x'];
      final int y = frameData['y'];
      final int width = frameData['w'];
      final int height = frameData['h'];

      final Sprite sprite = Sprite(
        imagePath,
        x: x.toDouble(),
        y: y.toDouble(),
        width: width.toDouble(),
        height: height.toDouble(),
      );

      return sprite;
    });

    return sprites.toList();
  }
}
