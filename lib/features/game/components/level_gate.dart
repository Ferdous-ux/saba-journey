import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LevelGate extends PositionComponent {
  double animationTime = 0;

  LevelGate({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(150, 210),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);

    animationTime += dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // الظل
    canvas.drawOval(
      const Rect.fromLTWH(
        10,
        190,
        130,
        18,
      ),
      Paint()
        ..color = Colors.black.withValues(
          alpha: 0.35,
        ),
    );

    // العمود الأيسر
    canvas.drawRect(
      const Rect.fromLTWH(
        10,
        35,
        30,
        160,
      ),
      Paint()
        ..color = const Color(
          0xFF8C6748,
        ),
    );

    // العمود الأيمن
    canvas.drawRect(
      const Rect.fromLTWH(
        110,
        35,
        30,
        160,
      ),
      Paint()
        ..color = const Color(
          0xFF8C6748,
        ),
    );

    // الجزء العلوي
    canvas.drawRect(
      const Rect.fromLTWH(
        0,
        15,
        150,
        35,
      ),
      Paint()
        ..color = const Color(
          0xFFA77A50,
        ),
    );

    // فتحة البوابة
    canvas.drawRect(
      const Rect.fromLTWH(
        40,
        50,
        70,
        145,
      ),
      Paint()
        ..color = const Color(
          0xFF171A26,
        ),
    );

    // توهج البوابة
    final glow =
        0.25 +
        (math.sin(animationTime * 3) + 1) * 0.10;

    canvas.drawRect(
      const Rect.fromLTWH(
        48,
        58,
        54,
        137,
      ),
      Paint()
        ..color = const Color(
          0xFFFFC857,
        ).withValues(
          alpha: glow,
        ),
    );

    // الرمز السبئي التجريبي
    canvas.drawCircle(
      const Offset(
        75,
        32,
      ),
      12,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = const Color(
          0xFFFFD36A,
        ),
    );
  }
}