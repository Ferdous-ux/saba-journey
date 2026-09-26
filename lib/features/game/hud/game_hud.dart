import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../player/saba_player.dart';



class GameHUD extends PositionComponent {


  final SabaPlayer player;



  late TextComponent healthText;

  late TextComponent coinText;

  late TextComponent levelText;





  GameHUD({

    required this.player,

  });






  @override
  Future<void> onLoad() async {


    await super.onLoad();





    // ❤️ الصحة

    healthText = TextComponent(

      text: "❤️ 100",

      textRenderer: TextPaint(

        style: const TextStyle(

          color: Colors.white,

          fontSize: 28,

          fontWeight: FontWeight.bold,

        ),

      ),

      position: Vector2(30,30),

    );






    // 🪙 العملات

    coinText = TextComponent(

      text: "🪙 0",

      textRenderer: TextPaint(

        style: const TextStyle(

          color: Colors.yellow,

          fontSize: 28,

          fontWeight: FontWeight.bold,

        ),

      ),

      position: Vector2(30,70),

    );







    // ⭐ المستوى

    levelText = TextComponent(

      text: "⭐ Level 1",

      textRenderer: TextPaint(

        style: const TextStyle(

          color: Colors.white,

          fontSize: 28,

          fontWeight: FontWeight.bold,

        ),

      ),

      position: Vector2(30,110),

    );





    add(healthText);

    add(coinText);

    add(levelText);



  }









  @override
  void update(double dt){


    super.update(dt);



    healthText.text =

        "❤️ ${player.health}";



    coinText.text =

        "🪙 ${player.coins}";



  }



}