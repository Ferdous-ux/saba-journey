import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../levels/saba_world.dart';



enum PlayerState {

  idle,

  walking,

  jumping,

  falling,

}




class SabaPlayer extends PositionComponent {


  static const double moveSpeed = 350;

  static const double gravity = 1900;

  static const double jumpForce = -780;


  static const double groundY = 535;

int health = 100;

int maxHealth = 100;

int coins = 0;

  double moveDirection = 0;

  double verticalVelocity = 0;


  bool isOnGround = true;

  bool facingRight = true;



  PlayerState state = PlayerState.idle;


  double animationTime = 0;



  





  SabaPlayer({

    required super.position,

  }) : super(

    size: Vector2(80,110),

    anchor: Anchor.center,

  );







  @override
  void update(double dt){


    super.update(dt);



    animationTime += dt;



    // حركة

    position.x += moveDirection * moveSpeed * dt;




    if(moveDirection > 0){

      facingRight = true;

    }

    else if(moveDirection < 0){

      facingRight = false;

    }






    // جاذبية

    verticalVelocity += gravity * dt;


    position.y += verticalVelocity * dt;






    // أرض

    if(position.y >= groundY){


      position.y = groundY;


      verticalVelocity = 0;


      isOnGround = true;


    }







    // حالات اللاعب

    if(!isOnGround){


      if(verticalVelocity < 0){

        state = PlayerState.jumping;

      }

      else{

        state = PlayerState.falling;

      }


    }

    else if(moveDirection != 0){


      state = PlayerState.walking;


    }

    else{


      state = PlayerState.idle;


    }



void takeDamage(int damage){

  health -= damage;


  if(health < 0){

    health = 0;

  }

}



void heal(int amount){

  health += amount;


  if(health > maxHealth){

    health = maxHealth;

  }

}



void addCoin(){

  coins++;

}




    // حدود العالم


    final halfWidth = size.x / 2;


    position.x = position.x.clamp(

      halfWidth,

      SabaWorld.worldWidth - halfWidth,

    );



  }








  void moveLeft(){

    moveDirection = -1;

  }




  void moveRight(){

    moveDirection = 1;

  }




  void stopMoving(){

    moveDirection = 0;

  }




  void jump(){

    if(!isOnGround){

      return;

    }


    verticalVelocity = jumpForce;

    isOnGround = false;

  }






  void takeDamage(int amount){

    health -= amount;


    if(health < 0){

      health = 0;

    }

  }





  void addCoin(){

    coins++;

  }







  @override
  void render(Canvas canvas){


    super.render(canvas);


    canvas.save();



    if(!facingRight){

      canvas.translate(size.x,0);

      canvas.scale(-1,1);

    }



    _drawPlayer(canvas);



    canvas.restore();


  }








  void _drawPlayer(Canvas canvas){


    double walk = 0;



    if(state == PlayerState.walking){

      walk = math.sin(animationTime * 10) * 5;

    }






    // ظل

    canvas.drawOval(

      const Rect.fromLTWH(

        10,

        100,

        60,

        10,

      ),

      Paint()

      ..color = Colors.black.withValues(alpha:0.3),

    );






    // الجسم

    canvas.drawRect(

      Rect.fromLTWH(

        29,

        45,

        22,

        40,

      ),

      Paint()

      ..color = const Color(0xFFC58B57),

    );







    // العباءة

    canvas.drawRect(

      Rect.fromLTWH(

        15,

        45,

        50,

        50,

      ),

      Paint()

      ..color = const Color(0xFF733B32),

    );








    // الرأس

    canvas.drawCircle(

      const Offset(40,29),

      15,

      Paint()

      ..color = const Color(0xFFB9784D),

    );








    // الأرجل المتحركة

    canvas.drawRect(

      Rect.fromLTWH(

        27,

        83 + walk,

        11,

        22,

      ),

      Paint()

      ..color = Colors.black,

    );



    canvas.drawRect(

      Rect.fromLTWH(

        43,

        83 - walk,

        11,

        22,

      ),

      Paint()

      ..color = Colors.black,

    );


  }


}