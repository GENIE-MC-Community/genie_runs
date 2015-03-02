#!/bin/sh

NUMEVT=1000
if [ $# -gt 0 ]; then
  NUMEVT=$1
fi

SPLINEFILE=$XSECSPLINEDIR/gxspl-vA-v2.8.0.xml 
SPLINEFILE=CCQE_TE_EFF_2_9_cand.xml

# http://pdg.lbl.gov/2007/reviews/montecarlorpp.pdf
# http://pdg.lbl.gov/2011/mcdata/mc_particle_id_contents.html
# http://genie.hepforge.org/doxygen/html/PDGCodes_8h_source.html
CARBON="1000060120"
OXYGEN="1000080160"

TARGET=$OXYGEN
TARGET=$CARBON

gdb -tui --args gevgen -n $NUMEVT -p 14 -t $TARGET -e 1 -r 101 \
  --seed 2989819 --cross-sections $SPLINEFILE \
  --message-thresholds Messenger_whisper.xml \
  --event-generator-list CCQE

