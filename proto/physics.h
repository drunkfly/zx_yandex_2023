
#define PHYS_DIRECTION  0x01
#define PHYS_LEFT       0
#define PHYS_RIGHT      1

#define PHYS_VERTICAL   0x02
#define PHYS_DOWN       0
#define PHYS_UP         2

typedef struct PhysObject {
    byte x;
    byte y;
    byte flags;
    byte speed;
    byte accel;
} PhysObject;

bool CanGoUp(PhysObject* obj, byte h);
bool CanGoDown(PhysObject* obj);
bool CanGoLeft(PhysObject* obj);
bool CanGoLeftWithItem(PhysObject* obj);
bool CanGoRight(PhysObject* obj);
bool CanGoRightWithItem(PhysObject* obj);

void InitPhysObject(PhysObject* obj, byte x, byte y);
void JumpPhysObject(PhysObject* obj, byte dir, byte speed);
bool UpdatePhysObject(PhysObject* obj, byte h);

bool SpawnFlyingItem(byte x, byte y, byte dir, const byte* sprite, byte attr, byte speed);
void UpdateFlying(void);
