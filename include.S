# include.S

# ( -- keyfileaddr )
# get ram address of key file descriptor
Forthword_ KEYFILEADDR, 0, "keyf#"
  user_ USER_KEYFILE
  end_
  
# ( -- key )
# fetch key from an open file using filedes, should leave
# a single character in WR or -1 if no more to read in file.
Forthword_ KEYFILE, 0, "keyfile"
  zero_                    # ( 0 )
  push_                    # ( 0 0 )
  lit_  1                  # ( 0 1 )
  rpush_                   # ( 0 1 ) (R: 1 )
  rpushdsp_                # ( 0 ebx ) (R: 1 ebx )
  do_ KEYFILEADDR          # ( 0 keyfile# )
  mw_                      # ( 0 filedes )
  rpush_                   # ( 0 filedes ) (R: 1 ebx filedes )
  do_ read                 # ( key count )
  rnip3_                   # ( key count ) (R:  )
  # was one key read from the file?
  push_                    # ( key count count )
  lit_ 1                   # ( key count 1 )
  do_ EQUAL                # ( key flag )
  iszero_                  # ( key flag )
  pop_                     # ( key )
  if_not_0_ KEYEND
    oneminus_
    exit_do_ BYE
    
 KEYEND:
  end_

# ( caddr -- ** )
# open a file that will be used for key input
# caddr points to null terminated file name
Forthword_ DOINCLUDE, 0, "(include)"
  # set file open mode to reading
  y_w_                  # ( caddr ) Y: caddr
  zero_                 # ( 0 )
  rpush_                # ( 0 ) (R: 0 )
  rpushy_               # ( 0 ) (R: 0 caddr )
  do_ open              # ( filedes )
  rnip2_                # ( filedes ) (R:  )
  # if file descriptor > 0 then open is success
  push_                 # ( filedes filedes )
  do_ ZEROGREATER       # ( filedes flag )
  iszero_
  if_0_ DOINCLUDE_EXIT

  do_ IDLETIMEFETCH     # ( filedes itime )
  rpush_                # ( filedes itime ) (R: itime )
  do_ SLEEPOFF          # ( filedes ? )
  # push FFLAGS on tor
  do_ FFLAGS            # ( filedes fflags# )
  hmw_                  # ( filedes fflags )
  rpush_                # ( filedes fflags ) (R: itime fflags )
  # push on return stack the old defer key
  do_ KEYADDR           # ( filedes KEYADDR )
  mw_                   # ( filedes KEY )
  rpush_                # ( filedes KEY ) (R: itime fflags KEY)
  # push old keyfile on return stack
  do_ KEYFILEADDR       # ( filedes KEYFILEADDR ) (R: itime fflags KEY)
  mw_                   # ( filedes KEYFILE ) (R: itime fflags KEY)
  rpush_                # ( filedes KEYFILE ) (R: itime fflags KEY KEYFILE)
  y_d0_                 # ( filedes KEYFILE Y:filedes )
  do_ KEYFILEADDR       # ( filedes KEYFILEADDR )
  nip_                  # ( KEYFILEADDR )
  mw_y_                 # ( KEYFILEADDR )
  # defer key to keyfile for input
  lit_y_ KEYFILE        # ( KEYFILEADDR Y:KEYFILE )
  do_ KEYADDR           # ( KEYADDR )
  mw_y_                 # ( KEYADDR )
  # run interpreter
  do_ DOTASKS           # ( ? )
  # close keyfile
  do_ KEYFILEADDR       # ( KEYFILEADDR )
  mw_                   # ( KEYFILE )
  rpush_                # ( KEYFILE ) (R: oitime offlags oKEY oKEYFILE KEYFILE )
  do_ close             # ( ? )
  rnip_                 # ( ? ) (R: oitime offlags oKEY oKEYFILE )
  # pop tor into keyfile
  rpopy_                # ( ? Y: KEYFILE ) ( R: itime fflags KEY )
  do_ KEYFILEADDR       # ( KEYFILEADDR )
  mw_y_                 # ( KEYFILEADDR )
  # pop top of return into defer key
  rpopy_                # ( KEYFILEADDR Y:KEY ) ( R: itime fflags )
  do_ KEYADDR           # ( KEYADDR )
  mw_y_                 # ( KEYADDR )
  # restore FFLAGS
  rpopy_                # ( KEYADDR Y:fflags ) ( R: itime )
  do_ FFLAGS            # ( FFLAGS )
  hmw_y_                # ( FFLAGS )
  rpop_                 # ( itime ) ( R: )
  exit_do_ IDLETIMESTORE

DOINCLUDE_EXIT:
  pop_                  # ( filedes )
  type_ "File not found!"
  end_

# ( C:filepath -- ** )
# open a file that will be used for key input
Forthword_ INCLUDEF, 0, "include"
  # parse input for filename to include
  do_ PNAME     # ( addr len )
  # add null to end of string
  y_d0_          # ( addr len ) Y: addr
  x_0_
  w_plus_y_      # ( addr addr' )
  cmw_x_         # ( addr addr' )
  pop_           # ( addr )
  end_do_ DOINCLUDE
