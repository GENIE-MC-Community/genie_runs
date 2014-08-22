#!/bin/sh

for i in 591 804
do
  echo "$i"
  gntpc -i ./gntp.$i.ghep.root -f rootracker
  gntpc -i ./gntp.$i.ghep.root -f gst
done

