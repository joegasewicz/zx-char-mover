ENTRY_POINT equ 32768


    org ENTRY_POINT
    ;ld a, 2                        ; upper channel (main window) - small bar at bottom is channel 1
    ;call 5633                      ; ROM routine which opens channel a
    call 0xdaf                      ; better way, clears screen AND opens channel  
    ld hl, udg                      ; hl - pointer to udg1
    ld (23675), hl                  ; 5C7B: UDG - Address of first user defined graphic

    ; screen color
    ld a, ATTR_BLUE_INK_YELLOW_PAPER
    ld (23693), a                   ; poke value into screen colour attr memory address
    call 0xdaf                      ; cls clear screen   

    ld bc, NOTE_G_SHARP             ; put g# into bc
    call play_note                  ; play note g#
    ld bc, NOTE_C                   ; play c into bc
    call play_note                  ; play note c

main:
    halt                            ; locks to 50fps / halt waits for the interupt


    ld de, (xpos)                   ; de = xpos,ypos
    call set_position
    call delete_sprite



    ld bc, 64510                    ; QWERT port
    in a, (c)                       ; reads (hardware) port in c

    rra                             ; rotate right, bit 0 into carry
    push af
    call nc, move_left              ; roll bits to the right, bit0 moves into the carry but of f (f=carry flag)
    pop af

    rra
    push af
    call nc, move_right
    pop af

    ld bc, 0xdffe                   ; POIUYH port
    in a, (c)                       ; reads port to c

    rra
    push af
    call nc, move_up
    pop af

    ld bc, 0xbffe
    in a, (c)                       ; ENTER,L,K,J,H

    rra                             ; 'ENTER'
    rra                             ; 'L'
    push af
    call nc, move_down
    pop af


    ld de, (xpos)                   ; ????
    call set_position
    call display_sprite
    
    ld de, (score_xpos)             ; bc = score value
    call set_position
    ld bc, (score)
    call 0x1a1b                     ; built in routine prints integer <= 9999

    jp main


display_sprite:
    ld a, (player_sprite)
    rst 16                          ; print a
    ret


delete_sprite:
    ld a, ASCII_SPACE               ; load a with a space
    rst 16
    ret

; ------------------------------------------------
; ROUTINE: set_position
; DESCR:    Uses the accumulator to set rst 16 from
;           d,e with ascii AT.
; INPUTS:   de
; ------------------------------------------------
set_position:
    ld a, ASCII_AT
    rst 16
    ld a, d
    rst 16
    ld a, e
    rst 16
    ret

move_right:
    ld a, (xpos)
    cp MAX_X
    ret nc                              ; pops out the carry flag
    ld a, (xpos)                        ; you can't increment data but a knows how to increment
    inc a                               ; increment a
    ld (xpos), a
    ret

move_left:
    ld a, (xpos)
    cp 0
    ret z                               ; pops out the carry flag
    ld a, (xpos)                        ; you can't increment data but a knows how to increment
    dec a                               ; increment a
    ld (xpos), a
    ret


move_up:
    ld a, (ypos)
    cp 0
    ret z
    ld a, (ypos)
    dec a
    ld (ypos), a
    ret

move_down:
    ld a, (ypos)
    cp MAX_Y
    ret z
    ld a, (ypos)
    inc a
    ld (ypos), a
    ret

;;;;;;;;;;;;;;;;;;;;; DATA ;;;;;;;;;;;;;;;;;;;;;;;;

score dw 0000
score_xpos db 0
score_ypos db 0

xpos db 0
ypos db 10

player_sprite db 0x91

 include "sprites.asm"  
 include "constants.asm" 
 include "audio.asm"

    end ENTRY_POINT