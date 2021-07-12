\ boot.fs - bootstrap the forth compiler
\ header are (create) are created manually
\ use (create) to make : then define the rest manually

\ header ( addr len wid -- nfa )
\ 
dp d=           \ ( nfa nfa ) name field address
pname header d= y# $FF00 |y @dp=$ \ ( nfa ? )
  current @ @   \ ( nfa linkaddr ) get latest word
  @dp=          \ ( nfa ? ) set link field to prev word in vocab
  cp @dp= d     \ ( nfa ) set code pointer field
  smudge=       \ ( ? )
  ]
    d= dp       \ ( addr len wid nfa )
    r=          \ ( addr len wid nfa ) (R: nfa )
    d           \ ( addr len wid )
    r=          \ ( addr len wid ) (R: nfa wid )
    y=d0        \ ( addr len wid Y:len )
    $FF00 |y    \ ( addr len len|$FF00 )
    @dp=$       \ ( ? )
    r @         \ ( linkaddr ) (R: nfa )
    @dp=        \ ( ? )
    r           \ ( dp )
  [
  ;opt
  uwid

\ (create) ( <input> -- nfa )
pname (create) d= current @ header \ ( nfa )
  d= cp         \ ( nfa cp )
  @dp= d        \ ( nfa )
  smudge=       \ ( ? )
  ]
    pname d= current @ header d= cp @dp= d
  [
  ;opt
  uwid

\ : ( <input> -- )
\ used to define a new word
(create) :
  smudge=
  ]
    (create) smudge= ]
  [
  ;opt
  uwid

\ : can now be used to define a new word but must manually
\ terminate the definition of a new word

\ ( -- wid )
\ get the current wid
: cur@
    current @
  [
  ;opt uwid

\ ( n -- )
\ set wid flags of current word
: widf
    y=         \ ( n ) y; n
    cur@ @ x=  \ ( nfa ) X: nfa
    h@x        \ ( flags )
    &y         \ ( n&flags )
    h@x=       \ ( n&flags )
  [
  ;opt uwid

: immediate
    $7FFF widf
  [
  ;opt uwid

\ define ; which is used when finishing the compiling of a word
: ;
  \ change to interpret mode and override to compile [
  [ pname [ findw nfa>xtf cxt ]
  \ back in compile mode
    ;opt uwid
[ ;opt uwid immediate
