#!/bin/sh

# Not used here...
# NKNOTS=100
# MAX_ENERGY=0.4

# http://pdg.lbl.gov/2007/reviews/montecarlorpp.pdf
# http://pdg.lbl.gov/2011/mcdata/mc_particle_id_contents.html
# http://genie.hepforge.org/doxygen/html/PDGCodes_8h_source.html
PROTON="1000010010"
CARBON="1000060120"
OXYGEN="1000080160"
ARGON40="1000180400"

TARGET=$OXYGEN
TARGET=$PROTON
TARGET=$CARBON
TARGET=$ARGON40

# nice gmkspl -p 14,-14 -t $CARBON -o CC_COH_TE_EFF_2_9_cand.xml --event-generator-list CCCOH
nice gmkspl -p 14,-14 -t $CARBON -o CCQE_TE_EFF_2_9_cand.xml --event-generator-list CCQE
