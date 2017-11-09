dp 
pname header dup $FF00 or $dp!
  current @ @ dp!
  cp dp!
  smudge !
  1 state h!
      dp >r >r dup $FF00 or $dp! r> @ dp! r>  
  [
  ;opt
  uwid

pname (create) current @ header
  cp dp!
  smudge !
  1 state h!
    pname current @ header cp dp!
  [
  ;opt
  uwid

(create) ] 
  smudge !
  1 state h!
    1 state h!
  [
  ;opt
  uwid

(create) :
  smudge !
  ]
    (create) smudge ! ]
  [
  ;opt
  uwid

: cur@
    current @
  [
  ;opt uwid

: widf
    cur@
    @
    dup
    h@
    rot and
    swap
    h!
  [
  ;opt uwid

: immediate
    $7FFF widf
  [
  ;opt uwid immediate

: \
    stib
    nip
    >in
    h!
  [
  ;opt uwid immediate

\ boot.fs - bootstrap the forth compiler
\ header, (create), ] are created manually
\ use (create) to make : then define the rest manually
\ : can now be used to define a new word but must manually
\ terminate the definition of a new word

\ define ; which is used when finishing the compiling of a word
: ;
  \ change to interpret mode and override to compile [
  [ pname [ findw nfa>xtf cxt ]
  \ back in compile mode
    ;opt uwid
[ ;opt uwid immediate
