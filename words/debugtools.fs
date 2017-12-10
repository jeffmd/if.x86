only

( -- n )
\ Tools
\ Amount of available RAM (incl. PAD)
: unused
    sp0 !y here -y
;

( addr1 cnt -- addr2)
: dmp
 over .$ [char] : emit space
 begin
   d0 ?while
     1- !d0 d1 @ .$ d1 dcell+ !d1
 repeat
 pop2
;

( addr -- )
\ Tools
\ print the contents at ram word addr
: ? @ . ;

\ print the contents at ram char addr
: c? c@ . ;

( bbb reg -- )
\ tools
\ set the bits of reg defined by bit pattern in bbb
: rbs d0!y nip !x c@ or.y xc! ;

( bbb reg -- )
\ tools
\ clear the bits of reg defined by bit pattern in bbb
: rbc !x d0!y nip not.y xc@ and.y xc! ;

\ modify bits of reg defined by mask
: rbm ( val mask reg -- )
    !x d0!y nip xc@ and.y d0!y or.y nip
    xc!
;


( reg -- )
\ tools
\ read register/ram byte contents and print in binary form
: rb? c@ bin <# # # # # # # # # #> type space decimal ;

( reg -- )
\ tools
\ read register/ram byte contents and print in hex form
: r? c@ .$ ;

\ setup fence which is the lowest address that we can forget words
var fence
find r? !y fence y.!

( c: name -- )
\ can only forget a name that is in the current definition
: forget
  pname             ( addr cnt )
  push cur@         ( addr cnt wid )
  findnfa           ( nfa )
  ?if
    \ nfa must be greater than fence
    push            ( nfa nfa)
    push fence @    ( nfa nfa fence )
    >               ( nfa nfa>fence )
    if
      \ nfa is valid
      \ set dp to nfa
      dp#!          ( dp# Y:nfa )
      \ set context wid to lfa
      y nfa>lfa     ( lfa )
      @ !y          ( nfa Y:nfa )
      cur@          ( wid )
      y.!           ( wid )
    then
  then
;

find forget !y fence y.!

\ create a marker word
\ when executed it will restore dp, here and current
\ back to when marker was created
: marker  ( c: name -- )
  \ copy current word list, current wid, dp, here
  cur@ push        ( wid wid )
  @ push           ( wid nfa nfa )
  dp push          ( wid nfa dp dp )
  here push        ( wid nfa dp here here )
  create           ( wid nfa dp here ? )
  \ save here, dp, current wid, current word list
  pop dw, pop dw, pop dw, pop dw,
  
  does> ( addr )
    \ restore here
    push @ !y here# y.!    ( addr ? )
    \ restore dp
    d0 dcell+ !d0 @ dp#!   ( addr ? )
    \ restore current wid
    d0 dcell+ !d0 @ !y     ( addr nfa Y:nfa )
    pop dcell+ @ y.!       ( wid )
    \ only Forth and Root are safe vocabs
    [compile] only
;
