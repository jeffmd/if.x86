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

.macro dup_r_ # put copy of tos on return stack
  pushl %eax
.endm

.macro r_drop_ # drop TOR
  popl %edx
.endm

.macro dup_ # save tos on data stack
  leal -4(%ebx), %ebx
  mov %eax, (%ebx) 
.endm

.macro nip_
  leal 4(%ebx), %ebx
.endm

.macro dnip_
  leal 8(%ebx), %ebx
.endm

.macro dropdup_
  movl (%ebx), %eax
.endm

.macro drop_ # load tos from stack, same as drop
  dropdup_
  nip_
.endm

# test with bit constant
.macro bittest_ v
  test $\v, %eax
  drop_
.endm

.macro swap_
  mov (%ebx), %edx
  mov %eax, (%ebx)
  mov %edx, %eax
.endm

.macro over_
  dup_
  movl 4(%ebx), %eax
.endm

.macro spfetch_
  dup_
  movl %ebx, %eax
.endm

.macro spstore_
  movl %eax, %ebx
  drop_
.endm

.macro to_r_
  dup_r_
  drop_
.endm

.macro r_from_
  dup_
  pop %eax
.endm

.macro r_fetch_
  dup_
  movl (%esp), %eax
.endm

.macro rpfetch_
  dup_
  movl %esp, %eax
.endm

.macro rpstore_
  movl %eax, %esp
  drop_
.endm

.macro ddrop_
  nip_
  drop_
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

.macro popnos_
  mov (%ebx), %edx
  nip_
.endm

.macro pop2nos_
  mov (%ebx), %edx
  mov 4(%ebx), %ecx
  leal 8(%ebx), %ebx
.endm

.macro plus_
  popnos_
  addl %edx, %eax
.endm

.macro minus_
  movl %eax, %edx
  drop_
  sub %edx, %eax
.endm

.macro neg_
    neg %eax
.endm

.macro and_
  and (%ebx), %eax
  nip_
.endm

.macro or_
  or (%ebx), %eax
  nip_
.endm

.macro xor_
  xor (%ebx), %eax
  nip_
.endm

.macro not_
  not %eax
.endm

.macro douser_ sym
  dup_
  leal (\sym-sysvar_base)(%ebp), %eax
  ret
.endm

# Push constant on datastack
.macro dolit_ val
  dup_
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


.macro dupzerosense_
  or %eax, %eax
.endm

.macro zerosense_
  dupzerosense_
  drop_
.endm

.macro zeroless_
  sar $31, %eax    # Turn MSB into 0xffffffff or 0x00000000
.endm

.macro zerotos_
    xor %eax, %eax
.endm

.macro zero_
  dup_
  zerotos_
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
  dup_
  or $-1, %eax
.endm

.macro lshift_
  mov %eax, %ecx
  drop_
  shl %cl, %eax
.endm

.macro rshift_
  mov %eax, %ecx
  drop_
  shr %cl, %eax
.endm

.macro fetch_
  movl (%eax), %eax
.endm

.macro store_
  popnos_
  movl %edx, (%eax)
  drop_
.endm

.macro zerostore_
  xor %edx, %edx
  movl %edx, (%eax)
  drop_
.endm

.macro hfetch_
  movsxw (%eax), %eax
.endm

.macro cfetch_
  movsxb (%eax), %eax
.endm

.macro niptoa_
  mov (%ebx), %esi
  nip_
.endm

.macro niptob_
  mov (%ebx), %edi
  nip_
.endm

.macro copytoa_
    mov %eax, %esi
.endm

.macro copytob_
    mov %eax, %edi
.endm

.macro toa_
  copytoa_
  drop_
.endm

.macro tob_
  copytob_
  drop_
.endm

.macro geta_
  dup_
  mov %esi, %eax
.endm

.macro getb_
  dup_
  mov %edi, %eax
.endm

.macro afetch_
  dup_
  movl (%esi), %eax
.endm

.macro astore_
  mov %eax, (%esi)
  drop_
.endm

.macro bfetch_
  dup_
  movl (%edi), %eax
.endm

.macro bstore_
  mov %eax, (%edi)
  drop_
.endm

.macro ahfetch_
  dup_
  movsxw (%esi), %eax
.endm

.macro ahstore_
  movw %ax, (%esi)
  drop_
.endm

.macro bhfetch_
  dup_
  movsxw (%edi), %eax
.endm

.macro acfetch_
  dup_
  movsxb (%esi), %eax
.endm

.macro acstore_
  movb %al, (%esi)
  drop_
.endm

.macro bcfetch_
  dup_
  movsxb (%edi), %eax
.endm

.macro bcstore_
  movb %al, (%edi)
  drop_
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
