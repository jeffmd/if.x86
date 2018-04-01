# number.S

# ( -- a-addr )
# location of the cell containing the number conversion radix
Forthword_ BASE, 0, "base"
  user_ USER_BASE
  ret

# ( n -- )
# save base
Forthword_ BASESTORE, 0, "base!"
  str_y_
  user_ USER_BASE
  yw_hstr_
  ret

# ( n -- )
# load base
Forthword_ BASEFETCH, 0, "base@"
  user_ USER_BASE
  hfetch_
  ret

# ( -- )
# set base for number conversion to 2
Forthword_ BIN, 0, "bin"
  two_
  jmp BASESTORE


# ( -- )
# set base for numeric conversion to 10
Forthword_ DECIMAL, 0, "decimal"
  ten_
  jmp BASESTORE

# ( -- )
# set base for number conversion to 16
Forthword_ HEX, 0, "hex"
  lit_ 16
  jmp BASESTORE

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
  ret

DIGITQ0:
  push2_               # ( n n n )
  call BASEFETCH       # ( n n base )
  call UGREATEREQUAL   # ( n flag )
  iszero_
  je PFA_DIGITQ_DONE
  zero_                # ( n 0 )
  nip_                 # ( 0 )
  ret

PFA_DIGITQ_DONE:
  true_                # ( n true )
  ret

# ( c -- ) Numeric IO
# set the BASE value depending on the character
#forthword_ SETBASE, 0, "setbase"
SETBASE:        
  cmp $'$, %eax
  jne PFA_SETBASE0
  jmp HEX

PFA_SETBASE0:
  cmp $'%, %eax
  jne PFA_SETBASE1
  jmp BIN

PFA_SETBASE1:
  cmp $'&, %eax
  jne PFA_SETBASE2
  jmp DECIMAL

PFA_SETBASE2:        # ( error)
  call EMIT
  slit_ " Bad Base!"
  call THROW

# ( addr len -- addr' len' )
# skip a numeric prefix character
#forthword_ PRAEFIX, 0, "praefix"
PRAEFIX:             # ( addr len -- addr' len' )
  over_            # ( addr len addr )
  cfetch_          # ( addr len c )
  cmp $0x30, %eax
  jb PFA_PRAEFIX0
  # no praefix
  pop_             # ( addr len )
  ret

PFA_PRAEFIX0:
  call SETBASE     # ( addr len c )
  one_             # ( addr len 1 )
  jmp SLASHSTRING # ( addr' len' )

# (addr len -- addr len flag) Numeric IO
# check for - sign
# forthword_ NUMBERSIGN, 0, "#-"
NUMBERSIGN:        # ( addr len -- )
  over_          # ( addr len addr )
  cfetch_        # ( addr len char )
  cmp $'-, %eax
  je NUMBERSIGN_HASSIGN
    zero_      # ( addr len 0 )
    ret

NUMBERSIGN_HASSIGN:
  rpush_           # ( addr len char ) (R: char )
  one_             # ( addr len 1 )
  call SLASHSTRING # ( addr len )
  push_            # ( addr len len )
  rpop_            # ( addr len char ) (R: )
  ret

# ( u1 addr len -- u2 addr2 len2 )
# convert a string to a number  c-addr2/u2 is the unconverted string
Forthword_ TO_NUMBER, 0, ">num"
  iszero_
  je TO_NUMBER_END
    over_                # ( u addr len addr )
    cfetch_              # ( u addr len char )
    call DIGITQ          # ( u addr len [digit] flag )
    iszero_
    pop_                 # ( u adr len [digit] )
    jne TO_NUMBER_CONV
      # character is not a recognized number
      ret              # ( u adr len )

TO_NUMBER_CONV:
  d2_str_y_            # ( u adr len digit ) Y: u
  str_x_               # ( u adr len digit ) X: digit
  call BASEFETCH       # ( u adr len base )
  imul %edx, %eax      # ( u adr len u*base )
  addx_                # ( u adr len u'' )
  str_d2_              # ( u'' adr len u'' )
  one_                 # ( u'' adr len 1 )
  call SLASHSTRING     # ( u'' adr' len' )
  jmp TO_NUMBER

TO_NUMBER_END:
  ret

# (addr len -- [n] f)
# convert a string at addr to a number
Forthword_ NUMBER, 0, "num"
  push_                   # ( addr len len )
  call BASEFETCH          # ( addr len base )
  rpush_                  # ( addr len base ) (R: base)
  pop_                    # ( addr len )
  call NUMBERSIGN         # ( addr len flag )
  rpush_                  # ( addr len flag ) (R: base flagsign)
  pop_                    # ( addr len )
  call PRAEFIX            # ( addr' len' )
  call NUMBERSIGN         # ( addr len flagsign2 )
  r0_str_y_               # ( addr len flagsign2 Y:flagsign ) (R: base flagsign)
  ory_                    # ( addr len flagsign' )
  str_r0_                 # ( addr len flagsign' ) (R: base flagsign')
  d0_str_x_               # ( addr len flagsign' ) X: len
  d1_str_y_               # ( addr len flagsign' ) Y: addr
  zero_                   # ( addr len 0 )
  str_d1_                 # ( 0 len 0 )
  y_str_d0_               # ( 0 addr 0 )
  x_                      # ( 0 addr len )
  call TO_NUMBER          # ( n addr' len' )
  # check length of the remaining string.
  # if zero: a single cell number is entered
  iszero_
  pop_                    # ( n addr' )
  je PFA_NUMBER_SIGN

  # error in string to number conversion
  nip_                    # ( addr' ) (R: base flagsign' )
  rnip_                   # ( addr' ) (R: base )
  zero_                   # ( 0 ) (R: base )
  jmp PFA_NUMBER_DONE

PFA_NUMBER_SIGN:
  # incorporate sign into number
  rpop_                   # ( n flagsign' ) (R: base )
  iszero_
  je PFA_NUMBER_TRUE
  pop_                    # ( n )
  neg_                    # ( -n )
  push_                   # ( -n -n )

PFA_NUMBER_TRUE:
  true_                   # ( n true ) (R: base )

PFA_NUMBER_DONE:
  push_                   # ( n flag flag )
  rpop_                   # ( n flag base ) (R: )
  call BASESTORE          # ( n flag ? )
  pop_                    # ( n flag )
  ret