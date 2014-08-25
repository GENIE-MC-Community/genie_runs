#!/bin/sh

# Generic SN run...

NUMEVT=1000
if [ $# -gt 0 ]; then
  NUMEVT=$1
fi

gevgen -n $NUMEVT -p -12 -t 1000060120 -e 0.02 -r 101 \
  --seed 2989819 --cross-sections $XSECSPLINEDIR/gxspl-vA-v2.8.0.xml >& run_log.txt

