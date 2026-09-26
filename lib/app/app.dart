import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../features/splash/splash_screen.dart';
import 'theme.dart';



class FeroGamesApp extends StatelessWidget {

  const FeroGamesApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: AppConstants.appName,


      theme: AppTheme.theme,


      home: const SplashScreen(),

    );

  }

}