import 'package:flutter/material.dart';

import '../features/splash/splash_screen.dart';
import 'theme.dart';



class FeroGamesApp extends StatelessWidget {

  const FeroGamesApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Fero Games',

      theme: AppTheme.theme,


      // البداية من شاشة الشعار
      home: const SplashScreen(),

    );

  }

}