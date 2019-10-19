import 'package:flame/flame.dart';

class FlameUtils {
  static loadAssets() async {
    Flame.images.loadAll([
      "heart_outline.png",
      "heart_filled.png",
      "balloon_red.png",
      "balloon_blue.png",
      "balloon_green.png",
      "balloon_yellow.png",
      "obstacle.png",
      "spaceship.png"
    ]);
  }
}
