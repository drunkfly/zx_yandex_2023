
typedef struct Player {
    const byte* oldSprite;
    PhysObject phys;
    byte state;
    byte cooldown;
    byte visualCooldown;
    const byte* itemSprite;
    byte itemAttr;
    byte gatesX;
    byte gatesY;
    byte originalX;
    byte originalY;
} Player;

#define IDLE 0
#define MOVING 1
#define JUMPING 2
#define DEAD_FALLING 3
#define DEAD 4
#define WAKING_UP 5
#define SITTING 6
#define DEAD_FALLING_RESPAWN 7
#define DEAD_RESPAWN 8

extern Player player1;
extern Player player2;

bool DoPlayers(void);

#define REASON_ENEMY 1
#define REASON_ITEM 2
#define REASON_BULLET 3

void KillPlayer(Player* player, byte reason);
