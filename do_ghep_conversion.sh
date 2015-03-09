#!/bin/sh

MINRUN=0
MAXRUN=0
DOROOTRACKER="NO"

help()
{
    cat <<EOF
Usage: ./do_ghep_conversion.sh MINRUN <MAXRUN> <DOROOTRACKER>

Please supply at least one argument (run). If two arguments are 
supplied they will be interpreted as the min and max run range.
The DOROOTRACKER flag will be set to true if any third argument
is supplied.

EOF
}

if [[ $# < 1 ]]; then
    help
    exit 1
fi

if [[ $# > 2 ]]; then
    DOROOTRACKER="YES"
fi

MINRUN=$1
MAXRUN=$1
if [[ $# > 1 ]]; then
    MAXRUN=$2
fi

for i in $MINRUN $MAXRUN
do
    echo "$i"
    if [[ $DOROOTRACKER == "YES" ]]; then
        gntpc -i ./gntp.$i.ghep.root -f rootracker
    fi
    gntpc -i ./gntp.$i.ghep.root -f gst
done

