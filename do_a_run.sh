#!/bin/sh

NUMEVT=10
if [ $# -gt 0 ]; then
  NUMEVT=$1
fi

# http://pdg.lbl.gov/2007/reviews/montecarlorpp.pdf
# http://pdg.lbl.gov/2011/mcdata/mc_particle_id_contents.html
# http://genie.hepforge.org/doxygen/html/PDGCodes_8h_source.html
PROTON="1000010010"
CARBON="1000060120"
OXYGEN="1000080160"

TARGET=$OXYGEN
TARGET=$CARBON

SPLINEFILE=gxspl-NuMIsmall.xml

gevgen -n $NUMEVT -p -14,14 -t $TARGET -e 2,10 -f 'x*exp(-x)' -r 101 \
  --seed 2989819 --cross-sections $XSECSPLINEDIR/$SPLINEFILE \
  >& run_log.txt
