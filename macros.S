# macros.S

# if registers and stacks
#
# data stack       registers      return stack
# d0               w              r0
# d1               a              r1
# d2               b              r2
#                  x
#                  y
#                  dsp
#                  rsp

# wreg -> %eax # W register and also considered Top of Stack
# dsp  -> %ebx # holds the Forth Parameter/Data stack pointer
# areg -> %esi # A register used for memory pointer operations - non-volatile: user must preserve
# breg -> %edi # B register used for general purpose operations - non-volatile: user must preserve
# xreg -> %ecx # X register used for general purpose operations 
# yreg -> %edx # Y register used as a temp register
# sysvar -> %ebp # system variables base pointer

# header flags
.set HFLAGS, 0xFF
# low byte is word count : 0 - 255
# high byte is flags for word
# enable inlining of word
# bit 0 : enable inlinning
.set INLINE_OPT_FB, 0
.set INLINE_OPT, 1 << INLINE_OPT_FB

# bit 3 : disable interpret execution ie compile only
.set COMPILE_ONLY_FB, 3
# set immediate word as compile time only execution
# disable interpret execution : & with word count flag ie: 0xFF04 & COMPILE_ONLY
.set COMPILE_ONLY, 1 << COMPILE_ONLY_FB

# bit 7 : immediate execution when in compile state
# enable immediate execution : & with word count flag ie: 0xFF04 & IMMEDIATE_EN
.set IMMEDIATE_EN_FB, 7
.set IMMEDIATE_EN, 1 << IMMEDIATE_EN_FB

# forth flags
# bit 0 - Terminate Tasks
.set TERMINATE_F, 1
# bit 1 : call was last instruction
.set LAST_IS_CALL_FB, 1
# if bit 0 and 1 are cleared then last instruction was an inline or tail call optimization was disabled by word
# bit 2 : disable tail call optimization
# same bit in header flags
.set DIS_CALL_OPT_FB, 2
# bit 3,4 : word type
# 00 : standard
# 01 : litteral
# 10 : ALU
# 11 : 
# bit 5, 6 ,7: register load
# 000 : WR
# 001 : Y
# 010 : X
# 011 : B
# 100 : A

# Inline macros
# push registers on return stack

# r=
.macro r_w_ 
  pushl %eax
.endm

# r=a
.macro r_a_ 
  pushl %esi
.endm

# r=b
.macro r_b_
  pushl %edi
.endm

# r=x
.macro r_x_
  pushl %ecx
.endm

# r=y
.macro r_y_
  pushl %edx
.endm

# r=dsp
.macro r_dsp_
  pushl %ebx
.endm

# pop value from return stack into register

# r
.macro r_
  popl %eax
.endm

# a=r
.macro a_r_ 
  popl %esi
.endm

# b=r
.macro b_r_ 
  popl %edi
.endm

# x=r
.macro x_r_ 
  popl %ecx
.endm

# y=r
.macro y_r_ 
  popl %edx
.endm

# dsp=r
.macro dsp_r_ 
  popl %ebx
.endm

# r-1
.macro r_sub_1_
  leal 4(%esp), %esp
.endm

# r-2
.macro r_sub_2_
  leal 8(%esp), %esp
.endm

# r-3
.macro r_sub_3_
  leal 12(%esp), %esp
.endm


# load value from return stack into register

# r0
.macro r0_ # load tos from stack
  movl (%esp), %eax
.endm

# r1
.macro r1_ # load tos from stack
  movl 4(%esp), %eax
.endm

# r2
.macro r2_ # load tos from stack
  movl 8(%esp), %eax
.endm

# a=r0
.macro a_r0_
  movl (%esp), %esi
.endm

# b=r0
.macro b_r0_
  movl (%esp), %edi
.endm

# x=r0
.macro x_r0_
  movl (%esp), %ecx
.endm

# y=r0
.macro y_r0_
  movl (%esp), %edx
.endm

# a=r1
.macro a_r1_
  movl 4(%esp), %esi
.endm

# b=r1
.macro b_r1_
  movl 4(%esp), %edi
.endm

# x=r1
.macro x_r1_
  movl 4(%esp), %ecx
.endm

# y=r1
.macro y_r1_
  movl 4(%esp), %edx
.endm

# a=r2
.macro a_r2_
  movl 8(%esp), %esi
.endm

# b=r2
.macro b_r2_
  movl 8(%esp), %edi
.endm

# x=r2
.macro x_r2_
  movl 8(%esp), %ecx
.endm

# y=r2 
.macro y_r2_
  movl 8(%esp), %edx
.endm

# store register value in return stack

# r0=
.macro r0_w_
  movl %eax, (%esp)
.endm

# r0=a
.macro r0_a_
  movl %esi, (%esp)
.endm

# r0=b
.macro r0_b_
  movl %edi, (%esp)
.endm

# r0=x
.macro r0_x_
  movl %ecx, (%esp)
.endm

# r0=y
.macro r0_y_
  movl %edx, (%esp)
.endm

# r1=w
.macro r1_w_
  movl %eax, 4(%esp)
.endm

# r1=a
.macro r1_a_
  movl %esi, 4(%esp)
.endm

# r1=b
.macro r1_b_
  movl %edi, 4(%esp)
.endm

# r1=x
.macro r1_x_
  movl %ecx, 4(%esp)
.endm

# r1=y
.macro r1_y_
  movl %edx, 4(%esp)
.endm

# r2=
.macro r2_w_
  movl %eax, 8(%esp)
.endm

# r2=a
.macro r2_a_
  movl %esi, 8(%esp)
.endm

# r2=b
.macro r2_b_
  movl %edi, 8(%esp)
.endm

# r2=x
.macro r2_x_
  movl %ecx, 8(%esp)
.endm

# r2=y
.macro r2_y_
  movl %edx, 8(%esp)
.endm

# store return stack register in register

# rsp
.macro rsp_
  movl %esp, %eax
.endm

# rsp=
.macro rsp_w_
  movl %eax, %esp
.endm

# move values between data stack locations and registers

# d0=
.macro d0_w_
  mov %eax, (%ebx)
.endm

# d0
.macro d0_ # load tos from stack
  movl (%ebx), %eax
.endm

# d1=
.macro d1_w_
  mov %eax, 4(%ebx)
.endm

# d1
.macro d1_ # load tos from stack
  movl 4(%ebx), %eax
.endm

# d2=
.macro d2_w_
  mov %eax, 8(%ebx)
.endm

# d2
.macro d2_ # load tos from stack
  movl 8(%ebx), %eax
.endm

# d0=a
.macro d0_a_
  mov %esi, (%ebx)
.endm

# d0=b
.macro d0_b_
  mov %edi, (%ebx)
.endm

# d0=x
.macro d0_x_
  mov %ecx, (%ebx)
.endm

# d0=y
.macro d0_y_
  mov %edx, (%ebx)
.endm

# d1=a
.macro d1_a_
  mov %esi, 4(%ebx)
.endm

# d1=b
.macro d1_b_
  mov %edi, 4(%ebx)
.endm

# d1=x
.macro d1_x_
  mov %ecx, 4(%ebx)
.endm

# d1=y
.macro d1_y_
  mov %edx, 4(%ebx)
.endm

# d2=a
.macro d2_a_
  mov %esi, 8(%ebx)
.endm

# d2=b
.macro d2_b_
  mov %edi, 8(%ebx)
.endm

# d2=x
.macro d2_x_
  mov %ecx, 8(%ebx)
.endm

# d2=y
.macro d2_y_
  mov %edx, 8(%ebx)
.endm

# a=d0
.macro a_d0_
  movl (%ebx), %esi
.endm

# a=d1
.macro a_d1_
  movl 4(%ebx), %esi
.endm

# a=d2
.macro a_d2_
  movl 8(%ebx), %esi
.endm

# b=d0
.macro b_d0_
  movl (%ebx), %edi
.endm

# b=d1
.macro b_d1_
  movl 4(%ebx), %edi
.endm

# b=d2
.macro b_d2_
  movl 8(%ebx), %edi
.endm

# x=d0
.macro x_d0_
  movl (%ebx), %ecx
.endm

# x=d1
.macro x_d1_
  movl 4(%ebx), %ecx
.endm

# x=d2
.macro x_d2_
  movl 8(%ebx), %ecx
.endm

# y=d0
.macro y_d0_
  movl (%ebx), %edx
.endm

# y=d1
.macro y_d1_
  movl 4(%ebx), %edx
.endm

# y=d2
.macro y_d2_
  movl 8(%ebx), %edx
.endm

# make space on data stack

# d+1
.macro d_plus_1_ # move stack pointer down one cell
  leal -4(%ebx), %ebx
.endm

# d+2
.macro d_plus_2_ # move stack pointer down two cells
  leal -8(%ebx), %ebx
.endm

# d+3
.macro d_plus_3_ # move stack pointer down three cells
  leal -12(%ebx), %ebx
.endm

# push register on data stack

# d=
.macro d_w_ # save WR on data stack
  d_p1_
  d0_w_
.endm

# d=a
.macro d_a_ # save a on data stack
  d_p1_
  d0_a_
.endm

# d=b
.macro d_b_ # save b on data stack
  d_p1_
  d0_b_
.endm

# d=x
.macro d_x_ # save x on data stack
  d_p1_
  d0_x_
.endm

# d=y
.macro d_y_ # save y on data stack
  d_p1_
  d0_y_
.endm

# d-1
.macro d_sub_1_
  leal 4(%ebx), %ebx
.endm

# d-2
.macro d_sub_2_
  leal 8(%ebx), %ebx
.endm

# d-3
.macro d_sub_3_
  leal 12(%ebx), %ebx
.endm

# pop value from data stack into register

# d
.macro w_d_ # load WR from stack, increment stack pointer
  d0_
  d_m1_
.endm

# a=d
.macro a_d_
  a_d0_
  d_m1_
.endm

# b=d
.macro b_d_
  b_d0_
  d_m1_
.endm

# x=d
.macro x_d_
  x_d0_
  d_m1_
.endm

# y=d
.macro y_d_
  y_d0_
  d_m1_
.endm

# test with bit constant
.macro bittest_ v
  test $\v, %eax
.endm

# dsp
.macro dsp_
  movl %ebx, %eax
.endm

# dsp=
.macro dsp_w_
  movl %eax, %ebx
.endm

# +y
.macro plus_y_
  addl %edx, %eax
.endm

# +x
.macro plus_x_
  addl %ecx, %eax
.endm

# +a
.macro plus_a_
  addl %esi, %eax
.endm

# +b
.macro plus_b_
  addl %edi, %eax
.endm

# y+
.macro y_plus_
  addl %eax, %edx
.endm

# y+x
.macro y_plus_x_
  addl %ecx, %edx
.endm

# y+a
.macro y_plus_a_
  addl %esi, %edx
.endm

# y+b
.macro y_plus_b_
  addl %edi, %edx
.endm

# x+w
.macro x_plus_
  addl %eax, %ecx
.endm

# x+y
.macro x_plus_y_
  addl %edx, %ecx
.endm

# x+a
.macro x_plus_a_
  addl %esi, %ecx
.endm

# x+b
.macro x_plus_b_
  addl %edi, %ecx
.endm

# a+
.macro a_plus_
  addl %eax, %esi
.endm

# a+b
.macro a_plus_b_
  addl %edi, %esi
.endm

# a+x
.macro a_plus_x_
  addl %ecx, %esi
.endm

# a+y
.macro a_plus_y_
  addl %edx, %esi
.endm

# b+
.macro b_plus_
  addl %eax, %edi
.endm

# b+a
.macro b_plus_a_
  addl %esi, %edi
.endm

# b+x
.macro b_plus_x_
  addl %ecx, %edi
.endm

# b+y
.macro b_plus_y_
  addl %edx, %edi
.endm

# -y
.macro sub_y_
  sub %edx, %eax
.endm

# -x
.macro sub_x_
  sub %ecx, %eax
.endm

# -a
.macro sub_a_
  sub %esi, %eax
.endm

# -b
.macro sub_b_
  sub %edi, %eax
.endm

# y-
.macro y_sub_
  sub %eax, %edx
.endm

# y-x
.macro y_sub_x_
  sub %ecx, %edx
.endm

# y-a
.macro y_sub_a_
  sub %esi, %edx
.endm

# y-b
.macro y_sub_b_
  sub %edi, %edx
.endm

# x-
.macro x_sub_
  sub %eax, %ecx
.endm

# x-y
.macro x_sub_y_
  sub %edx, %ecx
.endm

# x-a
.macro x_sub_a_
  sub %esi, %ecx
.endm

# x-b
.macro x_sub_b_
  sub %edi, %ecx
.endm

# a-
.macro a_sub_w_
  sub %eax, %esi
.endm

# a-b
.macro a_sub_b_
  sub %edi, %esi
.endm

# a-x
.macro a_sub_x_
  sub %ecx, %esi
.endm

# a-y
.macro a_sub_y_
  sub %edx, %esi
.endm

# b-
.macro b_sub_
  sub %eax, %edi
.endm

# b-a
.macro b_sub_a_
  sub %esi, %edi
.endm

# b-x
.macro b_sub_x_
  sub %ecx, %edi
.endm

# b-y
.macro b_sub_y_
  sub %edx, %edi
.endm

# -
.macro neg_
  neg %eax
.endm

.macro neg_y_
  neg %edx
.endm

.macro neg_x_
  neg %ecx
.endm

.macro neg_a_
  neg %esi
.endm

.macro neg_b_
  neg %edi
.endm

# &y
.macro and_y_
  and %edx, %eax
.endm

# &x
.macro and_x_
  and %ecx, %eax
.endm

# &a
.macro and_a_
  and %esi, %eax
.endm

# &b
.macro and_b_
  and %edi, %eax
.endm

# |y
.macro or_y_
  or %edx, %eax
.endm

# |x
.macro or_x_
  or %ecx, %eax
.endm

# |a
.macro or_a_
  or %esi, %eax
.endm

# |b
.macro or_b_
  or %edi, %eax
.endm

# ^y
.macro xor_y_
  xor %edx, %eax
.endm

# ^x
.macro xor_x_
  xor %ecx, %eax
.endm

# ^a
.macro xor_a_
  xor %esi, %eax
.endm

# ^b
.macro xor_b_
  xor %edi, %eax
.endm

# !
.macro not_
  not %eax
.endm

# !y
.macro not_y_
  not %edx
.endm

# !x
.macro not_x_
  not %ecx
.endm

# !a
.macro not_a_
  not %esi
.endm

# !b
.macro not_b_
  not %edi
.endm

.macro user_ sym
  leal (\sym-sysvar_base)(%ebp), %eax
.endm

# load constant into register
.macro lit_ val
  movl $\val, %eax
.endm

.macro lit_a_ val
  movl $\val, %esi
.endm

.macro lit_b_ val
  movl $\val, %edi
.endm

.macro lit_x_ val
  movl $\val, %ecx
.endm

.macro lit_y_ val
  movl $\val, %edx
.endm

# +1
.macro plus_1_
  inc %eax
.endm

# 1-
.macro _1_sub_
  dec %eax
.endm

# +2
.macro plus_2_
  add $2, %eax
.endm

# +4
.macro plus_4_
  add $4, %eax
.endm

# 2-
.macro _2_sub_
  sub $2, %eax
.endm

# 4-
.macro _4_sub_
  sub $4, %eax
.endm

# /2
.macro div_2_
  sar %eax
.endm

# /4
.macro div_4_
  sar $2, %eax
.endm

# *2
.macro mul_2_
  sal %eax
.endm

# *4
.macro mul_4_
  sal $2, %eax
.endm

# x/2
.macro x_div_2_
  sar %ecx
.endm

# x/4
.macro x_div_4_
  sar $2, %ecx
.endm

# x*2
.macro x_mul_2_
  sal %ecx
.endm

# x*4
.macro x_mul_4_
  sal $2, %ecx
.endm

# y/2
.macro y_div_2_
  sar %edx
.endm

# y/4
.macro y_div_4_
  sar $2, %edx
.endm

# y*2
.macro y_mul_2_
  sal %edx
.endm

# y*4
.macro y_mul_4_
  sal $2, %edx
.endm

# a/2
.macro a_div_2_
  sar %esi
.endm

# a/4
.macro a_div_4_
  sar $2, %esi
.endm

# a*2
.macro a_mul_2_
  sal %esi
.endm

# a*4
.macro a_mul_4_
  sal $2, %esi
.endm

# b/2
.macro b_div_2_
  sar %edi
.endm

# b/4
.macro b_div_4_
  sar $2, %edi
.endm

# b*2
.macro b_mul_2_
  sal %edi
.endm

# b*4
.macro b_mul_4_
  sal $2, %edi
.endm

# ==0
.macro iszero_
  or %eax, %eax
.endm

# a==0
.macro a_iszero_
  or %esi, %esi
.endm

# b==0
.macro b_iszero_
  or %edi, %edi
.endm

# x==0
.macro x_iszero_
  or %ecx, %ecx
.endm

# y==0
.macro y_iszero_
  or %edx, %edx
.endm

# 0<
.macro zeroless_
  sar $31, %eax    # Turn MSB into 0xffffffff or 0x00000000
.endm

# 0
.macro zero_
  xor %eax, %eax
.endm

# a=0
.macro a_0_
  xor %esi, %esi 
.endm

# b=0
.macro b_0_
  xor %edi, %edi 
.endm

# x=0
.macro x_0_
  xor %ecx, %ecx
.endm

# y=0
.macro y_0_
  xor %edx, %edx
.endm

# 0=
.macro zeroequal_
  sub $1, %eax
  sbb %eax, %eax
.endm

# bl
.macro bl_
  lit_ 32
.endm

# true
.macro true_
  or $-1, %eax
.endm


.macro lshift_
  x_w_
  w_d_
  shl %cl, %eax
.endm

.macro rshift_
  x_w_
  w_d_
  shr %cl, %eax
.endm

# fetch value from memory pointed to by working register and store in register

# @
.macro mw_
  movl (%eax), %eax
.endm

# a=@
.macro a_mw_
  movl (%eax), %esi
.endm

# b=@
.macro b_mw_
  movl (%eax), %edi
.endm

# x=@
.macro x_mw_
  movl (%eax), %ecx
.endm

# y=@
.macro y_mw_
  movl (%eax), %edx
.endm

# h@
.macro hmw_
  movsxw (%eax), %eax
.endm

# a=h@
.macro a_hmw_
  movsxw (%eax), %esi
.endm

# b=h@
.macro b_hmw_
  movsxw (%eax), %edi
.endm

# x=h@
.macro x_hmw_
  movsxw (%eax), %ecx
.endm

# y=h@
.macro y_hmw_
  movsxw (%eax), %edx
.endm

# c@
.macro cmw_
  movsxb (%eax), %eax
.endm

# a=c@
.macro a_cmw_
  movsxb (%eax), %esi
.endm

# b=c@
.macro b_cmw_
  movsxb (%eax), %edi
.endm

# x=c@
.macro x_cmw_
  movsxb (%eax), %ecx
.endm

# y=c@
.macro y_cmw_
  movsxb (%eax), %edx
.endm


# store register in memory pointed to by working register

# @=y
.macro mw_y_
  movl %edx, (%eax)
.endm

# @=x
.macro mw_x_
  movl %ecx, (%eax)
.endm

# @=a
.macro mw_a_
  movl %esi, (%eax)
.endm

# @=b
.macro mw_b_
  movl %edi, (%eax)
.endm

# store register in memory pointed to by working register

# h@=y
.macro hmw_y_
  movw %dx, (%eax)     
.endm

# h@=x
.macro hmw_x_
  movw %cx, (%eax)     
.endm

# h@=a
.macro hmw_a_
  movw %si, (%eax)     
.endm

# h@=b
.macro hmw_b_
  movw %di, (%eax)     
.endm

# c@=x
.macro cmw_x_
  movb %cl, (%eax)     
.endm

# c@=y
.macro cmw_y_
  movb %dl, (%eax)     
.endm

# a=
.macro a_w_
  mov %eax, %esi
.endm

# b=
.macro b_w_
  mov %eax, %edi
.endm

# x=
.macro x_w_
  mov %eax, %ecx
.endm

# y=
.macro y_w_
  mov %eax, %edx
.endm

# a
.macro a_
  mov %esi, %eax
.endm

# b
.macro b_
  mov %edi, %eax
.endm

# x
.macro x_
  mov %ecx, %eax
.endm

# y
.macro y_
  mov %edx, %eax
.endm

# @a
.macro ma_
  movl (%esi), %eax
.endm

# @a=
.macro ma_w_
  mov %eax, (%esi)
.endm

# @b
.macro mb_
  movl (%edi), %eax
.endm

# @b=
.macro mb_w_
  mov %eax, (%edi)
.endm

# @x
.macro mx_
  movl (%ecx), %eax
.endm

# @x=
.macro mx_w_
  mov %eax, (%ecx)
.endm

# @x=
.macro mx_y_
  mov %edx, (%ecx)
.endm

# @x=a
.macro mx_a_
  mov %esi, (%ecx)
.endm

# @x=b
.macro mx_b_
  mov %edi, (%ecx)
.endm

# @y
.macro my_
  movl (%edx), %eax
.endm

# @y=
.macro my_w_
  mov %eax, (%edx)
.endm

# h@a
.macro hma_
  movsxw (%esi), %eax
.endm

# h@a=
.macro hma_w_
  movw %ax, (%esi)
.endm

# h@b
.macro hmb_
  movsxw (%edi), %eax
.endm

# h@b=
.macro hmb_w_
  movw %ax, (%edi)
.endm

# h@x
.macro hmx_
  movsxw (%ecx), %eax
.endm

# h@x=
.macro hmx_w_
  movw %ax, (%ecx)
.endm

# h@y
.macro hmy_
  movsxw (%edx), %eax
.endm

# h@y=
.macro hmy_w_
  movw %ax, (%edx)
.endm

# c@a
.macro cma_
  movsxb (%esi), %eax
.endm

# c@a=
.macro cma_w_
  movb %al, (%esi)
.endm

# c@b
.macro cmb_
  movsxb (%edi), %eax
.endm

# c@b=
.macro cmb_w_
  movb %al, (%edi)
.endm

# c@x
.macro cmx_
  movsxb (%ecx), %eax
.endm

# c@x=
.macro cmx_w_
  movb %al, (%ecx)
.endm

# c@y
.macro cmy_
  movsxb (%edx), %eax
.endm

# c@y=
.macro cmy_w_
  movb %al, (%edx)
.endm

# a+4
.macro a_plus_4_
  add $4, %esi
.endm

# b+4
.macro b_plus_4_
  add $4, %edi
.endm

# x+4
.macro x_plus_4_
  add $4, %ecx
.endm

# y+4
.macro y_plus_4_
  add $4, %edx
.endm

# a-4
.macro a_sub_4_
  sub $4, %esi
.endm

# b-4
.macro b_sub_4_
  sub $4, %edi
.endm

# x-4
.macro x_sub_4_
  sub $4, %ecx
.endm

# y-4
.macro y_sub_4_
  sub $4, %edx
.endm

# a+2
.macro a_plus_2_
  add $2, %esi
.endm

# b+2
.macro b_plus_2_
  add $2, %edi
.endm

# x+2
.macro x_plus_2_
  add $2, %ecx
.endm

# y+2
.macro y_plus_2_
  add $2, %edx
.endm

# a-2
.macro a_sub_2_
  sub $2, %esi
.endm

# b-2
.macro b_sub_2_
  sub $2, %edi
.endm

# x-2
.macro x_sub_2_
  sub $2, %ecx
.endm

# y-2
.macro y_sub_2_
  sub $2, %edx
.endm

# a+1
.macro a_plus_1_
  inc %esi
.endm

# b+1
.macro b_plus_1_
  inc %edi
.endm

# x+1
.macro x_plus_1_
  inc %ecx
.endm

# y+1
.macro y_plus_1_
  inc %edx
.endm

# a-1
.macro a_sub_1_
  dec %esi
.endm

# b-1
.macro b_sub_1_
  dec %edi
.endm

# x-1
.macro x_sub_1_
  dec %ecx
.endm

# y-1
.macro y_sub_1_
  dec %edx
.endm

# if zero flag then go to addr
.macro ifz_ addr
  je \addr
.endm

# if not zero flag then go to addr
.macro ifnz_ addr
  jne \addr
.endm

.macro do_ addr
  call \addr
.endm

.macro exit_
  ret
.endm

.macro exit_do_ addr
  jmp \addr
.endm

.macro goto_ addr
  jmp \addr
.endm

.macro end_
  ret
.endm

.macro end_goto_ addr
  jmp \addr
.endm

.macro end_do_ addr
  jmp \addr
.endm

.macro end_next_
.endm


.macro ascii_ str, flg=0
  #.p2align 1 # Align to even locations
  .byte (8f - 7f)
  .byte \flg
7:  .ascii "\str"
8:
  #.p2align 1
.endm

.macro slit_ str
    call DOSLIT
    ascii_ "\str"
.endm

.macro type_ str
    slit_ "\str"
    call TYPE
.endm


.macro Forthword_ lbl, flags, name
.data
VE_\lbl:
    ascii_ "\name", HFLAGS & ~(\flags)
    .long VE_HEAD
    .long \lbl
    .set VE_HEAD, VE_\lbl
.text
\lbl:
.endm
