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
;        _____
;       |_..._|
;       |_ k _|
;       |_ n _| <-- $sp
;       |_ R _|         R:RECURSION
;       |_ r _|         r:result
;       |_..._|

    lw      $a0, 0($sp)         # load arguments from stack
    lw      $a1, 4($sp)         # into registers
    addi    $s0, $zero, 1       # constantly register equal to one (incrementing)
    addi    $s1, $zero, 8       # constantly register equal to eight (offset)
SUM2:
    addi    $sp, $sp, -8        # make room for return_address and return_result
    sw      $ra, 4($sp)         # store return_address on stack
    sw      $a0, 0($sp)         # save current $a0 into stack
    slt     $t0, $a1, $a0       # $t0 = ( $a1 < $a0 ) ? 1 : 0;
    beq     $t0, $zero, L1      # if ( $t0 == 0 ) goto L1;
    add     $v0, $zero, $zero   # initialize $v0 = 0;
    add     $sp, $sp, $s1       # $sp += 8; (8 = 2words) => move stack_pointer 2 words up
    jr      $ra                 # return to caller

L1:
    add     $a0, $a0, $s0       # $a0 += 1;
    jal     SUM2                # jump_and_link => jump to SUM2 procedure
                                #                  and set PC -> PC + 4
END:
    lw      $a0, 0($sp)         # load (last) 'n' into $a0
    lw      $ra, 4($sp)         # load return_address into $ra
    add     $sp, $sp, $s1       # move stack_pointer up => indicate data below $sp as garbage
    add     $v0, $v0, $a0       # result += (last)n
    jr      $ra                 # return to caller