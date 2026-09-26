import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../player/saba_player.dart';



class SabaEnemy extends PositionComponent {


  static const double moveSpeed = 80;


  double direction = -1;


  int health = 100;



  // وقت الانتظار بين الضربات

  double attackTimer = 0;



  final SabaPlayer player;





  SabaEnemy({

    required Vector2 position,

    required this.player,

  }) : super(

    position: position,

    size: Vector2(

      80,

      100,

    ),

    anchor: Anchor.center,

  );








  @override
  void update(double dt){


    super.update(dt);



    // =========================
    // حركة العدو
    // =========================


    position.x += direction * moveSpeed * dt;





    // حدود حركة العدو

    if(position.x < 600){

      direction = 1;

    }



    if(position.x > 1000){

      direction = -1;

    }








    // =========================
    // نظام الهجوم
    // =========================


    attackTimer -= dt;



    final distance = position.distanceTo(

      player.position,

    );





    if(distance < 100 && attackTimer <= 0){


      attack();


      attackTimer = 1;


    }



  }









  void attack(){


    player.takeDamage(10);


  }









  void takeDamage(int damage){


    health -= damage;



    if(health <= 0){


      removeFromParent();


    }


  }









  @override
  void render(Canvas canvas){


    super.render(canvas);




    // جسم العدو

    canvas.drawRect(

      const Rect.fromLTWH(

        10,

        20,

        60,

        70,

      ),

      Paint()

        ..color = const Color(0xFF4B1E1E),

    );







    // الرأس

    canvas.drawCircle(

      const Offset(

        40,

        20,

      ),

      20,

      Paint()

        ..color = const Color(0xFF8B4A32),

    );







    // العين اليمنى

    canvas.drawCircle(

      const Offset(

        32,

        18,

      ),

      4,

      Paint()

        ..color = Colors.red,

    );






    // العين اليسرى

    canvas.drawCircle(

      const Offset(

        48,

        18,

      ),

      4,

      Paint()

        ..color = Colors.red,

    );





    // شريط صحة العدو

    canvas.drawRect(

      const Rect.fromLTWH(

        0,

        -15,

        80,

        8,

      ),

      Paint()

        ..color = Colors.black,

    );




    canvas.drawRect(

      Rect.fromLTWH(

        0,

        -15,

        80 * (health / 100),

        8,

      ),

      Paint()

        ..color = Colors.green,

    );



  }



}