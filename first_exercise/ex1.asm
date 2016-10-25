; Michalis Papadopoullos
; el14702@mail.ntua.gr

    add $t1, $zero, $zero       # $t1 (register) = i = 0;
    add $s1, $zero, 1           # $s1 = 1;
LOOP:
    slt $t0, $t1, $s0           # $t0 = ($t1 < $s0) ? 1 : 0;
    beq $t0, $zero, END         # if ($t0 == 0) goto END;
    sll $t2, $t1, 2             # $t2 = ($t1) << 2 = ($t1) * 4, $t1 = index;
    add $t6, $t2, $s1           # $t6 = (index * 4) + base_address(A);
    lw  $t3, 0($t6)             # $t3 = $t6 + offset(0);
    sll $t4, $t3, 2             # $t4 = $t3 * 4, use it as offset for C
    add $t6, $t4, $s3           # $t6 = (indexb * 4) + base_address(C);
    lw  $t4, 0($t6)             # $t4 = $t6 + offset(0);
    add $t5, $t3, $t4           # $t5 = $t3 + $t4;
    add $t6, $t2, $s2           # $t6 = $s2 + $t2 = base_address(B) + (index * 4);
    sw  $t5, 0($t6)             # MEM[$t6 + 0] = $t5 = A[i] + C[A[i]]
    add $t1, $t1, $s1           # i++;
    j   LOOP                    # unconditional jump to LOOP address
END: