#include "proto.h"

byte Timer;

void Interrupt(void)
{
    Timer++;
    DoPlayers();
}

void Game(void)
{
    SpectrumBorder = 1;
    for (word off = 0; off < 768; off++)
        SpectrumScreen[6144 + off] = 0x47;

    InitPlayers();

    for (;;) {
        HandleEvents();
    }
}
