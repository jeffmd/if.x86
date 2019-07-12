# macros.S

# wreg -> %eax # W register and also considered Top of Stack
# dp   -> %ebx # holds the Forth Parameter/Data stack pointer
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

.macro rpush_ 
  pushl %eax
.endm

.macro rpusha_ 
  pushl %esi
.endm

.macro rpushb_
  pushl %edi
.endm

.macro rpushx_
  pushl %ecx
.endm

.macro rpushy_
  pushl %edx
.endm

.macro rpushdp_
  pushl %ebx
.endm

# pop value from return stack into register

.macro rpop_
  popl %eax
.endm

.macro rpopa_ 
  popl %esi
.endm

.macro rpopb_ 
  popl %edi
.endm

.macro rpopx_ 
  popl %ecx
.endm

.macro rpopy_ 
  popl %edx
.endm

.macro rpopdp_ 
  popl %ebx
.endm

.macro rnip_
  leal 4(%esp), %esp
.endm

.macro rnip2_
  leal 8(%esp), %esp
.endm

.macro rnip3_
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

# r0=w
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

# r2=w
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

# rp
.macro rp_
  movl %esp, %eax
.endm

# rp=w
.macro rp_w_
  movl %eax, %esp
.endm

# d0=w
.macro d0_w_
  mov %eax, (%ebx)
.endm

# d0
.macro d0_ # load tos from stack
  movl (%ebx), %eax
.endm

# d1=w
.macro d1_w_
  mov %eax, 4(%ebx)
.endm

# d1
.macro d1_ # load tos from stack
  movl 4(%ebx), %eax
.endm

# d1=w
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

# push1
.macro push1_ # move stack pointer down one cell
  leal -4(%ebx), %ebx
.endm

# push2
.macro push2_ # move stack pointer down two cells
  leal -8(%ebx), %ebx
.endm

# push3
.macro push3_ # move stack pointer down three cells
  leal -12(%ebx), %ebx
.endm

# push register on data stack

.macro push_ # save WR on data stack
  push1_
  d0_w_
.endm

# pusha
.macro pusha_ # save a on data stack
  push1_
  d0_a_
.endm

# pushb
.macro pushb_ # save b on data stack
  push1_
  d0_b_
.endm

# pushx
.macro pushx_ # save x on data stack
  push1_
  d0_x_
.endm

# pushy
.macro pushy_ # save y on data stack
  push1_
  d0_y_
.endm

.macro nip_
  leal 4(%ebx), %ebx
.endm

.macro nip2_
  leal 8(%ebx), %ebx
.endm

.macro nip3_
  leal 12(%ebx), %ebx
.endm

# pop value from data stack into register

.macro pop_ # load WR from stack, increment stack pointer
  d0_
  nip_
.endm

.macro popa_
  a_d0_
  nip_
.endm

.macro popb_
  b_d0_
  nip_
.endm

.macro popx_
  x_d0_
  nip_
.endm

.macro popy_
  y_d0_
  nip_
.endm

# test with bit constant
.macro bittest_ v
  test $\v, %eax
.endm

# dp
.macro dp_
  movl %ebx, %eax
.endm

# dp=w
.macro dp_w_
  movl %eax, %ebx
.endm

# w+=y
.macro w_plus_y_
  addl %edx, %eax
.endm

# w+=x
.macro w_plus_x_
  addl %ecx, %eax
.endm

# w+=a
.macro w_plus_a_
  addl %esi, %eax
.endm

# w+=b
.macro w_plus_b_
  addl %edi, %eax
.endm

# y+=w
.macro y_plus_w_
  addl %eax, %edx
.endm

# y+=x
.macro y_plus_x_
  addl %ecx, %edx
.endm

# y+=a
.macro y_plus_a_
  addl %esi, %edx
.endm

# y+=b
.macro y_plus_b_
  addl %edi, %edx
.endm

# x+=w
.macro x_plus_w_
  addl %eax, %ecx
.endm

# x+=y
.macro x_plus_y_
  addl %edx, %ecx
.endm

# x+=a
.macro x_plus_a_
  addl %esi, %ecx
.endm

# x+=b
.macro x_plus_b_
  addl %edi, %ecx
.endm

# a+=w
.macro a_plus_w_
  addl %eax, %esi
.endm

# a+=b
.macro a_plus_b_
  addl %edi, %esi
.endm

# a+=x
.macro a_plus_x_
  addl %ecx, %esi
.endm

# a+=y
.macro a_plus_y_
  addl %edx, %esi
.endm

# b+=w
.macro b_plus_w_
  addl %eax, %edi
.endm

# b+=a
.macro b_plus_a_
  addl %esi, %edi
.endm

# b+=x
.macro b_plus_x_
  addl %ecx, %edi
.endm

# b+=y
.macro b_plus_y_
  addl %edx, %edi
.endm

# w-=y
.macro w_minus_y_
  sub %edx, %eax
.endm

# w-=x
.macro w_minus_x_
  sub %ecx, %eax
.endm

# w-=a
.macro w_minus_a_
  sub %esi, %eax
.endm

# w-=b
.macro w_minus_b_
  sub %edi, %eax
.endm

# y-=w
.macro y_minus_w_
  sub %eax, %edx
.endm

# y-=x
.macro y_minus_x_
  sub %ecx, %edx
.endm

# y-=a
.macro y_minus_a_
  sub %es5, %edx
.endm

# y-=b
.macro y_minus_b_
  sub %edi, %edx
.endm

# x-=w
.macro x_minus_w_
  sub %eax, %ecx
.endm

# x-=y
.macro x_minus_y_
  sub %edx, %ecx
.endm

# x-=a
.macro x_minus_a_
  sub %esi, %ecx
.endm

# x-=b
.macro x_minus_b_
  sub %edi, %ecx
.endm

# a-=w
.macro a_minus_w_
  sub %eax, %esi
.endm

# a-=b
.macro a_minus_b_
  sub %edi, %esi
.endm

# a-=x
.macro a_minus_x_
  sub %ecx, %esi
.endm

# a-=y
.macro a_minus_y_
  sub %edx, %esi
.endm

# b-=w
.macro b_minus_w_
  sub %eax, %edi
.endm

# b-=a
.macro b_minus_a_
  sub %esi, %edi
.endm

# b-=x
.macro b_minus_x_
  sub %ecx, %edi
.endm

# b-=y
.macro b_minus_y_
  sub %edx, %edi
.endm

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

# w&=y
.macro w_and_y_
  and %edx, %eax
.endm

# w&=x
.macro w_and_x_
  and %ecx, %eax
.endm

# w&=a
.macro w_and_a_
  and %esi, %eax
.endm

# w&=b
.macro w_and_b_
  and %edi, %eax
.endm

# w|=y
.macro w_or_y_
  or %edx, %eax
.endm

# w|=x
.macro w_or_x_
  or %ecx, %eax
.endm

# w|=a
.macro w_or_a_
  or %esi, %eax
.endm

# w|=b
.macro w_or_b_
  or %edi, %eax
.endm

# w^=y
.macro w_xor_y_
  xor %edx, %eax
.endm

# w^=x
.macro w_xor_x_
  xor %ecx, %eax
.endm

# w^=a
.macro w_xor_a_
  xor %esi, %eax
.endm

# w^=b
.macro w_xor_b_
  xor %edi, %eax
.endm

# ~
.macro not_
  not %eax
.endm

# ~y
.macro not_y_
  not %edx
.endm

# ~x
.macro not_x_
  not %ecx
.endm

# ~a
.macro not_a_
  not %esi
.endm

# ~b
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

# 1+
.macro oneplus_
  inc %eax
.endm

# 1-
.macro oneminus_
  dec %eax
.endm

# 2+
.macro twoplus_
  add $2, %eax
.endm

# 4+
.macro fourplus_
  add $4, %eax
.endm

# 2-
.macro twominus_
  sub $2, %eax
.endm

# 4-
.macro fourminus_
  sub $4, %eax
.endm

# 2/
.macro twoslash_
  sar %eax
.endm

# 4/
.macro fourslash_
  sar $2, %eax
.endm

# 2*
.macro twostar_
  sal %eax
.endm

# 4*
.macro fourstar_
  sal $2, %eax
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

# 1
.macro one_
  lit_ 1
.endm

# 2
.macro two_
  lit_ 2
.endm

# 4
.macro four_
  lit_ 4
.endm

# 10
.macro ten_
  lit_ 10
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
  pop_
  shl %cl, %eax
.endm

.macro rshift_
  x_w_
  pop_
  shr %cl, %eax
.endm

# fetch value from memory pointed to by working register and store in register

# @
.macro mw_
  movl (%eax), %eax
.endm

# a=@w
.macro a_mw_
  movl (%eax), %esi
.endm

# b=@w
.macro b_mw_
  movl (%eax), %edi
.endm

# x=@w
.macro x_mw_
  movl (%eax), %ecx
.endm

# y=@w
.macro y_mw_
  movl (%eax), %edx
.endm

# h@
.macro hmw_
  movsxw (%eax), %eax
.endm

# a=h@w
.macro a_hmw_
  movsxw (%eax), %esi
.endm

# b=h@w
.macro b_hmw_
  movsxw (%eax), %edi
.endm

# x=h@w
.macro x_hmw_
  movsxw (%eax), %ecx
.endm

# y=h@w
.macro y_hmw_
  movsxw (%eax), %edx
.endm

# c@
.macro cmw_
  movsxb (%eax), %eax
.endm

# a=c@w
.macro a_cmw_
  movsxb (%eax), %esi
.endm

# b=c@w
.macro b_cmw_
  movsxb (%eax), %edi
.endm

# x=c@w
.macro x_cmw_
  movsxb (%eax), %ecx
.endm

# y=c@w
.macro y_cmw_
  movsxb (%eax), %edx
.endm


# store register in memory pointed to by working register

# @w=y
.macro mw_y_
  movl %edx, (%eax)
.endm

# @w=x
.macro mw_x_
  movl %ecx, (%eax)
.endm

# @w=a
.macro mw_a_
  movl %esi, (%eax)
.endm

# @w=b
.macro mw_b_
  movl %edi, (%eax)
.endm

# store register in memory pointed to by working register

# h@w=y
.macro hmw_y_
  movw %dx, (%eax)     
.endm

# h@w=x
.macro hmw_x_
  movw %cx, (%eax)     
.endm

# h@w=a
.macro hmw_a_
  movw %si, (%eax)     
.endm

# h@w=b
.macro hmw_b_
  movw %di, (%eax)     
.endm

# c@w=x
.macro cmw_x_
  movb %cl, (%eax)     
.endm

# c@w=y
.macro cmw_y_
  movb %dl, (%eax)     
.endm

# a=w
.macro a_w_
  mov %eax, %esi
.endm

# b=w
.macro b_w_
  mov %eax, %edi
.endm

# x=w
.macro x_w_
  mov %eax, %ecx
.endm

# y=w
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

# @a=w
.macro ma_w_
  mov %eax, (%esi)
.endm

# @b
.macro mb_
  movl (%edi), %eax
.endm

# @b=w
.macro mb_w_
  mov %eax, (%edi)
.endm

# @x
.macro mx_
  movl (%ecx), %eax
.endm

# @x=w
.macro mx_w_
  mov %eax, (%ecx)
.endm

# @x=y
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

# @y=w
.macro my_w_
  mov %eax, (%edx)
.endm

# h@a
.macro hma_
  movsxw (%esi), %eax
.endm

# h@a=w
.macro hma_w_
  movw %ax, (%esi)
.endm

# h@b
.macro hmb_
  movsxw (%edi), %eax
.endm

# h@b=w
.macro hmb_w_
  movw %ax, (%edi)
.endm

# h@x
.macro hmx_
  movsxw (%ecx), %eax
.endm

# h@x=w
.macro hmx_w_
  movw %ax, (%ecx)
.endm

# h@y
.macro hmy_
  movsxw (%edx), %eax
.endm

# h@y=w
.macro hmy_w_
  movw %ax, (%edx)
.endm

# c@a
.macro cma_
  movsxb (%esi), %eax
.endm

# c@a=w
.macro cma_w_
  movb %al, (%esi)
.endm

# c@b
.macro cmb_
  movsxb (%edi), %eax
.endm

# c@b=w
.macro cmb_w_
  movb %al, (%edi)
.endm

# c@x
.macro cmx_
  movsxb (%ecx), %eax
.endm

# c@x=w
.macro cmx_w_
  movb %al, (%ecx)
.endm

# c@y
.macro cmy_
  movsxb (%edx), %eax
.endm

# c@y=w
.macro cmy_w_
  movb %al, (%edx)
.endm

# a+=4
.macro a_plus4_
  add $4, %esi
.endm

# b+=4
.macro b_plus4_
  add $4, %edi
.endm

# x+=4
.macro x_plus4_
  add $4, %ecx
.endm

# y+=4
.macro y_plus4_
  add $4, %edx
.endm

# a-=4
.macro a_minus4_
  sub $4, %esi
.endm

# b-=4
.macro b_minus4_
  sub $4, %edi
.endm

# x-=4
.macro x_minus4_
  sub $4, %ecx
.endm

# y-=4
.macro y_minus4_
  sub $4, %edx
.endm

# a+=2
.macro a_plus2_
  add $2, %esi
.endm

# b+=2
.macro b_plus2_
  add $2, %edi
.endm

# x+=2
.macro x_plus2_
  add $2, %ecx
.endm

# y+=2
.macro y_plus2_
  add $2, %edx
.endm

# a-=2
.macro a_minus2_
  sub $2, %esi
.endm

# b-=2
.macro b_minus2_
  sub $2, %edi
.endm

# x-=2
.macro x_minus2_
  sub $2, %ecx
.endm

# y-=2
.macro y_minus2_
  sub $2, %edx
.endm

# a+=1
.macro a_plus1_
  inc %esi
.endm

# b+=1
.macro b_plus1_
  inc %edi
.endm

# x+=1
.macro x_plus1_
  inc %ecx
.endm

# y+=1
.macro y_plus1_
  inc %edx
.endm

# a-=1
.macro a_minus1_
  dec %esi
.endm

# b-=1
.macro b_minus1_
  dec %edi
.endm

# x-=1
.macro x_minus1_
  dec %ecx
.endm

# y-=1
.macro y_minus1_
  dec %edx
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
