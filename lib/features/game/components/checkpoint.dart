import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../player/saba_player.dart';

class Checkpoint extends PositionComponent {
  final SabaPlayer player;

  final void Function(Vector2 position) onActivated;

  bool activated = false;

  double animationTime = 0;

  Checkpoint({
    required Vector2 position,
    required this.player,
    required this.onActivated,
  }) : super(
          position: position,
          size: Vector2(
            90,
            150,
          ),
          anchor: Anchor.bottomCenter,
        );

  @override
  void update(double dt) {
    super.update(dt);

    animationTime += dt;

    if (activated) {
      return;
    }

    final distance = position.distanceTo(
      player.position,
    );

    if (distance < 100) {
      _activate();
    }
  }

  void _activate() {
    if (activated) {
      return;
    }

    activated = true;

    onActivated(
      Vector2(
        position.x,
        535,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // =========================
    // SHADOW
    // =========================

    canvas.drawOval(
      const Rect.fromLTWH(
        10,
        135,
        70,
        12,
      ),
      Paint()
        ..color = Colors.black.withValues(
          alpha: 0.30,
        ),
    );

    // =========================
    // POLE
    // =========================

    canvas.drawRect(
      const Rect.fromLTWH(
        40,
        15,
        8,
        125,
      ),
      Paint()
        ..color = const Color(
          0xFF5D4037,
        ),
    );

    // =========================
    // BASE
    // =========================

    canvas.drawRect(
      const Rect.fromLTWH(
        25,
        135,
        40,
        10,
      ),
      Paint()
        ..color = const Color(
          0xFF795548,
        ),
    );

    // =========================
    // FLAG
    // =========================

    final flagPath = Path();

    flagPath.moveTo(
      48,
      20,
    );

    flagPath.lineTo(
      85,
      30,
    );

    flagPath.lineTo(
      48,
      50,
    );

    flagPath.close();

    canvas.drawPath(
      flagPath,
      Paint()
        ..color = activated
            ? const Color(
                0xFFFFD54F,
              )
            : const Color(
                0xFF8D6042,
              ),
    );

    // =========================
    // GLOW WHEN ACTIVATED
    // =========================

    if (activated) {
      final glow =
          0.15 +
          ((math.sin(animationTime * 4) + 1) *
              0.10);

      canvas.drawCircle(
        const Offset(
          44,
          75,
        ),
        55,
        Paint()
          ..color =
              Colors.amber.withValues(
            alpha: glow,
          ),
      );

      // =========================
      // ACTIVE SYMBOL
      // =========================

      canvas.drawCircle(
        const Offset(
          44,
          75,
        ),
        18,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = const Color(
            0xFFFFD54F,
          ),
      );

      canvas.drawCircle(
        const Offset(
          44,
          75,
        ),
        6,
        Paint()
          ..color = const Color(
            0xFFFFD54F,
          ),
      );
    }
  }
}