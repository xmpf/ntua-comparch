; --------------------------\
; Michalis Papadopoullos    |
; el14702@mail.ntua.gr      |
; $a0 :: first argument     |
; $a1 :: second argument    |
; $v0 :: result             |
; --------------------------/

; We assume that the arguments are
; loaded into stack before calling the
; procedure. In this scenario stack looks like
;       |-----|
;       |_ k _|
;       |_ n _| <-- $sp
;       |_..._|

SUM1:                            # Initialization
    add  $v0, $zero, $zero       # result = 0;
    addi $s1, $zero, 1           # $s1 = 1; constantly 1 register
    lw   $a0, 0($sp)             # load first argument
    lw   $a1, 4($sp)             # load second argument
    slt  $t0, $a1, $a0           # check if $a1 < $a0
                                 # $t0 = ( $a1 < $a0 ) ? 1 : 0;
    beq  $t0, $s1, END           # if ( $a0 > $a1 ) goto END;

LOOP:
    beq  $a0, $a1, L1            # if ( $a0 == $a1 ) goto L1;
    add  $v0, $v0, $a0           # res += n;
    add  $a0, $a0, $s1           # $a0 += 1;
    j    LOOP                    # unconditional jump to LOOP address

L1:
    add  $v0, $v0, $a0           # res += n;

END:
    jr   $ra                     # return from procedure