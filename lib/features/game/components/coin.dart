import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../levels/level_progress.dart';
import '../player/saba_player.dart';

class Coin extends PositionComponent {
  final String? coinId;
  final LevelProgress? progress;

  bool collected = false;

  double animationTime = 0;

  late double startY;

  Coin({
    required Vector2 position,
    this.coinId,
    this.progress,
  }) : super(
          position: position,
          size: Vector2(
            40,
            40,
          ),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    startY = position.y;

    // ==========================================
    // إذا كانت العملة مجمعة سابقًا
    // لا تظهر مرة أخرى
    // ==========================================

    if (progress != null &&
        coinId != null &&
        progress!.isCoinCollected(coinId!)) {
      collected = true;

      removeFromParent();

      return;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (collected) {
      return;
    }

    animationTime += dt;

    // حركة طفو خفيفة
    position.y =
        startY +
        math.sin(
              animationTime * 3,
            ) *
            5;
  }

  // ==========================================
  // CHECK COLLISION
  // ==========================================

  void checkCollision(
    SabaPlayer player,
  ) {
    if (collected) {
      return;
    }

    final distance =
        position.distanceTo(
      player.position,
    );

    if (distance < 60) {
      collect(player);
    }
  }

  // ==========================================
  // COLLECT
  // ==========================================

  void collect(
    SabaPlayer player,
  ) {
    if (collected) {
      return;
    }

    // ========================================
    // حفظ العملة في LevelProgress
    // ========================================

    if (progress != null &&
        coinId != null) {
      // حماية إضافية من احتساب العملة مرتين
      if (progress!.isCoinCollected(
        coinId!,
      )) {
        collected = true;

        removeFromParent();

        return;
      }

      progress!.collectCoin(
        coinId!,
      );
    }

    // ========================================
    // تحديث عداد اللاعب الحالي
    // ========================================

    player.addCoin();

    collected = true;

    removeFromParent();
  }

  // ==========================================
  // RENDER
  // ==========================================

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (collected) {
      return;
    }

    // الظل
    canvas.drawOval(
      const Rect.fromLTWH(
        5,
        30,
        30,
        7,
      ),
      Paint()
        ..color = Colors.black.withValues(
          alpha: 0.20,
        ),
    );

    // جسم العملة
    canvas.drawCircle(
      Offset(
        size.x / 2,
        size.y / 2,
      ),
      18,
      Paint()
        ..color = const Color(
          0xFFFFD700,
        ),
    );

    // الحافة الداخلية
    canvas.drawCircle(
      Offset(
        size.x / 2,
        size.y / 2,
      ),
      11,
      Paint()
        ..style =
            PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = const Color(
          0xFFFFA000,
        ),
    );

    // اللمعة
    canvas.drawCircle(
      const Offset(
        14,
        12,
      ),
      5,
      Paint()
        ..color = Colors.white.withValues(
          alpha: 0.80,
        ),
    );
  }
}