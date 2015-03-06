# we can't set breakpoints for .so's we haven't loaded yet without this
set breakpoint pending on

# can often get away with typing: pv or pvis, etc.
define pvisit
  p visitor->Id().Key()._M_dataplus._M_p
end

# print C++ standard strings
define pcppstr
 p *(char**)($arg0)._M_dataplus._M_p
end

#
# Breakpoints ----------
#

# 1
break main

# 2
break gEvGen.cxx:274

# 3
# watch the loop through event record visitors!
# top of the loop. `p visitor->Id().Key()` (pvis above)
# check the processor and see if you want to step in
break EventGenerator.cxx:107 if ffwd==false
commands 3
pvisit
end
                          
# 4 actual call to ProcessEventRecord(event_rec)
break EventGenerator.cxx:118 if ffwd==false

# 5 once an event is accepted
break QELKinematicsGenerator.cxx:193
commands 5
silent
printf "xsec = %g ; E = %f ; Q^2 = %f\n", xsec, E, gQ2
end

# 6
break QELKinematicsGenerator.cxx:116

# 7
break KineGeneratorWithCache.cxx:78

# 8
break KineGeneratorWithCache.cxx:83

# 9
break QELKinematicsGenerator.cxx:499

# 10
break LwlynSmithQELCCPXSec.cxx:82

# 11
break LwlynSmithQELCCPXSec.cxx:114
commands 11
printf "xsec = %g; ml = %f; Q2 = %f", xsec, ml, -1.0*q2
end

# 12 - After algorithm loop
break EventGenerator.cxx:195

# 13
break FermiMover.cxx:73

# 14 
break FermiMover.cxx:130
