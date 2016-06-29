#!/bin/bash

./do_a_run.sh -w -l CCQE -t 1000060120 -n 50000 -e 1 -u 14 -r 301
./do_a_run.sh -w -l CCQE -t 1000060120 -n 50000 -e 0.2 -u 14 -r 309
./do_a_run.sh -w -l CCQE -t 1000822080 -n 50000 -e 1 -u 14 -r 401
./do_a_run.sh -w -l CCQE -t 1000822080 -n 50000 -e 0.2 -u 14 -r 409

./do_ghep_conversion.sh 301 > ztemp.out
./do_ghep_conversion.sh 309 >> ztemp.out
./do_ghep_conversion.sh 401 >> ztemp.out
./do_ghep_conversion.sh 409 >> ztemp.out

