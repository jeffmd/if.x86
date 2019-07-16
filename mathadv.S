# mathadv.S
# Multiply unsigned 32*32 = 64
# ( u u -- ud )
Forthword_ UMSTAR, INLINE_OPT, "um*"
  x_d0_
  mul %ecx
  d0_y_
  ret

# ( n n -- d)
# multiply 2 signed cells to a double cell
# signed 32*32 = 64
Forthword_ MSTAR, INLINE_OPT, "m*"
  x_d0_
  imul %ecx
  d0_y_
  ret

# ( ud u -- u u ) Dividend Divisor -- mod quotient
# 64/32 = 32 Rest 32
Forthword_ UM_DIVMOD, 0, "um/mod"
  x_w_
  y_d1_
  d0_
  nip_
  div %ecx
  d0_y_
  ret

# ( u1 u2 -- rem quot )
# unsigned 32b division with modulus result
Forthword_ U_DIVMOD, 0, "u/mod"
  x_w_
  d0_
  y_0_
  div %ecx
  d0_y_
  ret

Forthword_ M_DIVMOD, 0, "m/mod"
# Signed symmetric divide 64/32 = 32 remainder 32
# ( d n -- n n )
  x_w_
  y_d1_
  d0_
  nip_
  idiv %ecx
  d1_y_
  ret

# ( n1 n2 -- rem quot )
# signed division with remainder
Forthword_ DIVMOD, 0, "/mod"
  x_w_
  d0_
  cltd
  idiv %ecx
  d0_y_
  ret

# ( n1 n2 -- n1/n2 )
# 32bit/32bit = 32bit
Forthword_ DIV, 0, "/"
  x_w_
  d0_
  cltd
  nip_
  idiv %ecx
  ret
