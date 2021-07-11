# minimum.S

# ( -- )
Forthword_ WIPE, 0, "WIPE"
.if BUILD_LEVEL > 9
  lit_y_ DPSTART
  do_ DPSHARP
  mw_y_

  lit_y_ CPSTART
  do_ CPSHARP
  mw_y_
.endif

  y_0_
  lit_ EE_FORTHWORDLIST
  mw_y_
  add_4_
  mw_y_

  lit_y_ HERESTART
  do_ HEREADDR
  mw_y_
  
  jmp ONLY
