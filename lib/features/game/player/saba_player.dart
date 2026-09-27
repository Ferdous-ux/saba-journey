import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../levels/saba_world.dart';

enum PlayerState {
  idle,
  walking,
  jumping,
  falling,
  attacking,
}

class SabaPlayer extends PositionComponent {
  static const double moveSpeed = 350;
  static const double gravity = 1900;
  static const double jumpForce = -780;

  static const double groundY = 535;

  static const double attackDuration = 0.30;
  static const double attackRange = 110;
  static const int attackDamage = 25;

  double moveDirection = 0;
  double verticalVelocity = 0;

  double animationTime = 0;

  double attackTimer = 0;
  double hitFlashTimer = 0;

  double knockbackVelocity = 0;

  bool isOnGround = true;
  bool facingRight = true;
  bool isAttacking = false;

  PlayerState state = PlayerState.idle;

  int health = 100;
  final int maxHealth = 100;

  int coins = 0;

  SabaPlayer({
    required super.position,
  }) : super(
          size: Vector2(80, 110),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);

    animationTime += dt;

    // =========================
    // ATTACK TIMER
    // =========================

    if (attackTimer > 0) {
      attackTimer -= dt;

      if (attackTimer <= 0) {
        attackTimer = 0;
        isAttacking = false;
      }
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
    // HORIZONTAL MOVEMENT
    // =========================

    position.x +=
        (moveDirection * moveSpeed + knockbackVelocity) * dt;

    knockbackVelocity = _moveTowardsZero(
      knockbackVelocity,
      1400 * dt,
    );

    if (moveDirection > 0) {
      facingRight = true;
    } else if (moveDirection < 0) {
      facingRight = false;
    }

    // =========================
    // GRAVITY
    // =========================

    verticalVelocity += gravity * dt;

    position.y += verticalVelocity * dt;

    // =========================
    // GROUND
    // =========================

    if (position.y >= groundY) {
      position.y = groundY;
      verticalVelocity = 0;
      isOnGround = true;
    }

    // =========================
    // STATE
    // =========================

    if (isAttacking) {
      state = PlayerState.attacking;
    } else if (!isOnGround) {
      if (verticalVelocity < 0) {
        state = PlayerState.jumping;
      } else {
        state = PlayerState.falling;
      }
    } else if (moveDirection != 0) {
      state = PlayerState.walking;
    } else {
      state = PlayerState.idle;
    }

    // =========================
    // WORLD LIMITS
    // =========================

    final halfWidth = size.x / 2;

    position.x = position.x.clamp(
      halfWidth,
      SabaWorld.worldWidth - halfWidth,
    );
  }

  double _moveTowardsZero(
    double value,
    double amount,
  ) {
    if (value > 0) {
      return math.max(
        0,
        value - amount,
      );
    }

    if (value < 0) {
      return math.min(
        0,
        value + amount,
      );
    }

    return 0;
  }

  // =========================
  // MOVEMENT
  // =========================

  void moveLeft() {
    moveDirection = -1;
  }

  void moveRight() {
    moveDirection = 1;
  }

  void stopMoving() {
    moveDirection = 0;
  }

  // =========================
  // JUMP
  // =========================

  void jump() {
    if (!isOnGround || health <= 0) {
      return;
    }

    verticalVelocity = jumpForce;
    isOnGround = false;
  }

  // =========================
  // ATTACK
  // =========================

  void attack() {
    if (isAttacking || health <= 0) {
      return;
    }

    isAttacking = true;
    attackTimer = attackDuration;
  }

  bool canHit(Vector2 targetPosition) {
    if (!isAttacking) {
      return false;
    }

    final dx =
        targetPosition.x - position.x;

    final dy =
        (targetPosition.y - position.y).abs();

    if (dy > 100) {
      return false;
    }

    if (facingRight) {
      return dx >= 0 &&
          dx <= attackRange;
    }

    return dx <= 0 &&
        dx.abs() <= attackRange;
  }

  // =========================
  // HEALTH
  // =========================

  void takeDamage(
    int amount, {
    double knockbackDirection = 0,
  }) {
    if (health <= 0) {
      return;
    }

    health -= amount;

    if (health < 0) {
      health = 0;
    }

    hitFlashTimer = 0.18;

    if (knockbackDirection != 0) {
      knockbackVelocity =
          knockbackDirection * 420;
    }

    // قفزة صغيرة عند الإصابة
    verticalVelocity = -220;
    isOnGround = false;
  }

  void heal(int amount) {
    health += amount;

    if (health > maxHealth) {
      health = maxHealth;
    }
  }

  // =========================
  // COINS
  // =========================

  void addCoin() {
    coins++;
  }

  // =========================
  // RENDER
  // =========================

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.save();

    if (!facingRight) {
      canvas.translate(size.x, 0);
      canvas.scale(-1, 1);
    }

    _drawPlayer(canvas);

    canvas.restore();

    // وميض أحمر عند الإصابة
    if (hitFlashTimer > 0) {
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          size.x,
          size.y,
        ),
        Paint()
          ..color = Colors.red.withValues(
            alpha: 0.35,
          ),
      );
    }
  }

  void _drawPlayer(Canvas canvas) {
    double legOffset = 0;

    if (state == PlayerState.walking) {
      legOffset =
          math.sin(animationTime * 10) * 5;
    }

    // الظل
    canvas.drawOval(
      const Rect.fromLTWH(
        10,
        99,
        60,
        10,
      ),
      Paint()
        ..color = Colors.black.withValues(
          alpha: 0.30,
        ),
    );

    // العباءة
    final cloak = Path()
      ..moveTo(24, 43)
      ..lineTo(55, 43)
      ..lineTo(67, 96)
      ..lineTo(14, 96)
      ..close();

    canvas.drawPath(
      cloak,
      Paint()
        ..color = const Color(
          0xFF733B32,
        ),
    );

    // الجسم
    canvas.drawRect(
      const Rect.fromLTWH(
        29,
        45,
        22,
        40,
      ),
      Paint()
        ..color = const Color(
          0xFFC58B57,
        ),
    );

    // الحزام
    canvas.drawRect(
      const Rect.fromLTWH(
        25,
        66,
        31,
        7,
      ),
      Paint()
        ..color = const Color(
          0xFF332622,
        ),
    );

    // الرأس
    canvas.drawCircle(
      const Offset(
        40,
        29,
      ),
      15,
      Paint()
        ..color = const Color(
          0xFFB9784D,
        ),
    );

    // غطاء الرأس
    final headCover = Path()
      ..moveTo(23, 28)
      ..quadraticBezierTo(
        40,
        5,
        58,
        27,
      )
      ..lineTo(53, 35)
      ..lineTo(27, 35)
      ..close();

    canvas.drawPath(
      headCover,
      Paint()
        ..color = const Color(
          0xFF423330,
        ),
    );

    // الذراع الخلفية
    canvas.drawRect(
      const Rect.fromLTWH(
        17,
        48,
        10,
        34,
      ),
      Paint()
        ..color = const Color(
          0xFF99553D,
        ),
    );

    // الذراع الأمامية أثناء الضرب
    canvas.drawRect(
      Rect.fromLTWH(
        isAttacking ? 55 : 53,
        isAttacking ? 43 : 48,
        isAttacking ? 32 : 10,
        10,
      ),
      Paint()
        ..color = const Color(
          0xFF99553D,
        ),
    );

    // الرجل الأولى
    canvas.drawRect(
      Rect.fromLTWH(
        27,
        83 + legOffset,
        11,
        22,
      ),
      Paint()
        ..color = const Color(
          0xFF302725,
        ),
    );

    // الرجل الثانية
    canvas.drawRect(
      Rect.fromLTWH(
        43,
        83 - legOffset,
        11,
        22,
      ),
      Paint()
        ..color = const Color(
          0xFF302725,
        ),
    );

    // القدم
    canvas.drawRect(
      const Rect.fromLTWH(
        43,
        101,
        18,
        6,
      ),
      Paint()
        ..color = const Color(
          0xFF211B1A,
        ),
    );

    // قوس الضربة
    if (isAttacking) {
      canvas.drawArc(
        const Rect.fromLTWH(
          52,
          18,
          80,
          80,
        ),
        -1.0,
        2.0,
        false,
        Paint()
          ..color = const Color(
            0xFFFFD27A,
          )
          ..style =
              PaintingStyle.stroke
          ..strokeWidth = 5,
      );
    }
  }
}