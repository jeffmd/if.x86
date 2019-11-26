# core-inline.S

#@@@@@@@@@@@@@ Parameter Stack  Manipulation @@@@@@@@@@@@@@

# ( n -- n n )
# push WR onto top of data stack
Forthword_ DPUSH, INLINE_OPT, "push"
  push_
  end_  
  
# ( n -- ? n  )
# restore top of data stack once
Forthword_ PUT1, INLINE_OPT, "put1"
  put1_
  end_  
  
# ( n -- ? ? n )
# restore top of data stack twice
Forthword_ PUT2, INLINE_OPT, "put2"
  put2_
  end_  
  
# ( n -- ? ? ? n)
# restore top of data stack three times
Forthword_ PUT3, INLINE_OPT, "put3"
  put2_
  end_  
  
# ( n1 n2 -- n1 a  n2 )
#   d0 WR    d1 d0 WR
# push register A onto top of data stack
Forthword_ DPUSHA, INLINE_OPT, "pusha"
  pusha_
  end_  
  
# ( n1 n2 -- n1 b  n2 )
#   d0 WR    d1 d0 WR
# push register B onto top of data stack
Forthword_ DPUSHB, INLINE_OPT, "pushb"
  pushb_
  end_  
  
# ( n1 n2 -- n1 x  n2 )
#   d0 WR    d1 d0 WR
# push register X onto top of data stack
Forthword_ DPUSHX, INLINE_OPT, "pushx"
  pushx_
  end_  
  
# ( n1 n2 -- n1 y  n2 )
#   d0 WR    d1 d0 WR
# push register Y onto top of data stack
Forthword_ DPUSHY, INLINE_OPT, "pushy"
  pushy_
  end_  
  
# ( n2 n1 -- n2 n2 )
#   d0 WR
# w=d0
Forthword_ D0, INLINE_OPT, "d0"
  d0_
  end_
  
# ( n3 n2 n1 -- n3 n2 n3 )
#   d1 d0 WR
# w=d1
Forthword_ D1, INLINE_OPT, "d1"
  d1_
  end_
  
# ( n4 n3 n2 n1 -- n4 n3 n2 n4 )
#   d2 d1 d0 WR
# w=d2
Forthword_ D2, INLINE_OPT, "d2"
  d2_
  end_

# ( n2 n1 -- n1 n1 )
#   d0 WR
# d0=w
Forthword_ D0_W, INLINE_OPT, "d0=w"
  d0_w_
  end_
    
# ( n3 n2 n1 -- n1 n2 n1 )
#   d1 d0 WR
# d1=w
Forthword_ D1_W, INLINE_OPT, "d1=w"
  d1_w_
  end_
    
# ( n4 n3 n2 n1 -- n1 n3 n2 n1 )
#   d2 d1 d0 WR
# d2=w
Forthword_ D2_W, INLINE_OPT, "d2=w"
  d2_w_
  end_
    
# ( n2 n1 -- n2 n1 ) A: n2
#   d0 WR
# a=d0
Forthword_ A_D0, INLINE_OPT, "a=d0"
  a_d0_
  end_
  
# ( n2 n1 -- n2 n1 ) B: n2
#   d0 WR
# b=d0
Forthword_ B_D0, INLINE_OPT, "b=d0"
  b_d0_
  end_
  
# ( n2 n1 -- n2 n1 ) X: n2
#   d0 WR
# x=d0
Forthword_ X_D0, INLINE_OPT, "x=d0"
  x_d0_
  end_
  
# ( n2 n1 -- n2 n1 ) Y: n2
#   d0 WR
# y=d0
Forthword_ Y_D0, INLINE_OPT, "y=d0"
  y_d0_
  end_
   
# ( n3 n2 n1 -- n3 n2 n1 ) A: n3
#   d1 d0 WR
# a=d1
Forthword_ A_D1, INLINE_OPT, "a=d1"
  a_d1_
  end_
  
# ( n3 n2 n1 -- n3 n2 n1 ) B: n3
#   d1 d0 WR
# b=d1
Forthword_ B_D1, INLINE_OPT, "b=d1"
  b_d1_
  end_
  
# ( n3 n2 n1 -- n3 n2 n1 ) X: n3
#   d1 d0 WR
# x=d1
Forthword_ X_D1, INLINE_OPT, "x=d1"
  x_d1_
  end_
  
# ( n3 n2 n1 -- n3 n2 n1 ) Y: n3
#   d1 d0 WR
# y=d1
Forthword_ Y_D1, INLINE_OPT, "y=d1"
  y_d1_
  end_
  
# ( n4 n3 n2 n1 -- n4 n3 n2 n1 ) A: n4
#   d2 d1 d0 WR
# a=d2
Forthword_ A_D2, INLINE_OPT, "a=d2"
  a_d2_
  end_
  
# ( n4 n3 n2 n1 -- n4 n3 n2 n1 ) B: n4
#   d2 d1 d0 WR
# b=d2
Forthword_ B_D2, INLINE_OPT, "b=d2"
  b_d2_
  end_

# ( n4 n3 n2 n1 -- n4 n3 n2 n1 ) X: n4
#   d2 d1 d0 WR
# x=d2
Forthword_ X_D2, INLINE_OPT, "x=d2"
  x_d2_
  end_
  
# ( n4 n3 n2 n1 -- n4 n3 n2 n1 ) Y: n4
#   d2 d1 d0 WR
# y=d2
Forthword_ Y_D2, INLINE_OPT, "y=d2"
  y_d2_
  end_
  
# ( ?  n2 -- n1 n2 ) A: n1
#   d0 WR
# d0=a
Forthword_ D0_A, INLINE_OPT, "d0=a"
  d0_a_
  end_
  
# ( ?  n2 -- n1 n2 ) B: n1
#   d0 WR
# d0=b
Forthword_ D0_B, INLINE_OPT, "d0=b"
  d0_b_
  end_
  
# ( ?  n2 -- n1 n2 ) X: n1
#   d0 WR
# d0=x
Forthword_ D0_X, INLINE_OPT, "d0=x"
  d0_x_
  end_
  
# ( ?  n2 -- n1 n2 ) Y: n1
#   d0 WR
# d0=y
Forthword_ D0_Y, INLINE_OPT, "d0=y"
  d0_y_
  end_
  
# ( ?  ?  n1 -- n2 ? n1 ) A: n2
#   d1 d0 WR
# d1=a
Forthword_ D1_A, INLINE_OPT, "d1=a"
  d1_a_
  end_
  
# ( ?  ?  n1 -- n2 ?  n1 ) B: n2
#   d1 d0 WR
# d1=b
Forthword_ D1_B, INLINE_OPT, "d1=b"
  d1_b_
  end_
  
# ( ?  ?  n1 -- n2 ?  n1 ) X: n2
#   d1 d0 WR
# d1=x
Forthword_ D1_X, INLINE_OPT, "d1=x"
  d1_x_
  end_
  
# ( ?  ?  n1 -- n2 ?  n1 ) Y: n2
#   d1 d0 WR
# d1=y
Forthword_ D1_Y, INLINE_OPT, "d1=y"
  d1_y_
  end_
  
# ( ?  ?  ?  n1 -- n2 ?  ? n1 ) A: n2
#   d2 d1 d0 WR
# d2=a
Forthword_ D2_A, INLINE_OPT, "d2=a"
  d2_a_
  end_
  
# ( ?  ?  ?  n1 -- n2 ?  ? n1 ) B: n2
#   d2 d1 d0 WR
# d2=b
Forthword_ D2_B, INLINE_OPT, "d2=b"
  d2_b_
  end_
  
# ( ?  ?  ?  n1 -- n2 ?  ? n1 ) X: n2
#   d2 d1 d0 WR
# d2=x
Forthword_ D2_X, INLINE_OPT, "d2=x"
  d2_x_
  end_
  
# ( ?  ?  ?  n1 -- n2 ?  ? n1 ) Y: n2
#   d2 d1 d0 WR    d2 d1 d0 WR
# d2=y
Forthword_ D2_Y, INLINE_OPT, "d2=y"
  d2_y_
  end_
  
# ( n1 n2 n3 -- n1 n3)
#   d1 d0 WR    d0 WR
Forthword_ DNIP, INLINE_OPT, "nip"
  nip_ 
  end_
  
# ( n1 n2 n3 -- n3 )
# drop top 2 items from datastack.
Forthword_ DNIP2, INLINE_OPT, "nip2"
  nip2_ 
  end_
  
# ( n1 n2 n3 n4 -- n4 )
# drop top 2 items from datastack.
Forthword_ DNIP3, INLINE_OPT, "nip3"
  nip3_
  end_
  
# ( n1 n2 -- n1)
#   d0 WR    WR
# pop top of data stack into WR
Forthword_ DPOP, INLINE_OPT, "pop"
  pop_
  end_

# ( n1 n2 n3 -- n1 n3 ) A: n2
#   d1 d0 WR    d0 WR
# pop top of data stack into register A
Forthword_ DPOPA, INLINE_OPT, "popa"
  popa_
  end_

# ( n1 n2 n3 -- n1 n3 ) B: n2
#   d1 d0 WR    d0 WR
# pop top of data stack into register B
Forthword_ DPOPB, INLINE_OPT, "popb"
  popb_
  end_

# ( n1 n2 n3 -- n1 n3 ) X: n2
#   d1 d0 WR    d0 WR
# pop top of data stack into register X
Forthword_ DPOPX, INLINE_OPT, "popx"
  popx_
  end_

# ( n1 n2 n3 -- n1 n3 ) Y: n2
#   d1 d0 WR    d0 WR
# pop top of data stack into register Y
Forthword_ DPOPY, INLINE_OPT, "popy"
  popy_
  end_

# (  -- addr )
# current data stack pointer
Forthword_ DSP, INLINE_OPT, "dsp"
  dsp_
  end_
  
# ( addr -- i*x)
# set data stack pointer to addr
Forthword_ DSP_W, INLINE_OPT, "dsp=w"
  dsp_w_
  end_

#@@@@@@@@@@@@@ Return Stack @@@@@@@@@@@@@

# ( n1 -- n2 ) (R: n2 --)
# pop top of return stack into WR
Forthword_ RPOP, INLINE_OPT, "rpop"
  rpop_
  end_

# ( -- ) (R: n2 --) A: n2
# pop top of return stack into A
Forthword_ RPOPA, INLINE_OPT, "rpopa"
  rpopa_
  end_

# ( -- ) (R: n2 --) B: n2
# pop top of return stack into B
Forthword_ RPOPB, INLINE_OPT, "rpopb"
  rpopb_
  end_

# ( -- ) (R: n2 --) X: n2
# pop top of return stack into X
Forthword_ RPOPX, INLINE_OPT, "rpopx"
  rpopx_
  end_

# ( -- ) (R: n2 --) Y: n2
# pop top of return stack into Y
Forthword_ RPOPY, INLINE_OPT, "rpopy"
  rpopy_
  end_

# ( -- ) (R: n -- )
# Drop TOR
Forthword_ RNIP, INLINE_OPT, "rnip"
  rnip_
  end_

# ( -- ) (R: n2 n1 -- )
# remove 2 top cells of return stack
Forthword_ RNIP2, INLINE_OPT, "rnip2"
  rnip2_
  end_

# ( -- ) (R: n3 n2 n1 -- )
# remove 3 top cells of return stack
Forthword_ RNIP3, INLINE_OPT, "rnip3"
  rnip3_
  end_

# ( n -- ) (R: -- n)
# push WR on top of return stack
Forthword_ RPUSH, INLINE_OPT, "rpush"
  rpush_
  end_

# ( -- ) (R: -- a)
# push A on top of return stack
Forthword_ RPUSHA, INLINE_OPT, "rpusha"
  rpusha_
  end_

# ( -- ) (R: -- b)
# push B on top of return stack
Forthword_ RPUSHB, INLINE_OPT, "rpushb"
  rpushb_
  end_

# ( -- ) (R: -- x)
# push X on top of return stack
Forthword_ RPUSHX, INLINE_OPT, "rpushx"
  rpushx_
  end_

# ( -- ) (R: -- y)
# push Y on top of return stack
Forthword_ RPUSHY, INLINE_OPT, "rpushy"
  rpushy_
  end_

# ( -- ) (R: -- sp)
# push datastack pointer on top of return stack
Forthword_ RPUSHDP, INLINE_OPT, "rpushdsp"
  rpushdsp_
  end_

# ( -- n) (R: n -- n )
# r0
Forthword_ R0, INLINE_OPT, "r0"
  r0_
  end_

# ( -- n1 ) (R: n1 n2 -- n1 n2 )
# r1
Forthword_ R1, INLINE_OPT, "r1"
  r1_
  end_

# ( -- n1 ) (R: n1 n2 n3 -- n1 n2 n3 )
# put a copy of R2 in WR
Forthword_ R2, INLINE_OPT, "r2"
  r2_
  end_

# ( n1 -- n1) (R: n2 -- n1 )
#   WR            R0
# r0=w
Forthword_ R0_W, INLINE_OPT, "r0=w"
  r0_w_
  end_

# ( n1 -- n1) (R: n3 n2 -- n1 n2 )
#   WR            R1 R0
# r1=w
Forthword_ R1_W, INLINE_OPT, "r1=w"
  r1_w_
  end_

# ( n1 -- n1) (R: n4 n3 n2 -- n1 n3 n2 )
#   WR            R2 R1 R0
# r2=w
Forthword_ R2_W, INLINE_OPT, "r2=w"
  r2_w_
  end_

# ( -- ) (R: n1 -- n1 ) A: n1
#            R0
# a=r0
Forthword_ A_R0, INLINE_OPT, "a=r0"
  a_r0_
  end_

# ( -- ) (R: n1 -- n1 ) B: n1
#            R0
# b=r0
Forthword_ B_R0, INLINE_OPT, "b=r0"
  b_r0_
  end_

# ( -- ) (R: n1 -- n1 ) X: n1
#            R0
# put a copy of R0 into X register
Forthword_ X_R0, INLINE_OPT, "x=r0"
  x_r0_
  end_

# ( -- ) (R: n1 -- n1 ) Y: n1
#            R0
# put a copy of R0 into Y register
Forthword_ Y_R0, INLINE_OPT, "y=r0"
  y_r0_
  end_

# ( -- ) (R: n2 n1 -- n2 n1 ) A: n2
#            R1 R0
# a=r1
Forthword_ A_R1, INLINE_OPT, "a=r1"
  a_r1_
  end_

# ( -- ) (R: n2 n1 -- n2 n1 ) B: n2
#            R1 R0
# b=r1
Forthword_ B_R1, INLINE_OPT, "b=r1"
  b_r1_
  end_

# ( -- ) (R: n2 n1 -- n2 n1 ) X: n2
#            R1 R0
# x=r1
Forthword_ X_R1, INLINE_OPT, "x=r1"
  x_r1_
  end_

# ( -- ) (R: n2 n1 -- n2 n1 ) Y: n2
#            R1 R0
# y=r1
Forthword_ Y_R1, INLINE_OPT, "y=r1"
  y_r1_
  end_

# ( -- ) (R: n3 n2 n1 -- n3 n2 n1 ) A: n3
#            R2 R1 R0
# a=r2
Forthword_ A_R2, INLINE_OPT, "a=r2"
  a_r2_
  end_

# ( -- ) (R: n3 n2 n1 -- n3 n2 n1 ) B: n3
#            R2 R1 R0
# b=r2
Forthword_ B_R2, INLINE_OPT, "b=r2"
  b_r2_
  end_

# ( -- ) (R: n3 n2 n1 -- n3 n2 n1 ) X: n3
#            R2 R1 R0
# x=r2
Forthword_ X_R2, INLINE_OPT, "x=r2"
  x_r2_
  end_

# ( -- ) (R: n3 n2 n1 -- n3 n2 n1 ) Y: n3
#            R2 R1 R0
# y=r2
Forthword_ Y_R2, INLINE_OPT, "y=r2"
  y_r2_
  end_

# (R: n2 -- n1 ) A: n1
#     r0
# r0=a
Forthword_ R0_A, INLINE_OPT, "r0=a"
  r0_a_
  end_
  
# (R: n2 -- n1 ) B: n1
#     r0
# r0=b
Forthword_ R0_B, INLINE_OPT, "r0=b"
  r0_b_
  end_
  
# (R: n2 -- n1 ) X: n1
#     r0
# r0=x
Forthword_ R0_X, INLINE_OPT, "r0=x"
  r0_x_
  end_
  
# (R: n2 -- n1 ) Y: n1
#     r0
# r0=y
Forthword_ R0_Y, INLINE_OPT, "r0=y"
  r0_y_
  end_
  
# (R: ?  n1 -- n2 n1 ) A: n2
#     r1 r0
# r1=a
Forthword_ R1_A, INLINE_OPT, "r1=a"
  r1_a_
  end_
  
# (R: ?  n1 -- n2 n1 ) B: n2
#     r1 r0
# r1=b
Forthword_ R1_B, INLINE_OPT, "r1=b"
  r1_b_
  end_
  
# (R: ?  n1 -- n2 n1 ) X: n2
#     r1 r0
# r1=x
Forthword_ R1_X, INLINE_OPT, "r1=x"
  r1_x_
  end_
  
# (R: ?  n1 -- n2 n1 ) Y: n2
#     r1 r0
# r1=y
Forthword_ R1_Y, INLINE_OPT, "r1=y"
  r1_y_
  end_
  
# (R: ?  ?  n1 -- n2 ?  n1 ) A: n2
#     r2 r1 r0
# r2=a
Forthword_ R2_A, INLINE_OPT, "r2=a"
  r2_a_
  end_
  
# (R: ?  ?  n1 -- n2 ?  n1 ) B: n2
#     r2 r1 r0
# r2=b
Forthword_ R2_B, INLINE_OPT, "r2=b"
  r2_b_
  end_
  
# (R: ?  ?  n1 -- n2 ?  n1 ) X: n2
#     r2 r1 r0
# r2=x
Forthword_ R2_X, INLINE_OPT, "r2=x"
  r2_x_
  end_
  
# (R: ?  ?  n1 -- n2 ?  n1 ) Y: n2
#     r2 r1 r0
# r2=y
Forthword_ R2_Y, INLINE_OPT, "r2=y"
  r2_y_
  end_
  
# (  -- n)
# current return stack pointer address
Forthword_ RSP, INLINE_OPT, "rsp"
  rsp_
  end_

# ( addr  -- ) (R: -- x*y)
# set return stack pointer
Forthword_ RSP_W, INLINE_OPT, "rsp=w"
# keep the return address
  rsp_w_
  end_

# ( -- n) (R: n -- n+1 )
# get TOR and then increment TOR by 1 cell (32 bit)
# assumes TOR content will be used for 32 bit memory access
# since this word must be called, skip the top most item on the return stack
Forthword_ R0PLUS, INLINE_OPT, "r0+"
  r0_
  addl $4, (%esp)
  end_


#@@@@@@@@@@@@@ Arithmatic @@@@@@@@@@@@@

# ( n1 -- n1+y )
# w = w + y
Forthword_ W_PLUS_Y, INLINE_OPT, "w+=y"
  w_plus_y_
  end_

# ( n1 -- n1+x )
# w = w + x
Forthword_ W_PLUS_X, INLINE_OPT, "w+=x"
  w_plus_x_
  end_

# ( n1 -- n1+a )
# w = w + a
Forthword_ W_PLUS_A, INLINE_OPT, "w+=a"
  w_plus_a_
  end_

# ( n1 -- n1+b )
# w = w + b
Forthword_ W_PLUS_B, INLINE_OPT, "w+=b"
  w_plus_b_
  end_

# ( n1|u1 -- n1-y|u1-y )
# w = w - y
Forthword_ W_MINUS_Y, INLINE_OPT, "w-=y"
  w_minus_y_
  end_

# ( n1|u1 -- n1-x|u1-x )
# w = w - x
Forthword_ W_MINUS_X, INLINE_OPT, "w-=x"
  w_minus_x_
  end_

# ( n1|u1 -- n1-a|u1-a )
# w = w - a
Forthword_ W_MINUS_A, INLINE_OPT, "w-=a"
  w_minus_a_
  end_

# ( n1|u1 -- n1-b|u1-b )
# w = w - b
Forthword_ W_MINUS_B, INLINE_OPT, "w-=b"
  w_minus_b_
  end_

# ( n1 -- n1 Y:Y+n1 )
# y = y + w
Forthword_ Y_PLUS_W, INLINE_OPT, "y+=w"
  y_plus_w_
  end_

# ( n1 -- n1 Y:Y+A )
# y = y + a
Forthword_ Y_PLUS_A, INLINE_OPT, "y+=a"
  y_plus_a_
  end_

# ( n1 -- n1 Y:Y+B )
# y = y + b
Forthword_ Y_PLUS_B, INLINE_OPT, "y+=b"
  y_plus_b_
  end_

# ( n1 -- n1 Y:Y+X )
# y = y + x
Forthword_ Y_PLUS_X, INLINE_OPT, "y+=x"
  y_plus_x_
  end_

# ( n1 -- n1 Y:Y-n1 )
# y = y - w
Forthword_ Y_MINUS_W, INLINE_OPT, "y-=w"
  y_minus_w_
  end_

# ( n1 -- n1 Y:Y-A )
# y = y - a
Forthword_ Y_MINUS_A, INLINE_OPT, "y-=a"
  y_minus_a_
  end_

# ( n1 -- n1 Y:Y-B )
# y = y - b
Forthword_ Y_MINUS_B, INLINE_OPT, "y-=b"
  y_minus_b_
  end_

# ( n1 -- n1 Y:Y-X )
# y = y - x
Forthword_ Y_MINUS_X, INLINE_OPT, "y-=x"
  y_minus_x_
  end_

# ( n1 -- n1 X:X+n1 )
# x = x + w
Forthword_ X_PLUS_W, INLINE_OPT, "x+=w"
  x_plus_w_
  end_

# ( n1 -- n1 X:X+a )
# x = x + a
Forthword_ X_PLUS_A, INLINE_OPT, "x+=a"
  x_plus_a_
  end_

# ( n1 -- n1 X:X+B )
# x = x + b
Forthword_ X_PLUS_B, INLINE_OPT, "x+=b"
  x_plus_b_
  end_

# ( n1 -- n1 X:X+Y )
# x = x + y
Forthword_ X_PLUS_Y, INLINE_OPT, "x+=y"
  x_plus_y_
  end_

# ( n1 -- n1 X:X-n1 )
# x = x - w
Forthword_ X_MINUS_W, INLINE_OPT, "x-=w"
  x_minus_w_
  end_

# ( n1 -- n1 X:X-a )
# x = x - a
Forthword_ X_MINUS_A, INLINE_OPT, "x-=a"
  x_minus_a_
  end_

# ( n1 -- n1 X:X-B )
# x = x - b
Forthword_ X_MINUS_B, INLINE_OPT, "x-=b"
  x_minus_b_
  end_

# ( n1 -- n1 X:X-Y )
# x = x - y
Forthword_ X_MINUS_Y, INLINE_OPT, "x-=y"
  x_minus_y_
  end_

# ( n1 -- n1 A:A+n1 )
# a = a + n1
Forthword_ A_PLUS_W, INLINE_OPT, "a+=w"
  a_plus_w_
  end_

# ( n1 -- n1 A:A+B )
# a = a + b
Forthword_ A_PLUS_B, INLINE_OPT, "a+=b"
  a_plus_b_
  end_

# ( n1 -- n1 A:A+X )
# a = a + x
Forthword_ A_PLUS_X, INLINE_OPT, "a+=x"
  a_plus_x_
  end_

# ( n1 -- n1 A:A+Y )
# a = a + y
Forthword_ A_PLUS_Y, INLINE_OPT, "a+=y"
  a_plus_y_
  end_

# ( n1 -- n1 A:A-n1 )
# a = a - w
Forthword_ A_MINUS_W, INLINE_OPT, "a-=w"
  a_minus_w_
  end_

# ( n1 -- n1 A:A-B )
# a = a - b
Forthword_ A_MINUS_B, INLINE_OPT, "a-=b"
  a_minus_b_
  end_

# ( n1 -- n1 A:A-X )
# a = a - x
Forthword_ A_MINUS_X, INLINE_OPT, "a-=x"
  a_minus_x_
  end_

# ( n1 -- n1 A:A-Y )
# a = a - y
Forthword_ A_MINUS_Y, INLINE_OPT, "a-=y"
  a_minus_y_
  end_

# ( n1 -- n1 B:B+n1 )
# b = b + w
Forthword_ B_PLUS_W, INLINE_OPT, "b+=w"
  b_plus_w_
  end_

# ( n1 -- n1 B:B+A )
# b = b + a
Forthword_ B_PLUS_A, INLINE_OPT, "b+=a"
  b_plus_a_
  end_

# ( n1 -- n1 B:B+X )
# b = b + x
Forthword_ B_PLUS_X, INLINE_OPT, "b+=x"
  b_plus_x_
  end_

# ( n1 -- n1 B:B+Y )
# b = b + y
Forthword_ B_PLUS_Y, INLINE_OPT, "b+=y"
  b_plus_y_
  end_

# ( n1 -- n1 B:B-n1 )
# b = b - w
Forthword_ B_MINUS_W, INLINE_OPT, "b-=w"
  b_minus_w_
  end_

# ( n1 -- n1 B:B-A )
# b = b - a
Forthword_ B_MINUS_A, INLINE_OPT, "b-=a"
  b_minus_a_
  end_

# ( n1 -- n1 B:B-X )
# b = b - x
Forthword_ B_MINUS_X, INLINE_OPT, "b-=x"
  b_minus_x_
  end_

# ( n1 -- n1 B:B-Y )
# b = b - y
Forthword_ B_MINUS_Y, INLINE_OPT, "b-=y"
  b_minus_y_
  end_

# ( u1|n1 u2|n2 -- u3|n3 )
# signed multiply 32b x 32b = 32b
Forthword_ MULU, INLINE_OPT,  "*"
  popy_
  imul %edx, %eax 
  end_

# ( n1 -- -n1 )
# 2-compliment of n1
Forthword_ NEG, INLINE_OPT, "-"
  neg_
  end_

# ( Y:n1 -- Y:-n1 )
# 2-compliment of Y
Forthword_ NEG_Y, INLINE_OPT, "-y"
  neg_y_
  end_

# ( X:n1 -- X:-n1 )
# 2-compliment of X
Forthword_ NEG_X, INLINE_OPT, "-x"
  neg_x_
  end_


# ( A:n1 -- A:-n1 )
# 2-compliment of A
Forthword_ NEG_A, INLINE_OPT, "-a"
  neg_a_
  end_

# ( B:n1 -- B:-n1 )
# 2-compliment of B
Forthword_ NEG_B, INLINE_OPT, "-b"
  neg_b_
  end_

# ( n1 -- n1 and Y )
# w = w and y
Forthword_ W_AND_Y, INLINE_OPT, "w&=y"
  w_and_y_
  end_

# ( n1 -- n1 and X )
# w = w and x
Forthword_ W_AND_X, INLINE_OPT, "w&=x"
  w_and_x_
  end_

# ( n1 -- n1 and A )
# w = w and a
Forthword_ W_AND_A, INLINE_OPT, "w&=a"
  w_and_a_
  end_

# ( n1 -- n1 and B )
# w = w and b
Forthword_ W_AND_B, INLINE_OPT, "w&=b"
  w_and_b_
  end_

# ( n1 -- n1.or.Y )
# w = w or y
Forthword_ W_OR_Y, INLINE_OPT, "w|=y"
  w_or_y_
  end_

# ( n1 -- n1.or.X )
# w = w or x
Forthword_ W_OR_X, INLINE_OPT, "w|=x"
  w_or_x_
  end_

# ( n1 -- n1.or.A )
# w = w or a
Forthword_ W_OR_A, INLINE_OPT, "w|=a"
  w_or_a_
  end_

# ( n1 -- n1.or.B )
# w = w or b
Forthword_ W_OR_B, INLINE_OPT, "w|=b"
  w_or_b_
  end_

# ( n1 -- n1.xor.Y)
# w = w xor y
Forthword_ W_XOR_Y, INLINE_OPT, "w^=y"
  w_xor_y_
  end_

# ( n1 -- n1.xor.X)
# w = w xor x
Forthword_ W_XOR_X, INLINE_OPT, "w^=x"
  w_xor_x_
  end_

# ( n1 -- n1.xor.A)
# w = w xor a
Forthword_ W_XOR_A, INLINE_OPT, "w^=a"
  w_xor_a_
  end_

# ( n1 -- n1.xor.B)
# w = w xor b
Forthword_ W_XOR_B, INLINE_OPT, "w^=b"
  w_xor_b_
  end_

# ( n1 -- n2)
# 1-complement of WR
Forthword_ NOT, INLINE_OPT, "!"
  not_
  end_

# ( n1 -- n2)
# 1-complement of y
Forthword_ NOT_Y, INLINE_OPT, "!y"
  not_y_
  end_

# ( n1 -- n2)
# 1-complement of x
Forthword_ NOT_X, INLINE_OPT, "!x"
  not_x_
  end_

# ( n1 -- n2)
# 1-complement of a
Forthword_ NOT_A, INLINE_OPT, "!a"
  not_a_
  end_

# ( n1 -- n2)
# 1-complement of b
Forthword_ NOT_B, INLINE_OPT, "!b"
  not_b_
  end_

# ( n1 n2 -- flag)
# flag is true if n1 is not equal to n2
Forthword_ NOTEQUAL, INLINE_OPT, "!="
  y_d0_
  nip_
  w_xor_y_
  end_

# ( n1 -- n1+1 ) 
# optimized increment
Forthword_ ONEPLUS, INLINE_OPT, "1+"
  oneplus_
  end_

# ( n1 -- n1-1 )
# optimized decrement
Forthword_ ONEMINUS, INLINE_OPT, "1-"
  oneminus_
  end_

# ( n1 -- n1-2 )
# optimized decrement
Forthword_ TWOMINUS, INLINE_OPT, "2-"
  twominus_
  end_

# ( n1 -- n1+2 )
# optimized decrement
Forthword_ TWOPLUS, INLINE_OPT, "2+"
  twoplus_
  end_

# ( n1 -- n1-4 )
# optimized decrement
Forthword_ FOURMINUS, INLINE_OPT, "4-"
  fourminus_
  end_

# ( n1 -- n1+4 )
# optimized decrement
Forthword_ FOURPLUS, INLINE_OPT, "4+"
  fourplus_
  end_

# ( n1 -- n1/2 )
# optimized divide by 2
Forthword_ TWOSLASH, INLINE_OPT, "2/"
  twoslash_
  end_

# ( n1 -- n1*2 )
# optimized 2 multiply
Forthword_ TWOSTAR, INLINE_OPT, "2*"
  twostar_
  end_

# ( n1 -- n1/4 )
# optimized divide by 4
Forthword_ FOURSLASH, INLINE_OPT, "4/"
  fourslash_
  end_

# ( n1 -- n*4 )
# optimized four multiply
Forthword_ FOURSTAR, INLINE_OPT, "4*"
  fourstar_
  end_

# ( X:n1 -- X:n1/2 )
# optimized X divide by 2
Forthword_ XTWOSLASH, INLINE_OPT, "x/=2"
  x_twoslash_
  end_

# ( X:n1 -- X:n1*2 )
# optimized X 2 multiply
Forthword_ XTWOSTAR, INLINE_OPT, "x*=2"
  x_twostar_
  end_

# ( X:n1 -- X:n1/4 )
# optimized X divide by 4
Forthword_ XFOURSLASH, INLINE_OPT, "x/=4"
  x_fourslash_
  end_

# ( X:n1 -- X:n*4 )
# optimized x four multiply
Forthword_ XFOURSTAR, INLINE_OPT, "x*=4"
  x_fourstar_
  end_

# ( Y:n1 -- Y:n1/2 )
# optimized y divide by 2
Forthword_ YTWOSLASH, INLINE_OPT, "y/=2"
  y_twoslash_
  end_

# ( Y:n1 -- Y:n1*2 )
# optimized y 2 multiply
Forthword_ YTWOSTAR, INLINE_OPT, "y*=2"
  y_twostar_
  end_

# ( Y:n1 -- Y:n1/4 )
# optimized y divide by 4
Forthword_ YFOURSLASH, INLINE_OPT, "y/=4"
  y_fourslash_
  end_

# ( Y:n1 -- Y:n*4 )
# optimized y four multiply
Forthword_ YFOURSTAR, INLINE_OPT, "y*=4"
  y_fourstar_
  end_

# ( A:n1 -- A:n1/2 )
# optimized A divide by 2
Forthword_ ATWOSLASH, INLINE_OPT, "a/=2"
  a_twoslash_
  end_

# ( A:n1 -- A:n1*2 )
# optimized A 2 multiply
Forthword_ ATWOSTAR, INLINE_OPT, "a*=2"
  a_twostar_
  end_

# ( A:n1 -- A:n1/4 )
# optimized A divide by 4
Forthword_ AFOURSLASH, INLINE_OPT, "a/=4"
  a_fourslash_
  end_

# ( A:n1 -- A:n*4 )
# optimized A four multiply
Forthword_ AFOURSTAR, INLINE_OPT, "a*=4"
  a_fourstar_
  end_

# ( B:n1 -- B:n1/2 )
# optimized B divide by 2
Forthword_ BTWOSLASH, INLINE_OPT, "b/=2"
  b_twoslash_
  end_

# ( B:n1 -- B:n1*2 )
# optimized B 2 multiply
Forthword_ BTWOSTAR, INLINE_OPT, "b*=2"
  b_twostar_
  end_

# ( B:n1 -- B:n1/4 )
# optimized B divide by 4
Forthword_ BFOURSLASH, INLINE_OPT, "b/=4"
  b_fourslash_
  end_

# ( B:n1 -- B:n*4 )
# optimized B four multiply
Forthword_ BFOURSTAR, INLINE_OPT, "b*=4"
  b_fourstar_
  end_

# ( n1 -- flag )
# flag is true if n1 is 0
Forthword_ ZEROEQUAL, INLINE_OPT, "0="
  zeroequal_
  end_

# ( -- -1 )
# w=-1 (true)
Forthword_ TRUE, INLINE_OPT, "true"
  true_
  end_

# ( -- 0 )
# w = 0
Forthword_ ZERO, INLINE_OPT, "0"
  zero_
  end_

# ( -- ) A: 0
# a = 0
Forthword_ A_0, INLINE_OPT, "a=0"
  a_0_
  end_

# ( -- ) B: 0
# b = 0
Forthword_ B_0, INLINE_OPT, "b=0"
  b_0_
  end_

# ( -- ) X: 0
# x = 0
Forthword_ X_0, INLINE_OPT, "x=0"
  x_0_
  end_

# ( -- ) Y: 0
# y = 0
Forthword_ Y_0, INLINE_OPT, "y=0"
  y_0_
  end_

# ( n -- n )
# test WR if zero, does not consume WR
Forthword_ ISZERO, INLINE_OPT, "==0"
  iszero_
  end_  
  
# ( n1 n2 -- n3)
# logically shift n1 left n2 times
forthword_ LSHIFT, INLINE_OPT, "<<"
  lshift_
  end_

# ( n1 n2 -- n3)
# logically shift n1 right n2 times
forthword_ RSHIFT, INLINE_OPT, ">>"
  rshift_
  end_


# ( a-addr -- n32 )
# read 1 cell (32 bits) from RAM address
Forthword_ FETCH, INLINE_OPT, "@"
  mw_
  end_

# ( a-addr -- a-addr A:n32 )
# read 1 cell (32 bits) from RAM address and put in A register
Forthword_ A_MW, INLINE_OPT, "a=@w"
  a_mw_
  end_

# ( a-addr -- a-addr B:n32 )
# read 1 cell (32 bits) from RAM address and put in B register
Forthword_ B_MW, INLINE_OPT, "b=@w"
  b_mw_
  end_

# ( a-addr -- a-addr X:n32 )
# read 1 cell (32 bits) from RAM address and put in X register
Forthword_ X_MW, INLINE_OPT, "x=@w"
  x_mw_
  end_

# ( a-addr -- a-addr Y:n32 )
# read 1 cell (32 bits) from RAM address and put in Y register
Forthword_ Y_MW, INLINE_OPT, "y=@w"
  y_mw_
  end_

# ( a-addr -- n16 )
# read half cell (16 bits) from RAM address
Forthword_ HMW, INLINE_OPT, "h@"
  hmw_
  end_

# ( a-addr -- a-addr A:n16 )
# read 1 cell (16 bits) from RAM address and put in A register
Forthword_ A_HMW, INLINE_OPT, "a=h@w"
  a_hmw_
  end_

# ( a-addr -- a-addr B:n16 )
# read 1 cell (16 bits) from RAM address and put in B register
Forthword_ B_HMW, INLINE_OPT, "b=h@w"
  b_hmw_
  end_

# ( a-addr -- a-addr X:n16 )
# read 1 cell (16 bits) from RAM address and put in X register
Forthword_ X_HMW, INLINE_OPT, "x=h@w"
  x_hmw_
  end_

# ( a-addr -- a-addr Y:n16 )
# read 1 cell (16 bits) from RAM address and put in Y register
Forthword_ Y_HMW, INLINE_OPT, "y=h@w"
  y_hmw_
  end_

# ( a-addr -- n8 )
# read byte (8 bits) from RAM address
Forthword_ CMW, INLINE_OPT, "c@"
  cmw_
  end_

# ( a-addr -- a-addr A:n8 )
# read 1 cell (8 bits) from RAM address and put in A register
Forthword_ A_CMW, INLINE_OPT, "a=c@w"
  a_cmw_
  end_

# ( a-addr -- a-addr B:n8 )
# read 1 cell (8 bits) from RAM address and put in B register
Forthword_ B_CMW, INLINE_OPT, "b=c@w"
  b_cmw_
  end_

# ( a-addr -- a-addr X:n8 )
# read 1 cell (8 bits) from RAM address and put in X register
Forthword_ X_CMW, INLINE_OPT, "x=c@w"
  x_cmw_
  end_

# ( a-addr -- a-addr Y:n8 )
# read 1 cell (8 bits) from RAM address and put in Y register
Forthword_ Y_CMW, INLINE_OPT, "y=c@w"
  y_cmw_
  end_

# ( addr Y:n -- )
# store a word from Y (32 bits) to RAM address
Forthword_ MW_Y, INLINE_OPT, "@w=y"
  mw_y_
  end_

# ( addr X:n -- )
# store a word From X (32 bits) to RAM address
Forthword_ MW_X, INLINE_OPT, "@w=x"
  mw_x_
  end_

# ( addr A:n -- )
# store a word From A (32 bits) to RAM address
Forthword_ MW_A, INLINE_OPT, "@w=a"
  mw_a_
  end_

# ( addr B:n -- )
# store a word From B (32 bits) to RAM address
Forthword_ MW_B, INLINE_OPT, "@w=b"
  mw_b_
  end_

# ( a-addr -- a-addr Y:n16 )
# store a half word (16 bits) in Y register to RAM address
Forthword_ HMW_Y, INLINE_OPT, "h@w=y"
  hmw_y_
  end_

# ( a-addr -- a-addr X:n16 )
# store a half word (16 bits) in X register to RAM address
Forthword_ HMW_X, INLINE_OPT, "h@w=x"
  hmw_x_
  end_

# ( a-addr -- a-addr A:n16 )
# store a half word (16 bits) in A register to RAM address
Forthword_ HMW_A, INLINE_OPT, "h@w=a"
  hmw_a_
  end_

# ( a-addr -- a-addr B:n16 )
# store a half word (16 bits) in B register to RAM address
Forthword_ HMW_B, INLINE_OPT, "h@w=b"
  hmw_b_
  end_

# ( a-addr -- )
# store a single byte from Y register to RAM address
Forthword_ CMW_Y, INLINE_OPT, "c@w=y"
  cmw_y_
  end_

# ( a-addr -- )
# store a single byte from Y register to RAM address
Forthword_ CMW_X, INLINE_OPT, "c@w=x"
  cmw_x_
  end_

# ( n -- n ) A: n
# copy WR to A register
Forthword_ A_W, INLINE_OPT, "a=w"
  a_w_
  end_

# ( n -- n ) B: n
# copy WR to B register
Forthword_ B_W, INLINE_OPT, "b=w"
  b_w_
  end_

# ( n1 -- n1 ) X: n1
#   WR
# copy WR register to X register
Forthword_ X_W, INLINE_OPT, "x=w"
  x_w_
  end_
  
# ( n1 -- n1 ) Y: n1
#   WR
# copy WR register to Y register
Forthword_ Y_W, INLINE_OPT, "y=w"
  y_w_
  end_
  

# ( -- n )
# copy A register to WR
Forthword_ A_, INLINE_OPT, "a"
  a_
  end_

# ( -- n )
# copy B register to WR
Forthword_ B_, INLINE_OPT, "b"
  b_
  end_

# ( -- n )
# copy X register to WR
Forthword_ X_, INLINE_OPT, "x"
  x_
  end_

# ( -- n )
# copy the Y register to WR
Forthword_ Y_, INLINE_OPT, "y"
  y_
  end_

# ( -- n )
# Read a word (32bit) from memory pointed to by register A
Forthword_ MA, INLINE_OPT, "@a"
  ma_
  end_

# ( n -- )
# store a word to RAM address pointed to by areg
Forthword_ MA_W, INLINE_OPT, "@a=w"
  ma_w_
  end_

# ( -- n )
# Read a half word (32bit) from memory pointed to by register A
Forthword_ HMA, INLINE_OPT, "h@a"
  hma_
  end_

# ( h -- h )
# store a half word to RAM address pointed to by areg
Forthword_ HMA_W, INLINE_OPT, "h@a=w"
  hma_w_
  end_

# ( -- n )
# Read a byte from memory pointed to by register A
Forthword_ CMA, INLINE_OPT, "c@a"
  cma_
  end_

# ( c -- )
# store a single byte to RAM address pointed to by areg
Forthword_ CMA_W, INLINE_OPT, "c@a=w"
  cma_w_
  end_

# ( -- )
# a = a + 4
Forthword_ A_PLUS4, INLINE_OPT, "a+=4"
  a_plus4_
  end_

# ( -- )
# a = a + 2
Forthword_ A_PLUS2, INLINE_OPT, "a+=2"
  a_plus2_
  end_


# ( -- )
# a = a + 1
Forthword_ A_PLUS1, INLINE_OPT, "a+=1"
  a_plus1_
  end_

# ( -- )
# a = a -4
Forthword_ A_MINUS4, INLINE_OPT, "a-=4"
  a_minus4_
  end_

# ( -- )
# a = a - 2
Forthword_ A_MINUS2, INLINE_OPT, "a-=2"
  a_minus2_
  end_

# ( -- )
# a = a - 1
Forthword_ A_MINUS1, INLINE_OPT, "a-=1"
  a_minus1_
  end_

# ( -- n )
# Read a word (32bit) from memory pointed to by register B
Forthword_ MB, INLINE_OPT, "@b"
  mb_
  end_

# ( n -- )
# store a word to RAM address pointed to by b register
Forthword_ MB_W, INLINE_OPT, "@b=w"
  mb_w_
  end_

# ( -- n )
# Read a half word (32bit) from memory pointed to by register B
Forthword_ HMB, INLINE_OPT, "h@b"
  hmb_
  end_

# ( h -- )
# store a half word to RAM address pointed to by b reg
Forthword_ HMB_W, INLINE_OPT, "h@b=w"
  hmb_w_
  end_

# ( -- n )
# Read a byte from memory pointed to by register B
Forthword_ CMB, INLINE_OPT, "c@b"
  cmb_
  end_

# ( c -- )
# store a single byte to RAM address pointed to by B reg
Forthword_ CMB_W, INLINE_OPT, "c@b=w"
  cmb_w_
  end_

# ( -- )
# update register B with post increment 4+ from last memory operation
Forthword_ B_PLUS4, INLINE_OPT, "b+=4"
  b_plus4_
  end_

# ( -- )
# update register B with post increment 2+ from last memory operation
Forthword_ B_PLUS2, INLINE_OPT, "b+=2"
  b_plus2_
  end_

# ( -- )
# update register B with post increment 1+ from last memory operation
Forthword_ B_PLUS1, INLINE_OPT, "b+=1"
  b_plus1_
  end_

# ( -- )
# update register B with decrement 4
Forthword_ B_MINUS4, INLINE_OPT, "b-=4"
  b_minus4_
  end_

# ( -- )
# update register B with decrement 2
Forthword_ B_MINUS2, INLINE_OPT, "b-=2"
  b_minus2_
  end_

# ( -- )
# update register B with decrement 1
Forthword_ B_MINUS1, INLINE_OPT, "b-=1"
  b_minus1_
  end_

# ( -- n )
# Read a word (32bit) from memory pointed to by register X
Forthword_ MX, INLINE_OPT, "@x"
  mx_
  end_

# ( n -- )
# store a word to RAM address pointed to by x register
Forthword_ MX_W, INLINE_OPT, "@x=w"
  mx_w_
  end_

# ( -- n )
# Read a half word (32bit) from memory pointed to by register X
Forthword_ HMX, INLINE_OPT, "h@x"
  hmx_
  end_

# ( h -- )
# store a half word to RAM address pointed to by x reg
Forthword_ HMX_W, INLINE_OPT, "h@x=w"
  hmx_w_
  end_

# ( -- n )
# Read a byte from memory pointed to by register X
Forthword_ CMX, INLINE_OPT, "c@x"
  cmx_
  end_

# ( c -- )
# store a single byte to RAM address pointed to by X reg
Forthword_ CMX_W, INLINE_OPT, "c@x=w"
  cmx_w_
  end_

# ( -- )
# update register X with post increment 4+ from last memory operation
Forthword_ X_PLUS4, INLINE_OPT, "x+=4"
  x_plus4_
  end_

# ( -- )
# update register X with post increment 2+ from last memory operation
Forthword_ X_PLUS2, INLINE_OPT, "x+=2"
  x_plus2_
  end_


# ( -- )
# update register X with post increment 1+ from last memory operation
Forthword_ X_PLUS1, INLINE_OPT, "x+=1"
  x_plus1_
  end_

# ( -- )
# update register X with decrement 4
Forthword_ X_MINUS4, INLINE_OPT, "x-=4"
  x_minus4_
  end_

# ( -- )
# update register X with decrement 2
Forthword_ X_MINUS2, INLINE_OPT, "x-=2"
  x_minus2_
  end_

# ( -- )
# update register X with decrement 1
Forthword_ X_MINUS1, INLINE_OPT, "x-=1"
  x_minus1_
  end_

# ( -- n )
# Read a word (32bit) from memory pointed to by register Y
Forthword_ MY, INLINE_OPT, "@y"
  my_
  end_

# ( n -- )
# store a word to RAM address pointed to by Y register
Forthword_ MY_W, INLINE_OPT, "@y=w"
  my_w_
  end_

# ( -- n )
# Read a half word (16bit) from memory pointed to by register Y
Forthword_ HMY, INLINE_OPT, "h@y"
  hmy_
  end_

# ( h -- )
# store a half word to RAM address pointed to by Y reg
Forthword_ HMY_W, INLINE_OPT, "h@y=w"
  hmy_w_
  end_

# ( -- n )
# Read a byte from memory pointed to by register Y
Forthword_ CMY, INLINE_OPT, "c@y"
  cmy_
  end_

# ( c -- )
# store a single byte to RAM address pointed to by Y reg
Forthword_ CMY_W, INLINE_OPT, "c@y=w"
  cmy_w_
  end_
  
# ( -- )
# y = y + 4
Forthword_ Y_PLUS4, INLINE_OPT, "y+=4"
  y_plus4_
  end_

# ( -- )
# y = y + 2
Forthword_ Y_PLUS2, INLINE_OPT, "y+=2"
  y_plus2_
  end_


# ( -- )
# y = y + 1
Forthword_ Y_PLUS1, INLINE_OPT, "y+=1"
  y_plus1_
  end_

# ( -- )
# y = y - 4
Forthword_ Y_MINUS4, INLINE_OPT, "y-=4"
  y_minus4_
  end_

# ( -- )
# y = y - 2
Forthword_ Y_MINUS2, INLINE_OPT, "y-=2"
  y_minus2_
  end_

# ( -- )
# y = y - 1
Forthword_ Y_MINUS1, INLINE_OPT, "y-=1"
  y_minus1_
  end_
