#!/bin/bash

EMIN=2
EMAX=6
RUNSIZE=1000
TARGET=1000060120

# neutrinos
for i in {2000..2099}
do
    time nice ./do_a_run.sh -t $TARGET -e $EMIN,$EMAX -n $RUNSIZE -r $i -s $i -u 14
    sleep 2
done

# antineutrinos
for i in {2100..2199}
do
    time nice ./do_a_run.sh -t $TARGET -e $EMIN,$EMAX -n $RUNSIZE -r $i -s $i -u -14
    sleep 2
done
