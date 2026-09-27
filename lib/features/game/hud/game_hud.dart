import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../player/saba_player.dart';

class GameHUD extends PositionComponent {
  final SabaPlayer player;
  final int levelNumber;

  late TextComponent healthText;
  late TextComponent coinText;
  late TextComponent levelText;

  GameHUD({
    required this.player,
    required this.levelNumber,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    healthText = TextComponent(
      text: '❤️ ${player.health}',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(30, 30),
    );

    coinText = TextComponent(
      text: '🪙 ${player.coins}',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.yellow,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(30, 70),
    );

    levelText = TextComponent(
      text: '⭐ Level $levelNumber',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(30, 110),
    );

    add(healthText);
    add(coinText);
    add(levelText);
  }

  @override
  void update(double dt) {
    super.update(dt);

    healthText.text = '❤️ ${player.health}';
    coinText.text = '🪙 ${player.coins}';
    levelText.text = '⭐ Level $levelNumber';
  }
}