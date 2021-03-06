# flame_texturepacker

A flame plugin to import spritesheets generated by TexturePacker

## Install from Dart Pub

Include the following to your pubspec.yaml file:
```
dependencies:
  flame_texturepacker: any
 ```
 
 ## Usage
 Drop generated spritesheet image into the `assets/images/` folder and the spritesheet json into `assets/` and link the files in your `pubspec.yaml` file:
 ```
 assets:
    - assets/spritesheet.json
    - assets/images/spritesheet.png
 ```
 
 import the plugin like this:
 `import 'package:flame_texturepacker/flame_texturepacker.dart';`
 
 generate a list of Sprites from the provided spritesheet:
 `List<Sprites> sprites =  await TexturepackerLoader.fromJSONAtlas('spritesheet.png', 'spritesheet.json');`
 
 the list can be used to generate an Animation as well:
 ```
 Animation anim = Animation.spriteList(
     sprites,
     stepTime: 0.1,
     loop: true,
 );
 ```
 
 Full working example can be found in example folder.
