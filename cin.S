# cin.S

# ( -- addr )
# terminal input buffer address
Forthword_ TIB, 0, "tib"
  user_ ram_tib
  ret

# ( -- addr-half )
# variable holding the number of characters in TIB
# is half cell size
Forthword_ SHARPTIB, 0, "#tib"
  user_ ram_sharptib
  ret

# ( -- addr len )
# address and current length of the input buffer
Forthword_ STIB, 0, "stib"
  user_ ram_tib
  push_
  user_ ram_sharptib
  hmw_
  ret

# ( -- a-addr )
# index to current read position in input buffer
# is half cell size
Forthword_ G_IN, 0, ">in"
  user_ user_g_in
  ret

# ( -- keyaddr )
# get ram address of key defer
Forthword_ KEYADDR, 0, "key#"
  user_ USER_KEY
  ret

# ( -- key )
# fetch key from standard input, should leave a single character in WR
# if a key was pressed. If no key pressed then -1 is in WR.
Forthword_ STDIN, 0, "stdin"
  call getchr
  ret

# ( -- key )
# fetch key from deffered routine, should leave a single character
# in WR if a key was pressed. If no key pressed then -1 is in WR.
Forthword_ KEY, 0, "key"
  push_
  call KEYADDR
  mw_
  jmp EXEC

# ( -- )
# Reset the input buffer
Forthword_ INRESET, 0, "in_"
  call G_IN                # ( >inaddr )
  y_0_
  hmw_y_                   # ( >inaddr )
  # reset input buffer cursor position
  call SHARPTIB            # ( #tibaddr )
  hmw_y_                   # ( #tibaddr )
  jmp QP_RD

# ( -- flag )
# receive a string of at most tibsize characters or cr/lf detected.
# flag will be true if input buffer needs to be processed ie interpreted
# flag will be false if more input needed
Forthword_ ACCEPT, 0, "accept"
  # <begin>
  call KEY        # ( k )
  iszero_
  jg ACCEPT_checkeol
  oneplus_
  ret

ACCEPT_checkeol:
  # check for EOL
  cmp $10, %eax
  # <if>
  jne ACCEPT_checkreturn
  ret

ACCEPT_checkreturn:
  cmp $13, %eax     # ( k )
  # <if>
  jne ACCEPT_checkdelete
  ret

ACCEPT_checkdelete:
  # check delete
  cmp $127, %eax     # ( k )
  # <if>
  jne ACCEPT_checkcontrol
  # delete previous character
  # check beginning of line
  # if cursor is 0 then at begining of input
  push_             # ( k k )
  call SHARPTIB     # ( k #tib )
  hmw_              # ( k tib )
  # <if>
  iszero_           # ( k tib )
  pop_              # ( k )
  jne ACCEPT_dodelete
  # at the beginning of the line, ignore this character
  zero_             # ( 0 )
  ret

ACCEPT_dodelete:
  andl $8, %eax
  push_               # ( k k )
  call EMIT           # ( k ? )
  bl_                 # ( k bl )
  call EMIT           # ( k ? )
  pop_                # ( k )
  call EMIT           # ( ? )
  # decrease cursor position by one
  call TRUE           # ( true )
  y_w_                # ( true Y:true )
  call SHARPTIB       # ( #tibaddr )
  x_hmw_
  x_plus_y_
  hmw_x_              # ( #tibaddr )
  jmp ACCEPT_checkmaxinput


ACCEPT_checkcontrol:
  # check for remaining control characters, replace them with blank
  cmp $32, %eax          # ( k )
  jge ACCEPT_echo
  # replace control key with a space
  bl_                    # ( bl )

ACCEPT_echo:
    # emit the key
  push_                  # ( k k )
  call EMIT              # ( k ? )
  # now store the key in the input buffer
  call STIB              # ( k tibaddr #tib)
  y_d0_                  # ( k tibaddr #tib) Y: tibaddr
  w_plus_y_              # ( k tibaddr tibaddr+#tib )
  x_d1_                  # ( k tibaddr tibaddr+#tib ) X: k
  cmw_x_                 # ( k tibaddr tibaddr+#tib )
  nip2_                  # ( tibaddr+#tib )

  call SHARPTIB          # ( #tib )
  y_hmw_
  y_plus1_
  hmw_y_                 # ( ? )

ACCEPT_checkmaxinput:
  # check if max number of char input
  call SHARPTIB          # ( #tibaddr )
  y_hmw_                 # ( #tib )
  lit_ TIBSIZE           # ( tibsize )
  w_minus_y_             # ( tibsize-#tib )
  # <if>
  iszero_                # ( tibsize-#tib )
  je ACCEPT_atmaxinput
  jmp ZERO

ACCEPT_atmaxinput:
  # max number of characters in input buffer so have it processed
  jmp TRUE

# ( -- f )
# refills the input buffer - flag is true if buffer has something
Forthword_ REFILLTIB, 0, "reftib"
  call ACCEPT                # ( f )
  iszero_                    # ( f )
  je REFILLTIB_exit
  push_
  call CR
  pop_

REFILLTIB_exit:
  ret

# ( -- f )
# refills the input buffer
Forthword_ REFILL, 0, "refill"
  jmp REFILLTIB
