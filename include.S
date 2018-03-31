# include.S

# ( -- keyfileaddr )
# get ram address of key file descriptor
Forthword_ KEYFILEADDR, 0, "keyf#"
  user_ USER_KEYFILE
  ret
  
# ( caddr -- ** )
# open a file that will be used for key input
# caddr points to null terminated file name
Forthword_ DOINCLUDE, 0, "(include)"
  # set file open mode to reading
  str_y_                # ( caddr ) Y: caddr
  zero_                 # ( 0 )
  rpush_                # ( 0 ) (R: 0 )
  rpush_y_              # ( 0 ) (R: 0 caddr )
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
  hfetch_               # ( filedes fflags )
  rpush_                # ( filedes fflags ) (R: itime fflags )
  # push on return stack the old defer key
  call KEYADDR          # ( filedes KEYADDR )
  fetch_                # ( filedes KEY )
  rpush_                # ( filedes KEY ) (R: itime fflags KEY)
  # push old keyfile on return stack
  call KEYFILEADDR      # ( filedes KEYFILEADDR ) (R: itime fflags KEY)
  fetch_                # ( filedes KEYFILE ) (R: itime fflags KEY)
  rpush_                # ( filedes KEYFILE ) (R: itime fflags KEY KEYFILE)
  d0_str_y_             # ( filedes KEYFILE Y:filedes )
  call KEYFILEADDR      # ( filedes KEYFILEADDR )
  nip_                  # ( KEYFILEADDR )
  yw_str_               # ( KEYFILEADDR )
  # defer key to keyfile for input
  lit_y_ KEYFILE        # ( KEYFILEADDR Y:KEYFILE )
  call KEYADDR          # ( KEYADDR )
  yw_str_               # ( KEYADDR )
  # run interpreter
  call DOTASKS          # ( ? )
  # close keyfile
  call KEYFILEADDR      # ( KEYFILEADDR )
  fetch_                # ( KEYFILE )
  rpush_                # ( KEYFILE ) (R: oitime offlags oKEY oKEYFILE KEYFILE )
  call close            # ( ? )
  rnip_                 # ( ? ) (R: oitime offlags oKEY oKEYFILE )
  # pop tor into keyfile
  rpop_y_               # ( ? Y: KEYFILE ) ( R: itime fflags KEY )
  call KEYFILEADDR      # ( KEYFILEADDR )
  yw_str_               # ( KEYFILEADDR )
  # pop top of return into defer key
  rpop_y_               # ( KEYFILEADDR Y:KEY ) ( R: itime fflags )
  call KEYADDR          # ( KEYADDR )
  yw_str_               # ( KEYADDR )
  # restore FFLAGS
  rpop_y_               # ( KEYADDR Y:fflags ) ( R: itime )
  call FFLAGS           # ( FFLAGS )
  yw_hstr_              # ( FFLAGS )
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
  d0_str_y_      # ( addr len ) Y: addr
  addy_          # ( addr addr' )
  zero_cstr_     # ( addr addr' )
  pop_           # ( addr )
  jmp DOINCLUDE
