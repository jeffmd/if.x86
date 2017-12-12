\ tasker.fs : words for managing tasks

only 
vocabulary Tasker
Tasker definitions

\ maximum number of tasks
62 con maxtask
\ the active index into the task list
cvar tidx

\ count register for each task
\ is an array 
var tcnt
maxtask dcell* allot

( -- n )
\ fetch task index: verifies index is valid
\ adjusts index if count is odd ?
: tidx@
  tidx c@ 
  \ verify index is below 63
  push2 maxtask >
  if
    \ greater than 62 so 0
    tidx 0c!
    0
  then
;

: cnt& ( idx -- cntaddr )
  dcell* !y tcnt +y
;

( idx -- cnt )
\ get count for a slot
\ idx: index of slot
: cnt@
  cnt& @
;

\ get the count for current task executing
( -- n )
: count
  tidx@ cnt@
;

\ increment tcnt array element using idx as index
( idx -- )
: cnt+
  cnt& 1+!
;

( n idx -- )
\ set tcnt array element using idx as index
: cnt!
  d0!x nip cnt& x.!
;

\ array of task slots in ram : max 31 tasks 62 bytes
\ array is a binary process tree
\                        0                          62.5 ms
\             1                      2              125 ms
\      3           4           5           6        250 ms
\   7     8     9    10     11   12     13   14     500 ms
\ 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30   1 s
\ 31 -                                          62  2 s
var tasks
maxtask dcell* allot

( -- )
\ increment task index to next task idx
\ assume array flat layout and next idx = idx*2 + 1
: tidx+
  tidx@ 2* 1+ 
  \ if slot count is odd then 1+
  count !x
  y= 1 and.y +x !y
  tidx y.c!
;

( idx -- taskaddr )
\ get task address based on idx
: task&
  dcell* !y tasks +y
;

( idx -- task )
\ get a task at idx slot
: task@
   task& @ 
;

( addr idx -- ) 
\ store a task in a slot
\ idx is the slot index range: 0 to 62
: task!
  task& d0!y nip y.!
;

\ store a task in a slot
: task ( idx C: name -- )
  push ' swap task!
;

( idx -- )
\ clear task at idx slot
\ replaces task with noop
: taskclr 
  push ['] noop swap task!
;


( -- )
\ execute active task and step to next task
: taskex
  \ increment count for task slot
  tidx@ push cnt+
  d0 task@ exec
  tidx+
;

var lastms
\ how often in microseconds to execute a task
\ default to 62.5/6 ms 
var exms


( -- )
\ execute tasks.ex if tick time expired
: tick
  time lastms @   ( time lastms )
  !y d0 -y !d1    ( timediff timediff Y:lastms )
  push exms @ u>  ( timediff flag )
  if
    !y            ( timediff Y:timediff ) 
    lastms y+!    ( lastms )
    taskex
  else
    y= 255 and.y usleep
  then
;

( -- )
\ clear all tasks
: allclr
  \ iterate 0 to 30 and clear tcnt[] and set tasks[] to noop
  tidx 0c!
  0 push           ( idx 0 )
  begin
    0 over         ( idx 0 idx )
    cnt!           ( idx ? )
    d0 taskclr     ( idx ? )
    d0 1+ !d0      ( idx+1 idx+1 )
    push maxtask > ( idx+1 flag ) 
  ?until
  nip
;

( -- )
\ start tasking
: run
  y= 10417 exms y.!
  lastms 0!
  ['] tick !y pause# y.!
;

( -- )
\ reset tasker
\ all tasks are reset to noop
: reset
  allclr
  run
;

( -- )
\ stop tasks from running
: stop
  ['] noop !y pause# y.!
;
