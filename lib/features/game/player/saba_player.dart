import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class SabaPlayer extends RectangleComponent {
  static const double moveSpeed = 350.0;

  // -1 = يسار
  //  0 = توقف
  //  1 = يمين
  double moveDirection = 0;

  SabaPlayer({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(70, 110),
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFFFFA726),
        );

  @override
  void update(double dt) {
    super.update(dt);

    position.x += moveDirection * moveSpeed * dt;

    // منع اللاعب من الخروج من حدود العالم.
    final halfWidth = size.x / 2;

    position.x = position.x.clamp(
      halfWidth,
      1280 - halfWidth,
    );
  }

  void moveLeft() {
    moveDirection = -1;
  }

  void moveRight() {
    moveDirection = 1;
  }

  void stopMoving() {
    moveDirection = 0;
  }
}