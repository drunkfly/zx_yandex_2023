
typedef struct Enemy {
    PhysObject phys;
    byte originalX;
    byte originalY;
    const byte* const* sprites;
    byte index;
    byte state;
} Enemy;

#define MAX_ENEMIES 16

extern const byte* const GhostSprites[];

extern Enemy enemies[MAX_ENEMIES];

void SpawnEnemy(byte x, byte y, const byte* const* sprites);
void KillEnemy(byte index);
byte EnemyCollides(byte x, byte y);
void UpdateEnemies(void);
