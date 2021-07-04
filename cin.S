# cin.S

# ( -- addr )
# terminal input buffer address
Forthword_ TIB, 0, "tib"
  user_ ram_tib
  end_

# ( -- addr-half )
# variable holding the number of characters in TIB
# is half cell size
Forthword_ SHARPTIB, 0, "#tib"
  user_ ram_sharptib
  end_

# ( -- addr len )
# address and current length of the input buffer
Forthword_ STIB, 0, "stib"
  user_ ram_tib
  d_w_
  user_ ram_sharptib
  hmw_
  end_

# ( -- a-addr )
# index to current read position in input buffer
# is half cell size
Forthword_ G_IN, 0, ">in"
  user_ user_g_in
  end_

# ( -- keyaddr )
# get ram address of key defer
Forthword_ KEYADDR, 0, "key#"
  user_ USER_KEY
  end_

# ( -- key )
# fetch key from standard input, should leave a single character in WR
# if a key was pressed. If no key pressed then -1 is in WR.
Forthword_ STDIN, 0, "stdin"
  end_do_ getchr

# ( -- key )
# fetch key from deffered routine, should leave a single character
# in WR if a key was pressed. If no key pressed then -1 is in WR.
Forthword_ KEY, 0, "key"
  d_w_
  do_ KEYADDR
  mw_
  end_do_ EXEC

# ( -- )
# Reset the input buffer
Forthword_ INRESET, 0, "in_"
  do_ G_IN                 # ( >inaddr )
  y_0_
  hmw_y_                   # ( >inaddr )
  # reset input buffer cursor position
  do_ SHARPTIB             # ( #tibaddr )
  hmw_y_                   # ( #tibaddr )
  end_do_ QP_RD

# ( -- flag )
# receive a string of at most tibsize characters or cr/lf detected.
# flag will be true if input buffer needs to be processed ie interpreted
# flag will be false if more input needed
Forthword_ ACCEPT, 0, "accept"
  # <begin>
  do_ KEY        # ( k )
  iszero_
  jg ACCEPT_checkeol
  add_1_
  exit_

ACCEPT_checkeol:
  # check for EOL
  cmp $10, %eax
  # <if>
  ifnz_ ACCEPT_checkreturn
  exit_

ACCEPT_checkreturn:
  cmp $13, %eax     # ( k )
  # <if>
  ifnz_ ACCEPT_checkdelete
  exit_

ACCEPT_checkdelete:
  # check delete
  cmp $127, %eax     # ( k )
  # <if>
  ifnz_ ACCEPT_checkcontrol
  # delete previous character
  # check beginning of line
  # if cursor is 0 then at begining of input
  d_w_             # ( k k )
  do_ SHARPTIB      # ( k #tib )
  hmw_              # ( k tib )
  # <if>
  iszero_           # ( k tib )
  d_              # ( k )
  ifnz_ ACCEPT_dodelete
  # at the beginning of the line, ignore this character
  zero_             # ( 0 )
  exit_

ACCEPT_dodelete:
  andl $8, %eax
  d_w_               # ( k k )
  do_ EMIT           # ( k ? )
  bl_                 # ( k bl )
  do_ EMIT            # ( k ? )
  d_                # ( k )
  do_ EMIT            # ( ? )
  # decrease cursor position by one
  true_               # ( true )
  y_w_                # ( true Y:true )
  do_ SHARPTIB        # ( #tibaddr )
  x_hmw_
  x_add_y_
  hmw_x_              # ( #tibaddr )
  goto_ ACCEPT_checkmaxinput


ACCEPT_checkcontrol:
  # check for remaining control characters, replace them with blank
  cmp $32, %eax          # ( k )
  jge ACCEPT_echo
  # replace control key with a space
  bl_                    # ( bl )

ACCEPT_echo:
    # emit the key
  d_w_                   # ( k k )
  do_ EMIT               # ( k ? )
  # now store the key in the input buffer
  do_ STIB               # ( k tibaddr #tib)
  y_d0_                  # ( k tibaddr #tib) Y: tibaddr
  add_y_                 # ( k tibaddr tibaddr+#tib )
  x_d1_                  # ( k tibaddr tibaddr+#tib ) X: k
  cmw_x_                 # ( k tibaddr tibaddr+#tib )
  r_sub_2_               # ( tibaddr+#tib )

  do_ SHARPTIB           # ( #tib )
  y_hmw_
  y_add_1_
  hmw_y_                 # ( ? )

ACCEPT_checkmaxinput:
  # check if max number of char input
  do_ SHARPTIB           # ( #tibaddr )
  y_hmw_                 # ( #tib )
  lit_ TIBSIZE           # ( tibsize )
  sub_y_                 # ( tibsize-#tib )
  # <if>
  iszero_                # ( tibsize-#tib )
  ifz_ ACCEPT_atmaxinput
  zero_
  exit_

ACCEPT_atmaxinput:
  # max number of characters in input buffer so have it processed
  true_
  end_

# ( -- f )
# refills the input buffer - flag is true if buffer has something
Forthword_ REFILLTIB, 0, "reftib"
  do_ ACCEPT                 # ( f )
  iszero_                    # ( f )
  ifz_ REFILLTIB_exit
  d_w_
  do_ CR
  d_

REFILLTIB_exit:
  end_

# ( -- f )
# refills the input buffer
Forthword_ REFILL, 0, "refill"
  end_do_ REFILLTIB
