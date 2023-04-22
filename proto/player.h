
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
} Player;

#define IDLE 0
#define MOVING 1
#define JUMPING 2
#define DEAD_FALLING 3
#define DEAD 4
#define WAKING_UP 5
#define SITTING 6

extern Player player1;
extern Player player2;

bool DoPlayers(void);

void KillPlayer(Player* player, bool isShot);
