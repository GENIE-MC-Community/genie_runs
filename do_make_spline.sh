#!/usr/bin/env bash

NKNOTS=50
MAX_ENERGY=100
HELPFLAG=0
GDB="NO"

# http://pdg.lbl.gov/2007/reviews/montecarlorpp.pdf
# http://pdg.lbl.gov/2011/mcdata/mc_particle_id_contents.html
# http://genie.hepforge.org/doxygen/html/PDGCodes_8h_source.html
PROTON="1000010010"
CARBON="1000060120"
OXYGEN="1000080160"
ARGON40="1000180400"

TARGET=$PROTON
NEUTRINOS="-14,14"
LIST="Default"

help()
{
    cat <<EOF


Usage: ./do_make_spline.sh -<f>|--<flag> arg
                            -h / --help        : print the help menu
                            -g / --gdb         : pipe the run through GDB
                            -l / --list LIST   : interaction list (default all)
                            -k / --knots #     : # of knots (default 50)
                            -e / --maxenergy # : max energy (default 100 GeV)
                            -t / --target #    : _single_ target for now
                            -u / --nus # or #1,#2, etc. (no spaces)

* Possible interaction lists: (empty for all), CCQE, COH, RES, SingleKaon, VLE

* Example targets: 1000060120 (Carbon) or 1000080160 (Oxygen) or 1000180400 (Argon40)
or etc.

* Example neutrino lists: -14,14 or -14,-12,12,14 


EOF
}

#
# If there are no arguments, print help (and exit)
#
if [[ $# == 0 ]]; then
    HELPFLAG=1
fi

#
# Parse args
#
while [[ $# > 0 ]]
do
    key="$1"
    shift

    case $key in
        -h|--help)
            HELPFLAG=1
            ;;
        -k|--knots)
            NKNOTS="$1"
            shift
            ;;
        -e|--maxenergy)
            MAX_ENERGY="$1"
            shift
            ;;
        -t|--target)
            TARGET="$1"
            shift
            ;;
        -u|--nus)
            NEUTRINOS="$1"
            shift
            ;;
        -l|--list)
            LIST="$1"
            shift
            ;;
        -g|--gdb)
            GDB="YES"
            ;;
        *)     # Unknown option
            ;;
    esac
done


if [[ $HELPFLAG -eq 1 ]]; then
    help
    exit 0
fi



XMLOUT=${LIST}_${TARGET}_splines.xml
echo "Making xml file $XMLOUT"


EVGENSTRING=""
if [[ $LIST != "Default" ]]; then
    EVGENSTRING="--event-generator-list $LIST"
fi

echo ""
echo "Command: "
echo ""
if [[ "$GDB" == "YES" ]]; then
    echo "gdb -tui --args nice gmkspl -p $NEUTRINOS -t $TARGET -o $XMLOUT \\"
    echo "    -n $NKNOTS -e $MAX_ENERGY --disable-bare-xsec-pre-calc \\"
    echo "    --message-thresholds Messenger_whisper.xml $EVGENSTRING"
    gdb -tui --args nice gmkspl -p $NEUTRINOS -t $TARGET -o $XMLOUT \
        -n $NKNOTS -e $MAX_ENERGY --disable-bare-xsec-pre-calc \
        --message-thresholds Messenger_whisper.xml $EVGENSTRING
else
    echo "nice gmkspl -p $NEUTRINOS -t $TARGET -o $XMLOUT \\"
    echo "     -n $NKNOTS -e $MAX_ENERGY --disable-bare-xsec-pre-calc \\"
    echo "     --message-thresholds Messenger.xml $EVGENSTRING"
    nice gmkspl -p $NEUTRINOS -t $TARGET -o $XMLOUT \
         -n $NKNOTS -e $MAX_ENERGY --disable-bare-xsec-pre-calc \
         --message-thresholds Messenger.xml $EVGENSTRING
fi
