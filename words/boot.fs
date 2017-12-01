\ boot.fs - bootstrap the forth compiler
\ header are (create) are created manually
\ use (create) to make : then define the rest manually

\ header ( addr len wid -- dp )
\ 
dp push         \ ( dp dp )
pname header push push $FF00 or $dp! \ ( dp ? )
  current @ @   \ ( dp linkaddr ) get latest word
  dp!           \ ( dp ? ) set link field to prev word in vocab
  cp dp! pop    \ ( dp ) set code pointer field
  smudge!       \ ( ? )
  ]
    push dp     \ ( addr len wid dp )
    rpush       \ ( addr len wid dp ) (R: dp )
    rpushd0     \ ( addr len wid dp ) (R: dp wid )
    d1 !d0      \ ( addr len len len ) (R: dp wid )
    $FF00 or    \ ( addr len len|$FF00 )
    $dp!        \ ( ? )
    rpop @      \ ( linkaddr ) (R: dp )
    dp!         \ ( ? )
    rpop        \ ( dp )  
  [
  ;opt
  uwid

\ (create) ( <input> -- dp )
pname (create) push current @ header \ ( dp )
  push cp       \ ( dp cp )
  dp! pop       \ ( dp )
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
