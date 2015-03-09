#!/bin/sh

nice valgrind --log-file-exactly=tmp.txt --gen-suppressions=all \
 gevgen -n 5 -p 14 -t 1000060120 -e 0,10 --run 100 \
 -f x*exp\(-x\) --seed 2989819 \
 --cross-sections $XSECSPLINEDIR/gxspl-vA-v2.8.0.xml


