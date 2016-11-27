# Michalis Papadopoullos
# 03114702
# el14702@central.ntua.gr
# Computer Architecture 2016 - 2017

.data

.text

# -------------------------------------------------------
# [A]: array of single-precision floating point numbers
#   N: number of elements
# $a0: &A[0]
# $a1: N
# $f0: average value (sum/N)
#
# Single-precision floating point are 32-bit long
# therefore 4-byte aligned (0x???????0 -> 0x???????4)
# -------------------------------------------------------

# $t0: displacement
# $t1: count
# $s0: constant one

INIT_SECTION:					# initialization
	ori		$t0, $zero, 4		# int displacement = 4;
	ori		$t1, $zero, 1		# int count = 1;
	or		$s0, $zero, $t1		# const int increment = 1;
	sub.s 	$f0, $f0, $f0	 	# float sum = 0.0
	add.s  	$f0, $f0, 0($a0)	# sum += *($a0 + 0)
	mtc1 	$a1, $f1			# move N to a fp-register
	cvt.s.w $f1, $f1			# cast into single-precision ($f1 = N.0)

LOOP_0:
	add		$a0, $a0, $t0		# $a0  = &($a0 + 4)
	lwc1	$f2, 0($a0)			# load contents of MEM[$a0] into $f2 register
	add.s	$f0, $f0, $f2		# $f0 += (float)(*$a0)
	add		$t1, $t1, $s0		# count++;
	bne		$t1, $a1, LOOP_0	# if (count != N) goto LOOP_0;
	div.s   $f0, $f0, $f1		# sum = (float)(sum / N.0);
	jr		$ra					# return;
