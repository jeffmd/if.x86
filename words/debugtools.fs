only

( -- n )
\ Tools
\ Amount of available RAM (incl. PAD)
: unused
    dsp0 y=w here w-=y
;

( addr1 cnt -- addr2)
: dmp
 push d1 .$ [char] : emit space
 begin
   d0 ?while
     1- d0=w d1 @ .$ d1 dcell+ d1=w
 repeat
 nip pop
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
: rbs popy x=w c@ w|=y c@x=w ;

( bbb reg -- )
\ tools
\ clear the bits of reg defined by bit pattern in bbb
: rbc x=w popy !y c@x w&=y c@x=w ;

\ modify bits of reg defined by mask
: rbm ( val mask reg -- )
    x=w popy c@x w&=y popy w|=y c@x=w
;


( reg|addr -- )
\ tools
\ read register/ram byte contents and print in binary form
: rb? c@ x=w bin x <# # # # # # # # # #> type space decimal ;

( reg -- )
\ tools
\ read register/ram byte contents and print in hex form
: r? c@ .$ ;

\ setup fence which is the lowest address that we can forget words
var fence
find r? y=w fence @w=y

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
      dp=           ( dp# Y:nfa )
      \ set context wid to lfa
      y nfa>lfa     ( lfa )
      @ y=w         ( nfa Y:nfa )
      cur@          ( wid )
      @w=y          ( wid )
    then
  then
;

find forget y=w fence @w=y

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
    x=w y=@w here# @w=y    ( here# X:addr )
    \ restore dp
    x+=4 @x dp=          ( dp )
    \ restore current wid
    x+=4 @x y=w          ( nfa Y:nfa )
    x+=4 @x @w=y         ( wid )
    \ only Forth and Root are safe vocabs
    [compile] only
;
