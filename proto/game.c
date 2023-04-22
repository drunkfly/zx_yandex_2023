#include "proto.h"

byte Timer;
const byte* CurrentLevel = Level1;
bool SinglePlayer = false;

void Interrupt(void)
{
    Timer++;
    DoPlayers();
    UpdateDrawBullets();
}

void Game(void)
{
    SpectrumBorder = 1;

    InitPlayers();
    DrawLevel(CurrentLevel);

    for (;;) {
        HandleEvents();
    }
}
