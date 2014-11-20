#!/bin/sh

NKNOTS=100
MAX_ENERGY=0.4

# http://pdg.lbl.gov/2007/reviews/montecarlorpp.pdf
# http://pdg.lbl.gov/2011/mcdata/mc_particle_id_contents.html
# http://genie.hepforge.org/doxygen/html/PDGCodes_8h_source.html
PROTON="1000010010"
CARBON="1000060120"
OXYGEN="1000080160"
ARGON40="1000180400"

TARGET=$PROTON
TARGET=$CARBON
TARGET=$OXYGEN

# Optionally supply an extra tag for the file name.
XMLOUT=vle_${TARGET}_splines
if [ $# -gt 0 ]; then
  XMLOUT=${XMLOUT}_$1
fi
XMLOUT=${XMLOUT}.xml
echo "Making xml file $XMLOUT"

gdb -tui --args gmkspl -p 12,-12 -t $TARGET -o ${XMLOUT} --event-generator-list VLE \
  --message-thresholds Messenger_laconic.xml \
  -n $NKNOTS -e $MAX_ENERGY
