import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'engine/saba_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final SabaGame _game;

  @override
  void initState() {
    super.initState();

    _game = SabaGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: GameWidget(
              game: _game,
            ),
          ),

          // Left controls
          Positioned(
            left: 40,
            bottom: 35,
            child: Row(
              children: [
                _ControlButton(
                  icon: Icons.arrow_left_rounded,
                  onPressed: _game.movePlayerLeft,
                  onReleased: _game.stopPlayer,
                ),
                const SizedBox(width: 20),
                _ControlButton(
                  icon: Icons.arrow_right_rounded,
                  onPressed: _game.movePlayerRight,
                  onReleased: _game.stopPlayer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback onReleased;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    required this.onReleased,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        onPressed();
      },
      onPointerUp: (_) {
        onReleased();
      },
      onPointerCancel: (_) {
        onReleased();
      },
      child: Container(
        width: 85,
        height: 85,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.7),
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 55,
        ),
      ),
    );
  }
}