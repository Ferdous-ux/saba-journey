import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../player/saba_player.dart';



class LevelGate extends PositionComponent {


  final SabaPlayer player;


  final VoidCallback onComplete;


  double animationTime = 0;


  bool completed = false;



  LevelGate({

    required Vector2 position,

    required this.player,

    required this.onComplete,

  }) : super(

          position: position,

          size: Vector2(
            150,
            210,
          ),

          anchor: Anchor.center,

        );





  @override
  void update(
    double dt,
  ) {

    super.update(dt);



    animationTime += dt;



    if (completed) {

      return;

    }




    final distance =
        position.distanceTo(
      player.position,
    );



    if (distance < 120) {

      completed = true;


      onComplete();

    }

  }







  @override
  void render(
    Canvas canvas,
  ) {

    super.render(canvas);



    // =========================
    // SHADOW
    // =========================


    canvas.drawOval(

      const Rect.fromLTWH(

        10,

        190,

        130,

        18,

      ),

      Paint()

        ..color =
            Colors.black.withValues(

          alpha: 0.35,

        ),

    );







    // =========================
    // LEFT COLUMN
    // =========================


    canvas.drawRect(

      const Rect.fromLTWH(

        10,

        35,

        30,

        160,

      ),

      Paint()

        ..color =
            const Color(

          0xFF8C6748,

        ),

    );







    // =========================
    // RIGHT COLUMN
    // =========================


    canvas.drawRect(

      const Rect.fromLTWH(

        110,

        35,

        30,

        160,

      ),

      Paint()

        ..color =
            const Color(

          0xFF8C6748,

        ),

    );







    // =========================
    // TOP
    // =========================


    canvas.drawRect(

      const Rect.fromLTWH(

        0,

        15,

        150,

        35,

      ),

      Paint()

        ..color =
            const Color(

          0xFFA77A50,

        ),

    );







    // =========================
    // GATE OPENING
    // =========================


    canvas.drawRect(

      const Rect.fromLTWH(

        40,

        50,

        70,

        145,

      ),

      Paint()

        ..color =
            const Color(

          0xFF171A26,

        ),

    );







    // =========================
    // GLOW
    // =========================


    final glow =

        0.25 +

        (math.sin(
              animationTime * 3,
            ) +
            1) *
            0.10;



    canvas.drawRect(

      const Rect.fromLTWH(

        48,

        58,

        54,

        137,

      ),

      Paint()

        ..color =
            const Color(

          0xFFFFC857,

        ).withValues(

          alpha: glow,

        ),

    );







    // =========================
    // SABAEAN SYMBOL
    // =========================


    canvas.drawCircle(

      const Offset(

        75,

        32,

      ),

      12,

      Paint()

        ..style =
            PaintingStyle.stroke

        ..strokeWidth = 4

        ..color =
            const Color(

          0xFFFFD36A,

        ),

    );


  }


}