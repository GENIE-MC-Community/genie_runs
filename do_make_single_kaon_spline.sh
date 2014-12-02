#!/bin/sh

NKNOTS=100
MAX_ENERGY=5
CHANNEL="single_kaon"

# http://pdg.lbl.gov/2007/reviews/montecarlorpp.pdf
# http://pdg.lbl.gov/2011/mcdata/mc_particle_id_contents.html
# http://genie.hepforge.org/doxygen/html/PDGCodes_8h_source.html
PROTON="1000010010"
CARBON="1000060120"
OXYGEN="1000080160"
ARGON40="1000180400"

TARGET=$OXYGEN
TARGET=$CARBON
TARGET=$PROTON

make_spline() {
  # Optionally supply an extra tag for the file name.
  XMLOUT=${CHANNEL}_${TARGET}_splines
  if [ $# -gt 0 ]; then
    XMLOUT=${XMLOUT}_$1
  fi
  # Add the file extension
  XMLOUT=${XMLOUT}.xml
  echo "Making xml file $XMLOUT"

  nice gmkspl -p 12,14 -t $TARGET -o $XMLOUT \
  --event-generator-list SingleKaon \
  -n $NKNOTS -e $MAX_ENERGY
}

TARGET=$PROTON
make_spline

