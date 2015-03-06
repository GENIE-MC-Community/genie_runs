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

TARGET=$CARBON
TARGET=$PROTON

CROSS_SECTION_DIR="."
CROSS_SECTION_FILENAME="single_kaon_${TARGET}_splines.xml"
XSECS="$CROSS_SECTION_DIR/$CROSS_SECTION_FILENAME"

if [[ ! -e "$XSECS" ]]; then
  echo "Cross section file $XSECS does not exits."
  echo "I cannot proceed..."
  exit 0
fi

gdb -tui --args gevgen -n $NUMEVT -p 14 -t $TARGET -e 2 -r 101 \
  --seed 2989819 --cross-sections $XSECS \
  --message-thresholds Messenger_whisper.xml \
  --event-generator-list SingleKaon

