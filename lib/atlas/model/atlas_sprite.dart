import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flame_texturepacker/atlas/model/region.dart';

class AtlasSprite extends Sprite {
  /// The number at the end of the original image file name, or -1 if none.<br>
  /// <br>
  /// When sprites are packed, if the original file name ends with a number, it is stored as the index and is not considered as
  /// part of the sprite's name. This is useful for keeping animation frames in order.
  final int index;

  /// The name of the original image file, without the file's extension.<br>
  /// If the name ends with an underscore followed by only numbers, that part is excluded: underscores denote special
  /// instructions to the texture packer.
  final String name;

  /// The offset from the left of the original image to the left of the packed image, after whitespace was removed for
  /// packing.
  final double offsetX;

  /// The offset from the bottom of the original image to the bottom of the packed image, after whitespace was removed for
  /// packing.
  final double offsetY;

  /// The width of the image, after whitespace was removed for packing. */
  final double packedWidth;

  /// The height of the image, after whitespace was removed for packing. */
  final double packedHeight;

  /// The width of the image, before whitespace was removed and rotation was applied for packing. */
  final double originalWidth;

  /// The height of the image, before whitespace was removed for packing. */
  final double originalHeight;

  /// If true, the region has been rotated 90 degrees counter clockwise. */
  final bool rotate;

  /// The degrees the region has been rotated, counter clockwise between 0 and 359. Most atlas region handling deals only with
  /// 0 or 90 degree rotation (enough to handle rectangles). More advanced texture packing may support other rotations (eg, for
  /// tightly packing polygons).
  final int degrees;

  AtlasSprite(Region region)
      : name = region.name,
        index = region.index,
        offsetX = region.offsetX,
        offsetY = region.offsetY,
        packedWidth = region.rotate ? region.height : region.width,
        packedHeight = region.rotate ? region.width : region.height,
        originalWidth = region.originalWidth,
        originalHeight = region.originalHeight,
        rotate = region.rotate,
        degrees = region.degrees,
        transform = Transform2D(),
        super(
          region.page.texture,
          srcPosition: Vector2(region.left, region.top),
          srcSize: Vector2(
            region.rotate ? region.height : region.width,
            region.rotate ? region.width : region.height,
          ),
        ) {
    decorator = Transform2DDecorator(transform);
    if (region.rotate) {
      transform.angle = radians(90);
    }
  }

  final Transform2D transform;
  late final Decorator decorator;

  // Used to avoid the creation of new Vector2 objects in render.
  static final _tmpRenderPosition = Vector2.zero();
  static final _tmpRenderSize = Vector2.zero();

  @override
  void render(
    Canvas canvas, {
    Vector2? position,
    Vector2? size,
    Anchor anchor = Anchor.topLeft,
    Paint? overridePaint,
  }) {
    if (position != null) {
      _tmpRenderPosition.setFrom(position);
    } else {
      _tmpRenderPosition.setZero();
    }

    // Transform if there is rotation
    final _anchor = rotate ? Anchor.bottomLeft : anchor;

    final tempSize = size ?? srcSize;
    final tempWidth = rotate ? tempSize.y : tempSize.x;
    final tempHeight = rotate ? tempSize.x : tempSize.y;

    _tmpRenderSize.setValues(tempWidth, tempHeight);

    _tmpRenderPosition.setValues(
      _tmpRenderPosition.x - (_anchor.x * _tmpRenderSize.x),
      _tmpRenderPosition.y - (_anchor.y * _tmpRenderSize.y),
    );

    decorator.applyChain(
      (applyCanvas) => super.render(
        applyCanvas,
        position: _tmpRenderPosition,
        size: _tmpRenderSize,
        anchor: anchor,
        overridePaint: overridePaint,
      ),
      canvas,
    );
  }
}
