; ---------------- Audio --------------------
; -------------------------------------------
;   Notes:
;   ------
;       - C             261.63
;       - C#            277.18      
;       - D             293.66
;       - D#            311.13
;       - E             329.63
;       - F             349.23
;       - F#            369.99
;       - G             392.00
;       - G#            415.30
;       - A             440.00
;       - A#            466.16
;       - B             493.88
; -------------------------------------------
; de: duration = freq * seconds
; hl: pitch = 0x6acfc / freq - 30.125
; -------------------------------------------

; -------------------------------------------
; ROUTINE: note_g_sharp
; d,e - 415.3 * 0.5
; h,l - 437500 / (415.3 - 30.125) = 1,023.3
note_g_sharp:
    ld hl, 0x03ff           ; h,l - 437500 / (415.3 - 30.125) = 1,023.3
    ld de, 208              ; d,e - 415.3 * 0.5
    call 0x03b5             ; beeper subroutine
    ret 