
sizeof_Item = 5
Item_x = 0
Item_y = 1
Item_spriteID = 2
Item_attr = 3
Item_index = 4

                section y_bss_items

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Items:          repeat  MAX_ITEMS
                db      0           ; x
                db      0           ; y
                db      0           ; spriteID
                db      0           ; attr
                db      0           ; index
                endrepeat

ItemCount       db      0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                section code_items

                ; Input:
                ;   A = item index
                ;   BC = base
                ; Output:
                ;   HL => item
                ; Preserves:
                ;   DE

CalcItemAddr:   ld      bc, Items
@@raw:          ld      l, a
                add     a, a        ; *= 2
                add     a, a        ; *= 4
                add     a, l        ; *= 5
                ld      l, a
                ld      h, 0
                add     hl, bc
                ret

                ; Input:
                ;   B = Y
                ;   C = X
                ;   E = sprite ID
                ;   D = attr

PlaceItem:      ld      a, (ItemCount)
                cp      MAX_ITEMS
                ret     z
                inc     a
                ld      (ItemCount), a
                push    bc
                ex      af, af'
                call    CalcAttribAddr
                ex      af, af'
                ld      (hl), d
                ld      bc, Items-sizeof_Item
                call    CalcItemAddr@@raw
                pop     bc
                ld      (hl), c
                inc     hl
                ld      (hl), b
                inc     hl
                ld      (hl), e
                inc     hl
                ld      (hl), d
                inc     hl
                ld      (hl), 0
                inc     hl
                ld      a, e
                ld      e, c
                ld      d, b
                call    DrawSprites@@draw
                ret

                ; Input:
                ;   A = sprite ID
                ;   HL => item + 2
                ; Return:
                ;   real sprite ID
                ; Preserves:
                ;   HL, DE, BC

GetRealItemSprite:
                cp      SPRITE_Coin1
                ret     nz
@@coin:         push    hl
                inc     hl          ; skip spriteID
                inc     hl          ; skip attr
                ld      a, (hl)     ; index
                add     a, SPRITE_Coin1
                pop     hl
                ret

                ; Input:
                ;   HL => item

RemoveItem:     push    hl
                ld      c, (hl)     ; x
                inc     hl
                ld      b, (hl)     ; y
                inc     hl
                push    bc
                push    hl
                call    CalcAttribAddr
                ld      (hl), PASSABLE_ATTR
                pop     hl
                ld      a, (hl)     ; spriteID
                call    GetRealItemSprite
                pop     de
                call    DrawSprites@@draw
                ld      a, (ItemCount)
                dec     a
                ld      (ItemCount), a
                call    CalcItemAddr
                pop     de
                repeat  sizeof_Item
                ldi
                endrepeat
                ret

                ; Input:
                ;   B = Y
                ;   C = X
                ; Result:
                ;   HL => item or H = 0
                ; Preserves:
                ;   IX

ItemAt:         ld      a, (ItemCount)
                or      a
                jr      z, @@notFound
                push    ix
                ld      ixl, a
                ld      a, b
                and     ~7
                ld      b, a
                ld      a, c
                and     ~7
                ld      c, a
                ld      hl, Items
                ld      de, sizeof_Item
@@loop:         ld      a, (hl)
                and     ~7
                cp      c
                jr      nz, @@continue
                inc     hl
                ld      a, (hl)
                dec     hl
                and     ~7
                cp      b
                ret     z
@@continue:     add     hl, de
                dec     ixl
                jr      nz, @@loop
                pop     ix
@@notFound:     ld      h, 0
                ret

                ; Input:
                ;   B = Y
                ;   C = X
                ; Result:
                ;   E = attr (0 if not grabbed)
                ;   D = sprite
                ; Preserves:
                ;   IX

TryGrabItem:    ld      a, (ItemCount)
                or      a
                ld      e, a
                ret     z
                push    ix
                ld      hl, Items
                ld      de, sizeof_Item
                ld      ixl, a
@@loop:         ld      a, (hl)
                cp      c
                jr      nz, @@continue
                inc     hl
                ld      a, (hl)
                dec     hl
                cp      b
                jr      z, @@ok
                jr      nc, @@continue
@@ok:           add     a, 8
                cp      b
                jr      c, @@continue
                push    hl
                inc     hl          ; skip X
                inc     hl          ; skip Y
                ld      d, (hl)     ; spriteID
                inc     hl
                ld      e, (hl)     ; attr
                pop     hl
                push    de
                call    RemoveItem
                pop     de
                pop     ix
                ret
@@continue:     add     hl, de
                dec     ixl
                jr      nz, @@loop
                pop     ix
                ld      e, 0
                ret

                ; Input:
                ;   none

UpdateItems:    ld      a, (Timer)
                and     7
                cp      7
                ret     nz
                ld      a, (ItemCount)
                or      a
                ret     z
                ld      hl, Items
                ld      ixl, a
@@loop:         ld      e, (hl)     ; x
                inc     hl
                ld      d, (hl)     ; y
                inc     hl
                ld      a, (hl)     ; spriteID
                cp      SPRITE_Coin1
                jr      nz, @@continue
                call    GetRealItemSprite
                push    hl
                push    de
                call    DrawSprites@@draw
                pop     de
                pop     hl
                push    hl
                inc     hl          ; skip spriteID
                inc     hl          ; skip attr
                ld      a, (hl)     ; index
                inc     a
                and     3
                ld      (hl), a
                pop     hl
                call    GetRealItemSprite@@coin
                push    hl
                call    DrawSprites@@draw
                pop     hl
@@continue:     ld      de, sizeof_Item-2
                add     hl, de
                dec     ixl
                jr      nz, @@loop
                ret
