#include "proto.h"

#define MAX_ITEMS 64

static const byte* Coins[] = {
        Apple1,
        Apple2,
        Apple3,
        Apple4,
    };

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
    items[itemCount].index = 0;
    XorSprite(x, y, items[itemCount].sprite);

    SpectrumScreen[6144 + ((y >> 3) + LEVEL_Y) * 32 + (x >> 3)] = attr;
    ++itemCount;
}

void RemoveItem(byte index)
{
    if (items[index].sprite == Apple1)
        XorSprite(items[index].x, items[index].y, Coins[items[index].index]);
    else
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

void UpdateItems(void)
{
    for (byte i = 0; i < itemCount; i++) {
        if (items[i].sprite == Apple1) {
            XorSprite(items[i].x, items[i].y, Coins[items[i].index]);
            if ((Timer & 7) == 7) {
                ++items[i].index;
                items[i].index &= 3;
            }
            XorSprite(items[i].x, items[i].y, Coins[items[i].index]);
        }
    }
}
