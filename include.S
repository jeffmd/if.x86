# include.S

# ( -- keyfileaddr )
# get ram address of key file descriptor
Forthword_ KEYFILEADDR, 0, "keyf#"
  user_ USER_KEYFILE
  ret
  
# ( -- key )
# fetch key from an open file using filedes, should leave
# a single character in WR or -1 if no more to read in file.
Forthword_ KEYFILE, 0, "keyfile"
  zero_                    # ( 0 )
  push_                    # ( 0 0 )
  lit_  1                  # ( 0 1 )
  rpush_                   # ( 0 1 ) (R: 1 )
  rpushdsp_                # ( 0 ebx ) (R: 1 ebx )
  call KEYFILEADDR         # ( 0 keyfile# )
  mw_                      # ( 0 filedes )
  rpush_                   # ( 0 filedes ) (R: 1 ebx filedes )
  call read                # ( key count )
  rnip3_                   # ( key count ) (R:  )
  # was one key read from the file?
  push_                    # ( key count count )
  lit_ 1                   # ( key count 1 )
  call EQUAL               # ( key flag )
  iszero_                  # ( key flag )
  pop_                     # ( key )
  jne KEYEND
    oneminus_
    jmp BYE
    
 KEYEND:
  ret

# ( caddr -- ** )
# open a file that will be used for key input
# caddr points to null terminated file name
Forthword_ DOINCLUDE, 0, "(include)"
  # set file open mode to reading
  y_w_                  # ( caddr ) Y: caddr
  zero_                 # ( 0 )
  rpush_                # ( 0 ) (R: 0 )
  rpushy_               # ( 0 ) (R: 0 caddr )
  call open             # ( filedes )
  rnip2_                # ( filedes ) (R:  )
  # if file descriptor > 0 then open is success
  push_                 # ( filedes filedes )
  call ZEROGREATER      # ( filedes flag )
  iszero_
  je DOINCLUDE_EXIT

  call IDLETIMEFETCH    # ( filedes itime )
  rpush_                # ( filedes itime ) (R: itime )
  call SLEEPOFF         # ( filedes ? )
  # push FFLAGS on tor
  call FFLAGS           # ( filedes fflags# )
  hmw_                  # ( filedes fflags )
  rpush_                # ( filedes fflags ) (R: itime fflags )
  # push on return stack the old defer key
  call KEYADDR          # ( filedes KEYADDR )
  mw_                   # ( filedes KEY )
  rpush_                # ( filedes KEY ) (R: itime fflags KEY)
  # push old keyfile on return stack
  call KEYFILEADDR      # ( filedes KEYFILEADDR ) (R: itime fflags KEY)
  mw_                   # ( filedes KEYFILE ) (R: itime fflags KEY)
  rpush_                # ( filedes KEYFILE ) (R: itime fflags KEY KEYFILE)
  y_d0_                 # ( filedes KEYFILE Y:filedes )
  call KEYFILEADDR      # ( filedes KEYFILEADDR )
  nip_                  # ( KEYFILEADDR )
  mw_y_                 # ( KEYFILEADDR )
  # defer key to keyfile for input
  lit_y_ KEYFILE        # ( KEYFILEADDR Y:KEYFILE )
  call KEYADDR          # ( KEYADDR )
  mw_y_                 # ( KEYADDR )
  # run interpreter
  call DOTASKS          # ( ? )
  # close keyfile
  call KEYFILEADDR      # ( KEYFILEADDR )
  mw_                   # ( KEYFILE )
  rpush_                # ( KEYFILE ) (R: oitime offlags oKEY oKEYFILE KEYFILE )
  call close            # ( ? )
  rnip_                 # ( ? ) (R: oitime offlags oKEY oKEYFILE )
  # pop tor into keyfile
  rpopy_                # ( ? Y: KEYFILE ) ( R: itime fflags KEY )
  call KEYFILEADDR      # ( KEYFILEADDR )
  mw_y_                 # ( KEYFILEADDR )
  # pop top of return into defer key
  rpopy_                # ( KEYFILEADDR Y:KEY ) ( R: itime fflags )
  call KEYADDR          # ( KEYADDR )
  mw_y_                 # ( KEYADDR )
  # restore FFLAGS
  rpopy_                # ( KEYADDR Y:fflags ) ( R: itime )
  call FFLAGS           # ( FFLAGS )
  hmw_y_                # ( FFLAGS )
  rpop_                 # ( itime ) ( R: )
  jmp IDLETIMESTORE

DOINCLUDE_EXIT:
  pop_                  # ( filedes )
  type_ "File not found!"
  ret

# ( C:filepath -- ** )
# open a file that will be used for key input
Forthword_ INCLUDEF, 0, "include"
  # parse input for filename to include
  call PNAME     # ( addr len )
  # add null to end of string
  y_d0_          # ( addr len ) Y: addr
  x_0_
  w_plus_y_      # ( addr addr' )
  cmw_x_         # ( addr addr' )
  pop_           # ( addr )
  jmp DOINCLUDE
