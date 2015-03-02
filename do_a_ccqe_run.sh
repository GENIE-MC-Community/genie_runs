#!/bin/sh

NUMEVT=10
if [ $# -gt 0 ]; then
  NUMEVT=$1
fi

# http://pdg.lbl.gov/2007/reviews/montecarlorpp.pdf
# http://pdg.lbl.gov/2011/mcdata/mc_particle_id_contents.html
# http://genie.hepforge.org/doxygen/html/PDGCodes_8h_source.html
PROTON="1000010010"
CARBON="1000060120"
OXYGEN="1000080160"

TARGET=$OXYGEN
TARGET=$CARBON

SPLINEFILE=$XSECSPLINEDIR/gxspl-vA-v2.8.0.xml
SPLINEFILE=CCQE_TE_EFF_2_9_cand.xml

# To use Effective Spectral Functions, edit UserPhysicsOptions.xml so:
#  <param type="alg" name="NuclearModel"> genie::EffectiveSF/Default </param>
# is active. To active Transverse Enhancement, make sure:
#  <param type="bool" name="UseElFFTransverseEnhancement"> true </param>

gevgen -n $NUMEVT -p -12 -t $TARGET -e 2 -r 101 \
  --seed 2989819 --cross-sections $SPLINEFILE \
  --event-generator-list CCQE >& run_log.txt

