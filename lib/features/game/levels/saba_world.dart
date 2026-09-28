import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../components/checkpoint.dart';
import '../components/coin.dart';
import '../components/enemy.dart';
import '../components/level_gate.dart';
import '../components/treasure_chest.dart';
import '../player/saba_player.dart';
import 'level_progress.dart';

class SabaWorld extends World {
  static const double worldWidth = 5000;
  static const double worldHeight = 720;

  // ============================================================
  // LEVEL DATA
  // ============================================================

  final int levelNumber;

  final LevelProgress progress;

  final Vector2 startPosition;

  final void Function(Vector2 position)?
      onCheckpointActivated;

  bool levelCompleted = false;

  late final SabaPlayer player;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  SabaWorld({
    required this.levelNumber,
    LevelProgress? progress,
    Vector2? startPosition,
    this.onCheckpointActivated,
  })  : progress =
            progress ??
                LevelProgress(
                  levelNumber: levelNumber,
                ),
        startPosition =
            startPosition ??
                Vector2(
                  640,
                  535,
                ) {
    player = SabaPlayer(
      position:
          this.startPosition.clone(),
    );

    // استعادة العملات المحفوظة
    player.coins =
        this.progress.coins;
  
// استعادة صحة اللاعب

player.health =
    this.progress.health;
  // ============================================================
  // LOAD
  // ============================================================
                }
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // =========================
    // BACKGROUND
    // =========================

    add(
      SabaSky(
        size: Vector2(
          worldWidth,
          worldHeight,
        ),
      )..priority = -100,
    );

    add(
      FarMountains(
        size: Vector2(
          worldWidth,
          worldHeight,
        ),
      )..priority = -80,
    );

    add(
      NearMountains(
        size: Vector2(
          worldWidth,
          worldHeight,
        ),
      )..priority = -60,
    );

    // =========================
    // LEVEL BUILD
    // =========================

    if (levelNumber == 1) {
      _buildLevelOne();
    } else {
      _buildLevelTwo();
    }

    // =========================
    // PLAYER
    // =========================

    player.priority = 10;

    add(player);
  }

  // ============================================================
  // LEVEL 1
  // ============================================================

  void _buildLevelOne() {
    // =========================
    // RUINS
    // =========================

    add(
      SabaRuins(
        position: Vector2(
          900,
          350,
        ),
      )..priority = -40,
    );

    add(
      SabaRuins(
        position: Vector2(
          2400,
          370,
        ),
        scale: Vector2.all(
          0.8,
        ),
      )..priority = -40,
    );

    // =========================
    // GROUND
    // =========================

    add(
      DesertGround(
        position: Vector2(
          0,
          590,
        ),
        size: Vector2(
          worldWidth,
          130,
        ),
      )..priority = -20,
    );

    // =========================
    // COIN 1
    // =========================

    add(
      Coin(
        coinId:
            'level1_coin_1',
        progress: progress,
        position: Vector2(
          1200,
          500,
        ),
      )..priority = 5,
    );

    // =========================
    // COIN 2
    // =========================

    add(
      Coin(
        coinId:
            'level1_coin_2',
        progress: progress,
        position: Vector2(
          1800,
          500,
        ),
      )..priority = 5,
    );

    // =========================
    // ENEMY
    // =========================

   add(
  SabaEnemy(
    enemyId: 'level1_enemy_1',
    progress: progress,
    position: Vector2(
      3650,
      500,
    ),
    player: player,
  )..priority = 6,
);

    // =========================
    // CHECKPOINT
    // =========================

    add(
      Checkpoint(
        position: Vector2(
          2800,
          590,
        ),
        player: player,
      onActivated:
    (
      position,
      health,
    ) {

  progress.saveCheckpoint(
    position,
    health: health,
  );


  onCheckpointActivated
      ?.call(
    position,
  );

},
      )
    );

    // =========================
    // TREASURE CHEST
    // =========================

    add(
    TreasureChest(
  chestId: 'level1_chest_1',
  progress: progress,
  position: Vector2(
    3200,
    535,
  ),
  player: player,
)
 );

    // =========================
// END GATE
// =========================

add(
  LevelGate(

    position: Vector2(
      4600,
      485,
    ),


    player: player,


    onComplete: () {

      levelCompleted = true;

    },


  )..priority = 5,
);
  }

  // ============================================================
  // LEVEL 2
  // ============================================================

  void _buildLevelTwo() {
    // =========================
    // RUINS
    // =========================

    add(
      SabaRuins(
        position: Vector2(
          1300,
          355,
        ),
        scale: Vector2.all(
          1.1,
        ),
      )..priority = -40,
    );

    add(
      SabaRuins(
        position: Vector2(
          3000,
          365,
        ),
        scale: Vector2.all(
          0.9,
        ),
      )..priority = -40,
    );

    add(
      SabaRuins(
        position: Vector2(
          4100,
          380,
        ),
        scale: Vector2.all(
          0.7,
        ),
      )..priority = -40,
    );

    // =========================
    // GROUND
    // =========================

    add(
      DesertGround(
        position: Vector2(
          0,
          590,
        ),
        size: Vector2(
          worldWidth,
          130,
        ),
      )..priority = -20,
    );

    // =========================
    // COINS
    // =========================

    final coinPositions =
        <Vector2>[
      Vector2(
        950,
        500,
      ),
      Vector2(
        1350,
        500,
      ),
      Vector2(
        1750,
        500,
      ),
      Vector2(
        2650,
        500,
      ),
      Vector2(
        3500,
        500,
      ),
    ];

    for (
      int i = 0;
      i < coinPositions.length;
      i++
    ) {
      add(
        Coin(
          coinId:
              'level2_coin_${i + 1}',
          progress: progress,
          position:
              coinPositions[i],
        )..priority = 5,
      );
    }

    // =========================
    // ENEMY 1
    // =========================

   add(
  SabaEnemy(
    enemyId: 'level2_enemy_1',
    progress: progress,
    position: Vector2(
      2050,
      500,
    ),
    player: player,
  )..priority = 6,
);

    // =========================
    // CHECKPOINT
    // =========================

    add(
      Checkpoint(
        position: Vector2(
          2900,
          590,
        ),
       player: player,
onActivated:
    (
      position,
      health,
    ) {

  progress.saveCheckpoint(
    position,
    health: health,
  );


  onCheckpointActivated
      ?.call(
    position,
  );

},

    // =========================
    // ENEMY 2
    // =========================
      )
    );
  add(
  SabaEnemy(
    enemyId: 'level2_enemy_2',

    progress: progress,

    position: Vector2(
      3650,
      500,
    ),

    player: player,

  )..priority = 6,
);
    // =========================
    // TREASURE CHEST
    // =========================

    add(
     TreasureChest(
  chestId: 'level2_chest_1',
  progress: progress,
  position: Vector2(
    4050,
    535,
  ),
  player: player,
)
    );

    // =========================
    // END GATE
    // =========================

    add(
    LevelGate(

  position: Vector2(
    4600,
    485,
  ),

  player: player,

  onComplete: () {

    levelCompleted = true;

  },

)..priority = 5,
    );
  }
  // ============================================================
  // UPDATE
  // ============================================================

  @override
  void update(double dt) {
    super.update(dt);

    // =========================
    // COIN COLLECTION
    // =========================

    final coins =
        children
            .whereType<Coin>()
            .toList();

    for (final coin in coins) {
      coin.checkCollision(
        player,
      );
    }

    // =========================
    // LEVEL END
    // =========================

    if (!levelCompleted &&
        player.position.x >=
            4520) {
      levelCompleted = true;
    }
  }
}

// ============================================================
// SKY
// ============================================================

class SabaSky
    extends PositionComponent {
  SabaSky({
    required Vector2 size,
  }) : super(
          size: size,
        );

  @override
  void render(
    Canvas canvas,
  ) {
    super.render(
      canvas,
    );

    final rect =
        Rect.fromLTWH(
      0,
      0,
      size.x,
      size.y,
    );

    const gradient =
        LinearGradient(
      begin:
          Alignment.topCenter,
      end:
          Alignment.bottomCenter,
      colors: [
        Color(
          0xFF111827,
        ),
        Color(
          0xFF39445C,
        ),
        Color(
          0xFFC87543,
        ),
        Color(
          0xFFE8BD7A,
        ),
      ],
    );

    canvas.drawRect(
      rect,
      Paint()
        ..shader =
            gradient
                .createShader(
          rect,
        ),
    );
  }
}

// ============================================================
// FAR MOUNTAINS
// ============================================================

class FarMountains
    extends PositionComponent {
  FarMountains({
    required Vector2 size,
  }) : super(
          size: size,
        );

  @override
  void render(
    Canvas canvas,
  ) {
    super.render(
      canvas,
    );

    final paint =
        Paint()
          ..color =
              const Color(
            0xFF554A56,
          );

    for (
      double x = 0;
      x < size.x;
      x += 800
    ) {
      final path =
          Path()
            ..moveTo(
              x,
              480,
            )
            ..lineTo(
              x + 200,
              260,
            )
            ..lineTo(
              x + 400,
              460,
            )
            ..lineTo(
              x + 620,
              300,
            )
            ..lineTo(
              x + 800,
              480,
            )
            ..close();

      canvas.drawPath(
        path,
        paint,
      );
    }
  }
}

// ============================================================
// NEAR MOUNTAINS
// ============================================================

class NearMountains
    extends PositionComponent {
  NearMountains({
    required Vector2 size,
  }) : super(
          size: size,
        );

  @override
  void render(
    Canvas canvas,
  ) {
    super.render(
      canvas,
    );

    final paint =
        Paint()
          ..color =
              const Color(
            0xFF342C31,
          );

    for (
      double x = 0;
      x < size.x;
      x += 1000
    ) {
      final path =
          Path()
            ..moveTo(
              x,
              540,
            )
            ..lineTo(
              x + 280,
              340,
            )
            ..lineTo(
              x + 520,
              500,
            )
            ..lineTo(
              x + 760,
              330,
            )
            ..lineTo(
              x + 1000,
              540,
            )
            ..close();

      canvas.drawPath(
        path,
        paint,
      );
    }
  }
}

// ============================================================
// SABA RUINS
// ============================================================

class SabaRuins
    extends PositionComponent {
  SabaRuins({
    required Vector2 position,
    Vector2? scale,
  }) : super(
          position: position,
          size: Vector2(
            360,
            240,
          ),
          scale:
              scale ??
                  Vector2.all(
                    1,
                  ),
        );

  @override
  void render(
    Canvas canvas,
  ) {
    super.render(
      canvas,
    );

    final stonePaint =
        Paint()
          ..color =
              const Color(
            0xFF806B55,
          );

    final darkStonePaint =
        Paint()
          ..color =
              const Color(
            0xFF57483A,
          );

    // =========================
    // ROOF
    // =========================

    canvas.drawRect(
      const Rect.fromLTWH(
        30,
        20,
        300,
        35,
      ),
      stonePaint,
    );

    // =========================
    // COLUMNS
    // =========================

    for (
      int i = 0;
      i < 5;
      i++
    ) {
      canvas.drawRect(
        Rect.fromLTWH(
          45.0 +
              (i * 65),
          55,
          32,
          160,
        ),
        stonePaint,
      );

      canvas.drawRect(
        Rect.fromLTWH(
          39.0 +
              (i * 65),
          205,
          44,
          18,
        ),
        darkStonePaint,
      );
    }
  }
}

// ============================================================
// DESERT GROUND
// ============================================================

class DesertGround
    extends PositionComponent {
  DesertGround({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
        );

  @override
  void render(
    Canvas canvas,
  ) {
    super.render(
      canvas,
    );

    final rect =
        Rect.fromLTWH(
      0,
      0,
      size.x,
      size.y,
    );

    const gradient =
        LinearGradient(
      begin:
          Alignment.topCenter,
      end:
          Alignment.bottomCenter,
      colors: [
        Color(
          0xFFD5A75F,
        ),
        Color(
          0xFF9B683D,
        ),
      ],
    );

    canvas.drawRect(
      rect,
      Paint()
        ..shader =
            gradient
                .createShader(
          rect,
        ),
    );

    final rockPaint =
        Paint()
          ..color =
              const Color(
            0xFF795038,
          );

    for (
      double x = 200;
      x < size.x;
      x += 600
    ) {
      canvas.drawOval(
        Rect.fromLTWH(
          x,
          25,
          55,
          18,
        ),
        rockPaint,
      );
    }
  }
}