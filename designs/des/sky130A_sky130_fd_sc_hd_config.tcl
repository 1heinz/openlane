set ::env(GLB_RT_ADJUSTMENT) 0.1
set ::env(SYNTH_STRATEGY) 2
set ::env(CLOCK_PERIOD) "11"
set ::env(FP_CORE_UTIL) 45

set ::env(SYNTH_MAX_FANOUT) 6

#Routing

# Regression


# Extra

set ::env(PL_TARGET_DENSITY) [ expr ($::env(FP_CORE_UTIL)-10) / 100.0 ] 

# Suggested Clock Period:
 set ::env(CLOCK_PERIOD) "20.0"
