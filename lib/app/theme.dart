import 'package:flutter/material.dart';


class AppTheme {


  static ThemeData get theme {

    return ThemeData(

      brightness: Brightness.dark,

      scaffoldBackgroundColor: Colors.black,

      colorScheme: ColorScheme.fromSeed(

        seedColor: Colors.orange,

        brightness: Brightness.dark,

      ),

    );

  }

}