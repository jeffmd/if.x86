# dictionary.S

# dictionary structure:
# length | flags : word: highbyte is flags, lowbyte is string length
# name : string
# previouse word: 32 bit pointer to previousely defined word
# code: 32 bit pointer to executable code


# ( -- addr )
# current wordlist vocabulary for new words
Forthword_ CURRENT, 0, "current"
  user_ ram_CURRENT
  ret

# ( -- addr )
# context wordlist vocabulary for searching
# array of wordlists
Forthword_ CONTEXT, 0, "context"
  user_ ram_CONTEXT
  ret

# ( nfa -- lfa )
# get the link field address from the name field address
Forthword_ NFA2LFA, 0, "nfa>lfa"
  call STRINGLEN               # ( nfa+2 len+flags )
  popy_                        # ( len ) Y: nfa+2
  # mask out flags in len, allow up to 31 characters
  and $31, %eax                # ( len )
  w_plus_y_                    # ( nfa+2+len )
  ret

# ( nfa -- [ 0 ] | [ xt xtflags] )
# convert name field address to xt and xtflags
Forthword_ NFATOXTF, 0, "nfa>xtf"
  iszero_                     # ( n )
  je NFATOXTF_EXIT

  push_                       # ( nfa nfa )
  hmw_                        # ( nfa xtflags )
  rpush_                      # ( nfa xtflags) (R: xtflags)
  pop_                        # ( nfa )
  call NFA2LFA                # ( lfa )
  fourplus_   # lfa>xtlink    # ( xtlink )
  mw_                         # ( xt )
  push_                       # ( xt xt )
  rpop_                       # ( xt xtflags )

NFATOXTF_EXIT:
  ret

# ( addr len idx -- 0 | nfa )
FINDWI:
  fourstar_          # ( addr len idx*4 )
  y_w_               # ( addr len idx*4 ) Y: idx*4
  call CONTEXT       # ( addr len context )
  w_plus_y_          # ( addr len context' )
  mw_                # ( addr len wid )

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
  mw_                         # ( c-addr len nfa )
  # <while>
FINDNFA_BEGIN1:
  iszero_                     # ( c-addr len nfa )
  jne FINDNFA_CHECK
    # terminating, 0 found
    nip2_                     # ( 0 )
    ret

FINDNFA_CHECK:
  
  rpush_                      # ( c-addr len nfa) (R: nfa )
  y_d1_                       # ( c-addr len nfa ) Y:c-addr
  x_d0_                       # ( c-addr len nfa ) X:len
  pushy_                      # ( c-addr len c-addr nfa )
  pushx_                      # ( c-addr len c-addr len nfa )
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
  d1_
  nip2_                       # ( addr len )

# ( addr len --  0 | nfa )
# search root wordlists for the name from string addr/len
Forthword_ FINDROOT, 0, "froot"
  # put root wid on stack
  push_              # ( addr len len )
  lit_ VE_WIPE       # ( addr len VE_COLD )
  jmp FINDNFA_BEGIN1

# ( -- idx )
# get context index
Forthword_ CONTIDX_FETCH, 0 "contidx@"
  call CONTEXT        # ( context )
  # get context index
  twominus_           # ( context-2 )
  y_w_                # ( contidx ) Y:contidx
  hmw_                # ( idx )
  x_w_            
  push_               # ( idx idx ) X:idx
  lit_ (MAX_CONTEXTS - 1) # ( idx max )
  call GREATER        # ( flag )
  iszero_
  jz 1f
    lit_ (MAX_CONTEXTS - 1)  # ( max )
    hmy_w_
    ret
1:
  x_                  # ( idx )
  ret

# ( addr len --  0 | nfa )
# search wordlists for the name from string addr/len
Forthword_ FINDW, 0, "findw"
  # loop through context slots to find a word
  # start with last slot
  push_               # ( addr len len )
  call CONTIDX_FETCH  # ( addr len idx )
  # get context index and use as counter
  push_               # ( addr len idx idx )
  
FINDW_BEGIN:
  iszero_
  js FINDLAST         # ( addr len idx idx )
    y_d2_
    x_d1_
    pushy_
    pushx_            # ( addr len idx addr len idx )
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
  d0_w_               # ( addr len idx-1 idx-1 )
  jmp FINDW_BEGIN

# ( -- )
# set the context and current to root and forth vocabulary and remove
# other vocabularies
Forthword_ ONLY, IMMEDIATE_EN, "only"
  # forth vocab always takes slot 0
  lit_y_ EE_FORTHWORDLIST     # ( ? ) Y:FLIST
  call CURRENT                # ( CURRENT )
  mw_y_                       # ( CURRENT )
  # make current also forth vocab
  call CONTEXT                # ( CONTEXT )
  mw_y_                       # ( CONTEXT )
  # move index to slot 1
  twominus_                   # ( CONTEXT-2 )
  lit_y_ 1                    # ( CONTEXT-2 Y:1 )
  hmw_y_                      # ( CONTEXT-2 )
  # make second slot have no vocab
  twoplus_                    # ( CONTEXT )
  y_0_
  fourplus_                   # ( CONTEXT+4 )
  mw_y_
  ret
