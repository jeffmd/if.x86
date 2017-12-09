# macros.S

# tos -> %eax # parameter top of stack [TOS] register
# dsp -> %ebx # holds the Forth Parameter/Data stack pointer
# areg -> %esi # A register used for memory pointer operations - non-volatile: user must preserve
# breg -> %edi # B register used for general purpose operations - non-volatile: user must preserve
# creg -> %ecx # C register used for general purpose operations 
# dreg -> %edx # D register used as a temp register
# sysvar -> %ebp # system variables base pointer
# temporary registers %ecx, %edx,

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

.macro rpushsp_
  pushl %ebx
.endm

.macro rpushd0_
  pushl (%ebx)
.endm

.macro rpushd1_
  pushl 4(%ebx)
.endm

.macro rpushd2_
  pushl 8(%ebx)
.endm

.macro rpop_
  pop %eax
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

.macro rnip_
  leal 4(%esp), %esp
.endm

.macro rnip2_
  leal 8(%esp), %esp
.endm

.macro rnip3_
  leal 12(%esp), %esp
.endm

.macro rtop1_
  leal -4(%esp), %esp
.endm

.macro rtop2_
  leal -8(%esp), %esp
.endm

.macro rtop3_
  leal -12(%esp), %esp
.endm

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

.macro rp_
  movl %esp, %eax
.endm

.macro str_rp_
  movl %eax, %esp
.endm

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

.macro top1_ # move stack pointer down one cell
  leal -4(%ebx), %ebx
.endm

.macro top2_ # move stack pointer down two cells
  leal -8(%ebx), %ebx
.endm

.macro top3_ # move stack pointer down three cells
  leal -12(%ebx), %ebx
.endm

.macro push_ # save WR on data stack
  top1_
  str_d0_
.endm

.macro push2_ # save WR on data stack
  top2_
  str_d0_
  str_d1_
.endm

.macro pusha_ # save a on data stack
  top1_
  a_str_d0_
.endm

.macro pushb_ # save b on data stack
  top1_
  b_str_d0_
.endm

.macro pushx_ # save x on data stack
  top1_
  x_str_d0_
.endm

.macro pushy_ # save y on data stack
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

.macro pop_ # load WR from stack, increment stack pointer
  d0_
  nip_
.endm

.macro popa_
  d0_str_a_
  nip_
.endm

.macro popb_
  d0_str_b_
  nip_
.endm

.macro popx_
  d0_str_x_
  nip_
.endm

.macro popy_
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

.macro addy_
  addl %edx, %eax
.endm

.macro addx_
  addl %ecx, %eax
.endm

.macro adda_
  addl %esi, %eax
.endm

.macro addb_
  addl %edi, %eax
.endm

.macro minusy_
  sub %edx, %eax
.endm

.macro minusx_
  sub %ecx, %eax
.endm

.macro minusa_
  sub %esi, %eax
.endm

.macro minusb_
  sub %edi, %eax
.endm

.macro neg_
  neg %eax
.endm

.macro negy_
  neg %edx
.endm

.macro negx_
  neg %ecx
.endm

.macro nega_
  neg %esi
.endm

.macro negb_
  neg %edi
.endm

.macro andy_
  and %edx, %eax
.endm

.macro andx_
  and %ecx, %eax
.endm

.macro anda_
  and %esi, %eax
.endm

.macro andb_
  and %edi, %eax
.endm

.macro ory_
  or %edx, %eax
.endm

.macro orx_
  or %ecx, %eax
.endm

.macro ora_
  or %esi, %eax
.endm

.macro orb_
  or %edi, %eax
.endm

.macro xor_
  xor (%ebx), %eax
  nip_
.endm

.macro not_
  not %eax
.endm

.macro noty_
  not %edx
.endm

.macro notx_
  not %ecx
.endm

.macro nota_
  not %esi
.endm

.macro notb_
  not %edi
.endm

.macro user_ sym
  leal (\sym-sysvar_base)(%ebp), %eax
.endm

# Push constant on datastack
.macro lit_ val
  movl $\val, %eax
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

.macro fetch_
  movl (%eax), %eax
.endm

.macro store_
  popy_
  movl %edx, (%eax)
.endm

.macro zero_str_
  xor %edx, %edx
  movl %edx, (%eax)
.endm

.macro plus_str_
  popy_
  addl  %edx, (%eax)   
.endm

.macro oneminus_str_
  subl  $1, (%eax)
.endm

.macro oneplus_str_
  addl  $1, (%eax)
.endm

.macro hfetch_
  movsxw (%eax), %eax
.endm

.macro hstore_
  popy_
  movw %dx, (%eax)     
.endm

.macro zero_hstr_
  movw $0, (%eax)
.endm

.macro plus_hstr_
  popy_
  addw %dx, (%eax)
.endm

.macro oneplus_hstr_
  addw  $1, (%eax)
.endm

.macro cfetch_
  movsxb (%eax), %eax
.endm

.macro cstr_
  popy_
  movb %dl, (%eax)
.endm

.macro zero_cstr_
  movb $0, (%eax)
.endm

.macro plus_cstr_
  popy_
  addb %dl, (%eax)
.endm

.macro oneplus_cstr_
  addb $1, (%eax)
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

.macro aplus4_
  add $4, %esi
.endm

.macro bplus4_
  add $4, %edi
.endm

.macro xplus4_
  add $4, %ecx
.endm

.macro yplus4_
  add $4, %edx
.endm

.macro aminus4_
  sub $4, %esi
.endm

.macro bminus4_
  sub $4, %edi
.endm

.macro xminus4_
  sub $4, %ecx
.endm

.macro yminus4_
  sub $4, %edx
.endm

.macro aplus2_
  add $2, %esi
.endm

.macro bplus2_
  add $2, %edi
.endm

.macro xplus2_
  add $2, %ecx
.endm

.macro yplus2_
  add $2, %edx
.endm

.macro aminus2_
  sub $2, %esi
.endm

.macro bminus2_
  sub $2, %edi
.endm

.macro xminus2_
  sub $2, %ecx
.endm

.macro yminus2_
  sub $2, %edx
.endm

.macro aplus1_
  inc %esi
.endm

.macro bplus1_
  inc %edi
.endm

.macro xplus1_
  inc %ecx
.endm

.macro yplus1_
  inc %ecx
.endm

.macro aminus1_
  dec %esi
.endm

.macro bminus1_
  dec %edi
.endm

.macro xminus1_
  dec %ecx
.endm

.macro yminus1_
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

.macro $lit_ str
    call DOSLIT
    ascii_ "\str"
.endm

.macro type_ str
    $lit_ "\str"
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
