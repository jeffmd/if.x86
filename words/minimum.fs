\ minimum.fs Forth words that make up minimum forth vocabulary


( n min max -- f )
\ check if n is within min..max
: within
    d0!y       \ n min max Y: min
    -y !x      \ n min diff X: diff
    d1 -y !d1  \ n-min min n-min 
    nip x      \ n-min diff
    u<         \ flag
;

\ emits a space (bl)
: space ( -- )
    bl emit
;

\ emits n space(s) (bl)
\ only accepts positive values
: spaces ( n -- )
    \ make sure a positive number
    !y 0> and.y   ( n' Y:n )
    push          ( n' n' )
    begin
    ?while
      space
      d0 1- !d0 
    repeat
    nip
;

\ pointer to current write position
\ in the Pictured Numeric Output buffer
var hld


\ prepend character to pictured numeric output buffer
: hold ( c -- )
    push hld 1-!   
    @ c!
;

\ Address of the temporary scratch buffer.
: pad ( -- a-addr )
    here !y 20 +y
;

\ initialize the pictured numeric output conversion process
: <# ( n -- n )
    push pad push hld ! pop
;

\ pictured numeric output: convert one digit
: # ( u1 -- u2 )
    push base@  ( u1 base )
    u/mod       ( rem u2 )
    swap        ( u2 rem )
    #h hold pop ( u2 )
;

\ pictured numeric output: convert all digits until 0 (zero) is reached
: #s ( u -- 0 )
    #
    begin
    ?while
      #
    repeat
;

\ Pictured Numeric Output: convert PNO buffer into an string
: #> ( u1 -- addr count )
    hld @ !y    \ addr Y: addr  
    push pad -y \ addr pad-addr
;

\ place a - in HLD if n is negative
: sign ( n -- )
    0< ?if [char] - hold then
;

\ singed PNO with cell numbers, right aligned in width w
: .r ( wantsign n w -- )
    rpush pop  ( wantsign n ) ( R: w )
    <# #s      ( wantsign 0 )
    pop sign   ( ? )
    #>         ( addr len )
    push rpop  ( addr len w )  ( R: )
    d0!y       ( addr len w Y:len )
    -y         ( addr len spaces )
    spaces     ( addr len ? )
    pop type   ( )
    space
;

\ unsigned PNO with single cell numbers
: u. ( u -- )
    push2 0 ( u u 0 ) \ want unsigned
    !d1     ( 0 u 0 )
    .r 
;


\ singed PNO with single cell numbers
: .  ( n -- )
    push      ( n n )
    abs       ( n n' )
    push 0    ( n n' 0 ) \ not right aligned
    .r
;

: .s  ( -- )
    push        ( ?  ? )
    sp          ( ? limit ) \ setup limit
    dcell-
    push sp0    ( ? limit counter )
    begin
      dcell-    ( ? limit counter-4 )
      2over     ( ? limit counter-4 limit counter-4 )
      <>        ( ? limit counter-4 flag )
      ?while
        d0      ( ? limit counter-4 counter-4 )
        @       ( ? limit counter-4 val )
        u. pop  ( ? limit counter-4 )
    repeat
    nip2 pop
;
