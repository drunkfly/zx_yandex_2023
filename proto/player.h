
typedef struct Player {
    const byte* oldSprite;
    PhysObject phys;
    byte state;
    byte cooldown;
    const byte* itemSprite;
    byte itemAttr;
    byte gatesX;
    byte gatesY;
} Player;

extern Player player1;
extern Player player2;

bool DoPlayers(void);

void KillPlayer(Player* player, bool isShot);
