
typedef unsigned char byte;
typedef signed char sbyte;
typedef unsigned short word;

#ifndef __cplusplus
typedef int bool;
#define false 0
#define true 1
#endif

#define SCREEN_SCALE        4
#define SCREEN_WIDTH        256
#define SCREEN_HEIGHT       192
#define SCREEN_BORDER_SIZE  32
#define FULL_SCREEN_WIDTH   (SCREEN_WIDTH  + SCREEN_BORDER_SIZE * 2)
#define FULL_SCREEN_HEIGHT  (SCREEN_HEIGHT + SCREEN_BORDER_SIZE * 2)

#define ZXCOORD(x, y) ( \
        ((word) ((byte)(y) &    7) << 8) | \
         (word)(((byte)(y) & 0x38) << 2) | \
        ((word) ((byte)(y) & 0xc0) << 5) | \
                ((byte)(x) & 0x1f) \
    )

#define KEY(INDEX, MASK) ((INDEX) * 8 + (MASK))

#define NO_KEY          0xffff
/* Spectrum classic */
#define KEY_CAPS_SHIFT  KEY( 0, 0)                                  /* Shift on PC */
#define KEY_Z           KEY( 0, 1)
#define KEY_X           KEY( 0, 2)
#define KEY_C           KEY( 0, 3)
#define KEY_V           KEY( 0, 4)
#define KEY_A           KEY( 1, 0)
#define KEY_S           KEY( 1, 1)
#define KEY_D           KEY( 1, 2)
#define KEY_F           KEY( 1, 3)
#define KEY_G           KEY( 1, 4)
#define KEY_Q           KEY( 2, 0)
#define KEY_W           KEY( 2, 1)
#define KEY_E           KEY( 2, 2)
#define KEY_R           KEY( 2, 3)
#define KEY_T           KEY( 2, 4)
#define KEY_1           KEY( 3, 0)
#define KEY_2           KEY( 3, 1)
#define KEY_3           KEY( 3, 2)
#define KEY_4           KEY( 3, 3)
#define KEY_5           KEY( 3, 4)
#define KEY_0           KEY( 4, 0)
#define KEY_9           KEY( 4, 1)
#define KEY_8           KEY( 4, 2)
#define KEY_7           KEY( 4, 3)
#define KEY_6           KEY( 4, 4)
#define KEY_P           KEY( 5, 0)
#define KEY_O           KEY( 5, 1)
#define KEY_I           KEY( 5, 2)
#define KEY_U           KEY( 5, 3)
#define KEY_Y           KEY( 5, 4)
#define KEY_ENTER       KEY( 6, 0)
#define KEY_L           KEY( 6, 1)
#define KEY_K           KEY( 6, 2)
#define KEY_J           KEY( 6, 3)
#define KEY_H           KEY( 6, 4)
#define KEY_SPACE       KEY( 7, 0)
#define KEY_SYMB_SHIFT  KEY( 7, 1)                                  /* Alt on PC */
#define KEY_M           KEY( 7, 2)
#define KEY_N           KEY( 7, 3)
#define KEY_B           KEY( 7, 4)
/* Spectrum Next */
#define KEY_RIGHT       KEY( 8, 0)  /* CAPS SHIFT + 8 */
#define KEY_LEFT        KEY( 8, 1)  /* CAPS SHIFT + 5 */
#define KEY_DOWN        KEY( 8, 2)  /* CAPS SHIFT + 6 */
#define KEY_UP          KEY( 8, 3)  /* CAPS SHIFT + 7 */
#define KEY_PERIOD      KEY( 8, 4)  /* SYMB SHIFT + M */
#define KEY_COMMA       KEY( 8, 5)  /* SYMB SHIFT + N */
#define KEY_QUOTES      KEY( 8, 6)  /* SYMB SHIFT + P */
#define KEY_SEMICOLON   KEY( 8, 7)  /* SYMB SHIFT + O */
#define KEY_EXTEND      KEY( 9, 0)  /* SYMB SHIFT + CAPS SHIFT */   /* F7 on PC */
#define KEY_CAPS_LOCK   KEY( 9, 1)  /* CAPS SHIFT + 2 */
#define KEY_GRAPH       KEY( 9, 2)  /* CAPS SHIFT + 9 */            /* F8 on PC */
#define KEY_TRUE_VIDEO  KEY( 9, 3)  /* CAPS SHIFT + 3 */            /* F6 on PC */
#define KEY_INV_VIDEO   KEY( 9, 4)  /* CAPS SHIFT + 4 */            /* F5 on PC */
#define KEY_BREAK       KEY( 9, 5)  /* CAPS SHIFT + SPACE */        /* Escape on PC */
#define KEY_EDIT        KEY( 9, 6)  /* CAPS SHIFT + 1 */            /* Insert on PC */
#define KEY_DELETE      KEY( 9, 7)  /* CAPS SHIFT + 0 */            /* Delete on PC */
/* PC */
#define KEY_PC_BCKSLASH KEY(10, 0)
#define KEY_PC_BCKSPACE KEY(10, 1)
#define KEY_PC_END      KEY(10, 2)
#define KEY_PC_EQUALS   KEY(10, 3)
#define KEY_PC_F1       KEY(10, 4)
#define KEY_PC_F2       KEY(10, 5)
#define KEY_PC_F3       KEY(10, 6)
#define KEY_PC_F4       KEY(10, 7)
#define KEY_PC_GRAVE    KEY(11, 0)
#define KEY_PC_HOME     KEY(11, 1)
#define KEY_PC_MINUS    KEY(11, 2)
#define KEY_PC_KPADMULT KEY(11, 3)
#define KEY_PC_KPADPLUS KEY(11, 4)
#define KEY_PC_CTRL     KEY(11, 5)
#define KEY_PC_LBRACKET KEY(11, 6)
#define KEY_PC_PAUSE    KEY(11, 7)
#define KEY_PC_RBRACKET KEY(12, 0)
#define KEY_PC_SCRLLOCK KEY(12, 1)
#define KEY_PC_SLASH    KEY(12, 2)
#define KEY_PC_TAB      KEY(12, 3)

#ifdef ZXNEXT
#define KeyTable_size 51
#else
#define KeyTable_size 71
#endif

#define KEYIDX_INVALID      0xff
#define KEYIDX_A            0
#define KEYIDX_B            1
#define KEYIDX_C            2
#define KEYIDX_D            3
#define KEYIDX_E            4
#define KEYIDX_F            5
#define KEYIDX_G            6
#define KEYIDX_H            7
#define KEYIDX_I            8
#define KEYIDX_J            9
#define KEYIDX_K            10
#define KEYIDX_L            11
#define KEYIDX_M            12
#define KEYIDX_N            13
#define KEYIDX_O            14
#define KEYIDX_P            15
#define KEYIDX_Q            16
#define KEYIDX_R            17
#define KEYIDX_S            18
#define KEYIDX_T            19
#define KEYIDX_U            20
#define KEYIDX_V            21
#define KEYIDX_W            22
#define KEYIDX_X            23
#define KEYIDX_Y            24
#define KEYIDX_Z            25
#define KEYIDX_0            26
#define KEYIDX_1            27
#define KEYIDX_2            28
#define KEYIDX_3            29
#define KEYIDX_4            30
#define KEYIDX_5            31
#define KEYIDX_6            32
#define KEYIDX_7            33
#define KEYIDX_8            34
#define KEYIDX_9            35
#define KEYIDX_ENTER        36
#define KEYIDX_SPACE        37
#define KEYIDX_RIGHT        38
#define KEYIDX_LEFT         39
#define KEYIDX_DOWN         40
#define KEYIDX_UP           41
#define KEYIDX_PERIOD       42
#define KEYIDX_COMMA        43
#define KEYIDX_QUOTES       44
#define KEYIDX_SEMICOLON    45
#define KEYIDX_EXTEND       46
#define KEYIDX_CAPS_LOCK    47
#define KEYIDX_BREAK        48
#define KEYIDX_EDIT         49
#define KEYIDX_DELETE       50
#ifndef ZXNEXT /////////////////
#define KEYIDX_PC_BCKSLASH  51
#define KEYIDX_PC_BCKSPACE  52
#define KEYIDX_PC_END       53
#define KEYIDX_PC_EQUALS    54
#define KEYIDX_PC_F1        55
#define KEYIDX_PC_F2        56
#define KEYIDX_PC_F3        57
#define KEYIDX_PC_F4        58
#define KEYIDX_PC_GRAVE     59
#define KEYIDX_PC_HOME      60
#define KEYIDX_PC_MINUS     61
#define KEYIDX_PC_KPADMULT  62
#define KEYIDX_PC_KPADPLUS  63
#define KEYIDX_PC_CTRL      64
#define KEYIDX_PC_LBRACKET  65
#define KEYIDX_PC_PAUSE     66
#define KEYIDX_PC_RBRACKET  67
#define KEYIDX_PC_SCRLLOCK  68
#define KEYIDX_PC_SLASH     69
#define KEYIDX_PC_TAB       70
#endif

#define LEVEL_Y             2
#define LEVEL_WIDTH         32
#define LEVEL_HEIGHT        22

#define PASSABLE_ATTR       0x47

#define PLAYER_1_START      0
#define PLAYER_2_START      1
#define PLAYER_1_APPLE      2
#define PLAYER_2_APPLE      3
#define PLAYER_1_TOP        4
#define PLAYER_2_TOP        5

#define LEFT 0
#define RIGHT 1

typedef struct Player {
    const byte* oldSprite;
    byte x;
    byte y;
    byte state : 2;
    byte dir : 1;
    byte speed;
    byte accel;
    byte decel;
    byte cooldown;
    byte appleX;
    byte appleY;
    byte appleCounter;
    byte appleStolen;
} Player;

extern byte AppleLeft[8];
extern byte AppleTopLeft[8];
extern byte AppleTop[8];
extern byte AppleTop1[8];
extern byte AppleTop2[8];
extern byte AppleTopRight[8];
extern byte AppleRight[8];
extern byte Apple1[8];
extern byte Apple2[8];
extern byte Apple3[8];

extern Player player1;
extern Player player2;

extern byte Timer;
extern bool SinglePlayer;

extern bool AnyKeyPressed;
extern bool KeyPressed[256];
extern byte SpectrumBorder;
extern byte SpectrumScreen[6912];

void ErrorExit(const char* fmt, ...);
void XorSprite(byte x, byte y, const byte* pixels);
void HandleEvents(void);

void Interrupt(void);
void Game(void);

void LoadData(void);

extern byte PlayerLeft1[];
extern byte PlayerLeft2[];
extern byte PlayerLeft3[];
extern byte PlayerLeft4[];
extern byte PlayerLeft5[];
extern byte PlayerRight1[];
extern byte PlayerRight2[];
extern byte PlayerRight3[];
extern byte PlayerRight4[];
extern byte PlayerRight5[];
extern byte PlayerLeftJump[];
extern byte PlayerRightJump[];

extern byte PlayerHandsLeft1[8];
extern byte PlayerHandsLeft2[8];
extern byte PlayerHandsLeft3[8];
extern byte PlayerHandsLeft4[8];
extern byte PlayerHandsLeft5[8];
extern byte PlayerHandsRight1[8];
extern byte PlayerHandsRight2[8];
extern byte PlayerHandsRight3[8];
extern byte PlayerHandsRight4[8];
extern byte PlayerHandsRight5[8];
extern byte PlayerHandsLeftJump[8];
extern byte PlayerHandsRightJump[8];

extern byte Empty[];
extern byte Bricks[];
extern byte Apple[];

extern byte Level1[];

void InitPlayers(void);
void DoPlayers(void);

void DrawLevel(const byte* level);

void SpawnBullet(byte x, byte y, byte dir);
void UpdateDrawBullets(void);
