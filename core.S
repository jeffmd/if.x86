# core.S

#@@@@@@@@@@@@@ Parameter Stack  Manipulation @@@@@@@@@@@@@@

# ( n -- n n )
# push WR onto top of data stack
Forthword_ DPUSH, INLINE_OPT, "push"
  push_
  ret  
  
# ( n -- n n n )
# push WR onto top of data stack twice
Forthword_ DPUSH2, INLINE_OPT, "push2"
  push2_
  ret  
  
# ( n1 n2 -- n1 a  n2 )
#   d0 WR    d1 d0 WR
# push register A onto top of data stack
Forthword_ DPUSHA, INLINE_OPT, "push.a"
  push_a_
  ret  
  
# ( n1 n2 -- n1 b  n2 )
#   d0 WR    d1 d0 WR
# push register B onto top of data stack
Forthword_ DPUSHB, INLINE_OPT, "push.b"
  push_b_
  ret  
  
# ( n1 n2 -- n1 x  n2 )
#   d0 WR    d1 d0 WR
# push register X onto top of data stack
Forthword_ DPUSHX, INLINE_OPT, "push.x"
  push_x_
  ret  
  
# ( n1 n2 -- n1 y  n2 )
#   d0 WR    d1 d0 WR
# push register Y onto top of data stack
Forthword_ DPUSHY, INLINE_OPT, "push.y"
  push_y_
  ret  
  
# ( n1 -- [ n1 n1 ] | 0)
# duplicate WR if non-zero
Forthword_ QPUSH, 0, "?push"
	iszero_
	je PFA_QDUP1	
	push_
PFA_QDUP1:
	ret

# ( n2 n1 -- n2 n2 )
#   d0 WR
# fetch datastack[0] and place in WR register
Forthword_ D0, INLINE_OPT, "d0"
  d0_
  ret
  
# ( n3 n2 n1 -- n3 n2 n3 )
#   d1 d0 WR
# fetch datastack[1] and place in WR register
Forthword_ D1, INLINE_OPT, "d1"
  d1_
  ret
  
# ( n4 n3 n2 n1 -- n4 n3 n2 n4 )
#   d2 d1 d0 WR
# fetch datastack[2] and place in WR register
Forthword_ D2, INLINE_OPT, "d2"
  d2_
  ret

# ( n2 n1 -- n1 n1 )
#   d0 WR
# fetch WR register and place in datastack[0] 
Forthword_ STR_D0, INLINE_OPT, "!d0"
  str_d0_
  ret
    
# ( n3 n2 n1 -- n1 n2 n1 )
#   d1 d0 WR
# fetch WR register and place in datastack[1] 
Forthword_ STR_D1, INLINE_OPT, "!d1"
  str_d1_
  ret
    
# ( n4 n3 n2 n1 -- n1 n3 n2 n1 )
#   d2 d1 d0 WR
# fetch WR register and place in datastack[2] 
Forthword_ STR_D2, INLINE_OPT, "!d2"
  str_d2_
  ret
    
# ( n2 n1 -- n2 n1 ) A: n2
#   d0 WR
# fetch datastack[0] and store in A register
Forthword_ D0_STR_A, INLINE_OPT, "d0!a"
  d0_str_a_
  ret
  
# ( n2 n1 -- n2 n1 ) B: n2
#   d0 WR
# fetch datastack[0] and store in B register
Forthword_ D0_STR_B, INLINE_OPT, "d0!b"
  d0_str_b_
  ret
  
# ( n2 n1 -- n2 n1 ) X: n2
#   d0 WR
# fetch datastack[0] and store in X register
Forthword_ D0_STR_X, INLINE_OPT, "d0!x"
  d0_str_x_
  ret
  
# ( n2 n1 -- n2 n1 ) Y: n2
#   d0 WR
# fetch datastack[0] and store in Y register
Forthword_ D0_STR_Y, INLINE_OPT, "d0!y"
  d0_str_y_
  ret
   
# ( n3 n2 n1 -- n3 n2 n1 ) A: n3
#   d1 d0 WR
# fetch datastack[1] and store in A register
Forthword_ D1_STR_A, INLINE_OPT, "d1!a"
  d1_str_a_
  ret
  
# ( n3 n2 n1 -- n3 n2 n1 ) B: n3
#   d1 d0 WR
# fetch datastack[1] and store in B register
Forthword_ D1_STR_B, INLINE_OPT, "d1!b"
  d1_str_b_
  ret
  
# ( n3 n2 n1 -- n3 n2 n1 ) X: n3
#   d1 d0 WR
# fetch datastack[1] and store in X register
Forthword_ D1_STR_X, INLINE_OPT, "d1!x"
  d1_str_x_
  ret
  
# ( n3 n2 n1 -- n3 n2 n1 ) Y: n3
#   d1 d0 WR
# fetch datastack[1] and store in Y register
Forthword_ D1_STR_Y, INLINE_OPT, "d1!y"
  d1_str_y_
  ret
  
# ( n4 n3 n2 n1 -- n4 n3 n2 n1 ) A: n4
#   d2 d1 d0 WR
# fetch datastack[2] and store in A register
Forthword_ D2_STR_A, INLINE_OPT, "d2!a"
  d2_str_a_
  ret
  
# ( n4 n3 n2 n1 -- n4 n3 n2 n1 ) B: n4
#   d2 d1 d0 WR
# fetch datastack[2] and store in B register
Forthword_ D2_STR_B, INLINE_OPT, "d2!b"
  d2_str_b_
  ret
  
# ( n4 n3 n2 n1 -- n4 n3 n2 n1 ) X: n4
#   d2 d1 d0 WR
# fetch datastack[2] and store in X register
Forthword_ D2_STR_X, INLINE_OPT, "d2!x"
  d2_str_x_
  ret
  
# ( n4 n3 n2 n1 -- n4 n3 n2 n1 ) Y: n4
#   d2 d1 d0 WR
# fetch datastack[2] and store in Y register
Forthword_ D2_STR_Y, INLINE_OPT, "d2!y"
  d2_str_y_
  ret
  
# ( ?  n2 -- n1 n2 ) A: n1
#   d0 WR
# fetch A register and store in d0 stack position
Forthword_ A_STR_D0, INLINE_OPT, "a!d0"
  a_str_d0_
  ret
  
# ( ?  n2 -- n1 n2 ) B: n1
#   d0 WR
# fetch B register and store in d0 stack position
Forthword_ B_STR_D0, INLINE_OPT, "b!d0"
  b_str_d0_
  ret
  
# ( ?  n2 -- n1 n2 ) X: n1
#   d0 WR
# fetch X register and store in d0 stack position
Forthword_ X_STR_D0, INLINE_OPT, "x!d0"
  x_str_d0_
  ret
  
# ( ?  n2 -- n1 n2 ) Y: n1
#   d0 WR
# fetch y register and store in d0 stack position
Forthword_ Y_STR_D0, INLINE_OPT, "y!d0"
  y_str_d0_
  ret
  
# ( ?  ?  n1 -- n2 ? n1 ) A: n2
#   d1 d0 WR
# fetch A register and store in d1 stack position
Forthword_ A_STR_D1, INLINE_OPT, "a!d1"
  a_str_d1_
  ret
  
# ( ?  ?  n1 -- n2 ?  n1 ) B: n2
#   d1 d0 WR
# fetch B register and store in d1 stack position
Forthword_ B_STR_D1, INLINE_OPT, "b!d1"
  b_str_d1_
  ret
  
# ( ?  ?  n1 -- n2 ?  n1 ) X: n2
#   d1 d0 WR
# fetch X register and store in d1 stack position
Forthword_ X_STR_D1, INLINE_OPT, "x!d1"
  x_str_d1_
  ret
  
# ( ?  ?  n1 -- n2 ?  n1 ) Y: n2
#   d1 d0 WR
# fetch y register and store in d1 stack position
Forthword_ Y_STR_D1, INLINE_OPT, "y!d1"
  y_str_d1_
  ret
  
# ( ?  ?  ?  n1 -- n2 ?  ? n1 ) A: n2
#   d2 d1 d0 WR
# fetch A register and store in d2 stack position
Forthword_ A_STR_D2, INLINE_OPT, "a!d2"
  a_str_d2_
  ret
  
# ( ?  ?  ?  n1 -- n2 ?  ? n1 ) B: n2
#   d2 d1 d0 WR
# fetch B register and store in d2 stack position
Forthword_ B_STR_D2, INLINE_OPT, "b!d2"
  b_str_d2_
  ret
  
# ( ?  ?  ?  n1 -- n2 ?  ? n1 ) X: n2
#   d2 d1 d0 WR
# fetch X register and store in d2 stack position
Forthword_ X_STR_D2, INLINE_OPT, "x!d2"
  x_str_d2_
  ret
  
# ( ?  ?  ?  n1 -- n2 ?  ? n1 ) Y: n2
#   d2 d1 d0 WR
# fetch y register and store in d2 stack position
Forthword_ Y_STR_D2, INLINE_OPT, "y!d2"
  y_str_d2_
  ret
  
# ( n1 n2 -- n2 n1 ) Y: d0
#   d0 WR
# swaps D0 with WR
Forthword_ SWAP, INLINE_OPT, "swap"
  swap_
  ret

# ( n1 n2 -- n2)
# drop NOS, one before WR.
# same as SWAP DROP
Forthword_ DNIP, INLINE_OPT, "nip"
  nip_ 
  ret
  
# ( n1 n2 n3 -- n3 )
# drop top 2 items from datastack.
Forthword_ DNIP2, INLINE_OPT, "nip2"
  nip2_ 
  ret
  
# ( n1 n2 n3 n4 -- n4 )
# drop top 2 items from datastack.
Forthword_ DNIP3, INLINE_OPT, "nip3"
  nip3_
  ret
  
# ( x1 x2 -- x1 x2 x1 )
#   do WR
# push WR on data stack and place D1 in WR
Forthword_ OVER, INLINE_OPT, "over"
  over_
  ret

# ( x1 x2 x3 -- x1 x2 x3 x1 x2 x3 )
# Place a copy of x1, x2, x3 on top of the stack
Forthword_ THREEOVER, 0, "3over"
  top3_
  str_d2_
  mov 16(%ebx), %eax
  str_d1_
  mov 12(%ebx), %eax
  str_d0_
  d2_
  ret


# ( n1 n2 -- n1)
#   d0 WR    WR
# pop top of data stack into WR
Forthword_ DPOP, INLINE_OPT, "pop"
  pop_
  ret

# ( n1 n2 n3 -- n1 n3 ) A: n2
#   d1 d0 WR    d0 WR
# pop top of data stack into register A
Forthword_ DPOPA, INLINE_OPT, "pop.a"
  pop_a_
  ret

# ( n1 n2 n3 -- n1 n3 ) B: n2
#   d1 d0 WR    d0 WR
# pop top of data stack into register B
Forthword_ DPOPB, INLINE_OPT, "pop.b"
  pop_b_
  ret

# ( n1 n2 n3 -- n1 n3 ) X: n2
#   d1 d0 WR    d0 WR
# pop top of data stack into register X
Forthword_ DPOPX, INLINE_OPT, "pop.x"
  pop_x_
  ret

# ( n1 n2 n3 -- n1 n3 ) Y: n2
#   d1 d0 WR    d0 WR
# pop top of data stack into register Y
Forthword_ DPOPY, INLINE_OPT, "pop.y"
  pop_y_
  ret

# ( n n -- )
# drop WR twice
Forthword_ DPOP2, INLINE_OPT, "pop2"
  pop2_
  ret


# (  -- addr )
# current data stack pointer
Forthword_ SP_FETCH, INLINE_OPT, "sp"
  sp_
  ret
  
# ( addr -- i*x)
# set data stack pointer to addr
Forthword_ SP_STORE, INLINE_OPT, "!sp"
  str_sp_
  ret

#@@@@@@@@@@@@@ Return Stack @@@@@@@@@@@@@

# ( n1 -- n2 ) (R: n2 --)
# pop top of return stack into WR
Forthword_ RPOP, INLINE_OPT, "rpop"
	rpop_
	ret

# ( -- ) (R: n2 --) A: n2
# pop top of return stack into A
Forthword_ RPOPA, INLINE_OPT, "rpop.a"
	rpop_a_
	ret

# ( -- ) (R: n2 --) B: n2
# pop top of return stack into B
Forthword_ RPOPB, INLINE_OPT, "rpop.b"
	rpop_b_
	ret

# ( -- ) (R: n2 --) X: n2
# pop top of return stack into X
Forthword_ RPOPX, INLINE_OPT, "rpop.x"
	rpop_x_
	ret

# ( -- ) (R: n2 --) Y: n2
# pop top of return stack into Y
Forthword_ RPOPY, INLINE_OPT, "rpop.y"
	rpop_y_
	ret

# ( -- ) (R: n -- )
# Drop TOR
Forthword_ RNIP, INLINE_OPT, "rnip"
	rnip_
	ret

# ( -- ) (R: n2 n1 -- )
# remove 2 top cells of return stack
Forthword_ RNIP2, INLINE_OPT, "rnip2"
	rnip2_
	ret

# ( -- ) (R: n3 n2 n1 -- )
# remove 3 top cells of return stack
Forthword_ RNIP3, INLINE_OPT, "rnip3"
	rnip3_
	ret

# ( n -- ) (R: -- n)
# push WR on top of return stack
Forthword_ RPUSH, INLINE_OPT, "rpush"
	rpush_
	ret

# ( -- ) (R: -- a)
# push A on top of return stack
Forthword_ RPUSHA, INLINE_OPT, "rpush.a"
	rpush_a_
	ret

# ( -- ) (R: -- b)
# push B on top of return stack
Forthword_ RPUSHB, INLINE_OPT, "rpush.b"
	rpush_b_
	ret

# ( -- ) (R: -- x)
# push X on top of return stack
Forthword_ RPUSHX, INLINE_OPT, "rpush.x"
	rpush_x_
	ret

# ( -- ) (R: -- y)
# push Y on top of return stack
Forthword_ RPUSHY, INLINE_OPT, "rpush.y"
	rpush_y_
	ret

# ( -- ) (R: -- sp)
# push datastack pointer on top of return stack
Forthword_ RPUSHSP, INLINE_OPT, "rpush.sp"
	rpush_sp_
	ret

# ( -- n) (R: n -- n )
# put a copy of TOR in WR
Forthword_ R0, INLINE_OPT, "r0"
	r0_
	ret

# ( -- n1 ) (R: n1 n2 -- n1 n2 )
# put a copy of R1 in WR
Forthword_ R1, INLINE_OPT, "r1"
	r1_
	ret

# ( -- n1 ) (R: n1 n2 n3 -- n1 n2 n3 )
# put a copy of R2 in WR
Forthword_ R2, INLINE_OPT, "r2"
	r2_
	ret

# ( n1 -- n1) (R: n2 -- n1 )
#   WR            R0
# put a copy of WR register into R0 on return stack
Forthword_ STR_R0, INLINE_OPT, "!r0"
	str_r0_
	ret

# ( n1 -- n1) (R: n3 n2 -- n1 n2 )
#   WR            R1 R0
# put a copy of WR register into R1 on return stack
Forthword_ STR_R1, INLINE_OPT, "!r1"
	str_r1_
	ret

# ( n1 -- n1) (R: n4 n3 n2 -- n1 n3 n2 )
#   WR            R2 R1 R0
# put a copy of WR register into R2 on return stack
Forthword_ STR_R2, INLINE_OPT, "!r2"
	str_r2_
	ret

# ( -- ) (R: n1 -- n1 ) A: n1
#            R0
# put a copy of R0 into A register
Forthword_ R0_STR_A, INLINE_OPT, "r0!a"
	r0_str_a_
	ret

# ( -- ) (R: n1 -- n1 ) B: n1
#            R0
# put a copy of R0 into B register
Forthword_ R0_STR_B, INLINE_OPT, "r0!b"
	r0_str_b_
	ret

# ( -- ) (R: n1 -- n1 ) X: n1
#            R0
# put a copy of R0 into X register
Forthword_ R0_STR_X, INLINE_OPT, "r0!x"
	r0_str_x_
	ret

# ( -- ) (R: n1 -- n1 ) Y: n1
#            R0
# put a copy of R0 into Y register
Forthword_ R0_STR_Y, INLINE_OPT, "r0!y"
	r0_str_y_
	ret

# ( -- ) (R: n2 n1 -- n2 n1 ) A: n2
#            R1 R0
# put a copy of R1 into A register
Forthword_ R1_STR_A, INLINE_OPT, "r1!a"
	r1_str_a_
	ret

# ( -- ) (R: n2 n1 -- n2 n1 ) B: n2
#            R1 R0
# put a copy of R0 into B register
Forthword_ R1_STR_B, INLINE_OPT, "r1!b"
	r1_str_b_
	ret

# ( -- ) (R: n2 n1 -- n2 n1 ) X: n2
#            R1 R0
# put a copy of R1 into X register
Forthword_ R1_STR_X, INLINE_OPT, "r1!x"
	r1_str_x_
	ret

# ( -- ) (R: n2 n1 -- n2 n1 ) Y: n2
#            R1 R0
# put a copy of R1 into Y register
Forthword_ R1_STR_Y, INLINE_OPT, "r1!y"
	r1_str_y_
	ret

# ( -- ) (R: n3 n2 n1 -- n3 n2 n1 ) A: n3
#            R2 R1 R0
# put a copy of R2 into A register
Forthword_ R2_STR_A, INLINE_OPT, "r2!a"
	r2_str_a_
	ret

# ( -- ) (R: n3 n2 n1 -- n3 n2 n1 ) B: n3
#            R2 R1 R0
# put a copy of R2 into B register
Forthword_ R2_STR_B, INLINE_OPT, "r2!b"
	r2_str_b_
	ret

# ( -- ) (R: n3 n2 n1 -- n3 n2 n1 ) X: n3
#            R2 R1 R0
# put a copy of R2 into X register
Forthword_ R2_STR_X, INLINE_OPT, "r2!x"
	r2_str_x_
	ret

# ( -- ) (R: n3 n2 n1 -- n3 n2 n1 ) Y: n3
#            R2 R1 R0
# put a copy of R2 into Y register
Forthword_ R2_STR_Y, INLINE_OPT, "r2!y"
	r2_str_y_
	ret

# (R: n2 -- n1 ) A: n1
#     r0
# fetch A register and store in r0 return stack position
Forthword_ A_STR_R0, INLINE_OPT, "a!r0"
  a_str_r0_
  ret
  
# (R: n2 -- n1 ) B: n1
#     r0
# fetch B register and store in r0 return stack position
Forthword_ B_STR_R0, INLINE_OPT, "b!r0"
  b_str_r0_
  ret
  
# (R: n2 -- n1 ) X: n1
#     r0
# fetch X register and store in r0 return stack position
Forthword_ X_STR_R0, INLINE_OPT, "x!r0"
  x_str_r0_
  ret
  
# (R: n2 -- n1 ) Y: n1
#     r0
# fetch y register and store in r0 return stack position
Forthword_ Y_STR_R0, INLINE_OPT, "y!r0"
  y_str_r0_
  ret
  
# (R: ?  n1 -- n2 n1 ) A: n2
#     r1 r0
# fetch A register and store in r1 return stack position
Forthword_ A_STR_R1, INLINE_OPT, "a!r1"
  a_str_r1_
  ret
  
# (R: ?  n1 -- n2 n1 ) B: n2
#     r1 r0
# fetch B register and store in r1 return stack position
Forthword_ B_STR_R1, INLINE_OPT, "b!r1"
  b_str_r1_
  ret
  
# (R: ?  n1 -- n2 n1 ) X: n2
#     r1 r0
# fetch X register and store in r1 return stack position
Forthword_ X_STR_R1, INLINE_OPT, "x!r1"
  x_str_r1_
  ret
  
# (R: ?  n1 -- n2 n1 ) Y: n2
#     r1 r0
# fetch y register and store in r1 return stack position
Forthword_ Y_STR_R1, INLINE_OPT, "y!r1"
  y_str_r1_
  ret
  
# (R: ?  ?  n1 -- n2 ?  n1 ) A: n2
#     r2 r1 r0
# fetch A register and store in r2 return stack position
Forthword_ A_STR_R2, INLINE_OPT, "a!r2"
  a_str_r2_
  ret
  
# (R: ?  ?  n1 -- n2 ?  n1 ) B: n2
#     r2 r1 r0
# fetch B register and store in r2 return stack position
Forthword_ B_STR_R2, INLINE_OPT, "b!r2"
  b_str_r2_
  ret
  
# (R: ?  ?  n1 -- n2 ?  n1 ) X: n2
#     r2 r1 r0
# fetch X register and store in r2 return stack position
Forthword_ X_STR_R2, INLINE_OPT, "x!R2"
  x_str_r2_
  ret
  
# (R: ?  ?  n1 -- n2 ?  n1 ) Y: n2
#     r2 r1 r0
# fetch y register and store in r2 return stack position
Forthword_ Y_STR_R2, INLINE_OPT, "y!r2"
  y_str_r2_
  ret
  
# (  -- n)
# current return stack pointer address
Forthword_ RP, INLINE_OPT, "rp"
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
Forthword_ RTORPLUS, INLINE_OPT, "r0+"
	r0_
	addl $4, (%esp)
	ret


#@@@@@@@@@@@@@ Arithmatic @@@@@@@@@@@@@

# ( n1 -- n1+y )
# add n1 and y
Forthword_ PLUS_Y, INLINE_OPT, "+y"
  plus_y_
  ret

# ( n1 -- n1+x )
# add n1 and x
Forthword_ PLUS_X, INLINE_OPT, "+x"
  plus_x_
  ret

# ( n1 -- n1+a )
# add n1 and a
Forthword_ PLUS_A, INLINE_OPT, "+a"
  plus_a_
  ret

# ( n1 -- n1+b )
# add n1 and b
Forthword_ PLUS_B, INLINE_OPT, "+b"
  plus_b_
  ret

# ( n1|u1 -- n1-y|u1-y )
# subtract y from n1
Forthword_ MINUS_Y, INLINE_OPT, "-y"
  minus_y_
  ret

# ( n1|u1 -- n1-x|u1-x )
# subtract x from n1
Forthword_ MINUS_X, INLINE_OPT, "-x"
  minus_x_
  ret

# ( n1|u1 -- n1-a|u1-a )
# subtract a from n1
Forthword_ MINUS_A, INLINE_OPT, "-a"
  minus_a_
  ret

# ( n1|u1 -- n1-b|u1-b )
# subtract b from n1
Forthword_ MINUS_B, INLINE_OPT, "-b"
  minus_b_
  ret

# ( n1 -- n1 Y:Y+n1 )
# y=y+n1
Forthword_ Y_PLUS, INLINE_OPT, "y+"
  y_plus_
  ret

# ( n1 -- n1 X:X+n1 )
# x=x+n1
Forthword_ X_PLUS, INLINE_OPT, "x+"
  x_plus_
  ret

# ( n1 -- n1 A:A+n1 )
# a=a+n1
Forthword_ A_PLUS, INLINE_OPT, "a+"
  a_plus_
  ret

# ( n1 -- n1 B:B+n1 )
# b=b+n1
Forthword_ B_PLUS, INLINE_OPT, "b+"
  b_plus_
  ret

# ( u1|n1 u2|n2 -- u3|n3 )
# signed multiply 32b x 32b = 32b
Forthword_ MULU, INLINE_OPT,  "*"
  pop_y_
  imul %edx, %eax 
  ret

# ( n1 -- -n1 )
# 2-compliment of n1
Forthword_ NEG, INLINE_OPT, "neg"
  neg_
  ret

# ( Y:n1 -- Y:-n1 )
# 2-compliment of Y
Forthword_ NEG_Y, INLINE_OPT, "neg.y"
  neg_y_
  ret

# ( X:n1 -- X:-n1 )
# 2-compliment of X
Forthword_ NEG_X, INLINE_OPT, "neg.x"
  neg_x_
  ret


# ( n1 -- n1 and Y )
# bitwise and
Forthword_ AND_Y, INLINE_OPT, "and.y"
  and_y_
  ret

# ( n1 -- n1 and X )
# bitwise and
Forthword_ AND_X, INLINE_OPT, "and.x"
  and_x_
  ret

# ( n1 -- n1 and A )
# bitwise and
Forthword_ AND_A, INLINE_OPT, "and.a"
  and_a_
  ret

# ( n1 -- n1 and B )
# bitwise and
Forthword_ AND_B, INLINE_OPT, "and.b"
  and_b_
  ret

# ( n1 -- n1.or.Y )
# logical or
Forthword_ OR_Y, INLINE_OPT, "or.y"
  or_y_
  ret

# ( n1 -- n1.or.X )
# logical or
Forthword_ OR_X, INLINE_OPT, "or.x"
  or_x_
  ret

# ( n1 -- n1.or.A )
# logical or
Forthword_ OR_A, INLINE_OPT, "or.a"
  or_a_
  ret

# ( n1 -- n1.or.B )
# logical or
Forthword_ OR_B, INLINE_OPT, "or.b"
  or_b_
  ret

# ( n1 -- n1.xor.Y)
# exclusive or
Forthword_ XOR_Y, INLINE_OPT, "xor.y"
  xor_y_
  ret

# ( n1 -- n1.xor.X)
# exclusive or
Forthword_ XOR_X, INLINE_OPT, "xor.x"
  xor_x_
  ret

# ( n1 -- n1.xor.A)
# exclusive or
Forthword_ XOR_A, INLINE_OPT, "xor.a"
  xor_a_
  ret

# ( n1 -- n1.xor.B)
# exclusive or
Forthword_ XOR_B, INLINE_OPT, "xor.b"
  xor_b_
  ret

# ( n1 -- n2)
# 1-complement of WR
Forthword_ NOT, INLINE_OPT, "not"
  not_
  ret

# ( n1 -- n2)
# 1-complement of y
Forthword_ NOT_Y, INLINE_OPT, "not.y"
  not_y_
  ret

# ( n1 -- n2)
# 1-complement of x
Forthword_ NOT_X, INLINE_OPT, "not.x"
  not_x_
  ret

# ( n1 -- n2)
# 1-complement of a
Forthword_ NOT_A, INLINE_OPT, "not.a"
  not_a_
  ret

# ( n1 -- n2)
# 1-complement of b
Forthword_ NOT_B, INLINE_OPT, "not.b"
  not_b_
  ret

# ( n1 n2 -- flag)
# flag is true if n1 is not equal to n2
Forthword_ NOTEQUAL, INLINE_OPT, "<>"
  d0_str_y_
  nip_
  xor_y_
  ret

# ( n1 n2 -- flag )
# flag is true if WR and NOS are equal
Forthword_ EQUAL, 0, "="
  sub (%ebx), %eax
  nip_
  sub $1, %eax
  sbb %eax, %eax
  ret

# ( n1 n2 -- flag)
# flag is true if n1 is less than n2
Forthword_ LESS, 0, "<"
  cmp %eax, (%ebx)
  nip_
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
  nip_
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

# ( n1 -- flag)
# flag is true if WR is less than zero
forthword_ ZEROLESS, INLINE_OPT, "0<"
  zeroless_
  ret

# ( -- ) A: 0
# set A to 0
Forthword_ ZEROA, INLINE_OPT, "0!a"
	zero_a_
	ret

# ( -- ) B: 0
# set B to 0
Forthword_ ZEROB, INLINE_OPT, "0!b"
	zero_b_
	ret

# ( -- ) X: 0
# set X to 0
Forthword_ ZEROX, INLINE_OPT, "0!x"
	zero_x_
	ret

# ( -- ) Y: 0
# set Y to 0
Forthword_ ZEROY, INLINE_OPT, "0!y"
	zero_y_
	ret

# ( n -- n )
# test WR if zero, does not consume WR
Forthword_ ISZERO, INLINE_OPT, "0?"
	iszero_
	ret
  
# ( n -- n )
# test if A is zero
Forthword_ AISZERO, INLINE_OPT, "a0?"
	a_iszero_
	ret
  
# ( n -- n )
# test if B is zero
Forthword_ BISZERO, INLINE_OPT, "b0?"
	b_iszero_
	ret
  
# ( n -- n )
# test if X is zero
Forthword_ XISZERO, INLINE_OPT, "x0?"
	x_iszero_
	ret
  
# ( n -- n )
# test if Y is zero
Forthword_ YISZERO, INLINE_OPT, "y0?"
	y_iszero_
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

# ( a-addr -- a-addr A:n32 )
# read 1 cell (32 bits) from RAM address and put in A register
Forthword_ FETCH_STR_A, INLINE_OPT, "@!a"
  fetch_str_a_
  ret

# ( a-addr -- a-addr B:n32 )
# read 1 cell (32 bits) from RAM address and put in B register
Forthword_ FETCH_STR_B, INLINE_OPT, "@!b"
  fetch_str_b_
  ret

# ( a-addr -- a-addr X:n32 )
# read 1 cell (32 bits) from RAM address and put in X register
Forthword_ FETCH_STR_X, INLINE_OPT, "@!x"
  fetch_str_x_
  ret

# ( a-addr -- a-addr Y:n32 )
# read 1 cell (32 bits) from RAM address and put in Y register
Forthword_ FETCH_STR_Y, INLINE_OPT, "@!y"
  fetch_str_y_
  ret

# ( a-addr -- n16 )
# read half cell (16 bits) from RAM address
Forthword_ HFETCH, INLINE_OPT, "h@"
  hfetch_
  ret

# ( a-addr -- a-addr A:n16 )
# read 1 cell (16 bits) from RAM address and put in A register
Forthword_ HFETCH_STR_A, INLINE_OPT, "h@!a"
  hfetch_str_a_
  ret

# ( a-addr -- a-addr B:n16 )
# read 1 cell (16 bits) from RAM address and put in B register
Forthword_ HFETCH_STR_B, INLINE_OPT, "h@!b"
  hfetch_str_b_
  ret

# ( a-addr -- a-addr X:n16 )
# read 1 cell (16 bits) from RAM address and put in X register
Forthword_ HFETCH_STR_X, INLINE_OPT, "h@!x"
  hfetch_str_x_
  ret

# ( a-addr -- a-addr Y:n16 )
# read 1 cell (16 bits) from RAM address and put in Y register
Forthword_ HFETCH_STR_Y, INLINE_OPT, "h@!y"
  hfetch_str_y_
  ret

# ( a-addr -- n8 )
# read byte (8 bits) from RAM address
Forthword_ CFETCH, INLINE_OPT, "c@"
  cfetch_
  ret

# ( a-addr -- a-addr A:n8 )
# read 1 cell (8 bits) from RAM address and put in A register
Forthword_ CFETCH_STR_A, INLINE_OPT, "c@!a"
  cfetch_str_a_
  ret

# ( a-addr -- a-addr B:n8 )
# read 1 cell (8 bits) from RAM address and put in B register
Forthword_ CFETCH_STR_B, INLINE_OPT, "c@!b"
  cfetch_str_b_
  ret

# ( a-addr -- a-addr X:n8 )
# read 1 cell (8 bits) from RAM address and put in X register
Forthword_ CFETCH_STR_X, INLINE_OPT, "c@!x"
  cfetch_str_x_
  ret

# ( a-addr -- a-addr Y:n8 )
# read 1 cell (8 bits) from RAM address and put in Y register
Forthword_ CFETCH_STR_Y, INLINE_OPT, "c@!y"
  cfetch_str_y_
  ret

# ( addr Y:n -- )
# store a word from Y (32 bits) to RAM address
Forthword_ YWSTORE, INLINE_OPT, "y.!"
  yw_str_
  ret

# ( addr X:n -- )
# store a word From X (32 bits) to RAM address
Forthword_ XWSTORE, INLINE_OPT, "x.!"
  xw_str_
  ret

# ( addr A:n -- )
# store a word From A (32 bits) to RAM address
Forthword_ AWSTORE, INLINE_OPT, "a.!"
  aw_str_
  ret

# ( addr B:n -- )
# store a word From B (32 bits) to RAM address
Forthword_ BWSTORE, INLINE_OPT, "b.!"
  bw_str_
  ret

# ( a-addr -- )
# store 0 (32 bits) to RAM address
Forthword_ ZERO_STR, INLINE_OPT, "0!"
  zero_str_
  ret

# ( addr -- addr )
# add Y to content of cell RAM address a-addr
Forthword_ Y_PLUS_STR, INLINE_OPT, "y+!"
  y_plus_str_
  ret

# ( addr -- addr )
# add X to content of cell RAM address a-addr
Forthword_ X_PLUS_STR, INLINE_OPT, "x+!"
  x_plus_str_
  ret

# ( addr -- addr )
# add A to content of cell RAM address a-addr
Forthword_ A_PLUS_STR, INLINE_OPT, "a+!"
  a_plus_str_
  ret

# ( addr -- addr )
# add B to content of cell RAM address a-addr
Forthword_ B_PLUS_STR, INLINE_OPT, "b+!"
  b_plus_str_
  ret

# ( a-addr -- )
# subtract 1 from content of cell RAM address a-addr
Forthword_ ONEMINUS_STR, INLINE_OPT, "1-!"
  oneminus_str_
  ret

# ( a-addr -- a-addr )
# add 1 to content of cell RAM address a-addr
Forthword_ ONEPLUS_STR, INLINE_OPT, "1+!"
  oneplus_str_
  ret

# ( a-addr -- a-addr Y:n16 )
# store a half word (16 bits) in Y register to RAM address
Forthword_ YW_HSTORE, INLINE_OPT, "y.h!"
  yw_hstr_
  ret

# ( a-addr -- a-addr X:n16 )
# store a half word (16 bits) in X register to RAM address
Forthword_ XW_HSTORE, INLINE_OPT, "x.h!"
  xw_hstr_
  ret

# ( a-addr -- a-addr A:n16 )
# store a half word (16 bits) in A register to RAM address
Forthword_ AW_HSTORE, INLINE_OPT, "a.h!"
  aw_hstr_
  ret

# ( a-addr -- a-addr B:n16 )
# store a half word (16 bits) in B register to RAM address
Forthword_ BW_HSTORE, INLINE_OPT, "b.h!"
  bw_hstr_
  ret

# ( a-addr -- a-addr )
# add n16 in Y register to content of half cell RAM address a-addr
Forthword_ Y_PLUS_HSTR, INLINE_OPT, "y+h!"
  y_plus_hstr_
  ret

# ( a-addr -- a-addr )
# add n16 in X register to content of half cell RAM address a-addr
Forthword_ X_PLUS_HSTR, INLINE_OPT, "x+h!"
  x_plus_hstr_
  ret

# ( a-addr -- a-addr )
# add n16 in A register to content of half cell RAM address a-addr
Forthword_ A_PLUS_HSTR, INLINE_OPT, "a+h!"
  a_plus_hstr_
  ret

# ( a-addr -- a-addr )
# add n16 in B register to content of half cell RAM address a-addr
Forthword_ B_PLUS_HSTR, INLINE_OPT, "b+h!"
  b_plus_hstr_
  ret

# ( a-addr -- )
# add 1 to content of half cell RAM address a-addr
Forthword_ ONEPLUS_HSTR, INLINE_OPT, "1+h!"
  oneplus_hstr_
  ret

# ( a-addr -- )
# subtract 1 from content of half cell RAM address a-addr
Forthword_ ONEMINUS_HSTR, INLINE_OPT, "1-h!"
  oneminus_hstr_
  ret

# ( a-addr -- )
# store a single byte from Y register to RAM address
Forthword_ YW_CSTR, INLINE_OPT, "y.c!"
  yw_cstr_
  ret

# ( a-addr -- )
# store a single byte from Y register to RAM address
Forthword_ XW_CSTR, INLINE_OPT, "x.c!"
  xw_cstr_
  ret

# ( a-addr -- )
# store 0 (16 bits) to RAM address
Forthword_ ZERO_CSTR, INLINE_OPT, "0c!"
  zero_cstr_
  ret

# ( a-addr -- )
# add c byte in Y register to content of byte RAM address a-addr
Forthword_ Y_PLUS_CSTR, INLINE_OPT, "y+c!"
  y_plus_cstr_
  ret

# ( a-addr -- )
# add c byte in X register to content of byte RAM address a-addr
Forthword_ X_PLUS_CSTR, INLINE_OPT, "x+c!"
  x_plus_cstr_
  ret

# ( a-addr -- )
# subtract byte in Y register from content of byte RAM address a-addr
Forthword_ Y_MINUS_CSTR, INLINE_OPT, "y-c!"
  y_minus_cstr_
  ret

# ( a-addr -- )
# subtract byte in X register from content of byte RAM address a-addr
Forthword_ X_MINUS_CSTR, INLINE_OPT, "x-c!"
  x_minus_cstr_
  ret

# ( a-addr -- )
# add 1 to content of byte cell RAM address a-addr
Forthword_ ONEPLUS_CSTR, INLINE_OPT, "1+c!"
  oneplus_cstr_
  ret
  
# ( a-addr -- )
# subtract 1 from content of byte cell RAM address a-addr
Forthword_ ONEMINUS_CSTR, INLINE_OPT, "1-c!"
  oneminus_cstr_
  ret

# ( n -- n ) A: n
# copy WR to A register
Forthword_ STR_A, INLINE_OPT, "!a"
  str_a_
  ret

# ( n -- n ) B: n
# copy WR to B register
Forthword_ STR_B, INLINE_OPT, "!b"
  str_b_
  ret

# ( n1 -- n1 ) X: n1
#   WR
# copy WR register to X register
Forthword_ STR_X, INLINE_OPT, "!x"
  str_x_
  ret
  
# ( n1 -- n1 ) Y: n1
#   WR
# copy WR register to Y register
Forthword_ STR_Y, INLINE_OPT, "!y"
  str_y_
  ret
  

# ( -- n )
# copy A register to WR
Forthword_ A_, INLINE_OPT, "a"
  a_
  ret

# ( -- n )
# copy B register to WR
Forthword_ B_, INLINE_OPT, "b"
  b_
  ret

# ( -- n )
# copy X register to WR
Forthword_ X_, INLINE_OPT, "x"
  x_
  ret

# ( -- n )
# copy the Y register to WR
Forthword_ Y_, INLINE_OPT, "y"
  y_
  ret

# ( -- n )
# Read a word (32bit) from memory pointed to by register A
Forthword_ A_FETCH, INLINE_OPT, "a@"
  a_fetch_
  ret

# ( n -- )
# store a word to RAM address pointed to by areg
Forthword_ A_STR, INLINE_OPT, "a!"
  a_str_
  ret

# ( -- n )
# Read a half word (32bit) from memory pointed to by register A
Forthword_ A_HFETCH, INLINE_OPT, "ah@"
  a_hfetch_
  ret

# ( h -- )
# store a half word to RAM address pointed to by areg
Forthword_ A_HSTR, INLINE_OPT, "ah!"
  a_hstr_
  ret

# ( -- n )
# Read a byte from memory pointed to by register A
Forthword_ A_CFETCH, INLINE_OPT, "ac@"
  a_cfetch_
  ret

# ( c -- )
# store a single byte to RAM address pointed to by areg
Forthword_ A_CSTORE, INLINE_OPT, "ac!"
  a_cstr_
  ret

# ( -- )
# update register A with post increment 4+ from last memory operation
Forthword_ A_PLUS4, INLINE_OPT, "a+4"
  a_plus4_
  ret

# ( -- )
# update register A with post increment 2+ from last memory operation
Forthword_ A_PLUS2, INLINE_OPT, "a+2"
  a_plus2_
  ret


# ( -- )
# update register A with post increment 1+ from last memory operation
Forthword_ A_PLUS1, INLINE_OPT, "a+1"
  a_plus1_
  ret

# ( -- )
# update register A with decrement 4
Forthword_ A_MINUS4, INLINE_OPT, "a-4"
  a_minus4_
  ret

# ( -- )
# update register A with decrement 2
Forthword_ A_MINUS2, INLINE_OPT, "a-2"
  a_minus2_
  ret

# ( -- )
# update register A with decrement 1
Forthword_ A_MINUS1, INLINE_OPT, "a-1"
  a_minus1_
  ret

# ( -- n )
# Read a word (32bit) from memory pointed to by register B
Forthword_ B_FETCH, INLINE_OPT, "b@"
  b_fetch_
  ret

# ( n -- )
# store a word to RAM address pointed to by b register
Forthword_ B_STR, INLINE_OPT, "b!"
  b_str_
  ret

# ( -- n )
# Read a half word (32bit) from memory pointed to by register B
Forthword_ B_HFETCH, INLINE_OPT, "bh@"
  b_hfetch_
  ret

# ( h -- )
# store a half word to RAM address pointed to by b reg
Forthword_ B_HSTR, INLINE_OPT, "bh!"
  b_hstr_
  ret

# ( -- n )
# Read a byte from memory pointed to by register B
Forthword_ B_CFETCH, INLINE_OPT, "bc@"
  b_cfetch_
  ret

# ( c -- )
# store a single byte to RAM address pointed to by B reg
Forthword_ B_CSTORE, INLINE_OPT, "bc!"
  b_cstr_
  ret

# ( -- )
# update register B with post increment 4+ from last memory operation
Forthword_ B_PLUS4, INLINE_OPT, "b+4"
  b_plus4_
  ret

# ( -- )
# update register B with post increment 2+ from last memory operation
Forthword_ B_PLUS2, INLINE_OPT, "b+2"
  b_plus2_
  ret

# ( -- )
# update register B with post increment 1+ from last memory operation
Forthword_ B_PLUS1, INLINE_OPT, "b+1"
  b_plus1_
  ret

# ( -- )
# update register B with decrement 4
Forthword_ B_MINUS4, INLINE_OPT, "b-4"
  b_minus4_
  ret

# ( -- )
# update register B with decrement 2
Forthword_ B_MINUS2, INLINE_OPT, "b-2"
  b_minus2_
  ret

# ( -- )
# update register B with decrement 1
Forthword_ B_MINUS1, INLINE_OPT, "b-1"
  b_minus1_
  ret

# ( -- n )
# Read a word (32bit) from memory pointed to by register X
Forthword_ X_FETCH, INLINE_OPT, "x@"
  x_fetch_
  ret

# ( n -- )
# store a word to RAM address pointed to by x register
Forthword_ X_STR, INLINE_OPT, "x!"
  x_str_
  ret

# ( -- n )
# Read a half word (32bit) from memory pointed to by register X
Forthword_ X_HFETCH, INLINE_OPT, "xh@"
  x_hfetch_
  ret

# ( h -- )
# store a half word to RAM address pointed to by x reg
Forthword_ X_HSTR, INLINE_OPT, "xh!"
  x_hstr_
  ret

# ( -- n )
# Read a byte from memory pointed to by register X
Forthword_ X_CFETCH, INLINE_OPT, "xc@"
  x_cfetch_
  ret

# ( c -- )
# store a single byte to RAM address pointed to by X reg
Forthword_ X_CSTORE, INLINE_OPT, "xc!"
  x_cstr_
  ret

# ( -- )
# update register X with post increment 4+ from last memory operation
Forthword_ X_PLUS4, INLINE_OPT, "x+4"
  x_plus4_
  ret

# ( -- )
# update register X with post increment 2+ from last memory operation
Forthword_ X_PLUS2, INLINE_OPT, "x+2"
  x_plus2_
  ret


# ( -- )
# update register X with post increment 1+ from last memory operation
Forthword_ X_PLUS1, INLINE_OPT, "x+1"
  x_plus1_
  ret

# ( -- )
# update register X with decrement 4
Forthword_ X_MINUS4, INLINE_OPT, "x-4"
  x_minus4_
  ret

# ( -- )
# update register X with decrement 2
Forthword_ X_MINUS2, INLINE_OPT, "x-2"
  x_minus2_
  ret

# ( -- )
# update register X with decrement 1
Forthword_ X_MINUS1, INLINE_OPT, "x-1"
  x_minus1_
  ret

# ( -- n )
# Read a word (32bit) from memory pointed to by register Y
Forthword_ Y_FETCH, INLINE_OPT, "y@"
  y_fetch_
  ret

# ( n -- )
# store a word to RAM address pointed to by Y register
Forthword_ Y_STR, INLINE_OPT, "y!"
  y_str_
  ret

# ( -- n )
# Read a half word (32bit) from memory pointed to by register Y
Forthword_ Y_HFETCH, INLINE_OPT, "yh@"
  y_hfetch_
  ret

# ( h -- )
# store a half word to RAM address pointed to by Y reg
Forthword_ Y_HSTR, INLINE_OPT, "yh!"
  y_hstr_
  ret

# ( -- n )
# Read a byte from memory pointed to by register Y
Forthword_ Y_CFETCH, INLINE_OPT, "yc@"
  y_cfetch_
  ret

# ( c -- )
# store a single byte to RAM address pointed to by Y reg
Forthword_ Y_CSTORE, INLINE_OPT, "yc!"
  y_cstr_
  ret
  
# ( -- )
# update register Y with post increment 4+ from last memory operation
Forthword_ Y_PLUS4, INLINE_OPT, "y+4"
  y_plus4_
  ret

# ( -- )
# update register Y with post increment 2+ from last memory operation
Forthword_ Y_PLUS2, INLINE_OPT, "y+2"
  y_plus2_
  ret


# ( -- )
# update register Y with post increment 1+ from last memory operation
Forthword_ Y_PLUS1, INLINE_OPT, "y+1"
  y_plus1_
  ret

# ( -- )
# update register Y with decrement 4
Forthword_ Y_MINUS4, INLINE_OPT, "y-4"
  y_minus4_
  ret

# ( -- )
# update register Y with decrement 2
Forthword_ Y_MINUS2, INLINE_OPT, "y-2"
  y_minus2_
  ret

# ( -- )
# update register Y with decrement 1
Forthword_ Y_MINUS1, INLINE_OPT, "y-1"
  y_minus1_
  ret

# (start dest count -- )
# count is the number of bytes to copy
# copy ram using bytes.  Assumes no overlap.
Forthword_ MCPY, 0, "mcpy"
	iszero_         # ( start dest count )
	je MCPY_END

  rpush_a_
  rpush_b_
	d0_str_b_          # ( start dest count ) B: dest
	mov %eax, %ecx
	d1_str_a_          # (  start dest count ) A: start
	cld
	rep movsb
  rpop_b_
  rpop_a_
MCPY_END:
  nip2_
  ret
