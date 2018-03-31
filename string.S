# string.S

# ( addr -- addr+2 len )
# get string address and length information out of a counted string
Forthword_ STRINGLEN, 0, "$l"
  str_x_        # ( addr ) X: addr
  twoplus_      # ( addr+2 )
  push_         # ( addr+2 addr+2 )
  x_hfetch_     # ( addr+2 len )
  ret

# ( addr1 u1 n -- addr2 u2 )
# adjust string from addr1 to addr1+n, reduce length from u1 to u2 by n
Forthword_ SLASHSTRING, 0, "/$"
  over_         # ( addr1 u1 n u1 )
  call MIN      # ( addr1 u1 n|u1 )
  str_y_        # ( addr1 u1 n ) Y: n
  d1_           # ( addr1 u1 addr1 )
  addy_         # ( addr1 u1 addr2 )
  str_d1_       # ( addr2 u1 addr2 )
  pop_          # ( addr2 u1 )
  minusy_       # ( addr2 u2 )
  ret

# ( -- addr len )
# runtime portion of sliteral
# string literal is located starting at return cell
# return cell is string length
# string then occupies the following cells: c2c1 c4c3 ...
Forthword_ DOSLIT, 0, "(slit)"
  # get return address to get string length, calculate string address start,
  # and calculate return address
  r0_            # ( raddr )  (R: raddr)
  push_          # ( raddr raddr )
  # get the string length
  hfetch_        # ( raddr slength )
  push_          # ( raddr slength slength )
  # calculate string address
  d1_            # ( raddr slength raddr )
  twoplus_       # ( raddr slength straddr )
  # calculate the number of words to skip over for return address
  str_d1_        # ( straddr slength straddr )
  d0_str_y_      # ( straddr slength straddr ) Y: slength
  addy_          # ( straddr slength straddr+slength )
  # also skip string length
  str_r0_        # ( straddr slength straddr+k ) (R: straddr+k )
  pop_           # ( straddr slength )
  ret
