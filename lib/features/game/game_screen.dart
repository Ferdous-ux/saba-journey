import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'engine/saba_game.dart';
import 'levels/level_progress.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SabaGame _game;

  // ============================================================
  // LEVEL
  // ============================================================

  int _currentLevel = 1;

  // ============================================================
  // LEVEL PROGRESS
  // ============================================================

  late LevelProgress _levelProgress;

  // ============================================================
  // UI STATES
  // ============================================================

  bool _showCheckpointMessage = false;
  bool _showGameOver = false;
  bool _showVictory = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _levelProgress = LevelProgress(
      levelNumber: _currentLevel,
    );

    _game = _createGame();
  }

  // ============================================================
  // CREATE GAME
  // ============================================================

  SabaGame _createGame() {
    Vector2? spawnPosition;

    // إذا كان اللاعب قد فعّل Checkpoint
    // يبدأ من آخر نقطة محفوظة
    if (_levelProgress.checkpointActivated &&
        _levelProgress.checkpointPosition != null) {
      spawnPosition =
          _levelProgress.checkpointPosition!.clone();
    }

    return SabaGame(
      levelNumber: _currentLevel,
      progress: _levelProgress,
      startPosition: spawnPosition,
      onGameOver: _handleGameOver,
      onVictory: _handleVictory,
      onCheckpointActivated: _handleCheckpointActivated,
    );
  }

  // ============================================================
  // CHECKPOINT
  // ============================================================

  void _handleCheckpointActivated(
    Vector2 position,
  ) {
    if (!mounted) {
      return;
    }

    setState(() {
      _showCheckpointMessage = true;
    });

    Future.delayed(
      const Duration(
        milliseconds: 1400,
      ),
      () {
        if (!mounted) {
          return;
        }

        setState(() {
          _showCheckpointMessage = false;
        });
      },
    );
  }

  // ============================================================
  // GAME OVER
  // ============================================================

  void _handleGameOver() {
    if (!mounted) {
      return;
    }

    setState(() {
      _showGameOver = true;
    });
  }

  // ============================================================
  // VICTORY
  // ============================================================

  void _handleVictory() {
    if (!mounted) {
      return;
    }

    setState(() {
      _showVictory = true;
    });
  }

  // ============================================================
  // RETRY
  // ============================================================

  void _restartGame() {
    setState(() {
      _showGameOver = false;
      _showVictory = false;
      _showCheckpointMessage = false;

      // نستخدم نفس LevelProgress
      // لذلك العملات ونقطة الحفظ تبقى محفوظة
      _game = _createGame();
    });
  }

  // ============================================================
  // NEXT LEVEL
  // ============================================================

  void _nextLevel() {
    setState(() {
      _showVictory = false;
      _showGameOver = false;
      _showCheckpointMessage = false;

      _currentLevel++;

      // حاليًا لدينا مرحلتان فقط
      if (_currentLevel > 2) {
        _currentLevel = 1;
      }

      // إنشاء تقدم جديد للمرحلة الجديدة
      _levelProgress = LevelProgress(
        levelNumber: _currentLevel,
      );

      _game = _createGame();
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // =====================================================
          // GAME
          // =====================================================

          Positioned.fill(
            child: GameWidget(
              key: ValueKey(_game),
              game: _game,
            ),
          ),

          // =====================================================
          // LEFT / RIGHT CONTROLS
          // =====================================================

          if (!_showGameOver && !_showVictory)
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

          // =====================================================
          // ATTACK / JUMP CONTROLS
          // =====================================================

          if (!_showGameOver && !_showVictory)
            Positioned(
              right: 40,
              bottom: 35,
              child: Row(
                children: [
                  // =========================
                  // ATTACK
                  // =========================

                  _ActionButton(
                    icon: Icons.gavel_rounded,
                    backgroundColor: const Color(
                      0xFF8A3030,
                    ),
                    borderColor: const Color(
                      0xFFFF9E80,
                    ),
                    onPressed: _game.attackPlayer,
                  ),

                  const SizedBox(
                    width: 22,
                  ),

                  // =========================
                  // JUMP
                  // =========================

                  _ActionButton(
                    icon: Icons.keyboard_arrow_up_rounded,
                    backgroundColor: const Color(
                      0xFF8D6042,
                    ),
                    borderColor: const Color(
                      0xFFE0B080,
                    ),
                    onPressed: _game.jumpPlayer,
                  ),
                ],
              ),
            ),

          // =====================================================
          // CHECKPOINT SAVED MESSAGE
          // =====================================================

          if (_showCheckpointMessage &&
              !_showGameOver &&
              !_showVictory)
            Positioned(
              top: 35,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF211A18,
                    ).withValues(
                      alpha: 0.92,
                    ),
                    borderRadius: BorderRadius.circular(
                      18,
                    ),
                    border: Border.all(
                      color: const Color(
                        0xFFFFD54F,
                      ),
                      width: 2,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.flag_rounded,
                        color: Color(
                          0xFFFFD54F,
                        ),
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      Text(
                        'CHECKPOINT SAVED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // =====================================================
          // GAME OVER
          // =====================================================

          if (_showGameOver)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(
                  alpha: 0.78,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      12,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        width: 430,
                        padding: const EdgeInsets.all(
                          35,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF211A18,
                          ),
                          borderRadius: BorderRadius.circular(
                            25,
                          ),
                          border: Border.all(
                            color: const Color(
                              0xFFC58B57,
                            ),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: 0.60,
                              ),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.dangerous_rounded,
                              color: Color(
                                0xFFD85C4A,
                              ),
                              size: 75,
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            const Text(
                              'GAME OVER',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            Text(
                              'Level $_currentLevel',
                              style: const TextStyle(
                                color: Color(
                                  0xFFFFD36A,
                                ),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Text(
                              _levelProgress.checkpointActivated
                                  ? 'Restart from checkpoint'
                                  : 'Restart from beginning',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 17,
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            Text(
                              'Coins saved: ${_levelProgress.coins}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 17,
                              ),
                            ),

                            const SizedBox(
                              height: 30,
                            ),

                            SizedBox(
                              width: 230,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: _restartGame,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                    0xFF8D6042,
                                  ),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                      18,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'RETRY',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // =====================================================
          // VICTORY
          // =====================================================

          if (_showVictory)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(
                  alpha: 0.72,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      12,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        width: 470,
                        padding: const EdgeInsets.all(
                          36,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF211A18,
                          ),
                          borderRadius: BorderRadius.circular(
                            25,
                          ),
                          border: Border.all(
                            color: const Color(
                              0xFFFFD36A,
                            ),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: 0.60,
                              ),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.emoji_events_rounded,
                              color: Color(
                                0xFFFFD54F,
                              ),
                              size: 85,
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            const Text(
                              'VICTORY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 46,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            Text(
                              'Level $_currentLevel Complete',
                              style: const TextStyle(
                                color: Color(
                                  0xFFFFD36A,
                                ),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            Text(
                              'Coins collected: '
                              '${_game.world.player.coins}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                              ),
                            ),

                            const SizedBox(
                              height: 28,
                            ),

                            SizedBox(
                              width: 240,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: _nextLevel,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                    0xFF8D6042,
                                  ),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                      18,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  _currentLevel == 1
                                      ? 'NEXT LEVEL'
                                      : 'PLAY AGAIN',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// HOLD BUTTON
// ============================================================

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

// ============================================================
// ACTION BUTTON
// ============================================================

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color borderColor;

  const _ActionButton({
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTapDown: (_) {
        onPressed();
      },

      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          color: backgroundColor.withValues(
            alpha: 0.80,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
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
          size: 52,
        ),
      ),
    );
  }
}