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
  hfetch_
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
  call getchar
  ret

# ( -- key )
# fetch key from an open file using filedes, should leave
# a single character in WR or -1 if no more to read in file.
Forthword_ KEYFILE, 0, "keyfile"
  zero_                    # ( 0 )
  push_                    # ( 0 0 )
  one_                     # ( 0 1 )
  rpush_                   # ( 0 1 ) (R: 1 )
  rpush_sp_                # ( 0 ebx ) (R: 1 ebx )
  call KEYFILEADDR         # ( 0 keyfile# )
  fetch_                   # ( 0 filedes )
  rpush_                   # ( 0 filedes ) (R: 1 ebx filedes )
  call read                # ( key count )
  rnip3_                   # ( key count ) (R:  )
  # was one key read from the file?
  push_                    # ( key count count )
  one_                     # ( key count 1 )
  call EQUAL               # ( key flag )
  iszero_                  # ( key flag )
  pop_                     # ( key )
  jne KEYEND
    oneminus_
    jmp BYE
    
 KEYEND:
  ret

# ( -- key )
# fetch key from deffered routine, should leave a single character
# in WR if a key was pressed. If no key pressed then -1 is in WR.
Forthword_ KEY, 0, "key"
  push_
  call KEYADDR
  fetch_
  jmp EXEC

# ( -- f )
# refills the input buffer
Forthword_ REFILL, 0, "refill"
  jmp REFILLTIB

# ( -- )
# Reset the input buffer
Forthword_ INRESET, 0, "in_"
  call G_IN                # ( >inaddr )
  zero_hstr_               # ( >inaddr )
  # reset input buffer cursor position
  call SHARPTIB            # ( #tibaddr )
  zero_hstr_               # ( #tibaddr )
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
  hfetch_           # ( k tib )
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
  str_y_              # ( true Y:true )
  call SHARPTIB       # ( #tibaddr )
  yplus_hstr_         # ( #tibaddr )
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
  d0_str_y_              # ( k tibaddr #tib) Y: tibaddr
  addy_                  # ( k tibaddr tibaddr+#tib )
  d1_str_y_              # ( k tibaddr tibaddr+#tib ) Y: k
  yw_cstr_               # ( k tibaddr tibaddr+#tib )
  nip2_                  # ( tibaddr+#tib )

  call SHARPTIB          # ( #tib )
  oneplus_hstr_          # ( ? )

ACCEPT_checkmaxinput:
  # check if max number of char input
  call SHARPTIB          # ( #tibaddr )
  hfetch_                # ( #tib )
  str_y_                 # ( #tib ) Y: #tib
  lit_ TIBSIZE           # ( tibsize )
  minusy_                # ( tibsize-#tib )
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
