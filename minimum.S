# minimum.S

# ( -- )
Forthword_ WIPE, 0, "WIPE"
.if BUILD_LEVEL > 2
  lit_y_ DPSTART
  call DPSHARP
  mw_y_

  lit_y_ CPSTART
  call CPSHARP
  mw_y_
.endif

  y_0_
  lit_ EE_FORTHWORDLIST
  mw_y_
  fourplus_
  mw_y_

  lit_y_ HERESTART
  call HEREADDR
  mw_y_
  
  jmp ONLY
