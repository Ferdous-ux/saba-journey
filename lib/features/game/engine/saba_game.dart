import 'dart:math' as math;

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../levels/saba_world.dart';

class SabaGame extends FlameGame<SabaWorld> {
  static const double gameWidth = 1280;
  static const double gameHeight = 720;

  SabaGame()
      : super(
          world: SabaWorld(),
          camera: CameraComponent(
            viewport: MaxViewport(),
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder
      ..anchor = Anchor.center
      ..position = Vector2(
        gameWidth / 2,
        gameHeight / 2,
      );

    _updateCamera();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _updateCamera();
  }

  void _updateCamera() {
    if (size.x <= 0 || size.y <= 0) {
      return;
    }

    final scaleX = size.x / gameWidth;
    final scaleY = size.y / gameHeight;

    // Cover: يملأ الشاشة بالكامل مع الحفاظ على النسبة.
    camera.viewfinder.zoom = math.max(scaleX, scaleY);

    camera.viewfinder.position.setValues(
      gameWidth / 2,
      gameHeight / 2,
    );
  }

  void movePlayerLeft() {
    world.player.moveLeft();
  }

  void movePlayerRight() {
    world.player.moveRight();
  }

  void stopPlayer() {
    world.player.stopMoving();
  }
}