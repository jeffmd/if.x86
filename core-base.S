# core-base.S - minimum core words needed to get if up and running

# ( xt -- )
# execute XT
Forthword_ EXEC, 0, "exec"
  rpush_
  pop_
  ret

# ( xt -- )
# Don't do anything, just chew up a few cycles
Forthword_ NOOP, INLINE_OPT, "noop"
  nop
  ret
 
# ( u1 u2 -- flag )
# flag is true if u1 > u2 (unsigned)
Forthword_ UGREATER, 0, "u>"
  popy_
  sub %edx, %eax
  sbb %eax, %eax
  ret

# ( u1 u2 -- flag)
# flag is true if u1 < u2 (unsigned)
Forthword_ ULESS, 0, "u<"
  popy_
  sub %eax, %edx
# w = a-b  -- carry set if a is less than b
  sbb %edx, %edx
  mov %edx, %eax
  ret
