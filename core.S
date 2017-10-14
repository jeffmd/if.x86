# core.S

# ( xt -- )
# execute XT
Forthword_ EXEC, 0, "exec"
    pushl %ebx
    poptos_
    ret

# ( xt -- )
# Don't do anything, just chew up a few cycles
Forthword_ NOOP, INLINE_OPT, "noop"
    nop
    ret

# ( n -- n n )
# duplicate TOS
Forthword_ DUP, INLINE_OPT, "dup"
    pushtos_
    ret

# ( n1 n2 -- n2 n1)
# swaps the two top level stack cells
Forthword_ SWAP, INLINE_OPT, "swap"
  swap_
  ret

# ( n1 n2 -- n2)
# drop NOS, one before TOS.
# same as SWAP DROP
Forthword_ NIP, INLINE_OPT, "nip"
  nip_ 
  ret
  
# ( x1 x2 -- x1 x2 x1 )
# Place a copy of x1 on top of the stack
Forthword_ OVER, INLINE_OPT, "over"
  over_
  ret

# ( x1 x2 -- x1 x2 x1 x2)
# Place a copy of x1 and x2 on top of the stack
Forthword_ TWOOVER, 0, "2over"
  over_
  jmp OVER

# ( n -- )
# drop TOS
Forthword_ DROP, INLINE_OPT, "drop"
  drop_
  ret

# ( n n -- )
# drop TOS twice
Forthword_ DDROP, INLINE_OPT, "2drop"
    ddrop_
    ret

# (  -- addr )
# current data stack pointer
Forthword_ SP_FETCH, INLINE_OPT, "sp@"
  spfetch_
  ret
  
# ( addr -- i*x)
# set data stack pointer to addr
Forthword_ SP_STORE, INLINE_OPT, "sp!"
  spstore_
  ret

# ( n1 n2 -- n3)
# add n1 and n2
Forthword_ PLUS, INLINE_OPT, "+"
  plus_
  ret

# ( n1|u1 n2|u2 -- n3|u3 )
# subtract n2 from n1
Forthword_ MINUS, INLINE_OPT, "-"
  minus_
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

# ( -- 0 )
# place a value 0 on TOS
Forthword_ ZERO, INLINE_OPT, "0"
  zero_
  ret

  
# ( -- -1 )
# leaves the value -1 (true) on TOS
Forthword_ TRUE, INLINE_OPT, "true"
  true_
  ret


# ( a-addr -- n32 )
# read 1 cell (32 bits) from RAM address
Forthword_ FETCH, INLINE_OPT, "@"
  fetch_
  ret

# ( n32 a-addr -- )
# store a word (32 bits) to RAM address
Forthword_ STORE, 0, "!"
  movl (%eax), %edx
  movl %edx, (%ebx)
  movl 4(%eax), %ebx
  add $8, %eax
  ret

# ( a-addr -- n16 )
# read half cell (16 bits) from RAM address
Forthword_ HFETCH, INLINE_OPT, "h@"
  hfetch_
  ret

# ( n16 a-addr -- )
# store a half word (16 bits) to RAM address
Forthword_ HSTORE, 0, "h!"
  popnos_
  movw %dx, (%ebx)     
  poptos_
  ret

# ( a-addr -- )
# store 0 (16 bits) to RAM address
Forthword_ ZEROHSTORE, 0, "0h!"
  movw $0, (%ebx)
  poptos_
  ret

# ( n16 a-addr -- )
# add n16 to content of half cell RAM address a-addr
Forthword_ PLUSHSTORE, 0, "+h!"
  popnos_          
PLUSHSTORE_do:
  movsxw (%ebx), %ecx     # Load the current cell value
  add %ecx, %edx          # Do the add
  movw %dx, (%ebx)        # Store it back
  poptos_
  ret

# ( a-addr -- )
# add 1 to content of half cell RAM address a-addr
Forthword_ ONEPLUSHSTORE, 0, "1+h!"
  mov $1, %edx
  jmp PLUSHSTORE_do

# ( a-addr -- n8 )
# read byte (8 bits) from RAM address
Forthword_ CFETCH, INLINE_OPT, "c@"
  cfetch_
  ret

# ( c a-addr -- )
# store a single byte to RAM address
Forthword_ CSTORE, 0, "c!"
  popnos_ 
  movb %dl, (%ebx)
  poptos_
  ret

# ( a-addr -- )
# store 0 (16 bits) to RAM address
Forthword_ ZEROCSTORE, 0, "0c!"
  movb $0, (%ebx)
  poptos_
  ret

# ( c a-addr -- )
# add c byte to content of byte RAM address a-addr
Forthword_ PLUSCSTORE, 0, "+c!"
  popnos_ 
PLUSCSTORE_do:
  movsxb (%ebx), %ecx     # Load the current cell value
  add %ecx, %edx          # Do the add
  movb %dl, (%ebx)        # Store it back
  poptos_
  ret

# ( a-addr -- )
# add 1 to content of byte cell RAM address a-addr
Forthword_ ONEPLUSCSTORE, 0, "1+c!"
  mov $1, %edx
  jmp PLUSCSTORE_do

# ( n1 n2 -- n2 ) A: n1
# Remove next on stack and write to A register (Extended VM)
Forthword_ NIPTOA, INLINE_OPT, "nip>a"
  niptoa_
  ret

# ( n1 n2 -- n2 ) B: n1
# Remove next on stack and write to B register (Extended VM)
Forthword_ NIPTOB, INLINE_OPT, "nip>b"
  niptob_
  ret

# ( n -- ) A: n
# Move TOS to A register (Extended VM)
Forthword_ TO_A, INLINE_OPT, ">a"
  toa_
  ret

# ( n -- ) B: n
# Move TOS to B register (Extended VM)
Forthword_ TO_B, INLINE_OPT, ">b"
  tob_
  ret

# ( n -- n ) A: n
# copy TOS to A register (Extended VM)
Forthword_ _A, INLINE_OPT, ":a"
  copytoa_
  ret

# ( n -- n ) B: n
# copy TOS to B register (Extended VM)
Forthword_ _B, INLINE_OPT, ":b"
  copytob_
  ret

# ( -- n )
# read the A register (Extended VM)
Forthword_ A_, INLINE_OPT, "a"
  geta_
  ret

# ( -- n )
# read the B register (Extended VM)
Forthword_ B_, INLINE_OPT, "b"
  getb_
  ret

# ( -- n )
# Read a word (32bit) from memory pointed to by register A (Extended VM)
Forthword_ AFETCH, INLINE_OPT, "a@"
  afetch_
  ret

# ( n -- )
# store a word to RAM address pointed to by areg
Forthword_ ASTORE, 0, "a!"
  mov %ebx, (%esi)
  poptos_
  ret

# ( -- n )
# Read a half word (32bit) from memory pointed to by register A (Extended VM)
Forthword_ AHFETCH, INLINE_OPT, "ah@"
  ahfetch_
  ret

# ( h -- )
# store a half word to RAM address pointed to by areg
Forthword_ AHSTORE, 0, "ah!"
  movw %bx, (%esi)
  poptos_
  ret

# ( -- n )
# Read a byte from memory pointed to by register A (Extended VM)
Forthword_ ACFETCH, INLINE_OPT, "ac@"
  acfetch_
  ret

# ( c -- )
# store a single byte to RAM address pointed to by areg
Forthword_ ACSTORE, 0, "ac!"
  movb %bl, (%esi)
  poptos_
  ret

# ( -- )
# update register A with post increment 4+ from last memory operation (Extended VM)
Forthword_ APLUS, INLINE_OPT, "a+"
  aplus_
  ret

# ( -- )
# update register A with post increment 2+ from last memory operation (Extended VM)
Forthword_ AHPLUS, INLINE_OPT, "ah+"
  ahplus_
  ret


# ( -- )
# update register A with post increment 1+ from last memory operation (Extended VM)
Forthword_ ACPLUS, INLINE_OPT, "ac+"
  acplus_
  ret
