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

          // ==========================
          // LEFT / RIGHT
          // ==========================

          Positioned(
            left: 40,
            bottom: 35,
            child: Row(
              children: [
                _HoldButton(
                  icon: Icons.arrow_left_rounded,
                  onPressed: _game.movePlayerLeft,
                  onReleased: _game.stopPlayer,
                ),

                const SizedBox(
                  width: 20,
                ),

                _HoldButton(
                  icon: Icons.arrow_right_rounded,
                  onPressed: _game.movePlayerRight,
                  onReleased: _game.stopPlayer,
                ),
              ],
            ),
          ),

          // ==========================
          // JUMP
          // ==========================

          Positioned(
            right: 45,
            bottom: 40,
            child: _ActionButton(
              icon: Icons.keyboard_arrow_up_rounded,
              onPressed: _game.jumpPlayer,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// MOVEMENT BUTTON
// ==========================================================

class _HoldButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback onReleased;

  const _HoldButton({
    required this.icon,
    required this.onPressed,
    required this.onReleased,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
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
          color: Colors.black.withValues(
            alpha: 0.40,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(
              alpha: 0.65,
            ),
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

// ==========================================================
// ACTION BUTTON
// ==========================================================

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        onPressed();
      },
      child: Container(
        width: 95,
        height: 95,
        decoration: BoxDecoration(
          color: const Color(0xFF8D6042).withValues(
            alpha: 0.75,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFE0B080),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.30,
              ),
              blurRadius: 12,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 60,
        ),
      ),
    );
  }
}