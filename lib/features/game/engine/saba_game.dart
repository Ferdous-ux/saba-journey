import 'package:flame/game.dart';

import 'game_config.dart';



class SabaGame extends FlameGame {


  @override
  Future<void> onLoad() async {

    await super.onLoad();


    camera.viewfinder.visibleGameSize = Vector2(

      GameConfig.gameWidth,

      GameConfig.gameHeight,

    );


  }


}