\ minimum.fs Forth words that make up minimum forth vocabulary


( n min max -- f )
\ check if n is within min..max
\ flag is 1 if min <= n <= max
: within
    popy       \ n max Y: min
    w-=y       \ n diff 
    x=d0 x-=y 
    d0=x       \ n-min diff 
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
    y=w 0> w&=y   ( n' Y:n )
    push          ( n' n' )
    begin
    ?while
      space
      d0 1- d0=w 
    repeat
    nip
;

\ pointer to current write position
\ in the Pictured Numeric Output buffer
var hld


\ prepend character to pictured numeric output buffer
: hold ( c -- )
    y=w hld
    x=@w x-=1 @w=x   
    y c@x=w
;

\ Address of the temporary scratch buffer.
: pad ( -- a-addr )
    y= 20 here  w+=y
;

\ initialize the pictured numeric output conversion process
: <# ( n -- n )
    push pad y=w hld @w=y pop
;

\ pictured numeric output: convert one digit
: # ( u1 -- u2 )
    push base@  ( u1 base )
    u/mod       ( rem u2 )
    x=w d0 d0=x ( u2 rem )
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
    hld @ x=w     \ addr Y: addr  
    push pad w-=x \ addr pad-addr
;

\ place a - in HLD if n is negative
: sign ( n -- )
    0< ?if [char] - hold then
;

\ signed PNO with cell numbers, right aligned in width w
: .r ( wantsign n w -- )
    rpush pop  ( wantsign n ) ( R: w )
    <# #s      ( wantsign 0 )
    pop sign   ( ? )
    #>         ( addr len )
    push rpop  ( addr len w )  ( R: )
    y=d0       ( addr len w Y:len )
    w-=y       ( addr len spaces )
    spaces     ( addr len ? )
    pop type   ( )
    space
;

\ unsigned PNO with single cell numbers
: u. ( u -- )
    push push 0 ( u u 0 ) \ want unsigned
    d1=w        ( 0 u 0 )
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
    dsp         ( ? limit ) \ setup limit
    dcell-
    push dsp0   ( ? limit counter )
    begin
      dcell-    ( ? limit counter-4 )
      y=d0 push
      pushy     ( ? limit counter-4 limit counter-4 )
      !=        ( ? limit counter-4 flag )
      ?while
        d0      ( ? limit counter-4 counter-4 )
        @       ( ? limit counter-4 val )
        . pop  ( ? limit counter-4 )
    repeat
    nip2 pop
;
