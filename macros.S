# macros.S

#breg .equ %edi # B register used for general purpose operations
#sysvar .equ %ebp # system variables base pointer
#areg .equ %esi # A register used for memory pointer operations
#tos .equ %ebx # parameter top of stack [TOS] register
#dsp .equ %eax # holds the Forth Parameter/Data stack pointer

# header flags
.set HFLAGS, 0xFF
# low byte is word count : 0 - 255
# high byte is flags for word
# enable inlining of word
# bit 0 : enable inlinning
.set INLINE_OPT_FB, 0
.set INLINE_OPT, 0x01

# bit 3 : disable interpret execution ie compile only
.set COMPILE_ONLY_FB, 3
# set immediate word as compile time only execution
# disable interpret execution : & with word count flag ie: 0xFF04 & COMPILE_ONLY
.set COMPILE_ONLY, 0x08

# bit 7 : immediate execution when in compile state
# enable immediate execution : & with word count flag ie: 0xFF04 & IMMEDIATE_EN
.set IMMEDIATE_EN_FB, 7
.set IMMEDIATE_EN, 0x80

# forth flags
# bit 0 : rcall was last instruction
.set LAST_RCALL_FB, 0
# bit 1 : call was last instruction
.set LAST_CALL_FB, 1
# if bit 0 and 1 are cleared then last instruction was an inline or tail call optimization was disabled by word
# bit 2 : disable tail call optimization
.set DIS_CALL_OPT_FB, 2

# Inline macros
.macro dup_r_ # put copy of tos on return stack
    pushl %ebx
.endm

.macro r_drop_ # drop TOR
    popl %edx
.endm

.macro pushtos_ # save tos on data stack, same as dup
  xchg %eax, %esp
  pushl %ebx 
  xchg %eax, %esp
.endm

.macro dup_
  pushtos_
.endm

.macro poptos_ # load tos from stack, same as drop
  xchg %eax, %esp
  popl %ebx
  xchg %eax, %esp
.endm

.macro drop_
  poptos_
.endm

.macro swap_
  xchg %ebx, (%eax)
.endm

.macro over_
  pushtos_
  movl 4(%eax), %ebx
.endm

.macro spfetch_
  pushtos_
  movl %esp, %ebx
.endm

.macro spstore_
  movl %ebx, %esp
  poptos_
.endm

.macro to_r_
  dup_r_
  drop_
.endm

.macro r_from_
  pushtos_
  pop %ebx
.endm

.macro r_fetch_
  pushtos_
  movl (%esp), %ebx
.endm

.macro rpfetch_
  pushtos_
  movl %esp, %ebx
.endm

.macro rpstore_
  movl %ebx, %esp
  poptos_
.endm

.macro nip_
  addl $4, %eax
.endm

.macro dnip_
  addl $8, %eax
.endm

.macro ddrop_
  nip_
  drop_
.endm

# Push constant on datastack
.macro dolit_ val
  pushtos_
  movl $\val, %ebx
.endm

.macro oneplus_
  inc %ebx
.endm

.macro oneminus_
  dec %ebx
.endm

.macro ten_
  dolit_ 10
.endm

.macro bl_
  dolit_ 32
.endm

.macro fetch_
  movl (%ebx), %ebx
.endm

.macro ascii_ str, flg=0
  #.p2align 1 # Align to even locations
  .byte (8f - 7f)
  .byte \flg
7:  .ascii "\str"
8:
  #.p2align 1
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
