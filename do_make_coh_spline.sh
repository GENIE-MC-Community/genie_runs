#!/bin/sh

NKNOTS=50
MAX_ENERGY=100
CHANNEL="coherent"
EVGENLIST="COH"
HELPFLAG=0

help()
{
cat <<EOF
Usage: ./do_make_coh_spline.sh -<f>|--<flag> arg
                               -h / --help        : print the help menu
                               -k / --knots #     : # of knots
                               -e / --maxenergy # : max energy
EOF
}

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
        *)     # Unknown option
            ;;
    esac
done

if [[ $HELPFLAG -eq 1 ]]; then
  help
  exit 0
fi

       
# http://pdg.lbl.gov/2007/reviews/montecarlorpp.pdf
# http://pdg.lbl.gov/2011/mcdata/mc_particle_id_contents.html
# http://genie.hepforge.org/doxygen/html/PDGCodes_8h_source.html
PROTON="1000010010"
CARBON="1000060120"
OXYGEN="1000080160"
ARGON40="1000180400"

TARGET=$OXYGEN
TARGET=$CARBON
TARGET=$PROTON

NEUTRINOS="-14,-12,12,14"
NEUTRINOS="12,14"
NEUTRINOS="-14,14"

make_spline() {
  XMLOUT=${CHANNEL}_${TARGET}_splines.xml
  echo "Making xml file $XMLOUT"

  nice gmkspl -p $NEUTRINOS -t $TARGET -o $XMLOUT \
  --event-generator-list $EVGENLIST \
  -n $NKNOTS -e $MAX_ENERGY
}

TARGET=$OXYGEN
make_spline

TARGET=$CARBON
make_spline
