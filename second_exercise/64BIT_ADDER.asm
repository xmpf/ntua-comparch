# Michalis Papadopoullos
# 03114702
# el14702@mail.ntua.gr
#
# Implementing 64-bit full adder
# in MIPS assembly language
# using 32-bit wide long variables

# Representation
# C = A + B
# C[0:31] 	= A[0:31] + B[0:31] 	-- unsigned
# C[32:63] 	= A[32:63] + B[32:62] + carry_bit		-- signed
# HiOrder _concat_ LowOrder
# A[32:63]	= $a1 (signed)
# A[0:31]	= $a0 (unsigned)
# B[32:63]	= $a3 (signed)
# B[0:31]	= $a2 (unsigned)

# First argument is loaded into $a1$a0
# and the second into $a3$a2
# Result is saved into $v1$v0
.data
 msg_err: .asciiz "Overflow occured. Terminating!\n"

.text
ADD64U:	# $v0$v1 = $a0$a1 + $a2$a3
	addu	$v0, $a0, $a2	# add low-order words (32-bit)
	sltu	$t0, $v0, $a0	# 1 if v0 < a0 => OVERFLOW occured
	# sltu	$t0, $v0, $a2	# 1 if v0 < a2 => OVERFLOW occured
	xor $t1, $a1, $a3		# t1 < 0 if signs differ
	slt $t1, $t1, $zero		# t1 = 1 if sign(a1) != sign(a3)

	add	$v1, $t0, $a1   	# v1 = a1 + carry_bit
	add	$v1, $v1, $a3		# v1 = a3 + (a1 + carry_bit)

	bne $t1, $zero, NO_OVF	# no-overflow :: return

	xor $t2, $v1, $a3		# check if sign(result) != sign(operand)
	slt $t2, $t2, $zero		# t2 = 1 if sign(result) != sign(operand)
	bne $t2, $zero, L_OVF
NO_OVF:
	jr	$ra		#return

L_OVF: # overflow occured
	lui	$a0, 4097
	ori $v0, $v0, 4
	syscall # print error message

	ori $v0, $v0, 10
	syscall # exit
