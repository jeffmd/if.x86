# macros.S

# wreg -> %eax # W register and also considered Top of Stack
# dsp -> %ebx # holds the Forth Parameter/Data stack pointer
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

.macro rpush_a_ 
  pushl %esi
.endm

.macro rpush_b_
  pushl %edi
.endm

.macro rpush_x_
  pushl %ecx
.endm

.macro rpush_y_
  pushl %edx
.endm

.macro rpush_sp_
  pushl %ebx
.endm

# pop value from return stack into register

.macro rpop_
  popl %eax
.endm

.macro rpop_a_ 
  popl %esi
.endm

.macro rpop_b_ 
  popl %edi
.endm

.macro rpop_x_ 
  popl %ecx
.endm

.macro rpop_y_ 
  popl %edx
.endm

.macro rpop_sp_ 
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

.macro r0_str_a_
  movl (%esp), %esi
.endm

.macro r0_str_b_
  movl (%esp), %edi
.endm

.macro r0_str_x_
  movl (%esp), %ecx
.endm

.macro r0_str_y_
  movl (%esp), %edx
.endm

.macro r1_str_a_
  movl 4(%esp), %esi
.endm

.macro r1_str_b_
  movl 4(%esp), %edi
.endm

.macro r1_str_x_
  movl 4(%esp), %ecx
.endm

.macro r1_str_y_
  movl 4(%esp), %edx
.endm

.macro r2_str_a_
  movl 8(%esp), %esi
.endm

.macro r2_str_b_
  movl 8(%esp), %edi
.endm

.macro r2_str_x_
  movl 8(%esp), %ecx
.endm

.macro r2_str_y_
  movl 8(%esp), %edx
.endm

.macro str_r0_
  movl %eax, (%esp)
.endm

# store register value in return stack

.macro a_str_r0_
  movl %esi, (%esp)
.endm

.macro b_str_r0_
  movl %edi, (%esp)
.endm

.macro x_str_r0_
  movl %ecx, (%esp)
.endm

.macro y_str_r0_
  movl %edx, (%esp)
.endm

.macro str_r1_
  movl %eax, 4(%esp)
.endm

.macro a_str_r1_
  movl %esi, 4(%esp)
.endm

.macro b_str_r1_
  movl %edi, 4(%esp)
.endm

.macro x_str_r1_
  movl %ecx, 4(%esp)
.endm

.macro y_str_r1_
  movl %edx, 4(%esp)
.endm

.macro str_r2_
  movl %eax, 8(%esp)
.endm

.macro a_str_r2_
  movl %esi, 8(%esp)
.endm

.macro b_str_r2_
  movl %edi, 8(%esp)
.endm

.macro x_str_r2_
  movl %ecx, 8(%esp)
.endm

.macro y_str_r2_
  movl %edx, 8(%esp)
.endm

# store return stack register in register
 
.macro rp_
  movl %esp, %eax
.endm

.macro rp_str_x_
  movl %esp, %edx
.endm

.macro rp_str_y_
  movl %esp, %edx
.endm

.macro rp_str_a_
  movl %esp, %esi
.endm

.macro rp_str_b_
  movl %esp, %edi
.endm

.macro str_rp_
  movl %eax, %esp
.endm

# load working register with value from return stack location

.macro r0_ # load tos from stack
  movl (%esp), %eax
.endm

.macro r1_ # load tos from stack
  movl 4(%esp), %eax
.endm

.macro r2_ # load tos from stack
  movl 8(%esp), %eax
.endm

.macro str_d0_
  mov %eax, (%ebx)
.endm

.macro d0_ # load tos from stack
  movl (%ebx), %eax
.endm

.macro str_d1_
  mov %eax, 4(%ebx)
.endm

.macro d1_ # load tos from stack
  movl 4(%ebx), %eax
.endm

.macro str_d2_
  mov %eax, 8(%ebx)
.endm

.macro d2_ # load tos from stack
  movl 8(%ebx), %eax
.endm

.macro a_str_d0_
  mov %esi, (%ebx)
.endm

.macro b_str_d0_
  mov %edi, (%ebx)
.endm

.macro x_str_d0_
  mov %ecx, (%ebx)
.endm

.macro y_str_d0_
  mov %edx, (%ebx)
.endm

.macro a_str_d1_
  mov %esi, 4(%ebx)
.endm

.macro b_str_d1_
  mov %edi, 4(%ebx)
.endm

.macro x_str_d1_
  mov %ecx, 4(%ebx)
.endm

.macro y_str_d1_
  mov %edx, 4(%ebx)
.endm

.macro a_str_d2_
  mov %esi, 8(%ebx)
.endm

.macro b_str_d2_
  mov %edi, 8(%ebx)
.endm

.macro x_str_d2_
  mov %ecx, 8(%ebx)
.endm

.macro y_str_d2_
  mov %edx, 8(%ebx)
.endm

.macro d0_str_a_ 
  movl (%ebx), %esi
.endm

.macro d1_str_a_ 
  movl 4(%ebx), %esi
.endm

.macro d2_str_a_ 
  movl 8(%ebx), %esi
.endm

.macro d0_str_b_ 
  movl (%ebx), %edi
.endm

.macro d1_str_b_ 
  movl 4(%ebx), %edi
.endm

.macro d2_str_b_ 
  movl 8(%ebx), %edi
.endm

.macro d0_str_x_ 
  movl (%ebx), %ecx
.endm

.macro d1_str_x_ 
  movl 4(%ebx), %ecx
.endm

.macro d2_str_x_ 
  movl 8(%ebx), %ecx
.endm

.macro d0_str_y_ 
  movl (%ebx), %edx
.endm

.macro d1_str_y_ 
  movl 4(%ebx), %edx
.endm

.macro d2_str_y_ 
  movl 8(%ebx), %edx
.endm

# make space on data stack

.macro top1_ # move stack pointer down one cell
  leal -4(%ebx), %ebx
.endm

.macro top2_ # move stack pointer down two cells
  leal -8(%ebx), %ebx
.endm

.macro top3_ # move stack pointer down three cells
  leal -12(%ebx), %ebx
.endm

# push register on data stack

.macro push_ # save WR on data stack
  top1_
  str_d0_
.endm

.macro push2_ # save WR on data stack
  top2_
  str_d0_
  str_d1_
.endm

.macro push_a_ # save a on data stack
  top1_
  a_str_d0_
.endm

.macro push_b_ # save b on data stack
  top1_
  b_str_d0_
.endm

.macro push_x_ # save x on data stack
  top1_
  x_str_d0_
.endm

.macro push_y_ # save y on data stack
  top1_
  y_str_d0_
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

.macro pop_a_
  d0_str_a_
  nip_
.endm

.macro pop_b_
  d0_str_b_
  nip_
.endm

.macro pop_x_
  d0_str_x_
  nip_
.endm

.macro pop_y_
  d0_str_y_
  nip_
.endm

# test with bit constant
.macro bittest_ v
  test $\v, %eax
.endm

.macro swap_
  d0_str_y_
  str_d0_
  y_
.endm

.macro over_
  push_
  d1_
.endm

.macro sp_
  movl %ebx, %eax
.endm

.macro str_sp_
  movl %eax, %ebx
.endm

.macro pop2_
  nip_
  pop_
.endm

.macro plus_y_
  addl %edx, %eax
.endm

.macro plus_x_
  addl %ecx, %eax
.endm

.macro plus_a_
  addl %esi, %eax
.endm

.macro plus_b_
  addl %edi, %eax
.endm

.macro y_plus_
  addl %eax, %edx
.endm

.macro x_plus_
  addl %eax, %ecx
.endm

.macro a_plus_
  addl %eax, %esi
.endm

.macro b_plus_
  addl %eax, %edi
.endm

.macro minus_y_
  sub %edx, %eax
.endm

.macro minus_x_
  sub %ecx, %eax
.endm

.macro minus_a_
  sub %esi, %eax
.endm

.macro minus_b_
  sub %edi, %eax
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

.macro and_y_
  and %edx, %eax
.endm

.macro and_x_
  and %ecx, %eax
.endm

.macro and_a_
  and %esi, %eax
.endm

.macro and_b_
  and %edi, %eax
.endm

.macro or_y_
  or %edx, %eax
.endm

.macro or_x_
  or %ecx, %eax
.endm

.macro or_a_
  or %esi, %eax
.endm

.macro or_b_
  or %edi, %eax
.endm

.macro xor_y_
  xor %edx, %eax
.endm

.macro xor_x_
  xor %ecx, %eax
.endm

.macro xor_a_
  xor %esi, %eax
.endm

.macro xor_b_
  xor %edi, %eax
.endm

.macro not_
  not %eax
.endm

.macro not_y_
  not %edx
.endm

.macro not_x_
  not %ecx
.endm

.macro not_a_
  not %esi
.endm

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

.macro oneplus_
  inc %eax
.endm

.macro oneminus_
  dec %eax
.endm

.macro twoplus_
  add $2, %eax
.endm

.macro fourplus_
  add $4, %eax
.endm

.macro twominus_
  sub $2, %eax
.endm

.macro fourminus_
  sub $4, %eax
.endm

.macro twoslash_
  sar %eax
.endm

.macro fourslash_
  sar $2, %eax
.endm

.macro twostar_
  sal %eax
.endm

.macro fourstar_
  sal $2, %eax
.endm

.macro iszero_
  or %eax, %eax
.endm

.macro a_iszero_
  or %esi, %esi
.endm

.macro b_iszero_
  or %edi, %edi
.endm

.macro x_iszero_
  or %ecx, %ecx
.endm

.macro y_iszero_
  or %edx, %edx
.endm

.macro zeroless_
  sar $31, %eax    # Turn MSB into 0xffffffff or 0x00000000
.endm

.macro zero_
  xor %eax, %eax
.endm

.macro zero_a_
  xor %esi, %esi 
.endm

.macro zero_b_
  xor %edi, %edi 
.endm

.macro zero_x_
  xor %ecx, %ecx
.endm

.macro zero_y_
  xor %edx, %edx
.endm

.macro zeroequal_
  sub $1, %eax
  sbb %eax, %eax
.endm

.macro one_
  lit_ 1
.endm

.macro two_
  lit_ 2
.endm

.macro four_
  lit_ 4
.endm

.macro ten_
  lit_ 10
.endm

.macro bl_
  lit_ 32
.endm

.macro true_
  or $-1, %eax
.endm

.macro lshift_
  str_x_
  pop_
  shl %cl, %eax
.endm

.macro rshift_
  str_x_
  pop_
  shr %cl, %eax
.endm

# fetch value from memory pointed to by working register and store in register

.macro fetch_
  movl (%eax), %eax
.endm

.macro fetch_str_a_
  movl (%eax), %esi
.endm

.macro fetch_str_b_
  movl (%eax), %edi
.endm

.macro fetch_str_x_
  movl (%eax), %ecx
.endm

.macro fetch_str_y_
  movl (%eax), %edx
.endm

.macro hfetch_
  movsxw (%eax), %eax
.endm

.macro hfetch_str_a_
  movsxw (%eax), %esi
.endm

.macro hfetch_str_b_
  movsxw (%eax), %edi
.endm

.macro hfetch_str_x_
  movsxw (%eax), %ecx
.endm

.macro hfetch_str_y_
  movsxw (%eax), %edx
.endm

.macro cfetch_
  movsxb (%eax), %eax
.endm

.macro cfetch_str_a_
  movsxb (%eax), %esi
.endm

.macro cfetch_str_b_
  movsxb (%eax), %edi
.endm

.macro cfetch_str_x_
  movsxb (%eax), %ecx
.endm

.macro cfetch_str_y_
  movsxb (%eax), %edx
.endm


# store register in memory pointed to by working register

.macro yw_str_
  movl %edx, (%eax)
.endm

.macro xw_str_
  movl %ecx, (%eax)
.endm

.macro aw_str_
  movl %esi, (%eax)
.endm

.macro bw_str_
  movl %edi, (%eax)
.endm

.macro zero_str_
  xor %edx, %edx
  movl %edx, (%eax)
.endm

.macro y_plus_str_
  addl  %edx, (%eax)   
.endm

.macro x_plus_str_
  addl  %ecx, (%eax)   
.endm

.macro a_plus_str_
  addl  %esi, (%eax)   
.endm

.macro b_plus_str_
  addl  %edi, (%eax)   
.endm

.macro oneminus_str_
  subl  $1, (%eax)
.endm

.macro oneplus_str_
  addl  $1, (%eax)
.endm

# store register in memory pointed to by working register

.macro yw_hstr_
  movw %dx, (%eax)     
.endm

.macro xw_hstr_
  movw %cx, (%eax)     
.endm

.macro aw_hstr_
  movw %si, (%eax)     
.endm

.macro bw_hstr_
  movw %di, (%eax)     
.endm

.macro zero_hstr_
  movw $0, (%eax)
.endm

.macro y_plus_hstr_
  addw %dx, (%eax)
.endm

.macro x_plus_hstr_
  addw %cx, (%eax)
.endm

.macro a_plus_hstr_
  addw %si, (%eax)
.endm

.macro b_plus_hstr_
  addw %di, (%eax)
.endm

.macro oneplus_hstr_
  addw  $1, (%eax)
.endm

.macro oneminus_hstr_
  subw  $1, (%eax)
.endm

.macro yw_cstr_
  movb %dl, (%eax)
.endm

.macro xw_cstr_
  movb %cl, (%eax)
.endm

.macro zero_cstr_
  movb $0, (%eax)
.endm

.macro y_plus_cstr_
  addb %dl, (%eax)
.endm

.macro x_plus_cstr_
  addb %cl, (%eax)
.endm

.macro y_minus_cstr_
  subb %dl, (%eax)
.endm

.macro x_minus_cstr_
  subb %cl, (%eax)
.endm

.macro oneplus_cstr_
  addb $1, (%eax)
.endm

.macro oneminus_cstr_
  subb $1, (%eax)
.endm

.macro str_a_
  mov %eax, %esi
.endm

.macro str_b_
  mov %eax, %edi
.endm

.macro str_x_
  mov %eax, %ecx
.endm

.macro str_y_
  mov %eax, %edx
.endm

.macro a_
  mov %esi, %eax
.endm

.macro b_
  mov %edi, %eax
.endm

.macro x_
  mov %ecx, %eax
.endm

.macro y_
  mov %edx, %eax
.endm

.macro a_fetch_
  movl (%esi), %eax
.endm

.macro a_str_
  mov %eax, (%esi)
.endm

.macro b_fetch_
  movl (%edi), %eax
.endm

.macro b_str_
  mov %eax, (%edi)
.endm

.macro x_fetch_
  movl (%ecx), %eax
.endm

.macro x_str_
  mov %eax, (%ecx)
.endm

.macro y_fetch_
  movl (%edx), %eax
.endm

.macro y_str_
  mov %eax, (%edx)
.endm

.macro a_hfetch_
  movsxw (%esi), %eax
.endm

.macro a_hstr_
  movw %ax, (%esi)
.endm

.macro b_hfetch_
  movsxw (%edi), %eax
.endm

.macro b_hstr_
  movw %ax, (%edi)
.endm

.macro x_hfetch_
  movsxw (%ecx), %eax
.endm

.macro x_hstr_
  movw %ax, (%ecx)
.endm

.macro y_hfetch_
  movsxw (%edx), %eax
.endm

.macro y_hstr_
  movw %ax, (%edx)
.endm

.macro a_cfetch_
  movsxb (%esi), %eax
.endm

.macro a_cstr_
  movb %al, (%esi)
.endm

.macro b_cfetch_
  movsxb (%edi), %eax
.endm

.macro b_cstr_
  movb %al, (%edi)
.endm

.macro x_cfetch_
  movsxb (%ecx), %eax
.endm

.macro x_cstr_
  movb %al, (%ecx)
.endm

.macro y_cfetch_
  movsxb (%edx), %eax
.endm

.macro y_cstr_
  movb %al, (%edx)
.endm

.macro a_plus4_
  add $4, %esi
.endm

.macro b_plus4_
  add $4, %edi
.endm

.macro x_plus4_
  add $4, %ecx
.endm

.macro y_plus4_
  add $4, %edx
.endm

.macro a_minus4_
  sub $4, %esi
.endm

.macro b_minus4_
  sub $4, %edi
.endm

.macro x_minus4_
  sub $4, %ecx
.endm

.macro y_minus4_
  sub $4, %edx
.endm

.macro a_plus2_
  add $2, %esi
.endm

.macro b_plus2_
  add $2, %edi
.endm

.macro x_plus2_
  add $2, %ecx
.endm

.macro y_plus2_
  add $2, %edx
.endm

.macro a_minus2_
  sub $2, %esi
.endm

.macro b_minus2_
  sub $2, %edi
.endm

.macro x_minus2_
  sub $2, %ecx
.endm

.macro y_minus2_
  sub $2, %edx
.endm

.macro a_plus1_
  inc %esi
.endm

.macro b_plus1_
  inc %edi
.endm

.macro x_plus1_
  inc %ecx
.endm

.macro y_plus1_
  inc %edx
.endm

.macro a_minus1_
  dec %esi
.endm

.macro b_minus1_
  dec %edi
.endm

.macro x_minus1_
  dec %ecx
.endm

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
