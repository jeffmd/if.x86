# dictionary.S

# ( -- addr )
# current vocabulary for new words
Forthword_ CURRENT, 0, "current"
  user_ ram_CURRENT
  ret

# ( -- addr )
# context vocabulary for searching
# array of wordlists
Forthword_ CONTEXT, 0, "context"
  user_ ram_CONTEXT
  ret

# ( nfa -- lfa )
# get the link field address from the name field address
Forthword_ NFA2LFA, 0, "nfa>lfa"
  call STRINGLEN               # ( nfa+2 len+flags )
  # mask out flags in len, allow up to 31 characters
  and $31, %eax                # ( nfa+2 len )
  d0_str_y_                    # ( nfa+2 len ) Y: nfa+2
  addy_                        # ( nfa+2 nfa+2+len )
  nip_                         # ( nfa+2+len )
  ret

# ( nfa -- [ 0 ] | [ xt xtflags] )
# convert name field address to xt and xtflags
Forthword_ NFATOXTF, 0, "nfa>xtf"
  iszero_                     # ( n )
  je NFATOXTF_EXIT

  push_                       # ( nfa nfa )
  hfetch_                     # ( nfa xtflags )
  rpush_                      # ( nfa xtflags) (R: xtflags)
  pop_                        # ( nfa )
  call NFA2LFA                # ( lfa )
  fourplus_   # lfa>xtlink    # ( xtlink )
  fetch_                      # ( xt )
  push_                       # ( xt xt )
  rpop_                       # ( xt xtflags )

NFATOXTF_EXIT:
  ret

# ( addr len idx -- 0 | nfa )
FINDWI:
  fourstar_          # ( addr len idx*4 )
  str_y_             # ( addr len idx*4 ) Y: idx*4
  call CONTEXT       # ( addr len context )
  addy_              # ( addr len context' )
  fetch_             # ( addr len wid )

# ( c-addr len wid -- [ 0 | nfa ] )
# find a word in the dictionary
# 0 if word not found in dictionary
# nfa if word is found
Forthword_ FINDNFA, 0, "findnfa"
  iszero_
  jne FINDNFA_BEGIN
    # terminating, wid is empty
    nip2_
    ret

  # <begin>
FINDNFA_BEGIN:
  fetch_                      # ( c-addr len nfa )
  # <while>
FINDNFA_BEGIN1:
  iszero_                     # ( c-addr len nfa )
  jne FINDNFA_CHECK
    # terminating, 0 found
    nip2_                     # ( 0 )
    ret

FINDNFA_CHECK:
  
  rpush_                      # ( c-addr len nfa) (R: nfa )
  pop_
  call TWOOVER                # ( c-addr len c-addr len )
  push_                       # ( c-addr len c-addr len len )
  r0_                         # ( c-addr len c-addr len nfa )
  call STRINGLEN              # ( c-addr len c-addr len f-addr len )
  and $31, %eax               # ( c-addr len c-addr len f-addr 0:len )
  call MCMP                   # ( c-addr len flag )
  # <if>
  iszero_
  rpop_                       # ( c-addr len nfa )
  je FINDNFA_NEXT
    # we found the string
    nip2_                     # ( nfa )
    ret
    
  # <then>
FINDNFA_NEXT:
    # next try
    call NFA2LFA              # ( c-addr len lfa )
    # <repeat>
    jmp FINDNFA_BEGIN


# ( addr len idx * )
FINDLAST:
  pop2_                       # ( addr len )

# ( addr len --  0 | nfa )
# search root wordlists for the name from string addr/len
Forthword_ FINDROOT, 0, "froot"
  # put root wid on stack
  push_              # ( addr len len )
  lit_ VE_COLD     # ( addr len VE_COLD )
  jmp FINDNFA_BEGIN1

# ( addr len --  0 | nfa )
# search wordlists for the name from string addr/len
Forthword_ FINDW, 0, "findw"
  # loop through context slots to find a word
  # start with last slot
  push_               # ( addr len len )
  call CONTEXT        # ( addr len context )
  # get context index and use as counter
  twominus_           # ( addr len context-2 )
  hfetch_             # ( addr len idx )
  push_               # ( addr len idx idx )
  
FINDW_BEGIN:
  iszero_
  js FINDLAST         # ( addr len idx * )
    pop_              # ( addr len idx )
    call THREEOVER    # ( addr len idx addr len idx )
    call FINDWI       # ( addr len idx nfa )
    iszero_
    # end loop if word found
    je FINDW_NEXT
      nip3_           # ( nfa )
      ret

FINDW_NEXT:
  d0_                 # ( addr len idx idx )
  # decrement index
  oneminus_           # ( addr len idx idx-1 )
  str_d0_             # ( addr len idx-1 idx-1 )
  jmp FINDW_BEGIN

# ( -- )
# set the context and current to root forth vocabulary and remove
# other vocabularies
Forthword_ ONLY, IMMEDIATE_EN, "only"
  # forth vocab always takes slot 0
  lit_y_ EE_FORTHWORDLIST     # ( ? ) Y:FLIST
  call CURRENT                # ( CURRENT )
  yw_str_                     # ( CURRENT )
  # make current also forth vocab
  call CONTEXT                # ( CONTEXT )
  yw_str_                     # ( CONTEXT )
  # move index to next slot
  twominus_                   # ( CONTEXT-2 )
  lit_y_ 1                    # ( CONTEXT-2 Y:1 )
  yw_hstr_                    # ( CONTEXT-2 )
  # make second slot have no vocab
  twoplus_                    # ( CONTEXT )
  fourplus_                   # ( CONTEXT+4 )
  zero_str_
  ret
