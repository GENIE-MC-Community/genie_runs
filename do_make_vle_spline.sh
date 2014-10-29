#!/bin/sh

# Use just carbon-12 1000060120 and muon neutrinos.
# See config/EventGeneratorListAssembler.xml for other valid channels.
# Optionally supply an extra tag for the file name.

XMLOUT=vle_carbon_splines
if [ $# -gt 0 ]; then
  XMLOUT=${XMLOUT}_$1
fi
XMLOUT=${XMLOUT}.xml
echo "Making xml file $XMLOUT"

nice gmkspl -p 12,-12 -t 1000060120 -o ${XMLOUT} --event-generator-list VLE


