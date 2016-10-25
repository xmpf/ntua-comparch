; --------------------------\
; Michalis Papadopoullos    |
; el14702@mail.ntua.gr      |
; $a0 :: first argument     |
; $a1 :: second argument    |
; $v0 :: result             |
; $t1 :: tempb              |
; --------------------------/

RUSS_MULT:
    # load arguments from
    # stack into registers
    addu $v0, $zero, $zero   # (result) $v0 = 0;
    addu $t1, $a1, $zero     # (tempb)  $t1 = b;
    addu $s1, $s1, 1         # $s1 = 1
LOOP:
    sltu $t2, $t1, $s1       # $t2 = ($t1 < 1) ? 1 : 0;
    bne  $t2, $zero, END     # if ( $t2 != 0 ) goto END;
    and  $t2, $t1, $s1       # check if $t1 is odd $t2 = ($t1 & 1) ? 1 : 0;
    beq  $t2, $zero, NEXT    # if (odd) goto NEXT;
    addu $v0, $v0, $a0       # result += a;
NEXT:
    sllv $a0, $a0, $s1       # a *= 2;
    srlv $a1, $a1, $s1       # b /= 2;
    j   LOOP                 # unconditional jump at LOOP address
EXIT:
    sw  $v0, 0($sp)          # save result on stack
    jr  $ra