# core.S

# ( xt -- )
# execute XT
Forthword_ EXEC, 0, "exec"
  rpush_
  pop_
  ret

# ( xt -- )
# Don't do anything, just chew up a few cycles
Forthword_ NOOP, INLINE_OPT, "noop"
  nop
  ret

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
Forthword_ DPUSHA, INLINE_OPT, "pusha"
  pusha_
  ret  
  
# ( n1 n2 -- n1 b  n2 )
#   d0 WR    d1 d0 WR
# push register B onto top of data stack
Forthword_ DPUSHB, INLINE_OPT, "pushb"
  pushb_
  ret  
  
# ( n1 n2 -- n1 x  n2 )
#   d0 WR    d1 d0 WR
# push register X onto top of data stack
Forthword_ DPUSHX, INLINE_OPT, "pushx"
  pushx_
  ret  
  
# ( n1 n2 -- n1 y  n2 )
#   d0 WR    d1 d0 WR
# push register Y onto top of data stack
Forthword_ DPUSHY, INLINE_OPT, "pushy"
  pushy_
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
  
# ( x1 x2 -- x1 x2 x1 )
#   do WR
# push WR on data stack and place D1 in WR
Forthword_ OVER, INLINE_OPT, "over"
  over_
  ret

# ( x1 x2 -- x1 x2 x1 x2)
# Place a copy of x1 and x2 on top of the stack
Forthword_ TWOOVER, 0, "2over"
  top2_
  str_d1_
  d2_
  str_d0_
  d1_
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
Forthword_ DPOPA, INLINE_OPT, "popa"
  popa_
  ret

# ( n1 n2 n3 -- n1 n3 ) B: n2
#   d1 d0 WR    d0 WR
# pop top of data stack into register B
Forthword_ DPOPB, INLINE_OPT, "popb"
  popb_
  ret

# ( n1 n2 n3 -- n1 n3 ) X: n2
#   d1 d0 WR    d0 WR
# pop top of data stack into register X
Forthword_ DPOPX, INLINE_OPT, "popx"
  popx_
  ret

# ( n1 n2 n3 -- n1 n3 ) Y: n2
#   d1 d0 WR    d0 WR
# pop top of data stack into register Y
Forthword_ DPOPY, INLINE_OPT, "popy"
  popy_
  ret

# ( n n -- )
# drop WR twice
Forthword_ DPOP2, INLINE_OPT, "pop2"
  pop2_
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
# pop top of return stack into WR
Forthword_ RPOP, INLINE_OPT, "rpop"
	rpop_
	ret

# ( -- ) (R: n2 --) A: n2
# pop top of return stack into A
Forthword_ RPOPA, INLINE_OPT, "rpopa"
	rpopa_
	ret

# ( -- ) (R: n2 --) B: n2
# pop top of return stack into B
Forthword_ RPOPB, INLINE_OPT, "rpopb"
	rpopb_
	ret

# ( -- ) (R: n2 --) X: n2
# pop top of return stack into X
Forthword_ RPOPX, INLINE_OPT, "rpopx"
	rpopx_
	ret

# ( -- ) (R: n2 --) Y: n2
# pop top of return stack into Y
Forthword_ RPOPY, INLINE_OPT, "rpopy"
	rpopy_
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

# ( -- ) (R: -- ? )
# add 1 cell to return stack
Forthword_ RTOP1, INLINE_OPT, "rtop1"
	rtop1_
	ret

# ( -- ) (R: -- ? ? )
# add 2 cells to return stack
Forthword_ RTOP2, INLINE_OPT, "rtop2"
	rtop2_
	ret

# ( -- ) (R: -- ? ? ? )
# add 3 cells to return stack
Forthword_ RTOP3, INLINE_OPT, "rtop3"
	rtop3_
	ret

# ( n -- ) (R: -- n)
# push WR on top of return stack
Forthword_ RPUSH, INLINE_OPT, "rpush"
	rpush_
	ret

# ( -- ) (R: -- a)
# push A on top of return stack
Forthword_ RPUSHA, INLINE_OPT, "rpusha"
	rpusha_
	ret

# ( -- ) (R: -- b)
# push B on top of return stack
Forthword_ RPUSHB, INLINE_OPT, "rpushb"
	rpushb_
	ret

# ( -- ) (R: -- x)
# push X on top of return stack
Forthword_ RPUSHX, INLINE_OPT, "rpushx"
	rpushx_
	ret

# ( -- ) (R: -- y)
# push Y on top of return stack
Forthword_ RPUSHY, INLINE_OPT, "rpushy"
	rpushy_
	ret

# ( -- ) (R: -- sp)
# push datastack pointer on top of return stack
Forthword_ RPUSHSP, INLINE_OPT, "rpushsp"
	rpushsp_
	ret

# ( n2 n1 -- n2 n1 ) (R: -- n2 )
#   d0 WR
# push D0 on top of return stack
Forthword_ RPUSHD0, INLINE_OPT, "rpushd0"
	rpushd0_
	ret

# ( n3 n2 n1 -- n3 n2 n1 ) (R: -- n3 )
#   d1 d0 WR
# push D1 on top of return stack
Forthword_ RPUSHD1, INLINE_OPT, "rpushd1"
	rpushd1_
	ret

# ( n4 n3 n2 n1 -- n4 n3 n2 n1 ) (R: -- n4 )
#   d2 d1 d0 WR
# push D2 on top of return stack
Forthword_ RPUSHD2, INLINE_OPT, "rpushd2"
	rpushd2_
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
Forthword_ RTORPLUS, INLINE_OPT, "r>r+"
	r0_
	addl $4, (%esp)
	ret


#@@@@@@@@@@@@@ Arithmatic @@@@@@@@@@@@@

# ( n1 -- n1+y )
# add n1 and y
Forthword_ ADDY, INLINE_OPT, "+y"
  addy_
  ret

# ( n1 -- n1+x )
# add n1 and x
Forthword_ ADDX, INLINE_OPT, "+x"
  addx_
  ret

# ( n1 -- n1+a )
# add n1 and a
Forthword_ ADDA, INLINE_OPT, "+a"
  adda_
  ret

# ( n1 -- n1+b )
# add n1 and b
Forthword_ ADDB, INLINE_OPT, "+b"
  addb_
  ret

# ( n1|u1 -- n1-y|u1-y )
# subtract y from n1
Forthword_ MINUSY, INLINE_OPT, "-y"
  minusy_
  ret

# ( n1|u1 -- n1-x|u1-x )
# subtract x from n1
Forthword_ MINUSX, INLINE_OPT, "-x"
  minusx_
  ret

# ( n1|u1 -- n1-a|u1-a )
# subtract a from n1
Forthword_ MINUSA, INLINE_OPT, "-a"
  minusa_
  ret

# ( n1|u1 -- n1-b|u1-b )
# subtract b from n1
Forthword_ MINUSB, INLINE_OPT, "-b"
  minusb_
  ret

# ( u1|n1 u2|n2 -- u3|n3 )
# signed multiply 32b x 32b = 32b
Forthword_ MULU, INLINE_OPT,  "*"
  popy_
  imul %edx, %eax 
  ret

# ( n1 -- -n1 )
# 2-compliment of n1
Forthword_ NEGATE, INLINE_OPT, "neg"
  neg_
  ret

# ( Y:n1 -- Y:-n1 )
# 2-compliment of Y
Forthword_ NEGATEY, INLINE_OPT, "neg.y"
  negy_
  ret

# ( X:n1 -- X:-n1 )
# 2-compliment of X
Forthword_ NEGATEX, INLINE_OPT, "neg.x"
  negx_
  ret


# ( n1 -- n1andy )
# bitwise and
Forthword_ ANDY_, INLINE_OPT, "and.y"
  andy_
  ret

# ( n1 -- n1andx )
# bitwise and
Forthword_ ANDX_, INLINE_OPT, "and.x"
  andx_
  ret

# ( n1 -- n1anda )
# bitwise and
Forthword_ ANDA_, INLINE_OPT, "and.a"
  anda_
  ret

# ( n1 -- n1andb )
# bitwise and
Forthword_ ANDB_, INLINE_OPT, "and.b"
  andb_
  ret

# ( n1 -- n1.or.y )
# logical or
Forthword_ ORY, INLINE_OPT, "or.y"
  ory_
  ret

# ( n1 -- n1.or.x )
# logical or
Forthword_ ORX, INLINE_OPT, "or.x"
  orx_
  ret

# ( n1 -- n1.or.a )
# logical or
Forthword_ ORA, INLINE_OPT, "or.a"
  ora_
  ret

# ( n1 -- n1.or.b )
# logical or
Forthword_ ORB, INLINE_OPT, "or.b"
  orb_
  ret

# ( n1 -- n1.xor.y)
# exclusive or
Forthword_ XORY, INLINE_OPT, "xor.y"
  xory_
  ret

# ( n1 -- n1.xor.x)
# exclusive or
Forthword_ XORX, INLINE_OPT, "xor.x"
  xorx_
  ret

# ( n1 -- n1.xor.a)
# exclusive or
Forthword_ XORA, INLINE_OPT, "xor.a"
  xora_
  ret

# ( n1 -- n1.xor.b)
# exclusive or
Forthword_ XORB, INLINE_OPT, "xor.b"
  xorb_
  ret

# ( n1 -- n2)
# 1-complement of WR
Forthword_ NOT, INLINE_OPT, "not"
  not_
  ret

# ( n1 -- n2)
# 1-complement of y
Forthword_ NOTY, INLINE_OPT, "not.y"
  noty_
  ret

# ( n1 -- n2)
# 1-complement of x
Forthword_ NOTX, INLINE_OPT, "not.x"
  notx_
  ret

# ( n1 -- n2)
# 1-complement of a
Forthword_ NOTA, INLINE_OPT, "not.a"
  nota_
  ret

# ( n1 -- n2)
# 1-complement of b
Forthword_ NOTB, INLINE_OPT, "not.b"
  notb_
  ret

# ( n1 n2 -- flag)
# flag is true if n1 is not equal to n2
Forthword_ NOTEQUAL, INLINE_OPT, "<>"
  d0_str_y_
  nip_
  xory_
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

# ( u1 u2 -- flag )
# flag is true if u1 > u2 (unsigned)
Forthword_ UGREATER, 0, "u>"
  popy_
  sub %edx, %eax
  sbb %eax, %eax
  ret

# ( u1 u2 -- flag)
# flag is true if u1 < u2 (unsigned)
Forthword_ ULESS, 0, "u<"
  popy_
  sub %eax, %edx
# WR = a-b  -- carry set if a is less than b
  sbb %edx, %edx
  mov %edx, %eax
  ret

# ( n1 -- flag)
# flag is true if WR is less than zero
forthword_ ZEROLESS, INLINE_OPT, "0<"
  zeroless_
  ret

# ( -- 0 )
# set WR to 0
Forthword_ ZERO, INLINE_OPT, "0"
	zero_
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
  
# ( -- -1 )
# leaves the value -1 (true) in WR
Forthword_ TRUE, INLINE_OPT, "true"
  true_
  ret

# ( -- 1 )
# place a value 1 in WR
Forthword_ ONE, INLINE_OPT, "1"
  one_
  ret

# ( -- 2 )
# place a value 2 in WR
Forthword_ TWO, INLINE_OPT, "2"
  two_
  ret

# ( -- 4 )
# place a value 4 in WR
Forthword_ FOUR, INLINE_OPT, "4"
  four_
  ret

# ( -- 10 )
# place a value 10 in WR
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
Forthword_ APLUS4, INLINE_OPT, "a+4"
  aplus4_
  ret

# ( -- )
# update register A with post increment 2+ from last memory operation
Forthword_ APLUS2, INLINE_OPT, "a+2"
  aplus2_
  ret


# ( -- )
# update register A with post increment 1+ from last memory operation
Forthword_ APLUS1, INLINE_OPT, "a+1"
  aplus1_
  ret

# ( -- )
# update register A with decrement 4
Forthword_ AMINUS4, INLINE_OPT, "a-4"
  aminus4_
  ret

# ( -- )
# update register A with decrement 2
Forthword_ AMINUS2, INLINE_OPT, "a-2"
  aminus2_
  ret

# ( -- )
# update register A with decrement 1
Forthword_ AMINUS1, INLINE_OPT, "a-1"
  aminus1_
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
Forthword_ BPLUS4, INLINE_OPT, "b+4"
  bplus4_
  ret

# ( -- )
# update register B with post increment 2+ from last memory operation
Forthword_ BPLUS2, INLINE_OPT, "b+2"
  bplus2_
  ret

# ( -- )
# update register B with post increment 1+ from last memory operation
Forthword_ BPLUS1, INLINE_OPT, "b+1"
  bplus1_
  ret

# ( -- )
# update register B with decrement 4
Forthword_ BMINUS4, INLINE_OPT, "b-4"
  bminus4_
  ret

# ( -- )
# update register B with decrement 2
Forthword_ BMINUS2, INLINE_OPT, "b-2"
  bminus2_
  ret

# ( -- )
# update register B with decrement 1
Forthword_ BMINUS1, INLINE_OPT, "b-1"
  bminus1_
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
Forthword_ XPLUS4, INLINE_OPT, "x+4"
  xplus4_
  ret

# ( -- )
# update register X with post increment 2+ from last memory operation
Forthword_ XPLUS2, INLINE_OPT, "x+2"
  xplus2_
  ret


# ( -- )
# update register X with post increment 1+ from last memory operation
Forthword_ XPLUS1, INLINE_OPT, "x+1"
  xplus1_
  ret

# ( -- )
# update register X with decrement 4
Forthword_ XMINUS4, INLINE_OPT, "x-4"
  xminus4_
  ret

# ( -- )
# update register X with decrement 2
Forthword_ XMINUS2, INLINE_OPT, "x-2"
  xminus2_
  ret

# ( -- )
# update register X with decrement 1
Forthword_ XMINUS1, INLINE_OPT, "x-1"
  xminus1_
  ret

# ( -- )
# update register Y with post increment 4+ from last memory operation
Forthword_ YPLUS4, INLINE_OPT, "y+4"
  yplus4_
  ret

# ( -- )
# update register Y with post increment 2+ from last memory operation
Forthword_ YPLUS2, INLINE_OPT, "y+2"
  yplus2_
  ret


# ( -- )
# update register Y with post increment 1+ from last memory operation
Forthword_ YPLUS1, INLINE_OPT, "y+1"
  yplus1_
  ret

# ( -- )
# update register Y with decrement 4
Forthword_ YMINUS4, INLINE_OPT, "y-4"
  yminus4_
  ret

# ( -- )
# update register Y with decrement 2
Forthword_ YMINUS2, INLINE_OPT, "y-2"
  yminus2_
  ret

# ( -- )
# update register Y with decrement 1
Forthword_ YMINUS1, INLINE_OPT, "y-1"
  yminus1_
  ret

# (start dest count -- )
# count is the number of bytes to copy
# copy ram using bytes.  Assumes no overlap.
Forthword_ MCPY, 0, "mcpy"
	iszero_         # ( start dest count )
	je MCPY_END

  rpusha_
  rpushb_
	d0_str_b_          # ( start dest count ) B: dest
	mov %eax, %ecx
	d1_str_a_          # (  start dest count ) A: start
	cld
	rep movsb
  rpopb_
  rpopa_
MCPY_END:
  nip2_
  ret
