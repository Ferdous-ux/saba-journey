import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../player/saba_player.dart';

class SabaWorld extends World {
  static const double worldWidth = 1280;
  static const double worldHeight = 720;

  late final SabaPlayer player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Background
    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: Vector2(worldWidth, worldHeight),
        paint: Paint()..color = const Color(0xFF101828),
      ),
    );

    // Ground
    add(
      RectangleComponent(
        position: Vector2(0, 620),
        size: Vector2(worldWidth, 100),
        paint: Paint()..color = const Color(0xFF5D4037),
      ),
    );

    // Game title
    add(
      TextComponent(
        text: 'SABA JOURNEY',
        position: Vector2(
          worldWidth / 2,
          100,
        ),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // Player
    player = SabaPlayer(
      position: Vector2(
        worldWidth / 2,
        565,
      ),
    );

    add(player);
  }
}