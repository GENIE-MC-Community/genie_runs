#!/bin/sh

NUMEVT=100
SPLINEFILE=$XSECSPLINEDIR/gxspl-NuMIsmall.xml 
LIST="ALL"
HELPFLAG=0

# http://pdg.lbl.gov/2007/reviews/montecarlorpp.pdf
# http://pdg.lbl.gov/2011/mcdata/mc_particle_id_contents.html
# http://genie.hepforge.org/doxygen/html/PDGCodes_8h_source.html
PROTON="1000010010"
CARBON="1000060120"
OXYGEN="1000080160"
TARGET=$CARBON
RUNNUM=101
ENERGY=1
NEUTRINOS="-14,14"

help()
{
cat <<EOF


Usage: ./do_make_coh_spline.sh -<f>|--<flag> arg
                               -l / --list    : interaction list (default all)
                               -h / --help    : print the help menu
                               -t / --target  : default == 1000060120
                               -n / --numevt  : # of events
                               -r / --run     : run # (default 101)
                               -e / --energy  : e or emin,emax
                               -n / --nus     : neutrinos list (default -14,14)

* Possible interaction lists: (empty for all), CCQE, COH, RES, SingleKaon, VLE

* Possible targets: 1000060120 (Carbon), 1000080160 (Oxygen)

* For splines, the script first searches: $XSECSPLINEDIR 

* Channel specific splines are preferred to general splines if found.

* Local (this directory) spline files are preferred to those located
in $XSECSPLINEDIR.


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
        -l|--list)
            LIST="$1"
            shift
            ;;
        -t|--target)
            TARGET="$1"
            shift
            ;;
        -n|--numevt)
            NUMEVT="$1"
            shift
            ;;
        -r|--run)
            RUNNUM="$1"
            shift
            ;;
        -e|--energy)
            ENERGY="$1"
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


if [[ $LIST == "ALL" ]]; then
    if [[ -e gxspl-NuMIsmall.xml ]]; then
        SPLINEFILE=gxspl-NuMIsmall.xml
    fi
elif [[ $LIST == "CCQE" || 
              $LIST == "COH" ||
              $LIST == "RES" ||
              $LIST == "SingleKaon" ||
              $LIST == "VLE" ]]; then    
    FILENAM="$LIST_$TARGET_splines.xml"
    if [[ -e $XSECSPLINEDIR/$FILENAM ]]; then
        SPLINEFILE=$XSECSPLINEDIR/$FILENAM
    fi
    if [[ -e $FILENAM ]]; then
        SPLINEFILE=$FILENAM
    fi
fi   
         
if [[ ! -e $SPLINEFILE ]]; then
    echo "Spline file $SPLINEFILE does not exist!"
    exit 1
fi
echo "Using spline file $SPLINEFILE"

EVGENSTRING=""
if [[ $LIST != "ALL" ]]; then
    EVGENSTRING="--event-generator-list $LIST"
fi

# gdb -tui --args gevgen -n $NUMEVT -p $NEUTRINOS -t $TARGET
#     -e $ENERGY -r $RUNNUM \
#     --seed 2989819 --cross-sections $SPLINEFILE \
#     --message-thresholds Messenger_whisper.xml $EVGENSTRING
