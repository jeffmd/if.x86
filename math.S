# math.S

# ( n1 n2 -- n1|n2 )
# compare two values leave the smaller one
Forthword_ MIN, 0, "min"
  str_y_
  pop_
  cmp %eax, %edx
  jge 1f
  y_
1:
  ret

# ( n1 n2 -- n1|n2 )
# compare two values, leave the bigger one
Forthword_ MAX, 0, "max"
  str_y_
  pop_
  cmp %eax, %edx
  jl 1f
  y_
1:
  ret

# ( u1 u2 -- flag )
# compare two unsigned numbers, returns true flag if u1 is less then or equal to u2
Forthword_ ULESSEQUAL, 0, "u<="
  call UGREATER
  not_
  ret

# ( u1 u2 -- flag )
# compare two unsigned numbers, returns true flag if u1 is greater then or equal to u2
Forthword_ UGREATEREQUAL, 0, "u>="
  call ULESS
  not_
  ret

# ( n1 -- u1 )
# get the absolute value
Forthword_ ABS, 0, "abs"
  iszero_
  jns 1f
  neg_
1:
  ret
