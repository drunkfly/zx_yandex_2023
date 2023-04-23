#include "proto.h"
#include <stdlib.h>

byte Timer;
const byte* CurrentLevel = Level1;
bool SinglePlayer = true;

void Interrupt(void)
{
    Timer++;
    if (!DoPlayers())
        exit(0);
    UpdateDrawBullets();
    UpdateItems();
    UpdateEnemies();
    UpdateFlying();
}

void Game(void)
{
    SpectrumBorder = 1;

    DrawLevel(CurrentLevel);

    for (;;) {
        HandleEvents();
    }
}
