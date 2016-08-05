#!/usr/bin/env bash

NUMEVT=100
SPLINEFILE=$XSECSPLINEDIR/gxspl-small.xml
LIST="Default"
HELPFLAG=0
SEED=2989819

# http://pdg.lbl.gov/2007/reviews/montecarlorpp.pdf
# http://pdg.lbl.gov/2011/mcdata/mc_particle_id_contents.html
# http://genie.hepforge.org/doxygen/html/PDGCodes_8h_source.html
PROTON="1000010010"
CARBON="1000060120"
OXYGEN="1000080160"
ARGON40="1000180400"
TARGET=$CARBON
RUNNUM=101
ENERGY=1
NEUTRINOS="14"
GDB="NO"
FUNCTIONSTRING=""
FUNC=""
HAVEFUNC="NO"
PREFERWHISPER="NO"

help()
{
    cat <<EOF


Usage: ./do_a_run.sh    -<f>|--<flag> arg
                        -h / --help            : print the help menu
                        -g / --gdb             : pipe the run through GDB (default no)
                        -w / --whisper         : prefer Messenger_whisper.xml (if 
                                                 available, default to no)
                        -l / --list LIST       : interaction list (default all)
                        -t / --target NUM      : _single target_, default == 1000060120
                        -n / --numevt NUM      : # of events (default 100)
                        -r / --run NUM         : run # (default 101)
                        -e / --energy NUM(RNG) : e or emin,emax (default 1 GeV)
                        -u / --nus NU          : neutrino flavor (default 14)
                        -s / --seed #          : random number seed (default 2989819)
                        -f / --func            : flux shape (required for energy range,
                                                 default to 1/x)

* Possible interaction lists: (empty for all), CCQE, COH, RES, SingleKaon, VLE

* Possible targets: 1000060120 (Carbon), 1000080160 (Oxygen), 1000180400 (Argon40),
etc.

* Example neutrino flavors: -16, -14, -12, 12, 14, or 16

* Example energies: 0.05 or 1,10

* If an energy range is specified, also specify a function, e.g. 

  ./do_a_run.sh -e 1,10 -f '1/x'
  ./do_a_run.sh -e 1,10 -f 'x*exp(-x)'

* For splines, the script first searches: $XSECSPLINEDIR 

* Channel specific splines are preferred to general splines if found.

* Local (this directory) spline files are preferred to those located
in $XSECSPLINEDIR.


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
        -g|--gdb)
            GDB="YES"
            ;;
        -u|--nus)
            NEUTRINOS="$1"
            shift
            ;;        
        -s|--seed)
            SEED="$1"
            shift
            ;;        
        -w|--whisper)
            PREFERWHISPER="YES"
            ;;
        -f|--func)
            FUNC="$1"
            HAVEFUNC="YES"
            shift
            ;;
        *)     # Unknown option
            ;;
    esac
done

echo "Starting run $RUNNUM for list $LIST"


if [[ $HELPFLAG -eq 1 ]]; then
    help
    exit 0
fi


if [[ $LIST == "Default" ]]; then
    # Look locally first to override defaults.
    if [[ -e gxspl-NuMIsmall.xml ]]; then
        SPLINEFILE=gxspl-NuMIsmall.xml
    fi
else
    if [[ $LIST == "CCQE" || 
        $LIST == "COH" ||
        $LIST == "DIS" ||
        $LIST == "DFR" ||
        $LIST == "CCDIS" ||
        $LIST == "NCDIS" ||
        $LIST == "RES" ||
        $LIST == "CCRES" ||
        $LIST == "SingleKaon" ||
        $LIST == "CCMEC" ||
        $LIST == "CCMECTensor" ||
        $LIST == "VLE" ]]; then    
        FILENAM=${LIST}_${TARGET}_splines.xml
    elif [[ $LIST == "CCCOH" ||
        $LIST == "NCCOH" ]]; then
        FILENAM=COH_${TARGET}_splines.xml
    else
        echo "Error! This script doesn't know how to handle the LIST."
        exit 1
    fi
    # Check the XSECSPLINEDIR for the targetted splines...
    if [[ -e $XSECSPLINEDIR/$FILENAM ]]; then
        SPLINEFILE=$XSECSPLINEDIR/$FILENAM
    fi
    # ...but prefer local splines if they exist.
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
if [[ $LIST != "Default" ]]; then
    EVGENSTRING="--event-generator-list $LIST"
fi

# Try to get energies as an array
EARR=($(echo $ENERGY | tr "," " "))
# Get the length of the energy array.
EARRLEN=${#EARR[@]}
if [[ $EARRLEN -gt 1 ]]; then
  # We need a function
  if [[ "$HAVEFUNC" == "NO" ]]; then
    FUNCTIONSTRING="-f 1/x"
    echo ""
    echo "NOTE:"
    echo "When supplying an energy range, we must use a function for the shape."
    echo "Defaulting to 1/x."
  else 
    FUNCTIONSTRING="-f $FUNC"
  fi 
fi

MESSGSTR="--message-thresholds Messenger.xml"
if [[ $PREFERWHISPER == "YES" ]]; then 
    if [[ -e $GENIE/config/Messenger_whisper.xml ]]; then
        MESSGSTR="--message-thresholds Messenger_whisper.xml"
    else
        echo ""
        echo "Messenger_whisper.xml is not available."
    fi
fi

echo ""
echo "Command: "
echo ""
if [[ "$GDB" == "YES" ]]; then
    echo "gdb -tui --args gevgen -n $NUMEVT -p $NEUTRINOS -t $TARGET \\"
    echo "    -e $ENERGY $FUNCTIONSTRING -r $RUNNUM \\ "
    echo "    --seed $SEED --cross-sections $SPLINEFILE \\ "
    echo "    $MESSGSTR $EVGENSTRING "
    gdb -tui --args gevgen -n $NUMEVT -p $NEUTRINOS -t $TARGET \
        -e $ENERGY $FUNCTIONSTRING -r $RUNNUM \
        --seed $SEED --cross-sections $SPLINEFILE \
        $MESSGSTR $EVGENSTRING
else
    echo "gevgen -n $NUMEVT -p $NEUTRINOS -t $TARGET \\"
    echo "    -e $ENERGY $FUNCTIONSTRING -r $RUNNUM \\ "
    echo "    --seed $SEED --cross-sections $SPLINEFILE \\ "
    echo "    $MESSGSTR $EVGENSTRING \\ "
    echo "    >& run_${RUNNUM}_log.txt"
    gevgen -n $NUMEVT -p $NEUTRINOS -t $TARGET \
           -e $ENERGY $FUNCTIONSTRING -r $RUNNUM \
           --seed $SEED --cross-sections $SPLINEFILE \
           $MESSGSTR $EVGENSTRING \
           >& run_${RUNNUM}_log.txt
fi
