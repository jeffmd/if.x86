# core.S

# ( -- retaddr )
# pop second return onto data stack and exit caller
# used if data in program mem and need an address to it
# must be called
Forthword_ POPRET, 0, "popret"
  r_
  end_
    
# ( n1 n2 -- flag )
# flag is true if WR and NOS are equal
Forthword_ EQUAL, 0, "=="
  sub (%ebx), %eax
  d_sub_1_
  sub $1, %eax
  sbb %eax, %eax
  end_

# ( n1 n2 -- flag)
# flag is true if n1 is less than n2
Forthword_ LESS, 0, "<"
  cmp %eax, (%ebx)
  d_sub_1_
  jge 1f
  zero_
  not_
  exit_
1:
  zero_
  end_

# ( n1 n2 -- flag )
# flag is true if n1 is greater than n2
Forthword_ GREATER, 0, ">"
           # Get x1 into a register.
  cmp %eax, (%ebx)  # Is x2 greater?
  d_sub_1_
GREATER_CHK:
  jle 1f
  zero_
  not_
  exit_
1:
  zero_
  end_

# ( n1 -- flag )
# flag is true if n1 is greater than 0
Forthword_ ZEROGREATER, 0, "0>"
  sub $0, %eax
  end_do_ GREATER_CHK

# ( n1 -- flag)
# flag is true if WR is less than zero
forthword_ ZEROLESS, INLINE_OPT, "0<"
  zeroless_
  end_

# (start dest count -- )
# count is the number of bytes to copy
# copy ram using bytes.  Assumes no overlap.
Forthword_ MCPY, 0, "mcpy"
  iszero_         # ( start dest count )
  ifz_ MCPY_END

  r_a_
  r_b_
  b_d0_              # ( start dest count ) B: dest
  x_w_               # ( start dest count ) X: count
  a_d1_              # (  start dest count ) A: start
  cld
  rep movsb
  b_r_
  a_r_

MCPY_END:
  d_sub_2_
  end_
