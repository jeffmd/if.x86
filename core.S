# core.S

# ( xt -- )
# execute XT
Forthword_ EXEC, 0, "exec"
    pushl %ebx
    poptos_
    ret

# ( xt -- )
# Don't do anything, just chew up a few cycles
Forthword_ NOOP, INLINE_OPT, "noop"
    nop
    ret

#@@@@@@@@@@@@@ Parameter Stack  Manipulation @@@@@@@@@@@@@@

# ( n -- n n )
# duplicate TOS
Forthword_ DUP, INLINE_OPT, "dup"
    pushtos_
    ret

# ( n1 -- [ n1 n1 ] | 0)
# duplicate TOS if non-zero
Forthword_ QDUP, 0, "?dup"
    dupzerosense_
    je PFA_QDUP1
    pushtos_
PFA_QDUP1:
    ret

# ( n1 n2 -- n2 n1)
# swaps the two top level stack cells
Forthword_ SWAP, INLINE_OPT, "swap"
  swap_
  ret

# ( n1 n2 -- n2)
# drop NOS, one before TOS.
# same as SWAP DROP
Forthword_ NIP, INLINE_OPT, "nip"
  nip_ 
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

# ( n -- )
# drop TOS
Forthword_ DROP, INLINE_OPT, "drop"
  drop_
  ret

# ( n n -- )
# drop TOS twice
Forthword_ DDROP, INLINE_OPT, "2drop"
  ddrop_
  ret

# ( n1 n2 -- n2 n1 n2)
# tuck TOS before NOS, same as SWAP OVER
Forthword_ TUCK, 0, "tuck"
	popnos_
	sub $8, %eax
	mov %ebx, 4(%eax)
	mov %edx, (%eax)
	ret

# ( n1 n2 n3 -- n3 n2 n1)
# exchange TOS and stack cell before NOS, same as SWAP ROT
Forthword_ FLIP,  INLINE_OPT, "flip"
	flip_
	ret

# ( n1 n2 n3 -- n2 n3 n1)
# rotate the three top level cells
Forthword_ ROT, INLINE_OPT, "rot"
  rot_
  ret

# ( n1 n2 n3 -- n3 n1 n2)
# reverse rotate the three top level cells
# equivalent to rotate twice but faster
Forthword_ RROT, 0, "-rot"
  rrot_
  ret

# (  -- addr )
# current data stack pointer
Forthword_ SP_FETCH, INLINE_OPT, "sp@"
  spfetch_
  ret
  
# ( addr -- i*x)
# set data stack pointer to addr
Forthword_ SP_STORE, INLINE_OPT, "sp!"
  spstore_
  ret

#@@@@@@@@@@@@@ Return Stack @@@@@@@@@@@@@

# ( -- n ) (R: n --)
# move TOR to TOS
Forthword_ R_FROM, INLINE_OPT, "r>"
	r_from_
	ret

# ( -- ) (R: n -- )
# Drop TOR
Forthword_ R_DROP, INLINE_OPT, "r>drop"
	r_drop_
	ret

# ( n -- ) (R: -- n)
# move TOS to TOR
Forthword_ TO_R, INLINE_OPT, ">r"
	to_r_
	ret

# ( n -- n ) (R: -- n )
# copy TOS to TOR
Forthword_ DUP_R, INLINE_OPT, "r>r"
	dup_r_
	ret

# ( -- n) (R: n -- n )
# put a copy of TOR on TOS
Forthword_ R_FETCH, INLINE_OPT, "r"
	r_fetch_
	ret

# (  -- n)
# current return stack pointer address
Forthword_ RP_FETCH, INLINE_OPT, "rp@"
	rpfetch_
	ret

# ( addr  -- ) (R: -- x*y)
# set return stack pointer
Forthword_ RP_STORE, INLINE_OPT, "rp!"
	# keep the return address
	rpstore_
	ret

# ( -- retaddr )
# pop second return onto data stack and exit caller
# used if data in program mem and need an address to it
# must be called
Forthword_ POPRET, 0, "popret"
    pushtos_
    pop %ebx
    ret
    

# ( -- n) (R: n -- n+1 )
# get TOR and then increment TOR by 1 cell (32 bit)
# assumes TOR content will be used for 32 bit memory access
# since this word must be called, skip the top most item on the return stack
Forthword_ RTORPLUS, 0, "r>r+"
	pushtos_
	mov 4(%esp), %ebx
	addl $4, 4(%esp)
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
  popnos_
  sub %edx, %ebx
  sub $1, %ebx
  sbb %ebx, %ebx
  ret

# ( n1 n2 -- flag)
# flag is true if n1 is less than n2
Forthword_ LESS, 0, "<"
  popnos_
  cmp %ebx, %edx
  jge 1f
  zerotos_
  not_
  ret
1:
  mov $0, %ebx
  ret

# ( n1 n2 -- flag )
# flag is true if n1 is greater than n2
Forthword_ GREATER, 0, ">"
  popnos_         # Get x1 into a register.
  cmp %ebx, %edx  # Is x2 greater?
GREATER_CHK:
  jle 1f
  zerotos_
  not_
  ret
1:
  zerotos_
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

# ( n1 -- flag )
# flag is true if n1 is 0
Forthword_ ZEROEQUAL, INLINE_OPT, "0="
  zeroequal_
  ret

# ( n1 -- flag )
# flag is true if n1 is greater than 0
Forthword_ ZEROGREATER, 0, "0>"
  sub $0, %ebx
  jmp GREATER_CHK

# ( u1 u2 -- flag )
# flag is true if u1 > u2 (unsigned)
Forthword_ UGREATER, 0, "u>"
  xchg %eax, %esp
  pop %edx
  sub %edx, %ebx
  sbb %ebx, %ebx
  xchg %eax, %esp
  ret

# ( u1 u2 -- flag)
# flag is true if u1 < u2 (unsigned)
Forthword_ ULESS, 0, "u<"
  popnos_
  sub %ebx, %edx
# TOS = a-b  -- carry set if a is less than b
  sbb %edx, %edx
  mov %edx, %ebx
  ret

# ( n1 -- flag)
# flag is true if TOS is less than zero
forthword_ ZEROLESS, INLINE_OPT, "0<"
  zeroless_
  ret

# ( -- 0 )
# place a value 0 on TOS
Forthword_ ZERO, INLINE_OPT, "0"
  zero_
  ret

# ( -- 0 )
# set TOS to 0
Forthword_ ZEROSET, INLINE_OPT, "0:"
	zerotos_
	ret

# ( n -- )
# test TOS if zero
Forthword_ ZEROSENSE, INLINE_OPT, "0?"
	zerosense_
	ret

# ( n -- n)
# test TOS if zero, does not consume TOS
Forthword_ QZEROSENSE, INLINE_OPT, "?0?"
	dupzerosense_
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
Forthword_ ZEROSTORE, INLINE_OPT, "0!"
  zerostore_
  ret

# ( n32 a-addr -- )
# add n32 to content of cell RAM address a-addr
Forthword_ PLUSSTORE, INLINE_OPT, "+!"
  # X is the new TOS after the store completes.
  xchg %eax, %esp
  pop %edx
  addl  %edx, (%ebx)   
  pop %ebx
  xchg %eax, %esp
  ret

# ( a-addr -- )
# add 1 to content of cell RAM address a-addr
Forthword_ ONEPLUSSTORE, INLINE_OPT, "1+!"
  xchg %eax, %esp
  addl  $1, (%ebx)
  pop %ebx
  xchg %eax, %esp
  ret

# ( a-addr -- n16 )
# read half cell (16 bits) from RAM address
Forthword_ HFETCH, INLINE_OPT, "h@"
  hfetch_
  ret

# ( n16 a-addr -- )
# store a half word (16 bits) to RAM address
Forthword_ HSTORE, INLINE_OPT, "h!"
  xchg %eax, %esp
  pop %edx
  movw %dx, (%ebx)     
  pop %ebx
  xchg %eax, %esp
  ret

# ( a-addr -- )
# store 0 (16 bits) to RAM address
Forthword_ ZEROHSTORE, INLINE_OPT, "0h!"
  xchg %eax, %esp
  movw $0, (%ebx)
  pop %ebx
  xchg %eax, %esp
  ret

# ( n16 a-addr -- )
# add n16 to content of half cell RAM address a-addr
Forthword_ PLUSHSTORE, INLINE_OPT, "+h!"
  xchg %eax, %esp
  pop %edx
  addw %dx, (%ebx)
  pop %ebx
  xchg %eax, %esp
  ret

# ( a-addr -- )
# add 1 to content of half cell RAM address a-addr
Forthword_ ONEPLUSHSTORE, INLINE_OPT, "1+h!"
  xchg %eax, %esp
  addw  $1, (%ebx)
  pop %ebx
  xchg %eax, %esp
  ret

# ( a-addr -- n8 )
# read byte (8 bits) from RAM address
Forthword_ CFETCH, INLINE_OPT, "c@"
  cfetch_
  ret

# ( c a-addr -- )
# store a single byte to RAM address
Forthword_ CSTORE, INLINE_OPT, "c!"
  xchg %eax, %esp
  pop %edx
  movb %dl, (%ebx)
  pop %ebx
  xchg %eax, %esp
  ret

# ( a-addr -- )
# store 0 (16 bits) to RAM address
Forthword_ ZEROCSTORE, INLINE_OPT, "0c!"
  xchg %eax, %esp
  movb $0, (%ebx)
  pop %ebx
  xchg %eax, %esp
  ret

# ( c a-addr -- )
# add c byte to content of byte RAM address a-addr
Forthword_ PLUSCSTORE, INLINE_OPT, "+c!"
  xchg %eax, %esp
  pop %edx
  addb %dl, (%ebx)
  pop %ebx
  xchg %eax, %esp
  ret

# ( a-addr -- )
# add 1 to content of byte cell RAM address a-addr
Forthword_ ONEPLUSCSTORE, INLINE_OPT, "1+c!"
  xchg %eax, %esp
  addb $1, (%ebx)
  pop %ebx
  xchg %eax, %esp
  ret
  
# ( n1 n2 -- n2 ) A: n1
# Remove next on stack and write to A register (Extended VM)
Forthword_ NIPTOA, INLINE_OPT, "nip>a"
  niptoa_
  ret

# ( n1 n2 -- n2 ) B: n1
# Remove next on stack and write to B register (Extended VM)
Forthword_ NIPTOB, INLINE_OPT, "nip>b"
  niptob_
  ret

# ( n -- ) A: n
# Move TOS to A register (Extended VM)
Forthword_ TO_A, INLINE_OPT, ">a"
  toa_
  ret

# ( n -- ) B: n
# Move TOS to B register (Extended VM)
Forthword_ TO_B, INLINE_OPT, ">b"
  tob_
  ret

# ( n -- n ) A: n
# copy TOS to A register (Extended VM)
Forthword_ _A, INLINE_OPT, ":a"
  copytoa_
  ret

# ( n -- n ) B: n
# copy TOS to B register (Extended VM)
Forthword_ _B, INLINE_OPT, ":b"
  copytob_
  ret

# ( -- n )
# read the A register (Extended VM)
Forthword_ A_, INLINE_OPT, "a"
  geta_
  ret

# ( -- n )
# read the B register (Extended VM)
Forthword_ B_, INLINE_OPT, "b"
  getb_
  ret

# ( -- n )
# Read a word (32bit) from memory pointed to by register A (Extended VM)
Forthword_ AFETCH, INLINE_OPT, "a@"
  afetch_
  ret

# ( n -- )
# store a word to RAM address pointed to by areg
Forthword_ ASTORE, INLINE_OPT, "a!"
  astore_
  ret

# ( -- n )
# Read a half word (32bit) from memory pointed to by register A (Extended VM)
Forthword_ AHFETCH, INLINE_OPT, "ah@"
  ahfetch_
  ret

# ( h -- )
# store a half word to RAM address pointed to by areg
Forthword_ AHSTORE, INLINE_OPT, "ah!"
  ahstore_
  ret

# ( -- n )
# Read a byte from memory pointed to by register A (Extended VM)
Forthword_ ACFETCH, INLINE_OPT, "ac@"
  acfetch_
  ret

# ( c -- )
# store a single byte to RAM address pointed to by areg
Forthword_ ACSTORE, INLINE_OPT, "ac!"
  acstore_
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
	niptob_         # ( start count ) B: dest
MCPY_B:
	dupzerosense_   # ( start count )
	je MCPY_END
	mov %ebx, %ecx
	poptos_         # ( start ) ecx: count
	toa_            # ( ) esi: start
	cld
	rep movsb
	ret
	
MCPY_END:
	jmp DDROP
