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

# 1
break main

# 2
# watch the loop through event record visitors!
# top of the loop. `p visitor->Id().Key()` (pvis above)
# check the processor and see if you want to step in
break EventGenerator.cxx:107 if ffwd==false
commands 2
pvisit
end
                          
# 3 actual call to ProcessEventRecord(event_rec)
break EventGenerator.cxx:118 if ffwd==false

# 4 top of the event loop
break gEvGen.cxx:270
commands 4
printf "The event number is %d\n", ievent
end

# 5
break FermiMover.cxx:93

# 6
break StrumiaVissaniIBDPXSec.cxx:53

# 7
break QELInteractionListGenerator.cxx:51

# 8
break QELInteractionListGenerator.cxx:80

# 9
break IBDInteractionListGenerator.cxx:47

# 10
break IBDKinematicsGenerator.cxx:111
