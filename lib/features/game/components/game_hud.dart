import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../player/saba_player.dart';



class GameHud extends PositionComponent {


  final SabaPlayer player;


  late TextComponent healthText;

  late TextComponent coinText;

  late TextComponent levelText;



  GameHud({

    required this.player,

  });







  @override
  Future<void> onLoad() async {


    await super.onLoad();




    healthText = TextComponent(

      text: "❤️ ${player.health}",

      position: Vector2(30,30),

      textRenderer: TextPaint(

        style: const TextStyle(

          color: Colors.white,

          fontSize: 32,

          fontWeight: FontWeight.bold,

        ),

      ),

    );





    coinText = TextComponent(

      text: "🪙 ${player.coins}",

      position: Vector2(30,70),

      textRenderer: TextPaint(

        style: const TextStyle(

          color: Colors.yellow,

          fontSize: 30,

          fontWeight: FontWeight.bold,

        ),

      ),

    );






    levelText = TextComponent(

      text: "⭐ Level 1",

      position: Vector2(30,110),

      textRenderer: TextPaint(

        style: const TextStyle(

          color: Colors.white,

          fontSize: 28,

          fontWeight: FontWeight.bold,

        ),

      ),

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