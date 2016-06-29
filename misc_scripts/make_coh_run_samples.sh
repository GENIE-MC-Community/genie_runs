#!/bin/bash

# get the right spline file
# cp COH_1000060120_splines_BS_rev6124.xml COH_1000060120_splines.xml

# `do_a_run.sh` available in `genie_runs`:
# https://github.com/GENIEMC/genie_runs

MODELTAG="BSFM_6136"
MODELTAG="RS_6136"
MODELTAG="BS_6136"

energies="
0.5
1.0
1.5
3.0
5.0
10.0"

targets="
1000020040
1000060120
1000180400"

targets="
1000060120"


LOGNAME="coh_run_log_${MODELTAG}.csv"

echo "#Current, energy, run" > $LOGNAME

for TARGET in $targets
do

    cp COH_${TARGET}_splines_${MODELTAG}.xml COH_${TARGET}_splines.xml

    for energy in $energies
    do
        run=`echo $energy | perl -lne 'printf "%d", int(10000 + 10 * $_);'`
        ./do_a_run.sh --list CCCOH --target $TARGET --energy $energy --nus 14 --run $run --seed $run --numevt 50000 --whisper
        mv gntp.${run}.ghep.root gntp.${run}_${MODELTAG}_${TARGET}.ghep.root
        echo "CC, $energy, $run" >> $LOGNAME
        run=`echo $energy | perl -lne 'printf "%d", int(20000 + 10 * $_);'`
        ./do_a_run.sh --list NCCOH --target $TARGET --energy $energy --nus 14 --run $run --seed $run --numevt 50000 --whisper
        mv gntp.${run}.ghep.root gntp.${run}_${MODELTAG}_${TARGET}.ghep.root
        echo "NC, $energy, $run" >> $LOGNAME
    done

done
