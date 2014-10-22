#!/bin/sh

for i in 101 101
do
  echo "$i"
  gntpc -i ./gntp.$i.ghep.root -f rootracker
  gntpc -i ./gntp.$i.ghep.root -f gst
done

