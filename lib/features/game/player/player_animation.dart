import 'package:flame/components.dart';


class PlayerAnimationController {


  late SpriteAnimation idle;

  late SpriteAnimation run;

  late SpriteAnimation jump;

  late SpriteAnimation attack;

  late SpriteAnimation hurt;

  late SpriteAnimation death;



  late SpriteAnimation current;




  Future<void> load() async {


    final image =
        await Images().load(
      'player/saba_player.png',
    );



    final sheet = SpriteSheet(

      image: image,

      srcSize: Vector2(
        128,
        128,
      ),

    );



    idle =
        sheet.createAnimation(
          row: 0,
          stepTime: 0.15,
          loop: true,
          from: 0,
          to: 3,
        );



    run =
        sheet.createAnimation(
          row: 1,
          stepTime: 0.10,
          loop: true,
          from: 0,
          to: 5,
        );



    jump =
        sheet.createAnimation(
          row: 2,
          stepTime: 0.12,
          loop: false,
          from: 0,
          to: 2,
        );



    attack =
        sheet.createAnimation(
          row: 3,
          stepTime: 0.08,
          loop: false,
          from: 0,
          to: 5,
        );



    hurt =
        sheet.createAnimation(
          row: 4,
          stepTime: 0.15,
          loop: false,
          from: 0,
          to: 1,
        );



    death =
        sheet.createAnimation(
          row: 5,
          stepTime: 0.20,
          loop: false,
          from: 0,
          to: 3,
        );



    current = idle;


  }







  void setIdle(){

    current = idle;

  }


  void setRun(){

    current = run;

  }


  void setJump(){

    current = jump;

  }


  void setAttack(){

    current = attack;

  }


  void setHurt(){

    current = hurt;

  }


  void setDeath(){

    current = death;

  }


}