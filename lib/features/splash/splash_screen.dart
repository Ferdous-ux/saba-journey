import 'dart:async';

import 'package:flutter/material.dart';

import '../home/home_screen.dart';



class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();

}



class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {

    super.initState();


    Timer(

      const Duration(seconds: 3),

      () {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) => const HomeScreen(),

          ),

        );

      },

    );

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: Colors.black,


      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,


          children: [


            const Text(

              "FERO GAMES",

              style: TextStyle(

                color: Colors.orange,

                fontSize: 38,

                fontWeight: FontWeight.bold,

                letterSpacing: 4,

              ),

            ),


            const SizedBox(height: 15),


            const Text(

              "SABA JOURNEY",

              style: TextStyle(

                color: Colors.white70,

                fontSize: 18,

                letterSpacing: 3,

              ),

            ),


            const SizedBox(height: 40),


            const CircularProgressIndicator(

              color: Colors.orange,

            ),


          ],

        ),

      ),

    );

  }

}