import 'dart:math' as math;

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../hud/game_hud.dart';
import '../levels/level_progress.dart';
import '../levels/saba_world.dart';

class SabaGame extends FlameGame<SabaWorld> {
  static const double gameWidth = 1280;
  static const double gameHeight = 720;

  final int levelNumber;

  final LevelProgress progress;

  final Vector2? startPosition;

  final void Function()? onGameOver;
  final void Function()? onVictory;

  final void Function(Vector2 position)?
      onCheckpointActivated;

  bool _gameOverTriggered = false;
  bool _victoryTriggered = false;

  late GameHUD hud;

  SabaGame({
    required this.levelNumber,
    required this.progress,
    this.startPosition,
    this.onGameOver,
    this.onVictory,
    this.onCheckpointActivated,
  }) : super(
          world: SabaWorld(
            levelNumber: levelNumber,
            progress: progress,
            startPosition: startPosition,
            onCheckpointActivated:
                onCheckpointActivated,
          ),
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

    hud = GameHUD(
      player: world.player,
      levelNumber: levelNumber,
    );

    camera.viewport.add(hud);

    _updateCameraZoom();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    _updateCameraZoom();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!world.isLoaded) {
      return;
    }

    // ============================================================
    // CAMERA
    // ============================================================

    final playerX =
        world.player.position.x;

    final minCameraX =
        gameWidth / 2;

    final maxCameraX =
        SabaWorld.worldWidth -
        (gameWidth / 2);

    final cameraX =
        playerX.clamp(
      minCameraX,
      maxCameraX,
    );

    camera.viewfinder.position =
        Vector2(
      cameraX.toDouble(),
      gameHeight / 2,
    );

    // ============================================================
    // GAME OVER
    // ============================================================

    if (world.player.health <= 0 &&
        !_gameOverTriggered &&
        !_victoryTriggered) {
      _gameOverTriggered = true;

      world.player.stopMoving();

      pauseEngine();

      onGameOver?.call();

      return;
    }

    // ============================================================
    // VICTORY
    // ============================================================

    if (world.levelCompleted &&
        !_victoryTriggered &&
        !_gameOverTriggered) {
      _victoryTriggered = true;

      world.player.stopMoving();

      pauseEngine();

      onVictory?.call();
    }
  }

  // ============================================================
  // CAMERA
  // ============================================================

  void _updateCameraZoom() {
    if (size.x <= 0 ||
        size.y <= 0) {
      return;
    }

    final scaleX =
        size.x / gameWidth;

    final scaleY =
        size.y / gameHeight;

    camera.viewfinder.zoom =
        math.max(
      scaleX,
      scaleY,
    );
  }

  // ============================================================
  // CONTROLS
  // ============================================================

  void movePlayerLeft() {
    if (_gameOverTriggered ||
        _victoryTriggered) {
      return;
    }

    world.player.moveLeft();
  }

  void movePlayerRight() {
    if (_gameOverTriggered ||
        _victoryTriggered) {
      return;
    }

    world.player.moveRight();
  }

  void stopPlayer() {
    world.player.stopMoving();
  }

  void jumpPlayer() {
    if (_gameOverTriggered ||
        _victoryTriggered) {
      return;
    }

    world.player.jump();
  }

  void attackPlayer() {
    if (_gameOverTriggered ||
        _victoryTriggered) {
      return;
    }

    world.player.attack();
  }
}