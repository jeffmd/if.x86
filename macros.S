# macros.S

# tos -> %eax # parameter top of stack [TOS] register
# dsp -> %ebx # holds the Forth Parameter/Data stack pointer
# areg -> %esi # A register used for memory pointer operations
# breg -> %edi # B register used for general purpose operations
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

# Inline macros

.macro rpush_ # put copy of tos on return stack
  pushl %eax
.endm

.macro rpopnos_ # pop TOR into nos
  popl %edx
.endm

.macro rpop_
  pop %eax
.endm

.macro rnip_
  leal 4(%esp), %esp
.endm

.macro rfetch_
  movl (%esp), %eax
.endm

.macro rstore_
  movl %eax, (%esp)
.endm

.macro rpfetch_
  movl %esp, %eax
.endm

.macro rpstore_
  movl %eax, %esp
.endm

.macro r0store_
  mov %eax, (%ebx)
.endm

.macro r0fetch_ # load tos from stack
  movl (%esp), %eax
.endm

.macro r1store_
  mov %eax, 4(%esp)
.endm

.macro r1fetch_ # load tos from stack
  movl 4(%esp), %eax
.endm

.macro r2store_
  mov %eax, 8(%esp)
.endm

.macro r2fetch_ # load tos from stack
  movl 8(%esp), %eax
.endm


.macro d0store_
  mov %eax, (%ebx)
.endm

.macro d0fetch_ # load tos from stack
  movl (%ebx), %eax
.endm

.macro d1store_
  mov %eax, 4(%ebx)
.endm

.macro d1fetch_ # load tos from stack
  movl 4(%ebx), %eax
.endm

.macro d2store_
  mov %eax, 8(%ebx)
.endm

.macro d2fetch_ # load tos from stack
  movl 8(%ebx), %eax
.endm


.macro dpush_ # save tos on data stack
  leal -4(%ebx), %ebx
  d0store_
.endm

.macro dnip_
  leal 4(%ebx), %ebx
.endm

.macro d2nip_
  leal 8(%ebx), %ebx
.endm

.macro d3nip_
  leal 12(%ebx), %ebx
.endm

.macro dpop_ # load tos from stack, increment stack pointer
  d0fetch_
  dnip_
.endm

# test with bit constant
.macro bittest_ v
  test $\v, %eax
.endm

.macro swap_
  mov (%ebx), %edx
  mov %eax, (%ebx)
  mov %edx, %eax
.endm

.macro over_
  dpush_
  d1fetch_
.endm

.macro spfetch_
  movl %ebx, %eax
.endm

.macro spstore_
  movl %eax, %ebx
.endm

.macro d2pop_
  dnip_
  dpop_
.endm

.macro flip_
  mov 4(%ebx), %edx
  mov %eax, 4(%ebx)
  mov %edx, %eax
.endm

.macro rot_
  xchg %eax, (%ebx)
  xchg %eax, 4(%ebx)
.endm

.macro rrot_
  xchg %eax, 4(%ebx)
  xchg %eax, (%ebx)
.endm

.macro dpopnos_
  mov (%ebx), %edx
  dnip_
.endm

.macro pop2nos_
  mov (%ebx), %edx
  mov 4(%ebx), %ecx
  leal 8(%ebx), %ebx
.endm

.macro plus_
  dpopnos_
  addl %edx, %eax
.endm

.macro minus_
  movl %eax, %edx
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
  mov %eax, %ecx
  dpop_
  shl %cl, %eax
.endm

.macro rshift_
  mov %eax, %ecx
  dpop_
  shr %cl, %eax
.endm

.macro fetch_
  movl (%eax), %eax
.endm

.macro store_
  dpopnos_
  movl %edx, (%eax)
.endm

.macro zerostore_
  xor %edx, %edx
  movl %edx, (%eax)
.endm

.macro plusstore_
  dpopnos_
  addl  %edx, (%eax)   
.endm

.macro oneminusstore_
  subl  $1, (%eax)
.endm

.macro oneplusstore_
  addl  $1, (%eax)
.endm

.macro hfetch_
  movsxw (%eax), %eax
.endm

.macro hstore_
  dpopnos_
  movw %dx, (%eax)     
.endm

.macro zerohstore_
  movw $0, (%eax)
.endm

.macro plushstore_
  dpopnos_
  addw %dx, (%eax)
.endm

.macro oneplushstore_
  addw  $1, (%eax)
.endm

.macro cfetch_
  movsxb (%eax), %eax
.endm

.macro cstore_
  dpopnos_
  movb %dl, (%eax)
.endm

.macro zerocstore_
  movb $0, (%eax)
.endm

.macro pluscstore_
  dpopnos_
  addb %dl, (%eax)
.endm

.macro onepluscstore_
  addb $1, (%eax)
.endm

.macro d0toa_
  mov (%ebx), %esi
.endm

.macro d0tob_
  mov (%ebx), %edi
.endm

.macro d1toa_
  mov 4(%ebx), %esi
.endm

.macro d1tob_
  mov 4(%ebx), %edi
.endm

.macro d2toa_
  mov 8(%ebx), %esi
.endm

.macro d2tob_
  mov 8(%ebx), %edi
.endm

.macro toa_
  mov %eax, %esi
.endm

.macro tob_
  mov %eax, %edi
.endm


.macro geta_
  mov %esi, %eax
.endm

.macro getb_
  mov %edi, %eax
.endm

.macro afetch_
  movl (%esi), %eax
.endm

.macro astore_
  mov %eax, (%esi)
.endm

.macro bfetch_
  movl (%edi), %eax
.endm

.macro bstore_
  mov %eax, (%edi)
.endm

.macro ahfetch_
  movsxw (%esi), %eax
.endm

.macro ahstore_
  movw %ax, (%esi)
.endm

.macro bhfetch_
  movsxw (%edi), %eax
.endm

.macro acfetch_
  movsxb (%esi), %eax
.endm

.macro acstore_
  movb %al, (%esi)
.endm

.macro bcfetch_
  movsxb (%edi), %eax
.endm

.macro bcstore_
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
