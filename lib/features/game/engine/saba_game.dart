import 'dart:math' as math;

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../levels/saba_world.dart';
import '../hud/game_hud.dart';



class SabaGame extends FlameGame<SabaWorld> {


  static const double gameWidth = 1280;

  static const double gameHeight = 720;



  late GameHUD hud;





  SabaGame()
      : super(

          world: SabaWorld(),

          camera: CameraComponent(

            viewport: MaxViewport(),

          ),

        );









  @override
  Future<void> onLoad() async {


    await super.onLoad();





    camera.viewfinder

      ..anchor = Anchor.center

      ..position = Vector2(

        gameWidth / 2,

        gameHeight / 2,

      );





    // ==========================
    // HUD
    // ==========================


    hud = GameHUD(

      player: world.player,

    );



    camera.viewport.add(hud);






    _updateCameraZoom();



  }









  @override
  void onGameResize(Vector2 size) {


    super.onGameResize(size);



    _updateCameraZoom();


  }









  @override
  void update(double dt) {


    super.update(dt);



    if (!world.isLoaded) {

      return;

    }






    final playerX = world.player.position.x;






    final minCameraX = gameWidth / 2;



    final maxCameraX =

        SabaWorld.worldWidth -

        (gameWidth / 2);







    final cameraX = playerX.clamp(

      minCameraX,

      maxCameraX,

    );







    camera.viewfinder.position = Vector2(

      cameraX.toDouble(),

      gameHeight / 2,

    );



  }












  void _updateCameraZoom() {


    if(size.x <= 0 || size.y <= 0){

      return;

    }






    final scaleX = size.x / gameWidth;


    final scaleY = size.y / gameHeight;






    camera.viewfinder.zoom = math.max(

      scaleX,

      scaleY,

    );



  }









  // ==========================
  // PLAYER CONTROLS
  // ==========================



  void movePlayerLeft(){


    world.player.moveLeft();


  }





  void movePlayerRight(){


    world.player.moveRight();


  }







  void stopPlayer(){


    world.player.stopMoving();


  }







  void jumpPlayer(){


    world.player.jump();


  }




}