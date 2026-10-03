import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../levels/saba_world.dart';
import 'player_animation.dart';


enum PlayerState {

  idle,

  walking,

  running,

  jumping,

  falling,

  attacking,

  hurt,

  dead,

}





class SabaPlayer extends PositionComponent {



  // ============================================================
  // MOVEMENT CONSTANTS
  // ============================================================

late SpriteAnimationComponent sprite;

late PlayerAnimationController animationController;
  static const double walkSpeed = 350;

  static const double runSpeed = 520;


  static const double gravity = 1900;

  static const double jumpForce = -780;


  static const double groundY = 535;





  // ============================================================
  // COMBAT CONSTANTS
  // ============================================================


  static const double attackDuration = 0.30;

  static const double attackCooldown = 0.45;


  static const double attackRange = 120;


  static const int attackDamage = 25;





  // ============================================================
  // PHYSICS
  // ============================================================


  double moveDirection = 0;


  double verticalVelocity = 0;


  double knockbackVelocity = 0;


  bool isOnGround = true;


  bool facingRight = true;





  // ============================================================
  // ANIMATION SYSTEM
  // ============================================================


  double animationTime = 0;


  double animationTimer = 0;


  int animationFrame = 0;


  String currentAnimation = "idle";





  // ============================================================
  // STATES
  // ============================================================


  PlayerState state =
      PlayerState.idle;





  // ============================================================
  // ATTACK SYSTEM
  // ============================================================


  bool isAttacking = false;


  double attackTimer = 0;


  double attackCooldownTimer = 0;


  bool attackHit = false;





  // ============================================================
  // HEALTH SYSTEM
  // ============================================================


  int health = 100;


  final int maxHealth = 100;



  bool isDead = false;


  bool isInvincible = false;


  double invincibleTimer = 0;


  double hitFlashTimer = 0;





  // ============================================================
  // COINS
  // ============================================================


  int coins = 0;





  // ============================================================
  // CONSTRUCTOR
  // ============================================================


  SabaPlayer({

    required super.position,

  }) : super(

          size: Vector2(

            80,

            110,

          ),

          anchor:

              Anchor.center,

        );






  @override
  void update(
    double dt,
  ) {


    super.update(dt);



    animationTime += dt;



    _updateTimers(dt);



    _updateAnimation(dt);



    if (!isDead) {

      _updateMovement(dt);


      _updateGravity(dt);


      _updateGround();

    }



    _updateState();


    _checkWorldBounds();


  }






  // ============================================================
  // TIMERS
  // ============================================================


  void _updateTimers(
    double dt,
  ) {


    if (attackTimer > 0) {

      attackTimer -= dt;


      if (attackTimer <= 0) {

        attackTimer = 0;


        isAttacking = false;

      }

    }



    if (attackCooldownTimer > 0) {

      attackCooldownTimer -= dt;


      if (attackCooldownTimer < 0) {

        attackCooldownTimer = 0;

      }

    }





    if (invincibleTimer > 0) {


      invincibleTimer -= dt;


      if (invincibleTimer <= 0) {


        invincibleTimer = 0;


        isInvincible = false;

      }

    }




    if (hitFlashTimer > 0) {


      hitFlashTimer -= dt;


      if (hitFlashTimer < 0) {

        hitFlashTimer = 0;

      }

    }


  }
    // ============================================================
  // ANIMATION UPDATE
  // ============================================================


  void _updateAnimation(
    double dt,
  ) {


    animationTimer += dt;


    if (animationTimer >= 0.12) {


      animationTimer = 0;


      animationFrame++;


      if (animationFrame > 3) {

        animationFrame = 0;

      }

    }

  }






  // ============================================================
  // MOVEMENT SYSTEM
  // ============================================================


  void _updateMovement(
    double dt,
  ) {


    final speed = runSpeed;


    position.x +=
        (
          moveDirection * speed +
          knockbackVelocity
        ) * dt;



    knockbackVelocity =
        _moveTowardsZero(
          knockbackVelocity,
          1500 * dt,
        );



    if (moveDirection > 0) {

      facingRight = true;

    }

    else if (moveDirection < 0) {

      facingRight = false;

    }


  }








  // ============================================================
  // GRAVITY
  // ============================================================


  void _updateGravity(
    double dt,
  ) {


    verticalVelocity +=
        gravity * dt;



    position.y +=
        verticalVelocity * dt;


  }







  // ============================================================
  // GROUND CHECK
  // ============================================================


  void _updateGround() {


    if (position.y >= groundY) {


      position.y = groundY;


      verticalVelocity = 0;


      isOnGround = true;


    }

  }







  // ============================================================
  // PLAYER STATE
  // ============================================================


  void _updateState() {



    if (isDead) {


      state = PlayerState.dead;


      currentAnimation = "death";


      return;


    }





    if (isAttacking) {


      state = PlayerState.attacking;


      currentAnimation = "attack";


      return;


    }





    if (hitFlashTimer > 0) {


      state = PlayerState.hurt;


      currentAnimation = "hurt";


      return;


    }





    if (!isOnGround) {


      if (verticalVelocity < 0) {


        state = PlayerState.jumping;


        currentAnimation = "jump";


      }

      else {


        state = PlayerState.falling;


        currentAnimation = "fall";


      }


      return;


    }







    if (moveDirection != 0) {


      state = PlayerState.running;


      currentAnimation = "run";


      return;


    }





    state = PlayerState.idle;


    currentAnimation = "idle";


  }








  // ============================================================
  // WORLD LIMIT
  // ============================================================


  void _checkWorldBounds() {


    final halfWidth =
        size.x / 2;



    position.x =
        position.x.clamp(

          halfWidth,


          SabaWorld.worldWidth -
              halfWidth,

        );


  }








  // ============================================================
  // HELPERS
  // ============================================================


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








  // ============================================================
  // MOVEMENT CONTROLS
  // ============================================================


  void moveLeft() {


    if (isDead) return;


    moveDirection = -1;


  }






  void moveRight() {


    if (isDead) return;


    moveDirection = 1;


  }






  void stopMoving() {


    moveDirection = 0;


  }








  // ============================================================
  // JUMP
  // ============================================================


  void jump() {


    if (

      !isOnGround ||

      isDead

    ) {


      return;


    }




    verticalVelocity =
        jumpForce;



    isOnGround = false;


  }








  // ============================================================
  // ATTACK
  // ============================================================


  void attack() {


    if (

      isDead ||

      isAttacking ||

      attackCooldownTimer > 0

    ) {


      return;


    }





    isAttacking = true;


    attackHit = false;



    attackTimer =
        attackDuration;



    attackCooldownTimer =
        attackCooldown;


  }






  bool canHit(
    Vector2 targetPosition,

  ) {


    if (!isAttacking ||

        attackHit) {


      return false;


    }



    final distance =
        position.distanceTo(
          targetPosition,
        );



    if (distance > attackRange) {


      return false;


    }



    attackHit = true;


    return true;


  }








  // ============================================================
  // DAMAGE SYSTEM
  // ============================================================


  void takeDamage(

    int amount, {

    double knockbackDirection = 0,

  }) {



    if (

      isDead ||

      isInvincible

    ) {


      return;


    }




    health -= amount;



    if (health <= 0) {


      health = 0;


      die();


      return;


    }






    hitFlashTimer = 0.25;



    isInvincible = true;


    invincibleTimer = 0.8;




    if (knockbackDirection != 0) {


      knockbackVelocity =
          knockbackDirection * 450;


    }




    verticalVelocity = -250;


    isOnGround = false;



  }








  // ============================================================
  // DEATH
  // ============================================================


  void die() {


    isDead = true;


    state = PlayerState.dead;


    stopMoving();


  }








  void respawn(
    Vector2 position,

  ) {


    this.position =
        position.clone();



    health = maxHealth;


    isDead = false;


    isInvincible = false;



    verticalVelocity = 0;



    state = PlayerState.idle;


  }








  // ============================================================
  // HEALTH
  // ============================================================


  void heal(
    int amount,

  ) {


    health += amount;



    if (health > maxHealth) {


      health = maxHealth;


    }


  }







  void setHealth(
    int value,

  ) {


    health = value.clamp(

      0,

      maxHealth,

    );


  }







  int getCurrentHealth() {


    return health;


  }








  // ============================================================
  // COINS
  // ============================================================


  void addCoin() {


    coins++;


  }
    // ============================================================
  // RENDER SYSTEM
  // ============================================================


  @override
  void render(
    Canvas canvas,
  ) {


    super.render(canvas);



    canvas.save();



    // قلب الشخصية حسب الاتجاه

    if (!facingRight) {


      canvas.translate(

        size.x,

        0,

      );


      canvas.scale(

        -1,

        1,

      );


    }





    _drawPlayer(canvas);



    canvas.restore();






    // ============================================================
    // DAMAGE FLASH
    // ============================================================


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






    // ============================================================
    // DEAD EFFECT
    // ============================================================


    if (isDead) {


      canvas.drawCircle(

        Offset(

          size.x / 2,

          size.y / 2,

        ),


        55,


        Paint()

          ..color = Colors.black.withValues(

            alpha: 0.25,

          ),


      );


    }


  }









  // ============================================================
  // PLAYER DRAWING
  // ============================================================


  void _drawPlayer(
    Canvas canvas,
  ) {


    double legOffset = 0;



    if (

      state == PlayerState.running ||

      state == PlayerState.walking

    ) {


      legOffset =

          math.sin(

            animationTime * 12,

          ) *

          6;


    }







    // SHADOW

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







    // ============================================================
    // CLOAK
    // ============================================================


    final cloak = Path()

      ..moveTo(

        24,

        43,

      )


      ..lineTo(

        55,

        43,

      )


      ..lineTo(

        67,

        96,

      )


      ..lineTo(

        14,

        96,

      )


      ..close();





    canvas.drawPath(


      cloak,


      Paint()

        ..color = const Color(

          0xFF733B32,

        ),


    );







    // BODY


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







    // BELT


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







    // HEAD


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








    // HEAD COVER


    final headCover = Path()


      ..moveTo(

        23,

        28,

      )


      ..quadraticBezierTo(

        40,

        5,

        58,

        27,

      )


      ..lineTo(

        53,

        35,

      )


      ..lineTo(

        27,

        35,

      )


      ..close();





    canvas.drawPath(


      headCover,


      Paint()

        ..color = const Color(

          0xFF423330,

        ),


    );







    // ============================================================
    // ARMS
    // ============================================================


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







    // attack arm


    canvas.drawRect(


      Rect.fromLTWH(

        isAttacking ? 55 : 53,

        isAttacking ? 43 : 48,

        isAttacking ? 35 : 10,

        10,

      ),


      Paint()

        ..color = const Color(

          0xFF99553D,

        ),


    );









    // ============================================================
    // LEGS
    // ============================================================


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







    // FOOT


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









    // ============================================================
    // ATTACK EFFECT
    // ============================================================


    if (isAttacking) {


      canvas.drawArc(


        const Rect.fromLTWH(

          52,

          18,

          90,

          90,

        ),


        -1.0,


        2.0,


        false,


        Paint()

          ..color = const Color(

            0xFFFFD27A,

          )


          ..style = PaintingStyle.stroke


          ..strokeWidth = 6,


      );


    }





    // ============================================================
    // HURT EFFECT
    // ============================================================


    if (state == PlayerState.hurt) {


      canvas.drawCircle(


        const Offset(

          40,

          50,

        ),


        45,


        Paint()

          ..style = PaintingStyle.stroke


          ..strokeWidth = 3


          ..color = Colors.white,


      );


    }



  }


}