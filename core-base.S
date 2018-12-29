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

# ( x1 x2 -- x1 x2 x1 x2)
# Place a copy of x1 and x2 on top of the stack
Forthword_ TWOOVER, 0, "2over"
  top2_
  str_d1_
  d2_
  str_d0_
  d1_
  ret
  
# ( u1 u2 -- flag )
# flag is true if u1 > u2 (unsigned)
Forthword_ UGREATER, 0, "u>"
  pop_y_
  sub %edx, %eax
  sbb %eax, %eax
  ret

# ( u1 u2 -- flag)
# flag is true if u1 < u2 (unsigned)
Forthword_ ULESS, 0, "u<"
  pop_y_
  sub %eax, %edx
# WR = a-b  -- carry set if a is less than b
  sbb %edx, %edx
  mov %edx, %eax
  ret

# ( -- -1 )
# leaves the value -1 (true) in WR
Forthword_ TRUE, INLINE_OPT, "true"
  true_
  ret

# ( -- 0 )
# set WR to 0
Forthword_ ZERO, INLINE_OPT, "0"
	zero_
	ret

# ( a-addr -- )
# store 0 (16 bits) to RAM address
Forthword_ ZERO_HSTR, INLINE_OPT, "0h!"
  zero_hstr_
  ret
