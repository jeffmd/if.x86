# macros.S

# tos -> %eax # parameter top of stack [TOS] register
# dsp -> %ebx # holds the Forth Parameter/Data stack pointer
# areg -> %esi # A register used for memory pointer operations
# breg -> %edi # B register used for general purpose operations
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

.macro rpushc_
  pushl %ecx
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

.macro rpushd_
  pushl %edx
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

.macro rpopc_ 
  popl %ecx
.endm

.macro rpopd_ 
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

.macro r0_str_a_
  movl (%esp), %esi
.endm

.macro r0_str_b_
  movl (%esp), %edi
.endm

.macro r0_str_c_
  movl (%esp), %ecx
.endm

.macro r0_str_d_
  movl (%esp), %edx
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

.macro c_str_r0_
  movl %ecx, (%esp)
.endm

.macro d_str_r0_
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

.macro c_str_r1_
  movl %ecx, 4(%esp)
.endm

.macro d_str_r1_
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

.macro c_str_r2_
  movl %ecx, 8(%esp)
.endm

.macro d_str_r2_
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

.macro c_str_d0_
  mov %ecx, (%ebx)
.endm

.macro d_str_d0_
  mov %edx, (%ebx)
.endm

.macro a_str_d1_
  mov %esi, 4(%ebx)
.endm

.macro b_str_d1_
  mov %edi, 4(%ebx)
.endm

.macro c_str_d1_
  mov %ecx, 4(%ebx)
.endm

.macro d_str_d1_
  mov %edx, 4(%ebx)
.endm

.macro a_str_d2_
  mov %esi, 8(%ebx)
.endm

.macro b_str_d2_
  mov %edi, 8(%ebx)
.endm

.macro c_str_d2_
  mov %ecx, 8(%ebx)
.endm

.macro d_str_d2_
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

.macro d0_str_c_ 
  movl (%ebx), %ecx
.endm

.macro d1_str_c_ 
  movl 4(%ebx), %ecx
.endm

.macro d2_str_c_ 
  movl 8(%ebx), %ecx
.endm

.macro d0_str_d_ 
  movl (%ebx), %edx
.endm

.macro d1_str_d_ 
  movl 4(%ebx), %edx
.endm

.macro d2_str_d_ 
  movl 8(%ebx), %edx
.endm

.macro dtop1_ # move stack pointer down one cell
  leal -4(%ebx), %ebx
.endm

.macro dtop2_ # move stack pointer down two cells
  leal -8(%ebx), %ebx
.endm

.macro dtop3_ # move stack pointer down three cells
  leal -12(%ebx), %ebx
.endm


.macro dpush_ # save tos on data stack
  dtop1_
  str_d0_
.endm

.macro dnip_
  leal 4(%ebx), %ebx
.endm

.macro dnip2_
  leal 8(%ebx), %ebx
.endm

.macro dnip3_
  leal 12(%ebx), %ebx
.endm

.macro dpop_ # load tos from stack, increment stack pointer
  d0_
  dnip_
.endm

.macro d0popd_
  d0_str_d_
  dnip_
.endm

# test with bit constant
.macro bittest_ v
  test $\v, %eax
.endm

.macro swap_
  d0_str_d_
  str_d0_
  d_
.endm

.macro over_
  dpush_
  d1_
.endm

.macro sp_
  movl %ebx, %eax
.endm

.macro str_sp_
  movl %eax, %ebx
.endm

.macro dpop2_
  dnip_
  dpop_
.endm

.macro plus_
  d0popd_
  addl %edx, %eax
.endm

.macro minus_
  str_d_
  dpop_
  sub %edx, %eax
.endm

.macro neg_
  neg %eax
.endm

.macro and_
  and (%ebx), %eax
  dnip_
.endm

.macro or_
  or (%ebx), %eax
  dnip_
.endm

.macro xor_
  xor (%ebx), %eax
  dnip_
.endm

.macro not_
  not %eax
.endm

.macro douser_ sym
  leal (\sym-sysvar_base)(%ebp), %eax
  ret
.endm

# Push constant on datastack
.macro dolit_ val
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

.macro zeroless_
  sar $31, %eax    # Turn MSB into 0xffffffff or 0x00000000
.endm

.macro zero_
  xor %eax, %eax
.endm

.macro zeroequal_
  sub $1, %eax
  sbb %eax, %eax
.endm

.macro one_
  dolit_ 1
.endm

.macro two_
  dolit_ 2
.endm

.macro four_
  dolit_ 4
.endm

.macro ten_
  dolit_ 10
.endm

.macro bl_
  dolit_ 32
.endm

.macro true_
  or $-1, %eax
.endm

.macro lshift_
  str_c_
  dpop_
  shl %cl, %eax
.endm

.macro rshift_
  str_c_
  dpop_
  shr %cl, %eax
.endm

.macro fetch_
  movl (%eax), %eax
.endm

.macro store_
  d0popd_
  movl %edx, (%eax)
.endm

.macro zero_str_
  xor %edx, %edx
  movl %edx, (%eax)
.endm

.macro plus_str_
  d0_str_d_
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
  d0popd_
  movw %dx, (%eax)     
.endm

.macro zero_hstr_
  movw $0, (%eax)
.endm

.macro plus_hstr_
  d0popd_
  addw %dx, (%eax)
.endm

.macro oneplus_hstr_
  addw  $1, (%eax)
.endm

.macro cfetch_
  movsxb (%eax), %eax
.endm

.macro cstr_
  d0popd_
  movb %dl, (%eax)
.endm

.macro zero_cstr_
  movb $0, (%eax)
.endm

.macro plus_cstr_
  d0popd_
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

.macro str_c_
  mov %eax, %ecx
.endm

.macro str_d_
  mov %eax, %edx
.endm

.macro a_
  mov %esi, %eax
.endm

.macro b_
  mov %edi, %eax
.endm

.macro c_
  mov %ecx, %eax
.endm

.macro d_
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

.macro aplus_
  add $4, %esi
.endm

.macro bplus_
  add $4, %edi
.endm

.macro ahplus_
  add $2, %esi
.endm

.macro bhplus_
  add $2, %edi
.endm

.macro acplus_
  inc %esi
.endm

.macro bcplus_
  inc %edi
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
