import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../components/coin.dart';
import '../components/enemy.dart';
import '../player/saba_player.dart';



class SabaWorld extends World {


  static const double worldWidth = 5000;

  static const double worldHeight = 720;



  double cameraX = 0;



  final SabaPlayer player = SabaPlayer(

    position: Vector2(
      640,
      535,
    ),

  );





  void updateCamera(double x){

    cameraX = x;

  }







  @override
  Future<void> onLoad() async {


    await super.onLoad();





    // =========================
    // SKY
    // =========================

    add(

      SabaSky(

        size: Vector2(
          worldWidth,
          worldHeight,
        ),

      )

      ..priority = -100,

    );







    // =========================
    // FAR MOUNTAINS
    // =========================

    add(

      FarMountains(

        size: Vector2(
          worldWidth,
          worldHeight,
        ),

      )

      ..priority = -80,

    );








    // =========================
    // NEAR MOUNTAINS
    // =========================

    add(

      NearMountains(

        size: Vector2(
          worldWidth,
          worldHeight,
        ),

      )

      ..priority = -60,

    );







    // =========================
    // RUINS
    // =========================


    add(

      SabaRuins(

        position: Vector2(
          900,
          350,
        ),

      )

      ..priority = -40,

    );





    add(

      SabaRuins(

        position: Vector2(
          2400,
          370,
        ),

        scale: Vector2.all(0.8),

      )

      ..priority = -40,

    );







    // =========================
    // GROUND
    // =========================


    add(

      DesertGround(

        position: Vector2(
          0,
          590,
        ),

        size: Vector2(
          worldWidth,
          130,
        ),

      )

      ..priority = -20,

    );







    // =========================
    // COINS
    // =========================


    add(

      Coin(

        position: Vector2(
          1200,
          500,
        ),

      )

      ..priority = 5,

    );



    add(

      Coin(

        position: Vector2(
          1800,
          500,
        ),

      )

      ..priority = 5,

    );







    // =========================
    // ENEMY
    // =========================


    add(

      SabaEnemy(

        position: Vector2(
          2200,
          500,
        ),

        player: player,

      )

      ..priority = 6,

    );







    // =========================
    // PLAYER
    // =========================


      player.priority = 10;

    add(player);

  }



  @override
  void update(double dt){

    super.update(dt);



    // فحص جمع العملات

    for(final component in children){

      if(component is Coin){

        component.checkCollision(player);

      }

    }


  }





}
// =================================================
// SKY
// =================================================

class SabaSky extends PositionComponent {


  SabaSky({

    required super.size,

  });




  @override
  void render(Canvas canvas) {


    final rect = Rect.fromLTWH(

      0,

      0,

      size.x,

      size.y,

    );




    final paint = Paint()

      ..shader = const LinearGradient(

        begin: Alignment.topCenter,

        end: Alignment.bottomCenter,

        colors: [

          Color(0xFF17233C),

          Color(0xFF354B68),

          Color(0xFFB96E50),

          Color(0xFFF1B477),

        ],

        stops: [

          0.0,

          0.40,

          0.75,

          1.0,

        ],

      ).createShader(rect);




    canvas.drawRect(

      rect,

      paint,

    );


  }


}







// =================================================
// FAR MOUNTAINS
// =================================================

class FarMountains extends PositionComponent {


  FarMountains({

    required super.size,

  });





  @override
  void render(Canvas canvas) {


    final paint = Paint()

      ..color = const Color(0xFF554A56);





    for(

      double x = 0;

      x < size.x;

      x += 800

    ){


      final path = Path();



      path.moveTo(

        x,

        500,

      );



      path.lineTo(

        x + 120,

        400,

      );



      path.lineTo(

        x + 240,

        330,

      );



      path.lineTo(

        x + 370,

        430,

      );



      path.lineTo(

        x + 520,

        350,

      );



      path.lineTo(

        x + 800,

        420,

      );



      path.lineTo(

        x + 800,

        590,

      );



      path.lineTo(

        x,

        590,

      );



      path.close();




      canvas.drawPath(

        path,

        paint,

      );



    }


  }


}







// =================================================
// NEAR MOUNTAINS
// =================================================

class NearMountains extends PositionComponent {


  NearMountains({

    required super.size,

  });





  @override
  void render(Canvas canvas) {


    final paint = Paint()

      ..color = const Color(0xFF342C31);





    for(

      double x = 0;

      x < size.x;

      x += 1000

    ){


      final path = Path();




      path.moveTo(

        x,

        540,

      );



      path.lineTo(

        x + 150,

        450,

      );



      path.lineTo(

        x + 330,

        500,

      );



      path.lineTo(

        x + 520,

        390,

      );



      path.lineTo(

        x + 720,

        500,

      );



      path.lineTo(

        x + 1000,

        430,

      );



      path.lineTo(

        x + 1000,

        590,

      );



      path.lineTo(

        x,

        590,

      );



      path.close();





      canvas.drawPath(

        path,

        paint,

      );



    }


  }


}
// =================================================
// SABAEAN RUINS
// =================================================

class SabaRuins extends PositionComponent {


  SabaRuins({

    required super.position,

    super.scale,

  }) : super(

    size: Vector2(
      360,
      240,
    ),

  );




  @override
  void render(Canvas canvas) {


    final stone = Paint()

      ..color = const Color(0xFF916B50);



    final darkStone = Paint()

      ..color = const Color(0xFF5D4538);






    // قاعدة المعبد

    canvas.drawRect(

      const Rect.fromLTWH(

        15,

        190,

        330,

        25,

      ),

      darkStone,

    );





    canvas.drawRect(

      const Rect.fromLTWH(

        40,

        170,

        285,

        22,

      ),

      stone,

    );







    // الأعمدة

    const columns = [

      70.0,

      130.0,

      190.0,

      250.0,

    ];





    for(final x in columns){


      canvas.drawRect(

        Rect.fromLTWH(

          x,

          65,

          28,

          105,

        ),

        stone,

      );




      canvas.drawRect(

        Rect.fromLTWH(

          x - 5,

          55,

          38,

          12,

        ),

        darkStone,

      );



    }








    // سقف المعبد

    canvas.drawRect(

      const Rect.fromLTWH(

        55,

        38,

        240,

        18,

      ),

      stone,

    );



  }


}









// =================================================
// DESERT GROUND
// =================================================

class DesertGround extends PositionComponent {



  DesertGround({

    required super.position,

    required super.size,

  });







  @override
  void render(Canvas canvas) {



    final rect = Rect.fromLTWH(

      0,

      0,

      size.x,

      size.y,

    );






    final paint = Paint()

      ..shader = const LinearGradient(

        begin: Alignment.topCenter,

        end: Alignment.bottomCenter,

        colors: [

          Color(0xFF966644),

          Color(0xFF5C4031),

          Color(0xFF30251F),

        ],

      ).createShader(rect);








    // الرمل

    canvas.drawRect(

      rect,

      paint,

    );







    // حافة الأرض

    canvas.drawRect(

      Rect.fromLTWH(

        0,

        0,

        size.x,

        7,

      ),

      Paint()

        ..color = const Color(0xFFD0965E),

    );








    // الصخور

    final rockPaint = Paint()

      ..color = const Color(0xFF3B2D27);







    for(

      double x = 300;

      x < size.x;

      x += 600

    ){



      canvas.drawOval(

        Rect.fromLTWH(

          x,

          45,

          65,

          22,

        ),

        rockPaint,

      );



    }




  }



}