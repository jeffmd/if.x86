# core.S

# ( xt -- )
# execute XT
Forthword_ EXEC, 0, "exec"
  rpush_
  dpop_
  ret

# ( xt -- )
# Don't do anything, just chew up a few cycles
Forthword_ NOOP, INLINE_OPT, "noop"
  nop
  ret

#@@@@@@@@@@@@@ Parameter Stack  Manipulation @@@@@@@@@@@@@@

# ( n -- n n )
# duplicate TOS
Forthword_ DPUSH, INLINE_OPT, "dpush"
  dpush_
  ret  
  
# ( n1 -- [ n1 n1 ] | 0)
# duplicate TOS if non-zero
Forthword_ QDUP, 0, "?dpush"
	iszero_
	je PFA_QDUP1	
	dpush_
PFA_QDUP1:
	ret

# ( n2 n1 -- n2 n2 )
#   d0 TOS
# fetch datastack[0] and place in TOS register
Forthword_ D0, INLINE_OPT, "d0"
  d0_
  ret
  
# ( n3 n2 n1 -- n3 n2 n3 )
#   d1 d0 TOS
# fetch datastack[1] and place in TOS register
Forthword_ D1, INLINE_OPT, "d1"
  d1_
  ret
  
# ( n4 n3 n2 n1 -- n4 n3 n2 n4 )
#   d2 d1 d0 TOS
# fetch datastack[2] and place in TOS register
Forthword_ D2, INLINE_OPT, "d2"
  d2_
  ret
  
# ( n1 n2 -- n2 n1)
# swaps the two top level stack cells
Forthword_ SWAP, INLINE_OPT, "swap"
  swap_
  ret

# ( n1 n2 -- n2)
# drop NOS, one before TOS.
# same as SWAP DROP
Forthword_ DNIP, INLINE_OPT, "dnip"
  dnip_ 
  ret
  
# ( x1 x2 -- x1 x2 x1 )
# Place a copy of x1 on top of the stack
Forthword_ OVER, INLINE_OPT, "over"
  over_
  ret

# ( x1 x2 -- x1 x2 x1 x2)
# Place a copy of x1 and x2 on top of the stack
Forthword_ TWOOVER, 0, "2over"
  over_
  jmp OVER

# ( n1 n2 -- n1)
# drop TOS
Forthword_ DDOP, INLINE_OPT, "dpop"
  dpop_
  ret

# ( n n -- )
# drop TOS twice
Forthword_ DPOP2, INLINE_OPT, "dpop2"
  dpop2_
  ret


# (  -- addr )
# current data stack pointer
Forthword_ SP_FETCH, 0, "sp"
  sp_
  ret
  
# ( addr -- i*x)
# set data stack pointer to addr
Forthword_ SP_STORE, INLINE_OPT, "!sp"
  str_sp_
  ret

#@@@@@@@@@@@@@ Return Stack @@@@@@@@@@@@@

# ( n1 -- n2 ) (R: n2 --)
# move TOR to TOS
Forthword_ RPOP, INLINE_OPT, "rpop"
	rpop_
	ret

# ( -- ) (R: n -- )
# Drop TOR
Forthword_ RPOPNOS, INLINE_OPT, "rnip"
	rnip_
	ret

# ( n -- ) (R: -- n)
# move TOS to TOR
Forthword_ RPUSH, INLINE_OPT, "rpush"
	rpush_
	ret

# ( -- n) (R: n -- n )
# put a copy of TOR on TOS
Forthword_ R0FETCH, INLINE_OPT, "r0"
	r0_
	ret

# ( -- n1 ) (R: n1 n2 -- n1 n2 )
# put a copy of R1 on TOS
Forthword_ R1FETCH, INLINE_OPT, "r1"
	r1_
	ret

# ( -- n1 ) (R: n1 n2 n3 -- n1 n2 n3 )
# put a copy of R2 on TOS
Forthword_ R2FETCH, INLINE_OPT, "r2"
	r2_
	ret

# (  -- n)
# current return stack pointer address
Forthword_ RP_FETCH, INLINE_OPT, "rp"
	rp_
	ret

# ( addr  -- ) (R: -- x*y)
# set return stack pointer
Forthword_ STORE_RP, INLINE_OPT, "!rp"
	# keep the return address
	str_rp_
	ret

# ( -- retaddr )
# pop second return onto data stack and exit caller
# used if data in program mem and need an address to it
# must be called
Forthword_ POPRET, 0, "popret"
  rpop_
  ret
    

# ( -- n) (R: n -- n+1 )
# get TOR and then increment TOR by 1 cell (32 bit)
# assumes TOR content will be used for 32 bit memory access
# since this word must be called, skip the top most item on the return stack
Forthword_ RTORPLUS, INLINE_OPT, "r>r+"
	r0_
	addl $4, (%esp)
	ret


#@@@@@@@@@@@@@ Arithmatic @@@@@@@@@@@@@

# ( n1 n2 -- n3)
# add n1 and n2
Forthword_ PLUS, INLINE_OPT, "+"
  plus_
  ret

# ( n1|u1 n2|u2 -- n3|u3 )
# subtract n2 from n1
Forthword_ MINUS, INLINE_OPT, "-"
  minus_
  ret

# ( u1|n1 u2|n2 -- u3|n3 )
# signed multiply 32b x 32b = 32b
Forthword_ MULU, INLINE_OPT,  "*"
  d0popd_
  imul %edx, %eax 
  ret

# ( n1 -- -n1 )
# 2-compliment of n1
Forthword_ NEGATE, INLINE_OPT, "neg"
  neg_
  ret


# ( n1 n2 -- n3 )
# bitwise and
Forthword_ AND_, INLINE_OPT, "and"
  and_
  ret

# ( n1 n2 -- n3 )
# logical or
Forthword_ OR, INLINE_OPT, "or"
  or_
  ret

# ( n1 n2 -- n3)
# exclusive or
Forthword_ XOR, INLINE_OPT, "xor"
  xor_
  ret

# ( n1 -- n2)
# 1-complement of TOS
Forthword_ NOT, INLINE_OPT, "not"
  not_
  ret

# ( n1 n2 -- flag)
# flag is true if n1 is not equal to n2
Forthword_ NOTEQUAL, INLINE_OPT, "<>"
  xor_
  ret

# ( n1 n2 -- flag )
# flag is true if TOS and NOS are equal
Forthword_ EQUAL, 0, "="
  sub (%ebx), %eax
  dnip_
  sub $1, %eax
  sbb %eax, %eax
  ret

# ( n1 n2 -- flag)
# flag is true if n1 is less than n2
Forthword_ LESS, 0, "<"
  cmp %eax, (%ebx)
  dnip_
  jge 1f
  zero_
  not_
  ret
1:
  zero_
  ret

# ( n1 n2 -- flag )
# flag is true if n1 is greater than n2
Forthword_ GREATER, 0, ">"
           # Get x1 into a register.
  cmp %eax, (%ebx)  # Is x2 greater?
  dnip_
GREATER_CHK:
  jle 1f
  zero_
  not_
  ret
1:
  zero_
  ret


# ( n1 -- n1+1 ) 
# optimized increment
Forthword_ ONEPLUS, INLINE_OPT, "1+"
  oneplus_
  ret

# ( n1 -- n1-1 )
# optimized decrement
Forthword_ ONEMINUS, INLINE_OPT, "1-"
  oneminus_
  ret

# ( n1 -- n1-2 )
# optimized decrement
Forthword_ TWOMINUS, INLINE_OPT, "2-"
  twominus_
  ret

# ( n1 -- n1+2 )
# optimized decrement
Forthword_ TWOPLUS, INLINE_OPT, "2+"
  twoplus_
  ret

# ( n1 -- n1-4 )
# optimized decrement
Forthword_ FOURMINUS, INLINE_OPT, "4-"
  fourminus_
  ret

# ( n1 -- n1+4 )
# optimized decrement
Forthword_ FOURPLUS, INLINE_OPT, "4+"
  fourplus_
  ret

# ( n1 -- n1/2 )
# optimized divide by 2
Forthword_ TWOSLASH, INLINE_OPT, "2/"
  twoslash_
  ret

# ( n1 -- n1*2 )
# optimized 2 multiply
Forthword_ TWOSTAR, INLINE_OPT, "2*"
  twostar_
  ret

# ( n1 -- n1/4 )
# optimized divide by 4
Forthword_ FOURSLASH, INLINE_OPT, "4/"
  fourslash_
  ret

# ( n1 -- n*4 )
# optimized four multiply
Forthword_ FOURSTAR, INLINE_OPT, "4*"
  fourstar_
  ret


# ( n1 -- flag )
# flag is true if n1 is 0
Forthword_ ZEROEQUAL, INLINE_OPT, "0="
  zeroequal_
  ret

# ( n1 -- flag )
# flag is true if n1 is greater than 0
Forthword_ ZEROGREATER, 0, "0>"
  sub $0, %eax
  jmp GREATER_CHK

# ( u1 u2 -- flag )
# flag is true if u1 > u2 (unsigned)
Forthword_ UGREATER, 0, "u>"
  d0popd_
  sub %edx, %eax
  sbb %eax, %eax
  ret

# ( u1 u2 -- flag)
# flag is true if u1 < u2 (unsigned)
Forthword_ ULESS, 0, "u<"
  d0popd_
  sub %eax, %edx
# TOS = a-b  -- carry set if a is less than b
  sbb %edx, %edx
  mov %edx, %eax
  ret

# ( n1 -- flag)
# flag is true if TOS is less than zero
forthword_ ZEROLESS, INLINE_OPT, "0<"
  zeroless_
  ret

# ( -- 0 )
# set TOS to 0
Forthword_ ZEROSET, INLINE_OPT, "0"
	zero_
	ret

# ( n -- n)
# test TOS if zero, does not consume TOS
Forthword_ ISZERO, INLINE_OPT, "0?"
	iszero_
	ret
  
# ( -- -1 )
# leaves the value -1 (true) on TOS
Forthword_ TRUE, INLINE_OPT, "true"
  true_
  ret

# ( -- 1 )
# place a value 1 on TOS
Forthword_ ONE, INLINE_OPT, "1"
  one_
  ret

# ( -- 2 )
# place a value 2 on TOS
Forthword_ TWO, INLINE_OPT, "2"
  two_
  ret

# ( -- 4 )
# place a value 4 on TOS
Forthword_ FOUR, INLINE_OPT, "4"
  four_
  ret

# ( -- 10 )
# place a value 10 on TOS
Forthword_ TEN, INLINE_OPT, "10"
  ten_
  ret

# ( n1 n2 -- n3)
# logically shift n1 left n2 times
forthword_ LSHIFT, INLINE_OPT, "<<"
  lshift_
  ret

# ( n1 n2 -- n3)
# logically shift n1 right n2 times
forthword_ RSHIFT, INLINE_OPT, ">>"
  rshift_
  ret


# ( a-addr -- n32 )
# read 1 cell (32 bits) from RAM address
Forthword_ FETCH, INLINE_OPT, "@"
  fetch_
  ret

# ( n32 a-addr -- )
# store a word (32 bits) to RAM address
Forthword_ STORE, INLINE_OPT, "!"
  store_
  ret

# ( a-addr -- )
# store 0 (32 bits) to RAM address
Forthword_ ZERO_STR, INLINE_OPT, "0!"
  zero_str_
  ret

# ( n32 a-addr -- )
# add n32 to content of cell RAM address a-addr
Forthword_ PLUS_STR, INLINE_OPT, "+!"
  plus_str_
  ret

# ( a-addr -- )
# subtract 1 from content of cell RAM address a-addr
Forthword_ ONEMINUS_STR, INLINE_OPT, "1-!"
  oneminus_str_
  ret

# ( a-addr -- )
# add 1 to content of cell RAM address a-addr
Forthword_ ONEPLUS_STR, INLINE_OPT, "1+!"
  oneplus_str_
  ret

# ( a-addr -- n16 )
# read half cell (16 bits) from RAM address
Forthword_ HFETCH, INLINE_OPT, "h@"
  hfetch_
  ret

# ( n16 a-addr -- )
# store a half word (16 bits) to RAM address
Forthword_ HSTORE, INLINE_OPT, "h!"
  hstore_
  ret

# ( a-addr -- )
# store 0 (16 bits) to RAM address
Forthword_ ZERO_HSTR, INLINE_OPT, "0h!"
  zero_hstr_
  ret

# ( n16 a-addr -- )
# add n16 to content of half cell RAM address a-addr
Forthword_ PLUS_HSTR, INLINE_OPT, "+h!"
  plus_hstr_
  ret

# ( a-addr -- )
# add 1 to content of half cell RAM address a-addr
Forthword_ ONEPLUS_HSTR, INLINE_OPT, "1+h!"
  oneplus_hstr_
  ret

# ( a-addr -- n8 )
# read byte (8 bits) from RAM address
Forthword_ CFETCH, INLINE_OPT, "c@"
  cfetch_
  ret

# ( c a-addr -- )
# store a single byte to RAM address
Forthword_ CSTORE, INLINE_OPT, "c!"
  cstr_
  ret

# ( a-addr -- )
# store 0 (16 bits) to RAM address
Forthword_ ZERO_CSTR, INLINE_OPT, "0c!"
  zero_cstr_
  ret

# ( c a-addr -- )
# add c byte to content of byte RAM address a-addr
Forthword_ PLUS_CSTR, INLINE_OPT, "+c!"
  plus_cstr_
  ret

# ( a-addr -- )
# add 1 to content of byte cell RAM address a-addr
Forthword_ ONEPLUS_CSTR, INLINE_OPT, "1+c!"
  oneplus_cstr_
  ret
  
# ( n -- n ) A: n
# copy TOS to A register
Forthword_ STR_A, INLINE_OPT, "!a"
  str_a_
  ret

# ( n -- n ) B: n
# copy TOS to B register
Forthword_ STR_B, INLINE_OPT, "!b"
  str_b_
  ret

# ( -- n )
# read the A register
Forthword_ A_, INLINE_OPT, "a"
  a_
  ret

# ( -- n )
# read the B register
Forthword_ B_, INLINE_OPT, "b"
  b_
  ret

# ( -- n )
# read the C register (Extended VM)
Forthword_ C_, INLINE_OPT, "c"
  c_
  ret

# ( -- n )
# read the D register (Extended VM)
Forthword_ d_, INLINE_OPT, "d"
  d_
  ret

# ( -- n )
# Read a word (32bit) from memory pointed to by register A (Extended VM)
Forthword_ A_FETCH, INLINE_OPT, "a@"
  a_fetch_
  ret

# ( n -- )
# store a word to RAM address pointed to by areg
Forthword_ A_STR, INLINE_OPT, "a!"
  a_str_
  ret

# ( -- n )
# Read a half word (32bit) from memory pointed to by register A (Extended VM)
Forthword_ A_HFETCH, INLINE_OPT, "ah@"
  a_hfetch_
  ret

# ( h -- )
# store a half word to RAM address pointed to by areg
Forthword_ A_HSTR, INLINE_OPT, "ah!"
  a_hstr_
  ret

# ( -- n )
# Read a byte from memory pointed to by register A (Extended VM)
Forthword_ A_CFETCH, INLINE_OPT, "ac@"
  a_cfetch_
  ret

# ( c -- )
# store a single byte to RAM address pointed to by areg
Forthword_ A_CSTORE, INLINE_OPT, "ac!"
  a_cstr_
  ret

# ( -- )
# update register A with post increment 4+ from last memory operation (Extended VM)
Forthword_ APLUS, INLINE_OPT, "a+"
  aplus_
  ret

# ( -- )
# update register A with post increment 2+ from last memory operation (Extended VM)
Forthword_ AHPLUS, INLINE_OPT, "ah+"
  ahplus_
  ret


# ( -- )
# update register A with post increment 1+ from last memory operation (Extended VM)
Forthword_ ACPLUS, INLINE_OPT, "ac+"
  acplus_
  ret

# (start dest count -- )
# count is the number of bytes to copy
# copy ram using bytes.  Assumes no overlap.
Forthword_ MCPY, 0, "mcpy"
	iszero_         # ( start dest count )
	je MCPY_END

	d0_str_b_          # ( start dest count ) B: dest
	mov %eax, %ecx
	d1_str_a_          # (  start dest count ) A: start
	cld
	rep movsb
	
MCPY_END:
  dnip2_
  ret
