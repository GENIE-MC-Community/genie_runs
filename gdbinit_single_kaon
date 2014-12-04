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

#
# KineGeneratorWithCache.cxx
#

# 5 before finding/calculating max xsec
break KineGeneratorWithCache.cxx:70

#
# ASKKinematicsGenerator.cxx
#

# 6 
break ASKKinematicsGenerator.cxx:80

# 7 right after max sec calc
break ASKKinematicsGenerator.cxx:96
commands 7
printf "\n xsec_max = %g\n", xsec_max
end

# 8 comment
break ASKKinematicsGenerator.cxx:279
commands 8
printf "\n\n Why not: ml = PDGLibrary::Instance()->Find(leppdg)->Mass()\n\n"
end

# 9
break ASKKinematicsGenerator.cxx:314
commands 9
printf "\n\n tk = %f, tl = %f, ctl = %f \n\n", tk, tl, ctl
end

# 10 comment
break ASKKinematicsGenerator.cxx:294
commands 10
printf "\n\n TKaon = 0 always has zero cross section, so we could put a continue here or shift the loop bounds.\n"
printf " Tlep = 0 always has zero cross section, so we could put a continue here or shift the loop bounds.\n\n"
end

#
# AtharSingleKaonPXSec.cxx
# 

# 11
break AtharSingleKaonPXSec.cxx:82
commands 11
printf "\n\n We may want to put this check up in the max xsec calculator too so users don't end up wasting time here.\n"
printf " Actually, how do we end up here? Shouldn't only valid reactions make it past the interaction list generator?\n\n"
end

# 12 comment
break AtharSingleKaonPXSec.cxx:71
commands 12
printf "\n\n Usually, private variables of a class in GENIE have names like fEnu, etc.\n"
printf " Also, we may want to make mutables obvious by name, so fMutable_Enu, etc.\n\n"
end

# 13 comment
break AtharSingleKaonPXSec.cxx:98
commands 13
printf "\n\n Why not: ml = PDGLibrary::Instance()->Find(leppdg)->Mass()\n\n"
end

# 14 comment
break AtharSingleKaonPXSec.cxx:141
commands 14
printf "\n\n It would be useful to have comments referencing pieces of the paper and/or equation numbers.\n"
printf " Actually, we need to reference the paper somewhere in this class!\n\n"
end


# 15
break AtharSingleKaonPXSec.cxx:151

#
# ASKHadronicSystemGenerator.cxx
#
 
# 16
break ASKHadronicSystemGenerator.cxx:73

# 17
break ASKHadronicSystemGenerator.cxx:112
commands 17
printf "\n\n These four lines are great! Are the notes posted somewhere?\n\n"
end

# 
# ASKInteractionListGenerator.cxx
#

# 18
break ASKInteractionListGenerator.cxx:50

# 
# ASKPrimaryLeptonGenerator.cxx
#

# 19
break ASKPrimaryLeptonGenerator.cxx:70



