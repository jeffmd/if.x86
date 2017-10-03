# core.S

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
  
# ( x1 x2 -- x1 x2 x1 )
# Place a copy of x1 on top of the stack
Forthword_ OVER, INLINE_OPT, "over"
  over_
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
