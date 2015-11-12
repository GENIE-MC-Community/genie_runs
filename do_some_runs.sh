#!/bin/bash

TARGET1=1000060120
TARGET2=1000180400
TARGETS="$TARGET1 $TARGET2"
# VARIATIONS="original bsres effspecfunc ha2014 kln"
VARIATIONS="bsres effspecfunc ha2014 kln"

make_splines()
{
    for target in $TARGETS
    do
        ./do_make_spline.sh --list CCQE --maxenergy 10 --target $target --nus 14
        ./do_make_spline.sh --list RES --maxenergy 10 --target $target --nus 14
    done
}

make_all_splines()
{
    for variation in $VARIATIONS
    do
        pushd $GENIE/config >& /dev/null
        cp UserPhysicsOptions_${variation}.xml UserPhysicsOptions.xml
        popd >& /dev/null

        make_splines
        mv CCQE_1000060120_splines.xml CCQE_1000060120_splines_${variation}.xml
        mv CCQE_1000180400_splines.xml CCQE_1000180400_splines_${variation}.xml
        mv RES_1000060120_splines.xml RES_1000060120_splines_${variation}.xml
        mv RES_1000180400_splines.xml RES_1000180400_splines_${variation}.xml
    done
}


make_all_splines

EMIN=2
EMAX=6
RUNSIZE=1000

# # neutrinos
# for i in {2000..2099}
# do
#     time nice ./do_a_run.sh -t $TARGET -e $EMIN,$EMAX -n $RUNSIZE -r $i -s $i -u 14
#     sleep 2
# done

# # antineutrinos
# for i in {2100..2199}
# do
#     time nice ./do_a_run.sh -t $TARGET -e $EMIN,$EMAX -n $RUNSIZE -r $i -s $i -u -14
#     sleep 2
# done


