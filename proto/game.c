#include "proto.h"

byte Timer;
const byte* CurrentLevel = Level1;

void Interrupt(void)
{
    Timer++;
    DoPlayers();
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
