
typedef struct Item {
    byte x;
    byte y;
    const byte* sprite;
    byte attr;
    byte index;
} Item;

void PlaceItem(byte x, byte y, const byte* sprite, byte attr);
void RemoveItem(byte index);
const Item* ItemAt(byte x, byte y);
Item TryGrabItem(byte x, byte y);

void UpdateItems(void);
