import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../player/saba_player.dart';



class Coin extends PositionComponent {


  bool collected = false;


  double animationTime = 0;


  late double startY;



  Coin({

    required Vector2 position,

  }) : super(

    position: position,

    size: Vector2(40,40),

    anchor: Anchor.center,

  );







  @override
  Future<void> onLoad() async {

    await super.onLoad();


    startY = position.y;

  }







  @override
  void update(double dt){


    super.update(dt);



    animationTime += dt;



    // حركة طفو العملة

    position.y = startY +

        math.sin(animationTime * 3) * 5;



  }









  // فحص لمس اللاعب للعملة

  void checkCollision(SabaPlayer player){


    if(collected){

      return;

    }




    final distance = position.distanceTo(

      player.position,

    );




    if(distance < 60){


      collect(player);


    }


  }








  // جمع العملة

  void collect(SabaPlayer player){


    if(collected){

      return;

    }



    collected = true;



    player.addCoin();



    removeFromParent();


  }








  @override
  void render(Canvas canvas){


    super.render(canvas);



    // جسم العملة

    canvas.drawCircle(

      Offset(

        size.x / 2,

        size.y / 2,

      ),

      18,

      Paint()

        ..color = const Color(0xFFFFD700),

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

          alpha: 0.8,

        ),

    );




    // دائرة داخلية

    canvas.drawCircle(

      Offset(

        size.x / 2,

        size.y / 2,

      ),

      10,

      Paint()

        ..style = PaintingStyle.stroke

        ..strokeWidth = 3

        ..color = const Color(0xFFFFA000),

    );



  }



}