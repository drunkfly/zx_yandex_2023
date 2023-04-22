
#define PASSABLE_ATTR   0x47

#define APPLE1_ATTR     0x46
#define APPLE2_ATTR     0x42

#define LEVEL_Y             2
#define LEVEL_WIDTH         32
#define LEVEL_HEIGHT        22

#define PLAYER_1_START      0
#define PLAYER_2_START      1
#define PLAYER_1_APPLE      2
#define PLAYER_2_APPLE      3
#define PLAYER_1_TOP        4
#define PLAYER_2_TOP        5

void DrawLevel(const byte* level);
