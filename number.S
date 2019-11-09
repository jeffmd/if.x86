# number.S

# ( -- a-addr )
# location of the cell containing the number conversion radix
Forthword_ BASE, 0, "base"
  user_ USER_BASE
  end_
  ret

# ( n -- )
# save base
Forthword_ BASESTORE, 0, "base="
  y_w_
  user_ USER_BASE
  hmw_y_
  end_

# ( n -- )
# load base
Forthword_ BASEFETCH, 0, "base@"
  user_ USER_BASE
  hmw_
  end_
 
# ( -- )
# set base for number conversion to 2
Forthword_ BIN, 0, "bin"
  lit_ 2
  end_do_ BASESTORE


# ( -- )
# set base for numeric conversion to 10
Forthword_ DECIMAL, 0, "decimal"
  lit_ 10
  end_do_ BASESTORE

# ( -- )
# set base for number conversion to 16
Forthword_ HEX, 0, "hex"
  lit_ 16
  end_do_ BASESTORE

# ( c -- (number|) flag )
# tries to convert a character to a number, set flag accordingly
Forthword_ DIGITQ, 0, "digit?"
  sub $0x30, %eax      # ( c' )
  cmp $10, %eax
  jb DIGITQ0
  sub $7, %eax         # ( c )
  cmp $10, %eax        # ( c )
  jge DIGITQ0

  zero_                # ( 0 )
  exit_

DIGITQ0:
  push_
  push_                # ( n n n )
  do_ BASEFETCH        # ( n n base )
  do_ UGREATEREQUAL    # ( n flag )
  iszero_
  if_0_ PFA_DIGITQ_DONE
  zero_                # ( n 0 )
  nip_                 # ( 0 )
  exit_

PFA_DIGITQ_DONE:
  true_                # ( n true )
  end_

# ( c -- ) Numeric IO
# set the BASE value depending on the character
#forthword_ SETBASE, 0, "setbase"
SETBASE:        
  cmp $'$, %eax
  if_not_0_ PFA_SETBASE0
  exit_do_ HEX

PFA_SETBASE0:
  cmp $'%, %eax
  if_not_0_ PFA_SETBASE1
  exit_do_ BIN

PFA_SETBASE1:
  cmp $'&, %eax
  if_not_0_ PFA_SETBASE2
  exit_do_ DECIMAL

PFA_SETBASE2:        # ( error)
  do_ EMIT
  slit_ " Bad Base!"
  do_ THROW

# ( addr len -- addr' len' )
# skip a numeric prefix character
#forthword_ PRAEFIX, 0, "praefix"
PRAEFIX:             # ( addr len -- addr' len' )
  push_
  d1_              # ( addr len addr )
  cmw_             # ( addr len c )
  cmp $0x30, %eax
  jb PFA_PRAEFIX0
  # no praefix
  pop_             # ( addr len )
  exit_

PFA_PRAEFIX0:
  do_ SETBASE      # ( addr len c )
  lit_ 1           # ( addr len 1 )
  end_do_ SLASHSTRING  # ( addr' len' )

# (addr len -- addr len flag) Numeric IO
# check for - sign
# forthword_ NUMBERSIGN, 0, "#-"
NUMBERSIGN:        # ( addr len -- )
  push_
  d1_            # ( addr len addr )
  cmw_           # ( addr len char )
  cmp $'-, %eax
  if_0_ NUMBERSIGN_HASSIGN
    zero_      # ( addr len 0 )
    exit_

NUMBERSIGN_HASSIGN:
  rpush_           # ( addr len char ) (R: char )
  lit_ 1           # ( addr len 1 )
  do_ SLASHSTRING  # ( addr len )
  push_            # ( addr len len )
  rpop_            # ( addr len char ) (R: )
  end_

# ( u1 addr len -- u2 addr2 len2 )
# convert a string to a number  c-addr2/u2 is the unconverted string
Forthword_ TO_NUMBER, 0, ">num"
  iszero_
  if_0_ TO_NUMBER_END
    push_
    d1_                  # ( u addr len addr )
    cmw_                 # ( u addr len char )
    do_ DIGITQ           # ( u addr len [digit] flag )
    iszero_
    pop_                 # ( u adr len [digit] )
    if_not_0_ TO_NUMBER_CONV
      # character is not a recognized number
      exit_              # ( u adr len )

TO_NUMBER_CONV:
  y_d2_                # ( u adr len digit ) Y: u
  x_w_                 # ( u adr len digit ) X: digit
  do_ BASEFETCH        # ( u adr len base )
  imul %edx, %eax      # ( u adr len u*base )
  w_plus_x_            # ( u adr len u'' )
  d2_w_                # ( u'' adr len u'' )
  lit_ 1               # ( u'' adr len 1 )
  do_ SLASHSTRING      # ( u'' adr' len' )
  exit_do_ TO_NUMBER

TO_NUMBER_END:
  end_

# (addr len -- [n] f)
# convert a string at addr to a number
Forthword_ NUMBER, 0, "num"
  push_                   # ( addr len len )
  do_ BASEFETCH           # ( addr len base )
  rpush_                  # ( addr len base ) (R: base)
  pop_                    # ( addr len )
  do_ NUMBERSIGN          # ( addr len flag )
  rpush_                  # ( addr len flag ) (R: base flagsign)
  pop_                    # ( addr len )
  do_ PRAEFIX             # ( addr' len' )
  do_ NUMBERSIGN          # ( addr len flagsign2 )
  y_r0_                   # ( addr len flagsign2 Y:flagsign ) (R: base flagsign)
  w_or_y_                 # ( addr len flagsign' )
  r0_w_                   # ( addr len flagsign' ) (R: base flagsign')
  x_d0_                   # ( addr len flagsign' ) X: len
  y_d1_                   # ( addr len flagsign' ) Y: addr
  zero_                   # ( addr len 0 )
  d1_w_                   # ( 0 len 0 )
  d0_y_                   # ( 0 addr 0 )
  x_                      # ( 0 addr len )
  do_ TO_NUMBER           # ( n addr' len' )
  # check length of the remaining string.
  # if zero: a single cell number is entered
  iszero_
  pop_                    # ( n addr' )
  if_0_ PFA_NUMBER_SIGN

  # error in string to number conversion
  nip_                    # ( addr' ) (R: base flagsign' )
  rnip_                   # ( addr' ) (R: base )
  zero_                   # ( 0 ) (R: base )
  goto_ PFA_NUMBER_DONE

PFA_NUMBER_SIGN:
  # incorporate sign into number
  rpop_                   # ( n flagsign' ) (R: base )
  iszero_
  if_0_ PFA_NUMBER_TRUE
  pop_                    # ( n )
  neg_                    # ( -n )
  push_                   # ( -n -n )

PFA_NUMBER_TRUE:
  true_                   # ( n true ) (R: base )

PFA_NUMBER_DONE:
  push_                   # ( n flag flag )
  rpop_                   # ( n flag base ) (R: )
  do_ BASESTORE           # ( n flag ? )
  pop_                    # ( n flag )
  end_
