#!/bin/sh

NKNOTS=50
MAX_ENERGY=100
CHANNEL="coherent"
EVGENLIST="COH"

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

NEUTRINOS="-14,-12,12,14"
NEUTRINOS="12,14"
NEUTRINOS="-14,14"

make_spline() {
  # Optionally supply an extra tag for the file name.
  XMLOUT=${CHANNEL}_${TARGET}_splines
  if [ $# -gt 0 ]; then
    XMLOUT=${XMLOUT}_$1
  fi
  # Add the file extension
  XMLOUT=${XMLOUT}.xml
  echo "Making xml file $XMLOUT"

  nice gmkspl -p $NEUTRINOS -t $TARGET -o $XMLOUT \
  --event-generator-list $EVGENLIST \
  -n $NKNOTS -e $MAX_ENERGY
}

TARGET=$OXYGEN
make_spline

TARGET=$CARBON
make_spline
