#!/bin/sh

# Generic SN run...

NUMEVT=5
if [ $# -gt 0 ]; then
  NUMEVT=$1
fi

# http://pdg.lbl.gov/2007/reviews/montecarlorpp.pdf
# http://pdg.lbl.gov/2011/mcdata/mc_particle_id_contents.html
# http://genie.hepforge.org/doxygen/html/PDGCodes_8h_source.html
CARBON="1000060120"
OXYGEN="1000080160"
ARGON40="1000180400"

TARGET=$OXYGEN
TARGET=$ARGON40

SPLINEFILE=vle_${TARGET}_splines.xml

gdb -tui --args gevgen -n $NUMEVT -p 12 -t $TARGET -r 101 \
  -e 0.025,0.035 -f 'x*exp(-x)' \
  --seed 2989819 --cross-sections $SPLINEFILE \
  --message-thresholds Messenger_laconic.xml \
  --event-generator-list VLE
