\ boot.fs - bootstrap the forth compiler
\ header are (create) are created manually
\ use (create) to make : then define the rest manually

\ header ( addr len wid -- nfa )
\ 
dp push         \ ( nfa nfa ) name field address
pname header push push $FF00 or $dp! \ ( nfa ? )
  current @ @   \ ( nfa linkaddr ) get latest word
  dp!           \ ( nfa ? ) set link field to prev word in vocab
  cp dp! pop    \ ( nfa ) set code pointer field
  smudge!       \ ( ? )
  ]
    push dp     \ ( addr len wid nfa )
    rpush       \ ( addr len wid nfa ) (R: nfa )
    rpushd0     \ ( addr len wid nfa ) (R: nfa wid )
    d1 !d0      \ ( addr len len len ) (R: nfa wid )
    $FF00 or    \ ( addr len len|$FF00 )
    $dp!        \ ( ? )
    rpop @      \ ( linkaddr ) (R: nfa )
    dp!         \ ( ? )
    rpop        \ ( dp )
  [
  ;opt
  uwid

\ (create) ( <input> -- nfa )
pname (create) push current @ header \ ( nfa )
  push cp       \ ( nfa cp )
  dp! pop       \ ( nfa )
  smudge!       \ ( ? )
  ]
    pname push current @ header push cp dp! pop
  [
  ;opt
  uwid

\ : ( <input> -- )
\ used to define a new word
(create) :
  smudge!
  ]
    (create) smudge! ]
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
    push       \ ( n n )
    cur@ @ !x  \ ( n nfa ) X: nfa
    xh@        \ ( n flags )
    and        \ ( n&flags )
    xh!        \ ( n&flags )
  [
  ;opt uwid

: immediate
    $7FFF widf
  [
  ;opt uwid immediate

\ define ; which is used when finishing the compiling of a word
: ;
  \ change to interpret mode and override to compile [
  [ pname [ findw nfa>xtf cxt ]
  \ back in compile mode
    ;opt uwid
[ ;opt uwid immediate
