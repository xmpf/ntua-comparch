###Introduction
Numbers in a computer system are represented using bits. 
Bits can be either $1$ or $0$. Using $N$ bits there are $2^{N}$ unique representations.
To represent signed numbers, we use the left-most bit (MSB) to indicate whether the number is positive $(\leadsto MSB = 0)$ or negative $(\leadsto MSB = 1)$. Therefore we now have $N-1$ available and we can represent numbers in the range: $\space-2^{N - 1} \le x \le  2^{N-1} - 1$.
$\space x = 0$ is considered positive, that's why $|{UpperBound}| = |LowerBound| - 1$.

###Overflow in integer arithmetic (addition)
$Overflow$ occurs when the result of an operation cannot be represented using the available bits.
With $signed$ numbers there is a possible overflow when the two operands have the same sign.
To extract sign-bit on a 32-bit machine:

    #define MASK (0x80000000)
    sign := number & MASK;
 
 With $unsigned$ numbers, it's easy to check for overflow.
 
 $Precondition \space check$:
 
    if ( x > UINT_MAX - y ) { // Handle overflow
	    ...
    }
 
$Postcondition check$:

    z = x + y;
    if ( z < x ) { // Overflow occured
	    ...
	}

When however talking about signed numbers, our job becomes a bit more difficult:

    /** snippet from CERT-C **/
    #include <limits.h>
    void f(signed int si_a, signed int si_b) {
      signed int sum;
      if (((si_b > 0) && (si_a > (INT_MAX - si_b))) ||
          ((si_b < 0) && (si_a < (INT_MIN - si_b)))) {
        /* Handle error */
      } else { /* safe to procceed */
        sum = si_a + si_b;
      }
      /* ... */
    }
   
   Or in MIPS assembly:

       ori   $s0, 0x80000000 # MASK
       # $t0 holds result
       # $t1 holds first operand
       # $t2 holds second operand
       xor   $t3, $t1, $t2
       and   $t3, $t3, $s0
       # $t3 = 1 if $t1 and $t2 have 
       # different signs, 0 otherwise
       bne    $t3, $zero, NO_OVF # different signs 
       # => no overflow
       # else: signs match, therefore there is
       # a possibility for an overflow
       xor    $t3, $t0, $t1 # check sign of result
       and    $t3, $t3, $s0 # if different from operand's
       # then an overflow occured
       bne    $t3, $zero, OVF # handle overflow