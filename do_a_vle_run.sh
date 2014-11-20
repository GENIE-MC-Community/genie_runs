#!/bin/sh

# Generic SN run...

NUMEVT=100
if [ $# -gt 0 ]; then
  NUMEVT=$1
fi

# http://pdg.lbl.gov/2007/reviews/montecarlorpp.pdf
# http://pdg.lbl.gov/2011/mcdata/mc_particle_id_contents.html
# http://genie.hepforge.org/doxygen/html/PDGCodes_8h_source.html
PROTON="1000010010"
CARBON="1000060120"
OXYGEN="1000080160"
ARGON40="1000180400"

TARGET=$CARBON
TARGET=$OXYGEN
TARGET=$ARGON40

SPLINEFILE=vle_${TARGET}_splines.xml

gevgen -n $NUMEVT -p 12 -t $TARGET -e 0.01,0.03 -f 'x*exp(-x)' -r 101 \
  --seed 2989819 --cross-sections $SPLINEFILE \
  --event-generator-list VLE \
  >& run_log.txt
