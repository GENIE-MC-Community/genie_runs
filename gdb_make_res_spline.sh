#!/bin/sh

NKNOTS=100
MAX_ENERGY=120

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

# Optionally supply an extra tag for the file name.
XMLOUT=res_${TARGET}_splines
if [ $# -gt 0 ]; then
  XMLOUT=${XMLOUT}_$1
fi
XMLOUT=${XMLOUT}.xml
echo "Making xml file $XMLOUT"

gdb -tui --args gmkspl -p -14,-12,12,14 -t $TARGET -o ${XMLOUT} \
  --event-generator-list RES \
  --message-thresholds Messenger_laconic.xml \
  -n $NKNOTS -e $MAX_ENERGY
