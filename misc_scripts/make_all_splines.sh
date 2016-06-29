#!/bin/bash

MODELTAG="BSFM_6136"
MODELTAG="BS_6136"
MODELTAG="RS_6136"

TARGETS="1000020040"

for TARGET in $TARGETS
do
    ./do_make_spline.sh -l COH -e 100 -t ${TARGET} -u -14,14
    cp COH_${TARGET}_splines.xml COH_${TARGET}_splines_${MODELTAG}.xml
done
