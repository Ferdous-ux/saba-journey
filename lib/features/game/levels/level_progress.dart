import 'package:flame/components.dart';

class LevelProgress {
  // ============================================================
  // LEVEL
  // ============================================================

  final int levelNumber;

  // ============================================================
  // CHECKPOINT
  // ============================================================

  Vector2? checkpointPosition;

  bool checkpointActivated = false;

  // ============================================================
  // PLAYER DATA
  // ============================================================

  int coins = 0;

  int health = 100;

  // ============================================================
  // COLLECTED COINS
  // ============================================================

  final Set<String> collectedCoins = {};

  // ============================================================
  // DEFEATED ENEMIES
  // ============================================================

  final Set<String> defeatedEnemies = {};

  // ============================================================
  // OPENED CHESTS
  // ============================================================

  final Set<String> openedChests = {};

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  LevelProgress({
    required this.levelNumber,
  });

  // ============================================================
  // CHECKPOINT
  // ============================================================

  void saveCheckpoint(
    Vector2 position,
  ) {
    checkpointPosition =
        position.clone();

    checkpointActivated = true;
  }

  // ============================================================
  // COINS
  // ============================================================

  bool isCoinCollected(
    String coinId,
  ) {
    return collectedCoins.contains(
      coinId,
    );
  }

  void collectCoin(
    String coinId,
  ) {
    collectedCoins.add(
      coinId,
    );

    coins++;
  }

  // ============================================================
  // ENEMIES
  // ============================================================

  bool isEnemyDefeated(
    String enemyId,
  ) {
    return defeatedEnemies.contains(
      enemyId,
    );
  }

  void defeatEnemy(
    String enemyId,
  ) {
    defeatedEnemies.add(
      enemyId,
    );
  }

  // ============================================================
  // CHESTS
  // ============================================================

  bool isChestOpened(
    String chestId,
  ) {
    return openedChests.contains(
      chestId,
    );
  }

  void openChest(
    String chestId, {
    int reward = 5,
  }) {
    if (openedChests.contains(
      chestId,
    )) {
      return;
    }

    openedChests.add(
      chestId,
    );

    coins += reward;
  }

  // ============================================================
  // PLAYER HEALTH
  // ============================================================

  void saveHealth(
    int value,
  ) {
    health = value.clamp(
      0,
      100,
    );
  }

  void restoreFullHealth() {
    health = 100;
  }

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    checkpointPosition = null;

    checkpointActivated = false;

    coins = 0;

    health = 100;

    collectedCoins.clear();

    defeatedEnemies.clear();

    openedChests.clear();
  }
}