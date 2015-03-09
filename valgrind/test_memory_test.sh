#!/bin/sh

NUMEVT=1
if [ $# -gt 0 ]; then
  NUMEVT=$1
fi

EXE=gevgen
A1=$(echo -e "-n $NUMEVT -p 14 -t 1000060120 -e 1,2")
A2=$(echo -e "--run 100 -f x*exp(-x) --seed 2989819")
A3=$(echo -e "--cross-sections $XSECSPLINEDIR/ccqe_carbon_splines.xml")
A4=$(echo -e "--event-generator-list CCQE")
DAT=`date -u +%s`
VALLOG="${DAT}_CCQE_grindlog.txt"

valgrind --log-file-exactly=${VALLOG} ${EXE} ${A1} ${A2} ${A3} ${A4}

cp $VALLOG leaksum.txt
perl -i -e 'while(<>) { chomp; if (/definitely/) { print $_,"\n"; } }' leaksum.txt
cat leaksum.txt
echo 


