\ vocabulary.fs - words for managing the words

\ get context index address
: contidx ( -- addr )
  context 2-
;

\ get context array address using context index
: context# ( -- addr )
  context !y contidx h@ dcell* +y
;

\ get a wordlist id from context array
: context@ ( -- wid )
  context# @
;

\ save wordlist id in context array at context index
: context! ( wid -- addr )
  push context# d0!y nip y.!
;

\ get a valid wid from the context
\ tries to get the top vocabulary
\ if no valid entries then defaults to Forth wid
: wid@ ( -- wid )
  context@
  ?if else context @ then
;

\ wordlist record fields:
\ [0] word:dcell: address to nfa of most recent word
\     added to this wordlist
\ [1] Name:dcell: address to nfa of vocabulary name 
\ [2] link:dcell: address to previous sibling wordlist to form
\     vocabulary linked list
\ [3] child:dcell: address to head of child wordlist

\ add link field offset
: wid:link ( wid -- wid:link) dcell+ dcell+ ;
\ add child field offset
: wid:child ( wid -- wid:child ) !y 3 dcell* +y ;

\ initialize wid fields of definitions vocabulary
: widinit ( wid -- wid )
  \ wid.word = 0
  !x ( wid )  \ X: wid
  0! ( wid )  \ wid.word = 0

  \ parent wid child field is in cur@->child
  push cur@ wid:child  ( wid parentwid.child )
  push       ( wid parentwid.child parentwid.child )
  @          ( wid parentwid.child childwid )
  !y         ( wid parentwid.child childwid Y:childwid)
  x wid:link ( wid parentwid.child wid.link )
  \ wid.link = childLink
  y.!        ( wid parentwid.child wid.link )
  \ wid.child = 0
  dcell+ 0!  ( wid parentwid.child wid.child )
  \ parentwid.child = wid
  pop        ( wid parentwid.child )
  d0!y nip   ( parentwid.child )
  y.! x      ( wid )
;

\ make a wordlist record in data ram
\ and initialize the fields
: wordlist ( -- wid )
  \ get next available ram from here and use as wid
  here ( wid )   
  \ allocate  4 data cells in ram for the 4 fields
  push 4 dcell* allot pop ( wid )

  widinit ( wid )
;

\ similar to dup : duplicate current wordlist in vocabulary search list
\ normally used to add another vocabulary to search list
\ ie: also MyWords
: also ( -- )
  context@ push
  \ increment index
  contidx 1+h! pop
  context!
  
; immediate


\ similar to drop but for vocabulary search list
\ removes most recently added wordlist from vocabulary search list
: previous ( -- )
  \ get current index and decrement by 1
  contidx push ( contidx contidx ) 
  h@ 1- push   ( contidx idx-1 idx-1 )
  \ index must be >= 1
  0>           ( contidx idx-1 flag )
  ?if
    0 context! ( contidx idx-1 addr ) 
    d0!y d1    ( contidx idx-1 contidx Y:idx-1 )
    y.h!       ( contidx )
  else
    [compile] only
  then
  nip2
; immediate

\ Used in the form:
\ cccc DEFINITIONS
\ Set the CURRENT vocabulary to the CONTEXT vocabulary - where new
\ definitions are put in the CURRENT word list. In the
\ example, executing vocabulary name cccc made it the CONTEXT
\ vocabulary (for word searches) and executing DEFINITIONS
\ made both specify vocabulary
\ cccc.
( -- )
: definitions
    context@
    ?if !y current y.! then
; immediate

\ A defining word used in the form:
\     vocabulary cccc  
\ to create a vocabulary definition cccc. Subsequent use of cccc will
\ make it the CONTEXT vocabulary which is searched first by INTERPRET.
\ The sequence "cccc DEFINITIONS" will also make cccc the CURRENT
\ vocabulary into which new definitions are placed.

\ By convention, vocabulary names are automaticaly declared IMMEDIATE.

: vocabulary ( -- ) ( C:cccc )
  create
  [compile] immediate
  \ allocate space in ram for head and tail of vocab word list
  wordlist push  ( wid wid )
  \ voc.wid = wid
  dw,            ( wid ? )
  \ wid.name = vocabulary.nfa  
  cur@ @ !y pop  ( wid Y:voc.nfa )
  dcell+ y.!     ( wid.name )
  
  does>
   @ \ get header address
   \ make this vocabulary the active search context
   context!
;

\ Set context to Forth vocabulary
: Forth ( -- )
  context @ context!
; immediate

\ setup forth name pointer in forth wid name field
\ get forth nfa - its the most recent word created
cur@ @ push ( nfa nfa )
\ get the forth wid, initialize it and set name field
\ forthwid.word is already initialized
context @ dcell+ ( nfa forthwid.name )
\ forthwid.name = nfa
d0!y nip y.! ( forthwid.name )
\ forthwid.link = 0
dcell+ 0! ( forthwid.link )
\ forthwid.child = 0
dcell+ 0! ( )

\ print name field
: .nf ( nfa -- )
      $l !y $FF and.y  ( addr cnt ) \ mask immediate bit
      type space       ( ? )
;
 
\ list words starting at a name field address
: lwords ( nfa -- )
    push 0 push              ( nfa 0 0 )
    begin
    d1                       ( nfa cnt nfa )
    ?while                   ( nfa cnt nfa ) \ is nfa = counted string
      .nf d1                 ( nfa cnt nfa )
      nfa>lfa                ( nfa cnt lfa )
      @ !d1                  ( nfa' cnt addr )
      d0 1+ !d0              ( nfa' cnt+1 cnt+1 )
    repeat 
    cr ." count: " pop .
    nip
;

\ List the names of the definitions in the context vocabulary.
\ Does not list other linked vocabularies.
\ Use words to see all words in the top context search.
: words ( -- )
    wid@ ( wid )
    @    ( nfa )
    lwords
;

\ list the root words
: rwords ( -- )
  [ find WIPE lit, ]
  lwords
;

\ print out search list of active vocabularies
: order ( -- )
  ." Search: "
  \ get context index and use as counter
  contidx h@ push              ( idx idx )
  begin
  \ iterate through vocab array and print out vocab names
  ?while
    dcell* !y context +y      ( idx context' )
    \ get context wid
    @                          ( idx wid )
    \ if not zero then print vocab name 
    ?if
      \ next cell has name field address 
      dcell+ @                 ( idx nfa )
      .nf                      ( idx ? )
    then
    \ decrement index
    d0 1- !d0
  repeat
  pop
  ." Forth Root" cr
  ." definitions: "
  cur@ dcell+ @ .nf cr
;

\ print child vocabularies
: .childvocs ( spaces wid -- )
  begin
  \ while link is not zero
  ?while  ( spaces linkwid )
    \ print indent
    over spaces ." |- " ( spaces linkwid ? )
    \ get name from name field
    d0 dcell+ !d0 @ ( spaces linkwid.name name )
    \ print name and line feed
    .nf cr        ( spaces link.name ? )
    \ increase spaces for indenting child vocabularies
    d1 4+ push    ( spaces linkwid.name spaces+4 spaces+4 )
    \ get link field
    d1 dcell+ !d1 ( spaces linkwid.link spaces+4 linkwid.link )
    \ get child link and recurse: print child vocabularies
    dcell+ @      ( spaces linkwid.link spaces+4 childwid )
    recurse       ( spaces linkwid.link )
    \ get link for next sibling
    @
  repeat
  pop2
;

\ list context vocabulary and all child vocabularies
\ order is newest to oldest
: vocs ( -- )
  \ start spaces at 2
  push 2        ( ? 2 )
  \ get top search vocabulary address
  \ it is the head of the vocabulary linked list
  push wid@     ( ? 2 wid )
  \ print context vocabulary
  push dcell+   ( ? 2 wid wid.name )
  @ .nf cr pop  ( ? 2 wid )
  \ get child link of linked list
  wid:child @   ( ? 2 childwid )
  .childvocs cr ( ? )
;
