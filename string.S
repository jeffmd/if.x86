# string.S

# ( addr -- addr+2 len )
# get string address and length information out of a counted string
Forthword_ STRINGLEN, 0, "$l"
  x_w_          # ( addr ) X: addr
  twoplus_      # ( addr+2 )
  push_         # ( addr+2 addr+2 )
  hmx_          # ( addr+2 len )
  end_

# ( addr1 u1 n -- addr2 u2 )
# adjust string from addr1 to addr1+n, reduce length from u1 to u2 by n
Forthword_ SLASHSTRING, 0, "/$"
  push_         # ( addr1 u1 n n )
  d1_           # ( addr1 u1 n u1 )
  do_ MIN       # ( addr1 u1 n|u1 )
  y_w_          # ( addr1 u1 n ) Y: n
  d1_           # ( addr1 u1 addr1 )
  w_plus_y_     # ( addr1 u1 addr2 )
  d1_w_         # ( addr2 u1 addr2 )
  pop_          # ( addr2 u1 )
  w_minus_y_    # ( addr2 u2 )
  end_

# ( -- addr len )
# runtime portion of sliteral
# string literal is located starting at return cell
# return cell is string length
# string then occupies the following cells: c2c1 c4c3 ...
Forthword_ DOSLIT, 0, "(slit)"
  # get return address to get string length, calculate string address start,
  # and calculate return address
  y_r0_          # ( Y:raddr )  (R: raddr)
  # get the string length
  hmy_           # ( slength Y:raddr )
  # calculate string address
  y_plus2_       # ( slength Y:straddr )
  # calculate the number of words to skip over for return address
  pushy_         # ( straddr slength Y:straddr )
  y_plus_w_      # ( straddr slength Y:straddr+slength )
  # also skip string length
  r0_y_          # ( straddr slength ) (R: straddr+k )
  end_
