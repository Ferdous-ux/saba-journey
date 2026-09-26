import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ParallaxLayer extends PositionComponent {

  final double speed;
  final Color color;

  ParallaxLayer({
    required this.speed,
    required this.color,
    required Vector2 size,
  }) : super(
          size: size,
        );


  double cameraX = 0;


  void updateCamera(double x) {
    cameraX = x;
  }


  @override
  void render(Canvas canvas) {

    final offset = -cameraX * speed;


    final paint = Paint()
      ..color = color;


    canvas.save();

    canvas.translate(
      offset,
      0,
    );


    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.x,
        size.y,
      ),
      paint,
    );


    canvas.restore();
  }
}