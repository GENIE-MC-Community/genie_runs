#!/bin/sh

NUMEVT=100
SPLINEFILE=$XSECSPLINEDIR/gxspl-NuMIsmall.xml 
CARB_SPLINEFILE=coherent_1000060120_splines.xml
OXYG_SPLINEFILE=coherent_1000080160_splines.xml

HELPFLAG=0

# http://pdg.lbl.gov/2007/reviews/montecarlorpp.pdf
# http://pdg.lbl.gov/2011/mcdata/mc_particle_id_contents.html
# http://genie.hepforge.org/doxygen/html/PDGCodes_8h_source.html
CARBON="1000060120"
OXYGEN="1000080160"

TARGET=$CARBON

help()
{
cat <<EOF
Usage: ./do_make_coh_spline.sh -<f>|--<flag> arg
                               -h / --help    : print the help menu
                               -t / --target  : default == 1000060120
                               -n / --numevt  : # of events
EOF
}

# Parse args
while [[ $# > 0 ]]
do
    key="$1"
    shift

    case $key in
        -h|--help)
            HELPFLAG=1
            ;;
        -t|--target)
            TARGET="$1"
            shift
            ;;
        -n|--numevt)
            NUMEVT="$1"
            shift
            ;;
        *)     # Unknown option
            ;;
    esac
done

if [[ $HELPFLAG -eq 1 ]]; then
    help
    exit 0
fi



if [[ $TARGET == $OXYGEN && -e $OXYG_SPLINEFILE ]]; then
    SPLINEFILE=$OXYG_SPLINEFILE
fi
if [[ $TARGET == $CARBON && -e $CARB_SPLINEFILE ]]; then
    SPLINEFILE=$CARB_SPLINEFILE
fi
if [[ ! -e $SPLINEFILE ]]; then
    echo "Spline file $SPLINEFILE does not exist!"
    exit 1
fi
echo "Using spline file $SPLINEFILE"


gdb -tui --args gevgen -n $NUMEVT -p 14 -t $TARGET -e 1 -r 101 \
    --seed 2989819 --cross-sections $SPLINEFILE \
    --message-thresholds Messenger_whisper.xml \
    --event-generator-list COH
