section gfx

SPRITE_EMPTY = 0
Empty:
db 0, 0, 0, 0, 0, 0, 0, 0

SPRITE_Bricks = 1
Bricks:
db 0x00
db 0xBB
db 0x00
db 0x77
db 0x00
db 0xDD
db 0x00
db 0xEE

SPRITE_CoinLeft = 2
CoinLeft:
db 0x03
db 0x06
db 0x06
db 0x06
db 0x06
db 0x06
db 0x06
db 0x06

SPRITE_CoinTopLeft = 3
CoinTopLeft:
db 0x00
db 0x00
db 0x00
db 0x00
db 0x00
db 0x00
db 0x00
db 0x01

SPRITE_CoinTop = 4
CoinTop:
db 0x00
db 0x00
db 0x00
db 0x00
db 0x00
db 0x7E
db 0xFF
db 0x81

SPRITE_CoinTop1 = 5
CoinTop1:
db 0x00
db 0x18
db 0x38
db 0x18
db 0x3C
db 0x00
db 0xFF
db 0x81

SPRITE_CoinTop2 = 6
CoinTop2:
db 0x00
db 0x38
db 0x0C
db 0x18
db 0x3C
db 0x00
db 0xFF
db 0x81

SPRITE_CoinTopRight = 7
CoinTopRight:
db 0x00
db 0x00
db 0x00
db 0x00
db 0x00
db 0x00
db 0x00
db 0x80

SPRITE_CoinRight = 8
CoinRight:
db 0xC0
db 0x60
db 0x60
db 0x60
db 0x60
db 0x60
db 0x60
db 0x60

SPRITE_Coin1 = 9
Coin1:
db 0x00
db 0x3C
db 0x62
db 0xDB
db 0xDB
db 0xE3
db 0x5A
db 0x3C

SPRITE_Coin2 = 10
Coin2:
db 0x00
db 0x18
db 0x24
db 0x34
db 0x34
db 0x34
db 0x24
db 0x18

SPRITE_Coin3 = 11
Coin3:
db 0x00
db 0x18
db 0x18
db 0x18
db 0x18
db 0x18
db 0x18
db 0x18

SPRITE_Coin4 = 12
Coin4:
db 0x00
db 0x18
db 0x24
db 0x2C
db 0x2C
db 0x2C
db 0x24
db 0x18

SPRITE_PlayerLeft1 = 13
PlayerLeft1:
db 0x18
db 0x10
db 0x0C
db 0x2A
db 0x5A
db 0x1C
db 0x14
db 0x34

SPRITE_PlayerLeft2 = 14
PlayerLeft2:
db 0x18
db 0x10
db 0x0C
db 0x3E
db 0x0E
db 0x0C
db 0x0E
db 0x1A

SPRITE_PlayerLeft3 = 15
PlayerLeft3:
db 0x18
db 0x10
db 0x0C
db 0x1E
db 0x1C
db 0x1C
db 0x06
db 0x0C

SPRITE_PlayerLeft4 = 16
PlayerLeft4:
db 0x18
db 0x10
db 0x0C
db 0x3E
db 0x1A
db 0x3C
db 0x12
db 0x06

SPRITE_PlayerLeft5 = 17
PlayerLeft5:
db 0x00
db 0x18
db 0x10
db 0x0F
db 0x5C
db 0x3C
db 0x17
db 0x32

SPRITE_PlayerLeftJump = 18
PlayerLeftJump:
db 0x1A
db 0x52
db 0x2C
db 0x18
db 0x1C
db 0x14
db 0x0A
db 0x01

SPRITE_PlayerRight1 = 19
PlayerRight1:
db 0x18
db 0x08
db 0x30
db 0x54
db 0x5A
db 0x38
db 0x28
db 0x2C

SPRITE_PlayerRight2 = 20
PlayerRight2:
db 0x18
db 0x08
db 0x30
db 0x7C
db 0x70
db 0x30
db 0x70
db 0x58

SPRITE_PlayerRight3 = 21
PlayerRight3:
db 0x18
db 0x08
db 0x30
db 0x78
db 0x38
db 0x38
db 0x60
db 0x30

SPRITE_PlayerRight4 = 22
PlayerRight4:
db 0x18
db 0x08
db 0x30
db 0x7C
db 0x58
db 0x3C
db 0x48
db 0x60

SPRITE_PlayerRight5 = 23
PlayerRight5:
db 0x00
db 0x18
db 0x08
db 0xF0
db 0x3A
db 0x3C
db 0xE8
db 0x4C

SPRITE_PlayerRightJump = 24
PlayerRightJump:
db 0x58
db 0x4A
db 0x34
db 0x18
db 0x38
db 0x28
db 0x50
db 0x80

SPRITE_PlayerHandsLeft1 = 25
PlayerHandsLeft1:
db 0x5A
db 0x52
db 0x6E
db 0x18
db 0x18
db 0x1C
db 0x14
db 0x34

SPRITE_PlayerHandsLeft2 = 26
PlayerHandsLeft2:
db 0x5A
db 0x52
db 0x6E
db 0x18
db 0x0C
db 0x0C
db 0x0E
db 0x1A

SPRITE_PlayerHandsLeft3 = 27
PlayerHandsLeft3:
db 0x5A
db 0x52
db 0x6E
db 0x18
db 0x18
db 0x1C
db 0x06
db 0x0C

SPRITE_PlayerHandsLeft4 = 28
PlayerHandsLeft4:
db 0x5A
db 0x52
db 0x6E
db 0x18
db 0x18
db 0x3C
db 0x12
db 0x06

SPRITE_PlayerHandsLeft5 = 29
PlayerHandsLeft5:
db 0x42
db 0x5A
db 0x52
db 0x2C
db 0x1C
db 0x1C
db 0x17
db 0x32

SPRITE_PlayerHandsLeftJump = 30
PlayerHandsLeftJump:
db 0x5A
db 0x52
db 0x6E
db 0x18
db 0x1C
db 0x14
db 0x0A
db 0x01

SPRITE_PlayerHandsRight1 = 31
PlayerHandsRight1:
db 0x5A
db 0x4A
db 0x76
db 0x18
db 0x18
db 0x38
db 0x28
db 0x2C

SPRITE_PlayerHandsRight2 = 32
PlayerHandsRight2:
db 0x5A
db 0x4A
db 0x76
db 0x18
db 0x30
db 0x30
db 0x70
db 0x58

SPRITE_PlayerHandsRight3 = 33
PlayerHandsRight3:
db 0x5A
db 0x4A
db 0x76
db 0x18
db 0x18
db 0x38
db 0x60
db 0x30

SPRITE_PlayerHandsRight4 = 34
PlayerHandsRight4:
db 0x5A
db 0x4A
db 0x76
db 0x18
db 0x18
db 0x3C
db 0x48
db 0x60

SPRITE_PlayerHandsRight5 = 35
PlayerHandsRight5:
db 0x42
db 0x5A
db 0x4A
db 0x34
db 0x38
db 0x38
db 0xE8
db 0x4C

SPRITE_PlayerHandsRightJump = 36
PlayerHandsRightJump:
db 0x5A
db 0x4A
db 0x76
db 0x18
db 0x38
db 0x28
db 0x50
db 0x80

SPRITE_PlayerGunLeft1 = 37
PlayerGunLeft1:
db 0x18
db 0x10
db 0xFC
db 0x66
db 0x0C
db 0x1C
db 0x14
db 0x34

SPRITE_PlayerGunLeft2 = 38
PlayerGunLeft2:
db 0x18
db 0x10
db 0xFC
db 0x66
db 0x0C
db 0x0C
db 0x0E
db 0x1A

SPRITE_PlayerGunLeft3 = 39
PlayerGunLeft3:
db 0x18
db 0x10
db 0xFC
db 0x66
db 0x1C
db 0x1C
db 0x06
db 0x0C

SPRITE_PlayerGunLeft4 = 40
PlayerGunLeft4:
db 0x18
db 0x10
db 0xFC
db 0x66
db 0x1C
db 0x3C
db 0x12
db 0x06

SPRITE_PlayerGunLeft5 = 41
PlayerGunLeft5:
db 0x00
db 0x18
db 0x10
db 0xFE
db 0x66
db 0x1C
db 0x17
db 0x32

SPRITE_PlayerGunLeftJump = 42
PlayerGunLeftJump:
db 0x18
db 0x10
db 0xFC
db 0x64
db 0x1C
db 0x14
db 0x0A
db 0x01

SPRITE_PlayerGunRight1 = 43
PlayerGunRight1:
db 0x18
db 0x08
db 0x3F
db 0x66
db 0x30
db 0x38
db 0x28
db 0x2C

SPRITE_PlayerGunRight2 = 44
PlayerGunRight2:
db 0x18
db 0x08
db 0x3F
db 0x66
db 0x30
db 0x30
db 0x70
db 0x58

SPRITE_PlayerGunRight3 = 45
PlayerGunRight3:
db 0x18
db 0x08
db 0x3F
db 0x66
db 0x38
db 0x38
db 0x60
db 0x30

SPRITE_PlayerGunRight4 = 46
PlayerGunRight4:
db 0x18
db 0x08
db 0x3F
db 0x66
db 0x38
db 0x3C
db 0x48
db 0x60

SPRITE_PlayerGunRight5 = 47
PlayerGunRight5:
db 0x00
db 0x18
db 0x08
db 0x7F
db 0x66
db 0x38
db 0xE8
db 0x4C

SPRITE_PlayerGunRightJump = 48
PlayerGunRightJump:
db 0x18
db 0x08
db 0x3F
db 0x26
db 0x38
db 0x28
db 0x50
db 0x80

SPRITE_PlayerDead1Left = 49
PlayerDead1Left:
db 0x00
db 0x00
db 0x00
db 0x9C
db 0xD2
db 0x38
db 0xA8
db 0x67

SPRITE_PlayerDead2Left = 50
PlayerDead2Left:
db 0x00
db 0x00
db 0x80
db 0xDC
db 0x12
db 0xB8
db 0xA4
db 0x63

SPRITE_PlayerDead3Left = 51
PlayerDead3Left:
db 0x00
db 0x00
db 0x60
db 0x5C
db 0x92
db 0xB8
db 0x24
db 0x63

SPRITE_PlayerDead1Right = 52
PlayerDead1Right:
db 0x00
db 0x00
db 0x00
db 0x39
db 0x4B
db 0x1C
db 0x15
db 0xE6

SPRITE_PlayerDead2Right = 53
PlayerDead2Right:
db 0x00
db 0x00
db 0x01
db 0x3B
db 0x48
db 0x1D
db 0x25
db 0xC6

SPRITE_PlayerDead3Right = 54
PlayerDead3Right:
db 0x00
db 0x00
db 0x06
db 0x3A
db 0x49
db 0x1D
db 0x24
db 0xC6

SPRITE_PlayerDuckLeft = 55
PlayerDuckLeft:
db 0x00
db 0x00
db 0x18
db 0x10
db 0x0E
db 0x35
db 0x1E
db 0x37

SPRITE_PlayerHandsDuckLeft = 56
PlayerHandsDuckLeft:
db 0x00
db 0x00
db 0x5A
db 0x52
db 0x6E
db 0x38
db 0x3C
db 0x6E

SPRITE_PlayerGunDuckLeft = 57
PlayerGunDuckLeft:
db 0x00
db 0x00
db 0x18
db 0x10
db 0xFC
db 0x66
db 0x1E
db 0x37

SPRITE_PlayerDuckRight = 58
PlayerDuckRight:
db 0x00
db 0x00
db 0x18
db 0x08
db 0x70
db 0xAC
db 0x78
db 0xEC

SPRITE_PlayerHandsDuckRight = 59
PlayerHandsDuckRight:
db 0x00
db 0x00
db 0x5A
db 0x4A
db 0x76
db 0x1C
db 0x3C
db 0x76

SPRITE_PlayerGunDuckRight = 60
PlayerGunDuckRight:
db 0x00
db 0x00
db 0x18
db 0x08
db 0x3F
db 0x66
db 0x78
db 0xEC

SPRITE_Stone = 61
Stone:
db 0x3C
db 0x7E
db 0xFF
db 0xD7
db 0xEB
db 0xFF
db 0x7E
db 0x3C

SPRITE_GhostLeft1 = 62
GhostLeft1:
db 0x3C
db 0x6A
db 0xEA
db 0xFE
db 0x43
db 0x7B
db 0x7E
db 0x70

SPRITE_GhostLeft2 = 63
GhostLeft2:
db 0x3C
db 0x6A
db 0x6A
db 0xFF
db 0xC3
db 0x7A
db 0x7E
db 0x0E

SPRITE_GhostLeft3 = 64
GhostLeft3:
db 0x3C
db 0x6A
db 0x6B
db 0x7F
db 0xC2
db 0xFA
db 0x7E
db 0x70

SPRITE_GhostLeft4 = 65
GhostLeft4:
db 0x3C
db 0x7E
db 0x6A
db 0xFF
db 0xC3
db 0x7A
db 0x7E
db 0x0E

SPRITE_GhostRight1 = 66
GhostRight1:
db 0x3C
db 0x56
db 0x57
db 0x7F
db 0xC2
db 0xDE
db 0x7E
db 0x0E

SPRITE_GhostRight2 = 67
GhostRight2:
db 0x3C
db 0x56
db 0x56
db 0xFF
db 0xC3
db 0x5E
db 0x7E
db 0x70

SPRITE_GhostRight3 = 68
GhostRight3:
db 0x3C
db 0x56
db 0xD6
db 0xFE
db 0x43
db 0x5F
db 0x7E
db 0x0E

SPRITE_GhostRight4 = 69
GhostRight4:
db 0x3C
db 0x7E
db 0x56
db 0xFF
db 0xC3
db 0x5E
db 0x7E
db 0x70

SPRITE_GhostAppear1 = 70
GhostAppear1:
db 0x00
db 0x00
db 0x00
db 0x00
db 0x08
db 0x00
db 0x00
db 0x00

SPRITE_GhostAppear2 = 71
GhostAppear2:
db 0x00
db 0x00
db 0x00
db 0x08
db 0x1C
db 0x08
db 0x00
db 0x00

SPRITE_GhostAppear3 = 72
GhostAppear3:
db 0x00
db 0x00
db 0x08
db 0x1C
db 0x3E
db 0x1C
db 0x08
db 0x00

SPRITE_GhostAppear4 = 73
GhostAppear4:
db 0x00
db 0x00
db 0x1C
db 0x3E
db 0x3E
db 0x3E
db 0x1C
db 0x00

SPRITE_GhostDeath1 = 74
GhostDeath1:
db 0x7E
db 0x99
db 0x99
db 0xFF
db 0xC3
db 0x42
db 0x7E
db 0x66

SPRITE_GhostDeath2 = 75
GhostDeath2:
db 0x00
db 0x7E
db 0xDB
db 0x99
db 0xE7
db 0x42
db 0x5A
db 0x66

SPRITE_GhostDeath3 = 76
GhostDeath3:
db 0x00
db 0x00
db 0x00
db 0x7E
db 0xA5
db 0xC3
db 0xDB
db 0x3E

SPRITE_GhostDeath4 = 77
GhostDeath4:
db 0x00
db 0x00
db 0x00
db 0x00
db 0x00
db 0x66
db 0xC3
db 0x7E
