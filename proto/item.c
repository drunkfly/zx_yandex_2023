#include "proto.h"

#define MAX_ITEMS 64

Item items[MAX_ITEMS];
byte itemCount;

void PlaceItem(byte x, byte y, const byte* sprite, byte attr)
{
    if (itemCount >= MAX_ITEMS)
        return;

    items[itemCount].x = x;
    items[itemCount].y = y;
    items[itemCount].sprite = sprite;
    items[itemCount].attr = attr;
    XorSprite(x, y, items[itemCount].sprite);
    SpectrumScreen[6144 + ((y >> 3) + LEVEL_Y) * 32 + (x >> 3)] = attr;
    ++itemCount;
}

void RemoveItem(byte index)
{
    XorSprite(items[index].x, items[index].y, items[index].sprite);
    SpectrumScreen[6144 + ((items[index].y >> 3) + LEVEL_Y) * 32 + (items[index].x >> 3)] = PASSABLE_ATTR;
    items[index] = items[itemCount - 1];
    --itemCount;
}

const Item* ItemAt(byte x, byte y)
{
    for (byte i = 0; i < itemCount; i++) {
        if ((items[i].x & ~7) == (x & ~7) && (items[i].y & ~7) == (y & ~7))
            return &items[i];
    }

    return NULL;
}

Item TryGrabItem(byte x, byte y)
{
    for (byte i = 0; i < itemCount; i++) {
        if (items[i].x == x && items[i].y >= y - 8 && items[i].y <= y) {
            Item item = items[i];
            RemoveItem(i);
            return item;
        }
    }

    Item item;
    item.attr = 0;
    return item;
}
