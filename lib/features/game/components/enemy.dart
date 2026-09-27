import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../levels/level_progress.dart';
import '../player/saba_player.dart';

class SabaEnemy extends PositionComponent {
  static const double moveSpeed = 80;

  static const int maxHealth = 100;

  static const int damageToPlayer = 10;

  static const double attackCooldown = 1.0;

  // ============================================================
  // SAVE DATA
  // ============================================================

  final String? enemyId;

  final LevelProgress? progress;

  // ============================================================
  // ENEMY DATA
  // ============================================================

  double direction = -1;

  double attackTimer = 0;

  double hitFlashTimer = 0;

  double knockbackVelocity = 0;

  bool wasHitDuringCurrentAttack = false;

  bool defeated = false;

  int health = maxHealth;

  final SabaPlayer player;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  SabaEnemy({
    required Vector2 position,
    required this.player,
    this.enemyId,
    this.progress,
  }) : super(
          position: position,
          size: Vector2(
            80,
            100,
          ),
          anchor: Anchor.center,
        );

  // ============================================================
  // LOAD
  // ============================================================

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // إذا كان هذا العدو مقتولًا سابقًا
    // لا يظهر مرة أخرى بعد RETRY

    if (progress != null &&
        enemyId != null &&
        progress!.isEnemyDefeated(
          enemyId!,
        )) {
      defeated = true;

      removeFromParent();

      return;
    }
  }

  // ============================================================
  // UPDATE
  // ============================================================

  @override
  void update(double dt) {
    super.update(dt);

    if (defeated) {
      return;
    }

    // =========================
    // HIT FLASH
    // =========================

    if (hitFlashTimer > 0) {
      hitFlashTimer -= dt;

      if (hitFlashTimer < 0) {
        hitFlashTimer = 0;
      }
    }

    // =========================
    // ATTACK TIMER
    // =========================

    if (attackTimer > 0) {
      attackTimer -= dt;
    }

    // =========================
    // MOVEMENT
    // =========================

    position.x +=
        (direction * moveSpeed +
                knockbackVelocity) *
            dt;

    knockbackVelocity =
        _moveTowardsZero(
      knockbackVelocity,
      1200 * dt,
    );

    // دورية العدو

    if (position.x < 1800) {
      direction = 1;
    }

    if (position.x > 2500) {
      direction = -1;
    }

    // =========================
    // ENEMY ATTACKS PLAYER
    // =========================

    final distanceToPlayer =
        position.distanceTo(
      player.position,
    );

    if (distanceToPlayer < 100 &&
        attackTimer <= 0 &&
        player.health > 0) {
      _attackPlayer();

      attackTimer =
          attackCooldown;
    }

    // =========================
    // PLAYER ATTACKS ENEMY
    // =========================

    if (player.isAttacking) {
      if (!wasHitDuringCurrentAttack &&
          player.canHit(
            position,
          )) {
        final knockbackDirection =
            position.x >=
                    player.position.x
                ? 1.0
                : -1.0;

        takeDamage(
          SabaPlayer.attackDamage,
          knockbackDirection:
              knockbackDirection,
        );

        wasHitDuringCurrentAttack =
            true;
      }
    } else {
      wasHitDuringCurrentAttack =
          false;
    }
  }

  // ============================================================
  // MOVE TOWARDS ZERO
  // ============================================================

  double _moveTowardsZero(
    double value,
    double amount,
  ) {
    if (value > 0) {
      final next =
          value - amount;

      return next < 0
          ? 0
          : next;
    }

    if (value < 0) {
      final next =
          value + amount;

      return next > 0
          ? 0
          : next;
    }

    return 0;
  }

  // ============================================================
  // ATTACK PLAYER
  // ============================================================

  void _attackPlayer() {
    final knockbackDirection =
        player.position.x >=
                position.x
            ? 1.0
            : -1.0;

    player.takeDamage(
      damageToPlayer,
      knockbackDirection:
          knockbackDirection,
    );
  }

  // ============================================================
  // TAKE DAMAGE
  // ============================================================

  void takeDamage(
    int damage, {
    double knockbackDirection = 0,
  }) {
    if (defeated) {
      return;
    }

    health -= damage;

    if (health < 0) {
      health = 0;
    }

    hitFlashTimer = 0.18;

    if (knockbackDirection != 0) {
      knockbackVelocity =
          knockbackDirection * 360;
    }

    if (health <= 0) {
      _defeat();
    }
  }

  // ============================================================
  // DEFEAT
  // ============================================================

  void _defeat() {
    if (defeated) {
      return;
    }

    defeated = true;

    // حفظ أن العدو تم قتله

    if (progress != null &&
        enemyId != null) {
      progress!.defeatEnemy(
        enemyId!,
      );
    }

    removeFromParent();
  }

  // ============================================================
  // RENDER
  // ============================================================

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (defeated) {
      return;
    }

    // =========================
    // BODY
    // =========================

    canvas.drawRect(
      const Rect.fromLTWH(
        10,
        20,
        60,
        70,
      ),
      Paint()
        ..color =
            const Color(
          0xFF4B1E1E,
        ),
    );

    // =========================
    // HEAD
    // =========================

    canvas.drawCircle(
      const Offset(
        40,
        20,
      ),
      20,
      Paint()
        ..color =
            const Color(
          0xFF8B4A32,
        ),
    );

    // =========================
    // EYES
    // =========================

    canvas.drawCircle(
      const Offset(
        32,
        18,
      ),
      4,
      Paint()
        ..color = Colors.red,
    );

    canvas.drawCircle(
      const Offset(
        48,
        18,
      ),
      4,
      Paint()
        ..color = Colors.red,
    );

    // =========================
    // HEALTH BAR BACKGROUND
    // =========================

    canvas.drawRect(
      const Rect.fromLTWH(
        0,
        -15,
        80,
        8,
      ),
      Paint()
        ..color =
            const Color(
          0xFF2A1B1B,
        ),
    );

    // =========================
    // HEALTH BAR
    // =========================

    final healthRatio =
        health / maxHealth;

    Color healthColor;

    if (health > 50) {
      healthColor =
          Colors.green;
    } else if (health > 25) {
      healthColor =
          Colors.orange;
    } else {
      healthColor =
          Colors.red;
    }

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        -15,
        80 * healthRatio,
        8,
      ),
      Paint()
        ..color =
            healthColor,
    );

    // =========================
    // HIT FLASH
    // =========================

    if (hitFlashTimer > 0) {
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          size.x,
          size.y,
        ),
        Paint()
          ..color =
              Colors.red.withValues(
            alpha: 0.40,
          ),
      );
    }
  }
}