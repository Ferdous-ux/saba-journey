import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';


class SabaGame extends FlameGame {


  @override
  Future<void> onLoad() async {

    await super.onLoad();


    // خلفية اللعبة
    add(
      RectangleComponent(

        size: size,

        paint: Paint()
          ..color = const Color(0xff1b1b1b),

      ),
    );


    // نص تجريبي
    add(

      TextComponent(

        text: "SABA JOURNEY",

        position: Vector2(
          size.x / 2,
          size.y / 2,
        ),

        anchor: Anchor.center,

        textRenderer: TextPaint(

          style: const TextStyle(

            color: Colors.orange,

            fontSize: 40,

            fontWeight: FontWeight.bold,

          ),

        ),

      ),

    );


  }


}