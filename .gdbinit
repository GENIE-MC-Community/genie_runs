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

# 2 put breaks on all the model "XSec" functions.
break BergerSehgalCOHPiPXSec.cxx:61

# 3 exiting xsec
break BergerSehgalCOHPiPXSec.cxx:183

# 4
# watch the loop through event record visitors!
# top of the loop. `p visitor->Id().Key()` (pvis above)
# check the processor and see if you want to step in
break EventGenerator.cxx:107 if ffwd==false
commands 4
pvisit
end
                          
# 5 actual call to ProcessEventRecord(event_rec)
break EventGenerator.cxx:118 if ffwd==false

# 6 after calculating max xsec
break COHKinematicsGenerator.cxx:211
commands 6
silent
printf "xsec_max = %g\n", xsec_max
end

# 7 after selecting an event
break COHKinematicsGenerator.cxx:309
commands 7
silent 
printf "xsec = %g ; E = %f ; Q2 = %f ; x = %f ; y = %f ; t = %f \n", xsec, Ev, 2*kNucleonMass*gx*gy*Ev, gx, gy, gt
end


# n look at the xsec before we consider accepting it
# break COHKinematicsGenerator.cxx:158
# it is fragile to use numbered breakpoint commands like this, but shikata ga nai
# commands 4
# silent 
# printf "xsec =%g ; Q2 = %f ; y = %f ; t = %f \n", xsec, gQ2, gy, gt
# end

# n right after accepting an event's kinematics
# break COHKinematicsGenerator.cxx:162
# commands 7
# silent 
# printf "xsec =%g ; Q2 = %f ; y = %f ; t = %f \n", xsec, gQ2, gy, gt
# end

