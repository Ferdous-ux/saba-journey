import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../levels/level_progress.dart';
import '../player/saba_player.dart';

class TreasureChest extends PositionComponent {
  // ============================================================
  // SAVE DATA
  // ============================================================

  final String? chestId;

  final LevelProgress? progress;

  // ============================================================
  // PLAYER
  // ============================================================

  final SabaPlayer player;

  // ============================================================
  // CHEST STATE
  // ============================================================

  bool isOpened = false;

  double openAnimation = 0;

  static const int rewardCoins = 5;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  TreasureChest({
    required Vector2 position,
    required this.player,
    this.chestId,
    this.progress,
  }) : super(
          position: position,
          size: Vector2(
            100,
            75,
          ),
          anchor: Anchor.center,
        );

  // ============================================================
  // LOAD
  // ============================================================

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // إذا كان الصندوق مفتوحًا سابقًا
    // يبقى مفتوحًا بعد RETRY
    // ولا يعطي المكافأة مرة أخرى

    if (progress != null &&
        chestId != null &&
        progress!.isChestOpened(
          chestId!,
        )) {
      isOpened = true;

      openAnimation = 1;
    }
  }

  // ============================================================
  // UPDATE
  // ============================================================

  @override
  void update(double dt) {
    super.update(dt);

    // =========================
    // OPEN ANIMATION
    // =========================

    if (isOpened &&
        openAnimation < 1) {
      openAnimation += dt * 4;

      if (openAnimation > 1) {
        openAnimation = 1;
      }
    }

    // =========================
    // PLAYER DISTANCE
    // =========================

    if (!isOpened) {
      final distance =
          position.distanceTo(
        player.position,
      );

      if (distance < 100) {
        _openChest();
      }
    }
  }

  // ============================================================
  // OPEN CHEST
  // ============================================================

  void _openChest() {
    if (isOpened) {
      return;
    }

    // حماية من إعطاء المكافأة مرتين

    if (progress != null &&
        chestId != null &&
        progress!.isChestOpened(
          chestId!,
        )) {
      isOpened = true;
      openAnimation = 1;

      return;
    }

    isOpened = true;

    // =========================
    // SAVE CHEST
    // =========================

    if (progress != null &&
        chestId != null) {
      progress!.openChest(
        chestId!,
        reward: rewardCoins,
      );

      // مزامنة عداد اللاعب
      // مع LevelProgress
      player.coins =
          progress!.coins;
    } else {
      // دعم النظام القديم إذا لم يوجد Progress

      for (
        int i = 0;
        i < rewardCoins;
        i++
      ) {
        player.addCoin();
      }
    }
  }

  // ============================================================
  // RENDER
  // ============================================================

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // =========================
    // SHADOW
    // =========================

    canvas.drawOval(
      const Rect.fromLTWH(
        5,
        58,
        90,
        14,
      ),
      Paint()
        ..color =
            Colors.black.withValues(
          alpha: 0.30,
        ),
    );

    // =========================
    // CHEST BODY
    // =========================

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(
          5,
          30,
          90,
          38,
        ),
        const Radius.circular(
          8,
        ),
      ),
      Paint()
        ..color =
            const Color(
          0xFF6D3D21,
        ),
    );

    // =========================
    // GOLD BORDER
    // =========================

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(
          5,
          30,
          90,
          38,
        ),
        const Radius.circular(
          8,
        ),
      ),
      Paint()
        ..style =
            PaintingStyle.stroke
        ..strokeWidth = 5
        ..color =
            const Color(
          0xFFD6A84B,
        ),
    );

    // =========================
    // CHEST LID
    // =========================

    canvas.save();

    if (isOpened) {
      canvas.translate(
        10,
        32,
      );

      canvas.rotate(
        -math.pi /
            3 *
            openAnimation,
      );

      canvas.translate(
        -10,
        -32,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(
          5,
          10,
          90,
          30,
        ),
        const Radius.circular(
          12,
        ),
      ),
      Paint()
        ..color =
            const Color(
          0xFF87502B,
        ),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(
          5,
          10,
          90,
          30,
        ),
        const Radius.circular(
          12,
        ),
      ),
      Paint()
        ..style =
            PaintingStyle.stroke
        ..strokeWidth = 5
        ..color =
            const Color(
          0xFFD6A84B,
        ),
    );

    canvas.restore();

    // =========================
    // LOCK
    // =========================

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(
          40,
          35,
          20,
          24,
        ),
        const Radius.circular(
          4,
        ),
      ),
      Paint()
        ..color =
            const Color(
          0xFFFFD54F,
        ),
    );

    // =========================
    // OPENED EFFECT
    // =========================

    if (isOpened) {
      final glowAlpha =
          (0.30 +
                  0.20 *
                      math.sin(
                        openAnimation *
                            8,
                      ))
              .clamp(
        0.0,
        0.5,
      );

      canvas.drawCircle(
        const Offset(
          50,
          15,
        ),
        45,
        Paint()
          ..color =
              Colors.amber.withValues(
            alpha:
                glowAlpha,
          ),
      );

      // العملات الظاهرة فوق الصندوق

      for (
        int i = 0;
        i < 3;
        i++
      ) {
        canvas.drawCircle(
          Offset(
            35.0 +
                (i * 15),
            5.0 -
                (i % 2) * 8,
          ),
          7,
          Paint()
            ..color =
                const Color(
              0xFFFFD700,
            ),
        );
      }
    }
  }
}