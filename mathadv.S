# mathadv.S
# Multiply unsigned 32*32 = 64
# ( u u -- ud )
Forthword_ UMSTAR, INLINE_OPT, "um*"
  d0_str_x_
  mul %ecx
  y_str_d0_
  ret

# ( n n -- d)
# multiply 2 signed cells to a double cell
# signed 32*32 = 64
Forthword_ MSTAR, INLINE_OPT, "m*"
  d0_str_x_
  imul %ecx
  y_str_d0_
  ret

# ( ud u -- u u ) Dividend Divisor -- mod quotient
# 64/32 = 32 Rest 32
Forthword_ UM_DIVMOD, 0, "um/mod"
  str_x_
  d1_str_y_
  d0_
  nip_
  div %ecx
  y_str_d0_
  ret

# ( u1 u2 -- rem quot )
# unsigned 32b division with modulus result
Forthword_ U_DIVMOD, 0, "u/mod"
  str_x_
  d0_
  zero_y_
  div %ecx
  y_str_d0_
  ret

Forthword_ M_DIVMOD, 0, "m/mod"
# Signed symmetric divide 64/32 = 32 remainder 32
# ( d n -- n n )
  str_x_
  d1_str_y_
  d0_
  nip_
  idiv %ecx
  y_str_d1_
  ret

# ( n1 n2 -- rem quot )
# signed division with remainder
Forthword_ DIVMOD, 0, "/mod"
  str_x_
  d0_
  cltd
  idiv %ecx
  y_str_d0_
  ret

# ( n1 n2 -- n1/n2 )
# 32bit/32bit = 32bit
Forthword_ DIV, 0, "/"
  str_x_
  d0_
  cltd
  nip_
  idiv %ecx
  ret
