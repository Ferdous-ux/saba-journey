import 'package:flutter/material.dart';

import '../game/game_screen.dart';



class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: Colors.black,


      body: Center(

        child: ElevatedButton(

          onPressed: () {


            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (_) => const GameScreen(),

              ),

            );


          },

          child: const Text(

            "START GAME",

          ),

        ),

      ),

    );

  }

}