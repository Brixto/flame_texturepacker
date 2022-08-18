library flame_texturepacker;

import 'dart:convert';

import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

extension TexturepackerLoader on Game {
  Future<List<Sprite>> fromJSONAtlas(String imagePath, String dataPath) async {
    final jsonFrames = await _loadJsonFrames(dataPath);
    final image = await Flame.images.load(imagePath);

    final sprites = jsonFrames.values.map((value) {
      return _createSprite(value, image);
    });

    return sprites.toList();
  }

  Future<Map<String, Sprite>> fromJSONAtlasAsMap(
      String imagePath, String dataPath) async {
    final jsonFrames = await _loadJsonFrames(dataPath);
    final image = await Flame.images.load(imagePath);
    final Map<String, Sprite> map = {};

    jsonFrames.forEach((filename, value) {
      final id = _filenameWithoutExtension(filename);
      map[id] = _createSprite(value, image);
    });

    return map;
  }

  String _filenameWithoutExtension(String filename) {
    if (filename.indexOf('.') == -1) {
      return filename;
    } else {
      return filename.substring(0, filename.lastIndexOf('.'));
    }
  }

  Future<Map<String, dynamic>> _loadJsonFrames(String dataPath) async {
    final String content = await Flame.assets.readFile(dataPath);
    final Map<String, dynamic> json = jsonDecode(content);
    return json['frames'];
  }

  Sprite _createSprite(dynamic value, Image image) {
    final frameData = value['frame'];
    final int x = frameData['x'];
    final int y = frameData['y'];
    final int width = frameData['w'];
    final int height = frameData['h'];

    return Sprite(
      image,
      srcPosition: Vector2(x.toDouble(), y.toDouble()),
      srcSize: Vector2(width.toDouble(), height.toDouble()),
    );
  }
}
